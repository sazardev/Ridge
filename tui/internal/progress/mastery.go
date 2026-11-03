package progress

import (
	"fmt"
	"hash/fnv"
	"sort"
	"strings"
	"time"
)

// Mastery certification (SPEC §6.4). Speeds are chars/min, like the app.
const (
	AccuracyFloor  = 98.0
	decayFloorPass = 4
)

// SpeedFloor is the net chars/min needed per difficulty.
var SpeedFloor = map[string]float64{"beginner": 150, "intermediate": 180, "advanced": 210, "expert": 240}

// PrecisionResult is one finished Precision session.
type PrecisionResult struct{ AccuracyPct, NetCPM float64 }

// MasteryStatus is the certified state of a (category, difficulty) pair.
type MasteryStatus struct {
	Category, Difficulty string
	IsMastered           bool
	PassCount            int // -1 when there is not enough history yet
}

// Passes reports whether one precision result clears the floors.
func Passes(r PrecisionResult, difficulty string) bool {
	return r.AccuracyPct >= AccuracyFloor && r.NetCPM >= SpeedFloor[difficulty]
}

// EvaluateMastery needs the last five results (newest first): certifies on
// 5/5, and only decays once fewer than 4/5 pass.
func EvaluateMastery(cat, diff string, was bool, lastFive []PrecisionResult) MasteryStatus {
	if len(lastFive) < 5 {
		return MasteryStatus{cat, diff, was, -1}
	}
	n := 0
	for _, r := range lastFive {
		if Passes(r, diff) {
			n++
		}
	}
	m := n == len(lastFive)
	if was {
		m = n >= decayFloorPass
	}
	return MasteryStatus{cat, diff, m, n}
}

// --- Achievements (SPEC §12) -------------------------------------------------

// Tier thresholds.
var (
	MaratonistaTiers = []struct {
		Name  string
		Chars int
	}{{"bronze", 50000}, {"silver", 250000}, {"gold", 1000000}}
	StreakTiers = []struct {
		Name string
		Days int
	}{{"threeDays", 3}, {"sevenDays", 7}, {"thirtyDays", 30}, {"hundredDays", 100}}
)

// Achievement storage keys, identical to the app's AchievementId.storageKey.
const (
	CeroErrores = "cero_errores"
	Ambidiestro = "ambidiestro"
)

// MasteryKey is the storage key of a category-mastery achievement.
func MasteryKey(cat, diff string) string { return "category_mastery_" + cat + "_" + diff }

// SessionInput is what the per-session rules look at.
type SessionInput struct {
	Accuracy, HandBalance float64
	Corrections, Forward  int
	SessionID             int64
}

// Facts is everything the achievement evaluation reads.
type Facts struct {
	Mastery       []MasteryStatus
	StreakDays    int
	Sessions      []SessionInput
	LifetimeChars int
}

// Unlock is an achievement newly earned (SessionID 0 when not session-bound).
type Unlock struct {
	Key       string
	SessionID int64
}

// Evaluate returns the achievements earned in facts that are not already held.
func Evaluate(f Facts, have map[string]bool) []Unlock {
	var out []Unlock
	add := func(k string, sid int64) {
		if !have[k] {
			have[k] = true
			out = append(out, Unlock{k, sid})
		}
	}
	for _, m := range f.Mastery {
		if m.IsMastered {
			add(MasteryKey(m.Category, m.Difficulty), 0)
		}
	}
	for _, t := range StreakTiers {
		if f.StreakDays >= t.Days {
			add("streak_"+t.Name, 0)
		}
	}
	for _, s := range f.Sessions {
		if s.Accuracy == 100.0 && s.Corrections == 0 {
			add(CeroErrores, s.SessionID)
		}
		if s.Forward >= 100 && s.HandBalance >= 0.95 {
			add(Ambidiestro, s.SessionID)
		}
	}
	for _, t := range MaratonistaTiers {
		if f.LifetimeChars >= t.Chars {
			add("maratonista_"+t.Name, 0)
		}
	}
	return out
}

// --- Lessons (SPEC §5.7) -----------------------------------------------------

// LessonState is locked / unlocked / completed.
type LessonState int

const (
	Locked LessonState = iota
	Unlocked
	Completed
)

// LessonAttempt is one run of a lesson.
type LessonAttempt struct {
	LessonID string
	Accuracy float64
	Passed   bool
}

// LessonResult is the derived progress of one lesson.
type LessonResult struct {
	State        LessonState
	BestAccuracy float64
	HasAttempt   bool
}

// LessonProgress unlocks lessons strictly in order.
func LessonProgress(ordered []string, attempts []LessonAttempt) map[string]LessonResult {
	by := map[string][]LessonAttempt{}
	for _, a := range attempts {
		by[a.LessonID] = append(by[a.LessonID], a)
	}
	out := map[string]LessonResult{}
	prev := true
	for _, id := range ordered {
		done, best := false, 0.0
		for _, a := range by[id] {
			done = done || a.Passed
			if a.Accuracy > best {
				best = a.Accuracy
			}
		}
		st := Locked
		switch {
		case done:
			st = Completed
		case prev:
			st = Unlocked
		}
		out[id] = LessonResult{st, best, len(by[id]) > 0}
		prev = done
	}
	return out
}

// --- Daily challenge (SPEC §5.4) ---------------------------------------------

// DailyIndex is FNV-1a32 over the ISO date mod n, as in DailyChallengeSelector.
func DailyIndex(isoDate string, n int) int {
	h := fnv.New32a()
	h.Write([]byte(isoDate))
	return int(h.Sum32()) % n
}

// SortedIDs returns ids sorted ascending (selector sorts candidates by id).
func SortedIDs(ids []string) []string {
	out := append([]string(nil), ids...)
	sort.Strings(out)
	return out
}

// DayKey formats a date as the app's ChallengeDate.isoKey.
func DayKey(t time.Time) string { return t.UTC().Format("2006-01-02") }

// Pct formats a ratio for logs/tests.
func Pct(v float64) string { return strings.TrimSuffix(fmt.Sprintf("%.1f", v), ".0") + "%" }
