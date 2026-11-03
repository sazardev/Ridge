// Package typing is the keystroke engine and metrics core: the Go port of the
// Flutter app's practice domain (KeystrokeStreamRecorder, MetricsCalculator…).
package typing

import "time"

// Result of one forward keystroke.
type Result int

const (
	Correct Result = iota
	Substitution
)

// Keystroke is one recorded event (SPEC §4.1).
type Keystroke struct {
	Expected     rune
	Actual       rune
	Result       Result
	IsCorrection bool
	Finger       Finger
	Row          Row
	Flight       time.Duration // time since the previous keystroke; 0 for the first
	Seq          int
}

// Recorder walks a snippet, accepting only correct characters (a wrong key is
// recorded as an error but does not advance the cursor — same as the app).
type Recorder struct {
	expected []rune
	cursor   int
	events   []Keystroke
	lastAt   time.Time
	seq      int
}

// NewRecorder starts a recorder for a snippet.
func NewRecorder(code string) *Recorder { return &Recorder{expected: []rune(code)} }

// Expected is the full snippet as runes.
func (r *Recorder) Expected() []rune { return r.expected }

// Cursor is the index of the next expected character.
func (r *Recorder) Cursor() int { return r.cursor }

// Complete reports whether the whole snippet was typed.
func (r *Recorder) Complete() bool { return r.cursor >= len(r.expected) }

// Events returns every recorded keystroke.
func (r *Recorder) Events() []Keystroke { return r.events }

func (r *Recorder) at(i int) (rune, bool) {
	if i < 0 || i >= len(r.expected) {
		return 0, false
	}
	return r.expected[i], true
}

// Char ingests one typed character. The returned keystroke is nil if the
// snippet was already complete.
func (r *Recorder) Char(c rune, now time.Time) *Keystroke {
	exp, ok := r.at(r.cursor)
	if !ok {
		return nil
	}
	// Like the app, finger/row come from the physical key that was pressed;
	// a character with no US-QWERTY key falls back to the expected one.
	f, row, ok := Lookup(c)
	if !ok {
		f, row, _ = Lookup(exp)
	}
	ks := Keystroke{Expected: exp, Actual: c, Finger: f, Row: row, Seq: r.seq}
	if !r.lastAt.IsZero() {
		ks.Flight = now.Sub(r.lastAt)
	}
	r.lastAt = now
	r.seq++
	if c == exp {
		ks.Result = Correct
		r.cursor++
	} else {
		ks.Result = Substitution
	}
	r.events = append(r.events, ks)
	return &r.events[len(r.events)-1]
}

// Tab commits a whole run of the expected indent character at once; when the
// next expected character is not whitespace it counts as a wrong '\t'.
func (r *Recorder) Tab(now time.Time) []Keystroke {
	first, ok := r.at(r.cursor)
	if !ok {
		return nil
	}
	if first != ' ' && first != '\t' {
		if k := r.Char('\t', now); k != nil {
			return []Keystroke{*k}
		}
		return nil
	}
	return r.run(first, now)
}

func (r *Recorder) run(indent rune, now time.Time) []Keystroke {
	var out []Keystroke
	for {
		c, ok := r.at(r.cursor)
		if !ok || c != indent {
			return out
		}
		k := r.Char(indent, now)
		if k == nil {
			return out
		}
		out = append(out, *k)
	}
}

// Enter commits a newline, then auto-skips blank lines and the next line's
// indentation, mirroring the app's ingestEnterKey.
func (r *Recorder) Enter(now time.Time) []Keystroke {
	k := r.Char('\n', now)
	if k == nil {
		return nil
	}
	out := []Keystroke{*k}
	if k.Result != Correct {
		return out
	}
	for r.atBlankLine() {
		c, ok := r.at(r.cursor)
		if !ok {
			break
		}
		if k := r.Char(c, now); k != nil {
			out = append(out, *k)
		}
	}
	if c, ok := r.at(r.cursor); ok && (c == ' ' || c == '\t') {
		out = append(out, r.run(c, now)...)
	}
	return out
}

func (r *Recorder) atBlankLine() bool {
	for i := r.cursor; i < len(r.expected); i++ {
		switch r.expected[i] {
		case '\n':
			return true
		case ' ', '\t':
			continue
		default:
			return false
		}
	}
	return false
}

// Backspace undoes the last committed character and logs a correction event.
func (r *Recorder) Backspace(now time.Time) bool {
	if r.cursor == 0 {
		return false
	}
	r.cursor--
	r.events = append(r.events, Keystroke{IsCorrection: true, Seq: r.seq})
	r.seq++
	r.lastAt = now
	return true
}
