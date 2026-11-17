package store

import (
	"time"

	"github.com/omar/ridge/tui/internal/progress"
)

// LessonAttempts returns every attempt for the lesson progress calculator.
func (d *DB) LessonAttempts() []progress.LessonAttempt {
	rows, err := d.sql.Query("SELECT lesson_id,accuracy,passed FROM lesson_attempts ORDER BY started_ms")
	if err != nil {
		return nil
	}
	defer rows.Close()
	var out []progress.LessonAttempt
	for rows.Next() {
		var a progress.LessonAttempt
		var p int
		if rows.Scan(&a.LessonID, &a.Accuracy, &p) == nil {
			a.Passed = p == 1
			out = append(out, a)
		}
	}
	return out
}

// ResetLesson forgets the attempts (and their sessions) of one lesson.
func (d *DB) ResetLesson(id string) error {
	_, err := d.sql.Exec(`DELETE FROM sessions WHERE id IN (SELECT session_id FROM lesson_attempts WHERE lesson_id=?)`, id)
	if err != nil {
		return err
	}
	_, err = d.sql.Exec(`DELETE FROM lesson_attempts WHERE lesson_id=?`, id)
	return err
}

// ResetAllLessons forgets every lesson attempt.
func (d *DB) ResetAllLessons() error {
	if _, err := d.sql.Exec(`DELETE FROM sessions WHERE id IN (SELECT session_id FROM lesson_attempts)`); err != nil {
		return err
	}
	_, err := d.sql.Exec(`DELETE FROM lesson_attempts`)
	return err
}

// Wipe deletes every row (sessions, mastery, achievements, daily and settings).
func (d *DB) Wipe() error {
	for _, t := range []string{"sessions", "lesson_attempts", "mastery", "achievements", "daily_completions", "kv"} {
		if _, err := d.sql.Exec("DELETE FROM " + t); err != nil {
			return err
		}
	}
	return nil
}

// Mastery returns the stored status of a pair.
func (d *DB) Mastery(cat, diff string) (m progress.MasteryStatus, found bool) {
	var mm, pc int
	err := d.sql.QueryRow("SELECT is_mastered,pass_count FROM mastery WHERE category=? AND difficulty=?", cat, diff).Scan(&mm, &pc)
	return progress.MasteryStatus{Category: cat, Difficulty: diff, IsMastered: mm == 1, PassCount: pc}, err == nil
}

// PutMastery upserts a status.
func (d *DB) PutMastery(m progress.MasteryStatus, at time.Time) error {
	b := 0
	if m.IsMastered {
		b = 1
	}
	_, err := d.sql.Exec(`INSERT INTO mastery VALUES(?,?,?,?,?) ON CONFLICT(category,difficulty)
		DO UPDATE SET is_mastered=excluded.is_mastered,pass_count=excluded.pass_count,evaluated_ms=excluded.evaluated_ms`,
		m.Category, m.Difficulty, b, m.PassCount, at.UnixMilli())
	return err
}

// AllMastery lists every stored status.
func (d *DB) AllMastery() []progress.MasteryStatus {
	rows, err := d.sql.Query("SELECT category,difficulty,is_mastered,pass_count FROM mastery")
	if err != nil {
		return nil
	}
	defer rows.Close()
	var out []progress.MasteryStatus
	for rows.Next() {
		var m progress.MasteryStatus
		var b int
		if rows.Scan(&m.Category, &m.Difficulty, &b, &m.PassCount) == nil {
			m.IsMastered = b == 1
			out = append(out, m)
		}
	}
	return out
}

// Unlocked returns achievement key → unlock time.
func (d *DB) Unlocked() map[string]time.Time {
	out := map[string]time.Time{}
	rows, err := d.sql.Query("SELECT key,unlocked_ms FROM achievements")
	if err != nil {
		return out
	}
	defer rows.Close()
	for rows.Next() {
		var k string
		var ms int64
		if rows.Scan(&k, &ms) == nil {
			out[k] = time.UnixMilli(ms)
		}
	}
	return out
}

// RecordUnlock stores an achievement once.
func (d *DB) RecordUnlock(key string, at time.Time, session int64) error {
	_, err := d.sql.Exec("INSERT OR IGNORE INTO achievements VALUES(?,?,?)", key, at.UnixMilli(), nullInt(session))
	return err
}

func nullInt(v int64) any {
	if v == 0 {
		return nil
	}
	return v
}

// Daily is one counted daily-challenge attempt.
type Daily struct {
	Date, SnippetID string
	Score           int
	Passed          bool
}

// RecordDaily stores today's single counted attempt (first one wins).
func (d *DB) RecordDaily(x Daily, session int64, at time.Time) error {
	p := 0
	if x.Passed {
		p = 1
	}
	_, err := d.sql.Exec("INSERT OR IGNORE INTO daily_completions VALUES(?,?,?,?,?,?)",
		x.Date, x.SnippetID, nullInt(session), x.Score, p, at.UnixMilli())
	return err
}

// DailyFor returns the attempt of a date.
func (d *DB) DailyFor(date string) (Daily, bool) {
	var x Daily
	var p int
	err := d.sql.QueryRow("SELECT date,snippet_id,score,passed FROM daily_completions WHERE date=?", date).
		Scan(&x.Date, &x.SnippetID, &x.Score, &p)
	x.Passed = p == 1
	return x, err == nil
}

// DailyDates lists every completed daily date.
func (d *DB) DailyDates() map[string]bool {
	out := map[string]bool{}
	rows, err := d.sql.Query("SELECT date FROM daily_completions")
	if err != nil {
		return out
	}
	defer rows.Close()
	for rows.Next() {
		var s string
		if rows.Scan(&s) == nil {
			out[s] = true
		}
	}
	return out
}
