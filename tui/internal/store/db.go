// Package store is the local persistence port of the TUI: one SQLite file with
// the same shape as the Flutter app's drift database (sessions, keystrokes,
// n-gram/transition samples, lesson attempts, mastery, achievements, daily).
package store

import (
	"database/sql"
	"errors"
	"os"
	"path/filepath"

	_ "modernc.org/sqlite" // pure-Go SQLite driver
)

// DB wraps the SQLite handle.
type DB struct {
	sql  *sql.DB
	Path string
}

// DefaultPath is $RIDGE_DATA/ridge.db, else <config dir>/ridge/ridge.db.
func DefaultPath() string {
	if d := os.Getenv("RIDGE_DATA"); d != "" {
		return filepath.Join(d, "ridge.db")
	}
	base, err := os.UserConfigDir()
	if err != nil {
		base = "."
	}
	if x := os.Getenv("XDG_DATA_HOME"); x != "" {
		base = x
	}
	return filepath.Join(base, "ridge", "ridge.db")
}

const schemaVersion = 1

const schema = `
CREATE TABLE kv (k TEXT PRIMARY KEY, v TEXT NOT NULL);
CREATE TABLE sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  started_ms INTEGER NOT NULL, mode TEXT NOT NULL, lesson_id TEXT, snippet_id TEXT NOT NULL,
  language TEXT NOT NULL, category TEXT NOT NULL, difficulty TEXT NOT NULL,
  duration_ms INTEGER NOT NULL, raw_cpm REAL, net_cpm REAL, accuracy REAL, consistency REAL,
  max_streak INTEGER, hand_balance REAL, corrections INTEGER, forward_count INTEGER, correct_count INTEGER,
  fatigue1 REAL, fatigue2 REAL, fatigue3 REAL,
  passed INTEGER NOT NULL DEFAULT 0, xp INTEGER NOT NULL DEFAULT 0, first_completion INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_sessions_snippet ON sessions(snippet_id);
CREATE INDEX idx_sessions_mastery ON sessions(mode, category, difficulty, started_ms);
CREATE TABLE keystrokes (
  session_id INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE, seq INTEGER NOT NULL,
  expected INTEGER, actual INTEGER, correct INTEGER NOT NULL, correction INTEGER NOT NULL,
  finger TEXT, row TEXT, flight_us INTEGER NOT NULL, PRIMARY KEY (session_id, seq)
);
CREATE TABLE ngram_samples (session_id INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  at_ms INTEGER NOT NULL, text TEXT NOT NULL, is_error INTEGER NOT NULL, flight_ms REAL NOT NULL);
CREATE INDEX idx_ngram_at ON ngram_samples(at_ms);
CREATE TABLE transition_samples (session_id INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  at_ms INTEGER NOT NULL, from_key TEXT NOT NULL, to_key TEXT NOT NULL, is_error INTEGER NOT NULL, flight_ms REAL NOT NULL);
CREATE INDEX idx_trans_at ON transition_samples(at_ms);
CREATE TABLE lesson_attempts (id INTEGER PRIMARY KEY AUTOINCREMENT, lesson_id TEXT NOT NULL,
  session_id INTEGER REFERENCES sessions(id) ON DELETE CASCADE, accuracy REAL NOT NULL, passed INTEGER NOT NULL, started_ms INTEGER NOT NULL);
CREATE INDEX idx_attempts_lesson ON lesson_attempts(lesson_id);
CREATE TABLE mastery (category TEXT NOT NULL, difficulty TEXT NOT NULL, is_mastered INTEGER NOT NULL,
  pass_count INTEGER NOT NULL, evaluated_ms INTEGER NOT NULL, PRIMARY KEY (category, difficulty));
CREATE TABLE achievements (key TEXT PRIMARY KEY, unlocked_ms INTEGER NOT NULL, session_id INTEGER);
CREATE TABLE daily_completions (date TEXT PRIMARY KEY, snippet_id TEXT NOT NULL, session_id INTEGER,
  score INTEGER NOT NULL, passed INTEGER NOT NULL, completed_ms INTEGER NOT NULL);
`

// Open opens (creating and migrating) the database. Use ":memory:" in tests.
func Open(path string) (*DB, error) {
	dsn := path
	if path != ":memory:" {
		if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
			return nil, err
		}
		dsn = "file:" + path + "?_pragma=journal_mode(WAL)&_pragma=foreign_keys(1)&_pragma=busy_timeout(5000)"
	} else {
		dsn = "file::memory:?_pragma=foreign_keys(1)"
	}
	h, err := sql.Open("sqlite", dsn)
	if err != nil {
		return nil, err
	}
	h.SetMaxOpenConns(1) // single writer; also keeps :memory: on one connection
	d := &DB{sql: h, Path: path}
	if err := d.migrate(); err != nil {
		h.Close()
		return nil, err
	}
	if path != ":memory:" {
		_ = os.Chmod(path, 0o600) // holds the PIN hash
	}
	return d, nil
}

func (d *DB) migrate() error {
	var v int
	if err := d.sql.QueryRow("PRAGMA user_version").Scan(&v); err != nil {
		return err
	}
	if v > schemaVersion {
		return errors.New("database was created by a newer Ridge")
	}
	if v == 0 {
		tx, err := d.sql.Begin()
		if err != nil {
			return err
		}
		if _, err := tx.Exec(schema); err != nil {
			tx.Rollback()
			return err
		}
		if _, err := tx.Exec("PRAGMA user_version = 1"); err != nil {
			tx.Rollback()
			return err
		}
		return tx.Commit()
	}
	return nil
}

// Close closes the database.
func (d *DB) Close() error { return d.sql.Close() }

// Get reads a key/value pair ("" when absent).
func (d *DB) Get(k string) string {
	var v string
	_ = d.sql.QueryRow("SELECT v FROM kv WHERE k=?", k).Scan(&v)
	return v
}

// Set writes a key/value pair.
func (d *DB) Set(k, v string) error {
	_, err := d.sql.Exec("INSERT INTO kv(k,v) VALUES(?,?) ON CONFLICT(k) DO UPDATE SET v=excluded.v", k, v)
	return err
}

// Del removes a key.
func (d *DB) Del(k string) error { _, err := d.sql.Exec("DELETE FROM kv WHERE k=?", k); return err }
