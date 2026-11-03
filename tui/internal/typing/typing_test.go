package typing

import (
	"testing"
	"time"
)

func TestRecorderRejectsWrongKeyWithoutAdvancing(t *testing.T) {
	r := NewRecorder("ab")
	now := time.Now()
	if k := r.Char('x', now); k.Result != Substitution || r.Cursor() != 0 {
		t.Fatalf("wrong key must not advance: %+v cursor=%d", k, r.Cursor())
	}
	r.Char('a', now.Add(10*time.Millisecond))
	r.Char('b', now.Add(20*time.Millisecond))
	if !r.Complete() {
		t.Fatal("expected complete")
	}
	m := Calculate(r.Events(), time.Second)
	if m.Accuracy < 66 || m.Accuracy > 67 {
		t.Fatalf("accuracy = %v, want ~66.7", m.Accuracy)
	}
}

func TestEnterSkipsIndentAndTabCommitsRun(t *testing.T) {
	r := NewRecorder("a\n\t\tb")
	now := time.Now()
	r.Char('a', now)
	r.Enter(now)
	if got := r.Cursor(); got != 4 {
		t.Fatalf("after Enter cursor = %d, want 4 (newline + 2 tabs)", got)
	}
	r2 := NewRecorder("  x")
	r2.Tab(now)
	if r2.Cursor() != 2 {
		t.Fatalf("Tab should commit the whole indent run, cursor=%d", r2.Cursor())
	}
}

func TestXPAndLevelMatchFlutter(t *testing.T) {
	if got := XP(100, "intermediate", 100, true, 3); got != 130+50+15 {
		t.Fatalf("xp = %d", got)
	}
	if XPForLevel(2) != 300 || LevelForXP(299) != 1 || LevelForXP(300) != 2 {
		t.Fatalf("level curve off: %d", XPForLevel(2))
	}
	if PrecisionPasses(79.9) || !PrecisionPasses(80) {
		t.Fatal("precision threshold must be score>7 (>=80%)")
	}
}

func TestSurvivalComboAndLives(t *testing.T) {
	s := NewSurvival()
	for i := 0; i < 25; i++ {
		s.Record(Correct)
	}
	if s.Multiplier() != 2 {
		t.Fatalf("multiplier = %d", s.Multiplier())
	}
	for i := 0; i < SurvivalLives; i++ {
		s.Record(Substitution)
	}
	if !s.Over() {
		t.Fatal("run should be over")
	}
}
