package typing

import "math"

// XP + level formulas, ported 1:1 from xp_calculator.dart / level_calculator.dart.

var difficultyMultiplier = map[string]float64{
	"beginner": 1.0, "intermediate": 1.3, "advanced": 1.6, "expert": 2.0,
}

// UnlockLevel is the account level needed per difficulty (SPEC §6.2).
var UnlockLevel = map[string]int{"beginner": 1, "intermediate": 5, "advanced": 15, "expert": 30}

const (
	FirstCompletionBonus = 50
	StreakBonusCapDays   = 14
	StreakBonusPerDay    = 5
)

// XP returns the XP awarded for a session.
func XP(correctFirstTry int, difficulty string, accuracyPct float64, first bool, streakDays int) int {
	dm, ok := difficultyMultiplier[difficulty]
	if !ok {
		dm = 1
	}
	acc := math.Max(0.5, math.Min(1.0, 0.5+0.5*accuracyPct/100))
	base := int(math.Floor(float64(correctFirstTry) * dm * acc))
	bonus := 0
	if first {
		bonus = FirstCompletionBonus
	}
	d := streakDays
	if d > StreakBonusCapDays {
		d = StreakBonusCapDays
	}
	return base + bonus + d*StreakBonusPerDay
}

// XPForLevel is the cumulative XP needed to reach a level.
func XPForLevel(level int) int {
	if level <= 1 {
		return 0
	}
	raw := 100 * math.Pow(float64(level), 1.6)
	return int(math.Round(raw/10)) * 10
}

// LevelForXP is the account level for a cumulative XP.
func LevelForXP(xp int) int {
	l := 1
	for xp >= XPForLevel(l+1) {
		l++
	}
	return l
}

// PrecisionScore maps accuracy to 1..10 (precision_score_calculator.dart).
func PrecisionScore(accuracyPct float64) int {
	s := int(math.Floor(accuracyPct / 10))
	if s < 1 {
		return 1
	}
	if s > 10 {
		return 10
	}
	return s
}

// PrecisionPasses is the lesson-completion criterion (SPEC §5.3).
func PrecisionPasses(accuracyPct float64) bool { return PrecisionScore(accuracyPct) > 7 }

// Survival tracks lives, combo and score (SPEC §5.8).
type Survival struct {
	Lives, Streak, Score, Cleared, BestMultiplier int
}

const (
	SurvivalLives       = 5
	StreakPerMultiplier = 25
	MaxMultiplier       = 4
)

// NewSurvival starts a run with full lives.
func NewSurvival() *Survival { return &Survival{Lives: SurvivalLives, BestMultiplier: 1} }

// Multiplier is the current combo multiplier.
func (s *Survival) Multiplier() int {
	m := 1 + s.Streak/StreakPerMultiplier
	if m > MaxMultiplier {
		m = MaxMultiplier
	}
	return m
}

// Over reports whether the last life is gone.
func (s *Survival) Over() bool { return s.Lives <= 0 }

// Record applies one keystroke; returns true when the run just ended.
func (s *Survival) Record(r Result) bool {
	if r == Correct {
		s.Score += s.Multiplier()
		s.Streak++
		if m := s.Multiplier(); m > s.BestMultiplier {
			s.BestMultiplier = m
		}
		return false
	}
	if s.Over() {
		return true
	}
	s.Lives--
	s.Streak = 0
	return s.Over()
}
