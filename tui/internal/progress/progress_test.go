package progress

import (
	"testing"
	"time"

	"github.com/omar/ridge/tui/internal/typing"
)

func TestStreakCountsBackFromTodayOrYesterday(t *testing.T) {
	today := time.Date(2026, 11, 3, 12, 0, 0, 0, time.Local)
	days := map[string]bool{"2026-11-03": true, "2026-11-02": true, "2026-11-01": true, "2026-10-29": true}
	if got := Streak(days, today); got != 3 {
		t.Fatalf("streak = %d, want 3", got)
	}
	delete(days, "2026-11-03") // today not played yet: still alive through yesterday
	if got := Streak(days, today); got != 2 {
		t.Fatalf("streak = %d, want 2", got)
	}
	delete(days, "2026-11-02")
	if got := Streak(days, today); got != 0 {
		t.Fatalf("a gap of a full day kills the streak, got %d", got)
	}
}

func TestMasteryCertifiesOnFiveAndDecaysBelowFour(t *testing.T) {
	good := PrecisionResult{AccuracyPct: 99, NetCPM: 200}
	bad := PrecisionResult{AccuracyPct: 90, NetCPM: 200}
	if m := EvaluateMastery("c", "beginner", false, []PrecisionResult{good, good, good, good}); m.PassCount != -1 || m.IsMastered {
		t.Fatal("fewer than 5 results must not certify")
	}
	if m := EvaluateMastery("c", "beginner", false, []PrecisionResult{good, good, good, good, good}); !m.IsMastered {
		t.Fatal("5/5 certifies")
	}
	if m := EvaluateMastery("c", "beginner", false, []PrecisionResult{good, good, good, good, bad}); m.IsMastered {
		t.Fatal("4/5 does not certify a new pair")
	}
	if m := EvaluateMastery("c", "beginner", true, []PrecisionResult{good, good, good, good, bad}); !m.IsMastered {
		t.Fatal("an already-mastered pair survives 4/5")
	}
	if m := EvaluateMastery("c", "beginner", true, []PrecisionResult{good, good, good, bad, bad}); m.IsMastered {
		t.Fatal("3/5 decays mastery")
	}
	if Passes(PrecisionResult{AccuracyPct: 99, NetCPM: 149}, "beginner") {
		t.Fatal("speed floor for beginner is 150 cpm")
	}
}

func TestAchievementsUnlockOnceAndByRule(t *testing.T) {
	have := map[string]bool{}
	f := Facts{StreakDays: 7, LifetimeChars: 60000,
		Sessions: []SessionInput{{Accuracy: 100, Corrections: 0, Forward: 120, HandBalance: 0.97, SessionID: 5}},
		Mastery:  []MasteryStatus{{Category: "errors", Difficulty: "beginner", IsMastered: true}}}
	got := map[string]bool{}
	for _, u := range Evaluate(f, have) {
		got[u.Key] = true
	}
	for _, k := range []string{"cero_errores", "ambidiestro", "maratonista_bronze", "streak_threeDays", "streak_sevenDays", "category_mastery_errors_beginner"} {
		if !got[k] {
			t.Errorf("missing %s", k)
		}
	}
	if got["maratonista_silver"] || got["streak_thirtyDays"] {
		t.Error("higher tiers must stay locked")
	}
	if len(Evaluate(f, have)) != 0 {
		t.Fatal("second evaluation must not re-unlock")
	}
}

func TestLessonsUnlockInOrder(t *testing.T) {
	res := LessonProgress([]string{"a", "b", "c"}, []LessonAttempt{{"a", 95, true}, {"b", 70, false}})
	if res["a"].State != Completed || res["b"].State != Unlocked || res["c"].State != Locked {
		t.Fatalf("states = %+v", res)
	}
	if res["b"].BestAccuracy != 70 || !res["b"].HasAttempt {
		t.Fatal("best accuracy of a failed attempt is still tracked")
	}
}

func TestWeaknessRankPutsErrorProneFirst(t *testing.T) {
	by := map[string][]Sample{
		"{": {{AgeDays: 1, IsError: true, FlightMs: 300}, {AgeDays: 1, IsError: true, FlightMs: 280}},
		"a": {{AgeDays: 1, FlightMs: 120}, {AgeDays: 1, FlightMs: 110}},
	}
	r := Rank(by, 10)
	if r[0].Key != "{" || r[0].Score <= r[1].Score {
		t.Fatalf("rank = %+v", r)
	}
}

func TestDailyIndexMatchesFNV1a(t *testing.T) {
	// FNV-1a 32 of "2026-11-03", computed with the Dart algorithm in the app.
	h := uint32(0x811c9dc5)
	for _, c := range []byte("2026-11-03") {
		h ^= uint32(c)
		h *= 0x01000193
	}
	if DailyIndex("2026-11-03", 1000) != int(h)%1000 {
		t.Fatal("daily selection must match the app's FNV-1a32")
	}
}

func TestGhostFoldAndPosition(t *testing.T) {
	ev := []typing.Keystroke{
		{Result: typing.Correct, Flight: 0}, {Result: typing.Correct, Flight: 100 * time.Millisecond},
		{Result: typing.Substitution, Flight: 100 * time.Millisecond}, {Result: typing.Correct, Flight: 100 * time.Millisecond},
	}
	steps := FoldGhost(ev)
	if len(steps) != 3 || steps[2].Position != 2 {
		t.Fatalf("steps = %+v", steps)
	}
	if GhostPosition(steps, 150*time.Millisecond) != 2 || GhostPosition(steps, time.Second) != 3 {
		t.Fatal("ghost position follows the timeline")
	}
}
