package store

import (
	"database/sql"
	"time"

	"github.com/omar/ridge/tui/internal/progress"
	"github.com/omar/ridge/tui/internal/typing"
)

// Session is one finished run.
type Session struct {
	ID                              int64
	At                              time.Time
	Mode, LessonID, SnippetID       string
	Language, Category, Difficulty  string
	Duration                        time.Duration
	RawCPM, NetCPM, Accuracy        float64
	Consistency, HandBalance        float64
	MaxStreak, Corrections, Forward int
	Correct                         int
	Fatigue                         [3]float64
	Passed, First                   bool
	XP                              int
}

// SaveSession persists a session with its keystrokes and samples atomically,
// plus the lesson attempt when it belongs to one. Returns the new id.
func (d *DB) SaveSession(s Session, ks []typing.Keystroke) (int64, error) {
	tx, err := d.sql.Begin()
	if err != nil {
		return 0, err
	}
	defer tx.Rollback()
	b := func(v bool) int {
		if v {
			return 1
		}
		return 0
	}
	ms := s.At.UnixMilli()
	res, err := tx.Exec(`INSERT INTO sessions(started_ms,mode,lesson_id,snippet_id,language,category,difficulty,duration_ms,
		raw_cpm,net_cpm,accuracy,consistency,max_streak,hand_balance,corrections,forward_count,correct_count,
		fatigue1,fatigue2,fatigue3,passed,xp,first_completion) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
		ms, s.Mode, nullStr(s.LessonID), s.SnippetID, s.Language, s.Category, s.Difficulty, s.Duration.Milliseconds(),
		s.RawCPM, s.NetCPM, s.Accuracy, s.Consistency, s.MaxStreak, s.HandBalance, s.Corrections, s.Forward, s.Correct,
		s.Fatigue[0], s.Fatigue[1], s.Fatigue[2], b(s.Passed), s.XP, b(s.First))
	if err != nil {
		return 0, err
	}
	id, _ := res.LastInsertId()
	st, err := tx.Prepare(`INSERT INTO keystrokes VALUES(?,?,?,?,?,?,?,?,?)`)
	if err != nil {
		return 0, err
	}
	defer st.Close()
	for i, k := range ks {
		if _, err := st.Exec(id, i, int(k.Expected), int(k.Actual), b(k.Result == typing.Correct), b(k.IsCorrection),
			string(k.Finger), string(k.Row), k.Flight.Microseconds()); err != nil {
			return 0, err
		}
	}
	for _, n := range typing.NgramSamples(ks) {
		if _, err := tx.Exec(`INSERT INTO ngram_samples VALUES(?,?,?,?,?)`, id, ms, n.Text, b(n.IsError), n.FlightMs); err != nil {
			return 0, err
		}
	}
	for _, t := range typing.TransitionSamples(ks) {
		if _, err := tx.Exec(`INSERT INTO transition_samples VALUES(?,?,?,?,?,?)`, id, ms, t.From, t.To, b(t.IsError), t.FlightMs); err != nil {
			return 0, err
		}
	}
	if s.LessonID != "" {
		if _, err := tx.Exec(`INSERT INTO lesson_attempts(lesson_id,session_id,accuracy,passed,started_ms) VALUES(?,?,?,?,?)`,
			s.LessonID, id, s.Accuracy, b(s.Passed), ms); err != nil {
			return 0, err
		}
	}
	return id, tx.Commit()
}

func nullStr(s string) any {
	if s == "" {
		return nil
	}
	return s
}

const sessionCols = `id,started_ms,mode,COALESCE(lesson_id,''),snippet_id,language,category,difficulty,duration_ms,raw_cpm,net_cpm,
accuracy,consistency,max_streak,hand_balance,corrections,forward_count,correct_count,fatigue1,fatigue2,fatigue3,passed,xp,first_completion`

func scanSession(r interface{ Scan(...any) error }) (Session, error) {
	var s Session
	var ms, dur int64
	var passed, first int
	err := r.Scan(&s.ID, &ms, &s.Mode, &s.LessonID, &s.SnippetID, &s.Language, &s.Category, &s.Difficulty, &dur,
		&s.RawCPM, &s.NetCPM, &s.Accuracy, &s.Consistency, &s.MaxStreak, &s.HandBalance, &s.Corrections, &s.Forward,
		&s.Correct, &s.Fatigue[0], &s.Fatigue[1], &s.Fatigue[2], &passed, &s.XP, &first)
	s.At, s.Duration = time.UnixMilli(ms), time.Duration(dur)*time.Millisecond
	s.Passed, s.First = passed == 1, first == 1
	return s, err
}

func (d *DB) query(q string, args ...any) ([]Session, error) {
	rows, err := d.sql.Query("SELECT "+sessionCols+" FROM sessions "+q, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Session
	for rows.Next() {
		s, err := scanSession(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, s)
	}
	return out, rows.Err()
}

// Recent returns the newest sessions first.
func (d *DB) Recent(n int) []Session {
	out, _ := d.query("ORDER BY started_ms DESC, id DESC LIMIT ?", n)
	return out
}

// All returns every session, oldest first.
func (d *DB) All() []Session { out, _ := d.query("ORDER BY started_ms, id"); return out }

// ForSnippet returns every session of a snippet.
func (d *DB) ForSnippet(id string) []Session {
	out, _ := d.query("WHERE snippet_id=? ORDER BY started_ms", id)
	return out
}

// Session loads one by id.
func (d *DB) Session(id int64) (Session, error) {
	return scanSession(d.sql.QueryRow("SELECT "+sessionCols+" FROM sessions WHERE id=?", id))
}

// Keystrokes loads a session's keystroke stream in order.
func (d *DB) Keystrokes(id int64) []typing.Keystroke {
	rows, err := d.sql.Query(`SELECT expected,actual,correct,correction,finger,row,flight_us FROM keystrokes WHERE session_id=? ORDER BY seq`, id)
	if err != nil {
		return nil
	}
	defer rows.Close()
	var out []typing.Keystroke
	for rows.Next() {
		var e, a, ok, corr, us int
		var f, r string
		if rows.Scan(&e, &a, &ok, &corr, &f, &r, &us) != nil {
			continue
		}
		k := typing.Keystroke{Expected: rune(e), Actual: rune(a), IsCorrection: corr == 1, Finger: typing.Finger(f),
			Row: typing.Row(r), Flight: time.Duration(us) * time.Microsecond}
		if ok != 1 {
			k.Result = typing.Substitution
		}
		out = append(out, k)
	}
	return out
}

// TotalXP is the cumulative XP.
func (d *DB) TotalXP() int {
	var n sql.NullInt64
	_ = d.sql.QueryRow("SELECT SUM(xp) FROM sessions").Scan(&n)
	return int(n.Int64)
}

// HasCompleted reports whether a snippet was finished before.
func (d *DB) HasCompleted(snippetID string) bool {
	var n int
	_ = d.sql.QueryRow("SELECT COUNT(*) FROM sessions WHERE snippet_id=?", snippetID).Scan(&n)
	return n > 0
}

// SnippetsDone is the set of completed snippet ids.
func (d *DB) SnippetsDone() map[string]bool {
	out := map[string]bool{}
	rows, err := d.sql.Query("SELECT DISTINCT snippet_id FROM sessions")
	if err != nil {
		return out
	}
	defer rows.Close()
	for rows.Next() {
		var id string
		if rows.Scan(&id) == nil {
			out[id] = true
		}
	}
	return out
}

// PlayedDays is the set of local calendar days with at least one session.
func (d *DB) PlayedDays() map[string]bool {
	out := map[string]bool{}
	rows, err := d.sql.Query("SELECT started_ms FROM sessions")
	if err != nil {
		return out
	}
	defer rows.Close()
	for rows.Next() {
		var ms int64
		if rows.Scan(&ms) == nil {
			out[time.UnixMilli(ms).Local().Format("2006-01-02")] = true
		}
	}
	return out
}

// LifetimeCorrectChars is the Maratonista counter.
func (d *DB) LifetimeCorrectChars() int {
	var n sql.NullInt64
	_ = d.sql.QueryRow("SELECT SUM(correct_count) FROM sessions").Scan(&n)
	return int(n.Int64)
}

// RecentPrecision returns the last five Precision results of a pair, newest first.
func (d *DB) RecentPrecision(cat, diff string) []progress.PrecisionResult {
	rows, err := d.sql.Query(`SELECT accuracy,net_cpm FROM sessions WHERE mode='precision' AND category=? AND difficulty=?
		ORDER BY started_ms DESC, id DESC LIMIT 5`, cat, diff)
	if err != nil {
		return nil
	}
	defer rows.Close()
	var out []progress.PrecisionResult
	for rows.Next() {
		var r progress.PrecisionResult
		if rows.Scan(&r.AccuracyPct, &r.NetCPM) == nil {
			out = append(out, r)
		}
	}
	return out
}

// ActivitySamples feeds the activity ranking.
func (d *DB) ActivitySamples() []progress.ActivitySample {
	var out []progress.ActivitySample
	for _, s := range d.All() {
		out = append(out, progress.ActivitySample{At: s.At, Category: s.Category, SnippetID: s.SnippetID,
			Duration: s.Duration, AccuracyPct: s.Accuracy, NetCPM: s.NetCPM})
	}
	return out
}

// WeaknessSamples loads the 60-day keystroke/finger/n-gram/transition samples.
func (d *DB) WeaknessSamples(now time.Time) (chars, fingers, ngrams, trans map[string][]progress.Sample) {
	chars, fingers = map[string][]progress.Sample{}, map[string][]progress.Sample{}
	ngrams, trans = map[string][]progress.Sample{}, map[string][]progress.Sample{}
	since := now.AddDate(0, 0, -60).UnixMilli()
	age := func(ms int64) float64 { return float64(now.UnixMilli()-ms) / 86400000 }
	rows, err := d.sql.Query(`SELECT s.started_ms,k.expected,k.actual,k.correct,k.finger,k.flight_us FROM keystrokes k
		JOIN sessions s ON s.id=k.session_id WHERE k.correction=0 AND s.started_ms>=?`, since)
	if err == nil {
		for rows.Next() {
			var ms int64
			var e, a, ok, us int
			var f string
			if rows.Scan(&ms, &e, &a, &ok, &f, &us) != nil {
				continue
			}
			sm := progress.Sample{AgeDays: age(ms), IsError: ok != 1, FlightMs: float64(us) / 1000}
			chars[string(rune(e))] = append(chars[string(rune(e))], sm)
			fingers[f] = append(fingers[f], sm)
		}
		rows.Close()
	}
	if rows, err = d.sql.Query(`SELECT at_ms,text,is_error,flight_ms FROM ngram_samples WHERE at_ms>=?`, since); err == nil {
		for rows.Next() {
			var ms int64
			var t string
			var e int
			var f float64
			if rows.Scan(&ms, &t, &e, &f) == nil {
				ngrams[t] = append(ngrams[t], progress.Sample{AgeDays: age(ms), IsError: e == 1, FlightMs: f})
			}
		}
		rows.Close()
	}
	if rows, err = d.sql.Query(`SELECT at_ms,from_key,to_key,is_error,flight_ms FROM transition_samples WHERE at_ms>=?`, since); err == nil {
		for rows.Next() {
			var ms int64
			var a, b string
			var e int
			var f float64
			if rows.Scan(&ms, &a, &b, &e, &f) == nil {
				trans[a+"→"+b] = append(trans[a+"→"+b], progress.Sample{AgeDays: age(ms), IsError: e == 1, FlightMs: f})
			}
		}
		rows.Close()
	}
	return
}

// Heatmap aggregates every keystroke ever by physical key.
func (d *DB) Heatmap() map[string]typing.KeyHeat {
	rows, err := d.sql.Query(`SELECT actual,correct,flight_us FROM keystrokes WHERE correction=0`)
	if err != nil {
		return nil
	}
	defer rows.Close()
	out := map[string]typing.KeyHeat{}
	sums, cnt := map[string]float64{}, map[string]int{}
	for rows.Next() {
		var a, ok, us int
		if rows.Scan(&a, &ok, &us) != nil {
			continue
		}
		k := typing.PhysicalKey(rune(a))
		h := out[k]
		h.Presses++
		if ok != 1 {
			h.Errors++
		}
		out[k] = h
		if us > 0 {
			sums[k] += float64(us) / 1000
			cnt[k]++
		}
	}
	for k, h := range out {
		if cnt[k] > 0 {
			h.AvgFlightMs = sums[k] / float64(cnt[k])
		}
		out[k] = h
	}
	return out
}

// PerFinger aggregates attempts/errors by finger over all time.
func (d *DB) PerFinger() []typing.FingerStat {
	rows, err := d.sql.Query(`SELECT finger,COUNT(*),SUM(1-correct) FROM keystrokes WHERE correction=0 AND finger<>'' GROUP BY finger`)
	if err != nil {
		return nil
	}
	defer rows.Close()
	var out []typing.FingerStat
	for rows.Next() {
		var f typing.Finger
		var n, e int
		if rows.Scan(&f, &n, &e) == nil {
			out = append(out, typing.FingerStat{Finger: f, Attempts: n, Errors: e})
		}
	}
	return out
}

// SessionInputs feeds the per-session achievement rules.
func (d *DB) SessionInputs() []progress.SessionInput {
	var out []progress.SessionInput
	for _, s := range d.All() {
		out = append(out, progress.SessionInput{Accuracy: s.Accuracy, HandBalance: s.HandBalance,
			Corrections: s.Corrections, Forward: s.Forward, SessionID: s.ID})
	}
	return out
}

// WeeklySessions feeds the weekly summary.
func (d *DB) WeeklySessions() []progress.WeeklySession {
	var out []progress.WeeklySession
	for _, s := range d.All() {
		out = append(out, progress.WeeklySession{At: s.At, Duration: s.Duration, XP: s.XP, NetCPM: s.NetCPM, AccuracyPct: s.Accuracy})
	}
	return out
}
