package store

import (
	"testing"
	"time"

	"github.com/omar/ridge/tui/internal/typing"
)

func open(t *testing.T) *DB {
	t.Helper()
	d, err := Open(":memory:")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { d.Close() })
	return d
}

func sample() (Session, []typing.Keystroke) {
	r := typing.NewRecorder("ab")
	now := time.Now()
	r.Char('a', now)
	r.Char('x', now.Add(50*time.Millisecond))
	r.Char('b', now.Add(100*time.Millisecond))
	return Session{At: now, Mode: "lesson", LessonID: "L1", SnippetID: "s1", Language: "go", Category: "cat",
		Difficulty: "beginner", Duration: time.Second, NetCPM: 120, Accuracy: 66.7, XP: 10, Passed: false, Forward: 3, Correct: 2}, r.Events()
}

func TestSessionRoundTripAndSamples(t *testing.T) {
	d := open(t)
	s, ks := sample()
	id, err := d.SaveSession(s, ks)
	if err != nil {
		t.Fatal(err)
	}
	got, err := d.Session(id)
	if err != nil || got.SnippetID != "s1" || got.XP != 10 || got.LessonID != "L1" {
		t.Fatalf("session = %+v err=%v", got, err)
	}
	if n := len(d.Keystrokes(id)); n != 3 {
		t.Fatalf("keystrokes = %d", n)
	}
	chars, fingers, ngrams, trans := d.WeaknessSamples(time.Now())
	if len(chars) == 0 || len(fingers) == 0 || len(ngrams) == 0 || len(trans) == 0 {
		t.Fatal("per-char/finger/ngram/transition samples must be stored")
	}
	if d.TotalXP() != 10 || !d.HasCompleted("s1") || d.LifetimeCorrectChars() != 2 {
		t.Fatal("aggregates")
	}
	if att := d.LessonAttempts(); len(att) != 1 || att[0].Passed {
		t.Fatalf("attempts = %+v", att)
	}
	if h := d.Heatmap(); h["x"].Errors != 1 {
		t.Fatalf("heatmap = %+v", h)
	}
}

func TestResetAndWipe(t *testing.T) {
	d := open(t)
	s, ks := sample()
	d.SaveSession(s, ks)
	d.Set("k", "v")
	if err := d.ResetLesson("L1"); err != nil || len(d.LessonAttempts()) != 0 || d.TotalXP() != 0 {
		t.Fatal("resetting a lesson forgets its attempts and session")
	}
	d.SaveSession(s, ks)
	if err := d.Wipe(); err != nil || d.TotalXP() != 0 || d.Get("k") != "" {
		t.Fatal("wipe removes everything")
	}
}

func TestSettingsProfileAndPIN(t *testing.T) {
	d := open(t)
	if st := d.LoadSettings(); st.ThemeMode != "system" || st.Palette != "auto" || !st.Expressive || st.ReminderMinutes != 1200 {
		t.Fatalf("defaults = %+v", st)
	}
	st := d.LoadSettings()
	st.Palette, st.Bell = "nord", true
	d.SaveSettings(st)
	if got := d.LoadSettings(); got.Palette != "nord" || !got.Bell {
		t.Fatal("settings persist")
	}
	d.SaveProfile(Profile{Username: "ada", FavoriteLanguages: []string{"go", "rust"}})
	if p := d.LoadProfile(); p.Username != "ada" || len(p.FavoriteLanguages) != 2 {
		t.Fatal("profile persists")
	}
	if d.HasPIN() || d.VerifyPIN("1234") {
		t.Fatal("no PIN yet")
	}
	d.SetPIN("1234")
	if !d.HasPIN() || !d.VerifyPIN("1234") || d.VerifyPIN("1235") {
		t.Fatal("PIN verification")
	}
	if d.Get("lock.pin_hash") == "1234" {
		t.Fatal("PIN must be hashed")
	}
	d.ClearPIN()
	if d.HasPIN() {
		t.Fatal("cleared")
	}
}
