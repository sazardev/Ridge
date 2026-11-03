// Package service holds the use cases: they orchestrate the typing engine, the
// pure progression rules and the store, like the Flutter application layer.
package service

import (
	"strings"
	"time"

	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/progress"
	"github.com/omar/ridge/tui/internal/store"
	"github.com/omar/ridge/tui/internal/typing"
)

// Service is the application facade used by the UI.
type Service struct {
	DB  *store.DB
	Cat *content.Catalog
}

// Run is a finished practice run handed to FinishSession.
type Run struct {
	Mode     string // zen | sprint | precision | survival | lesson | daily
	Snippet  content.Snippet
	LessonID string
	Events   []typing.Keystroke
	Elapsed  time.Duration
	Complete bool // false when the run ended by timeout / game over
	Now      time.Time
}

// Outcome is what the results screen shows.
type Outcome struct {
	SessionID               int64
	Metrics                 typing.Metrics
	XP                      int
	First, Passed           bool
	LevelBefore, LevelAfter int
	TotalXP                 int
	Unlocked                []string // achievement keys earned by this run
	Mastery                 *progress.MasteryStatus
	PersonalBest            bool
}

// FinishSession computes metrics + XP, persists everything and re-evaluates
// mastery and achievements (RecomputeProgressSnapshot + EvaluateAchievements).
func (s *Service) FinishSession(r Run) (Outcome, error) {
	m := typing.Calculate(r.Events, r.Elapsed)
	before := s.DB.TotalXP()
	first := !s.DB.HasCompleted(r.Snippet.ID)
	days := s.DB.PlayedDays()
	days[r.Now.Local().Format("2006-01-02")] = true
	streak := progress.Streak(days, r.Now.Local())
	diff := string(r.Snippet.Difficulty)
	xp := typing.XP(m.CorrectFirstTryChars, diff, m.Accuracy, first, streak)

	passed := false
	switch r.Mode {
	case "precision", "lesson", "daily":
		passed = r.Complete && typing.PrecisionPasses(m.Accuracy)
	}
	var prevBest float64
	for _, p := range s.DB.ForSnippet(r.Snippet.ID) {
		if p.NetCPM > prevBest {
			prevBest = p.NetCPM
		}
	}
	id, err := s.DB.SaveSession(store.Session{
		At: r.Now, Mode: r.Mode, LessonID: r.LessonID, SnippetID: r.Snippet.ID, Language: r.Snippet.Language,
		Category: r.Snippet.Category, Difficulty: diff, Duration: r.Elapsed, RawCPM: m.RawCPM, NetCPM: m.NetCPM,
		Accuracy: m.Accuracy, Consistency: m.Consistency, HandBalance: m.HandBalance, MaxStreak: m.MaxStreak,
		Corrections: m.Corrections, Forward: len(forwardOnly(r.Events)), Correct: m.CorrectFirstTryChars,
		Fatigue: m.FatigueCPM, Passed: passed, First: first, XP: xp,
	}, r.Events)
	if err != nil {
		return Outcome{}, err
	}
	out := Outcome{SessionID: id, Metrics: m, XP: xp, First: first, Passed: passed,
		LevelBefore: typing.LevelForXP(before), PersonalBest: prevBest > 0 && m.NetCPM > prevBest}
	out.TotalXP = before + xp
	out.LevelAfter = typing.LevelForXP(out.TotalXP)

	if r.Mode == "daily" {
		_ = s.DB.RecordDaily(store.Daily{Date: progress.DayKey(r.Now), SnippetID: r.Snippet.ID,
			Score: typing.PrecisionScore(m.Accuracy), Passed: passed}, id, r.Now)
	}
	if r.Mode == "precision" {
		was, _ := s.DB.Mastery(r.Snippet.Category, diff)
		st := progress.EvaluateMastery(r.Snippet.Category, diff, was.IsMastered, s.DB.RecentPrecision(r.Snippet.Category, diff))
		_ = s.DB.PutMastery(st, r.Now)
		out.Mastery = &st
	}
	out.Unlocked = s.EvaluateAchievements(r.Now)
	return out, nil
}

func forwardOnly(ev []typing.Keystroke) []typing.Keystroke {
	var out []typing.Keystroke
	for _, k := range ev {
		if !k.IsCorrection {
			out = append(out, k)
		}
	}
	return out
}

// EvaluateAchievements unlocks every newly earned achievement and returns the keys.
func (s *Service) EvaluateAchievements(now time.Time) []string {
	have := map[string]bool{}
	for k := range s.DB.Unlocked() {
		have[k] = true
	}
	facts := progress.Facts{
		Mastery:       s.DB.AllMastery(),
		StreakDays:    progress.Streak(s.DB.PlayedDays(), now.Local()),
		Sessions:      s.DB.SessionInputs(),
		LifetimeChars: s.DB.LifetimeCorrectChars(),
	}
	var keys []string
	for _, u := range progress.Evaluate(facts, have) {
		if s.DB.RecordUnlock(u.Key, now, u.SessionID) == nil {
			keys = append(keys, u.Key)
		}
	}
	return keys
}

// Snapshot is the progress screen's data (ProgressSnapshot).
type Snapshot struct {
	TotalXP, Level, XPAtLevel, XPForNext int
	StreakDays                           int
	Characters, Fingers, Ngrams, Keys    []progress.RankEntry
	Activity                             progress.ActivityReport
	Weekly                               progress.Weekly
	Mastery                              []progress.MasteryStatus
}

// Snapshot recomputes the progress snapshot.
func (s *Service) Snapshot(now time.Time) Snapshot {
	xp := s.DB.TotalXP()
	lvl := typing.LevelForXP(xp)
	c, f, n, t := s.DB.WeaknessSamples(now)
	return Snapshot{
		TotalXP: xp, Level: lvl, XPAtLevel: typing.XPForLevel(lvl), XPForNext: typing.XPForLevel(lvl + 1),
		StreakDays: progress.Streak(s.DB.PlayedDays(), now.Local()),
		Characters: progress.Rank(c, 10), Fingers: progress.Rank(f, 10), Ngrams: progress.Rank(n, 10), Keys: progress.Rank(t, 10),
		Activity: progress.Activity(s.DB.ActivitySamples(), now),
		Weekly:   progress.WeeklySummary(s.DB.WeeklySessions(), now),
		Mastery:  s.DB.AllMastery(),
	}
}

// WarmUpTarget selects what a warm-up drills.
type WarmUpTarget int

const (
	WarmChars WarmUpTarget = iota
	WarmFinger
	WarmHand
)

// Recommended picks the snippet densest in the user's weak spots (GetRecommendedSnippet).
func (s *Service) Recommended(lang string, target WarmUpTarget, now time.Time) (content.Snippet, bool) {
	c, f, _, _ := s.DB.WeaknessSamples(now)
	var chars []rune
	switch target {
	case WarmChars:
		for _, e := range progress.Rank(c, 10) {
			chars = append(chars, []rune(e.Key)...)
		}
	case WarmFinger, WarmHand:
		r := progress.Rank(f, 1)
		if len(r) == 0 {
			return content.Snippet{}, false
		}
		fg := typing.Finger(r[0].Key)
		if target == WarmFinger {
			chars = typing.CharsForFinger(fg)
		} else {
			chars = typing.CharsForHand(fg.Hand())
		}
	}
	if len(chars) == 0 {
		return content.Snippet{}, false
	}
	var best content.Snippet
	bestD, found := -1, false
	for _, sn := range s.Cat.SnippetsFor(lang) {
		d := 0
		for _, ch := range dedupe(chars) {
			if strings.ContainsRune(sn.Code, ch) {
				d++
			}
		}
		if d == 0 {
			continue
		}
		if d > bestD || (d == bestD && len(sn.Code) < len(best.Code)) {
			best, bestD, found = sn, d, true
		}
	}
	return best, found
}

func dedupe(r []rune) []rune {
	seen := map[rune]bool{}
	var out []rune
	for _, c := range r {
		if !seen[c] {
			seen[c] = true
			out = append(out, c)
		}
	}
	return out
}

// DailySnippet is today's Go snippet for everyone (beginner + intermediate,
// sorted by id, FNV-1a32 of the UTC date — DailyChallengeSelector).
func (s *Service) DailySnippet(now time.Time) (content.Snippet, bool) {
	var ids []string
	byID := map[string]content.Snippet{}
	for _, sn := range s.Cat.SnippetsFor("go") {
		if sn.Difficulty == content.Beginner || sn.Difficulty == content.Intermediate {
			ids = append(ids, sn.ID)
			byID[sn.ID] = sn
		}
	}
	if len(ids) == 0 {
		return content.Snippet{}, false
	}
	ids = progress.SortedIDs(ids)
	return byID[ids[progress.DailyIndex(progress.DayKey(now), len(ids))]], true
}

// DailyStreak is the consecutive-days daily challenge streak.
func (s *Service) DailyStreak(now time.Time) int {
	return progress.Streak(s.DB.DailyDates(), now.UTC())
}

// Ghost returns the best previous run of a snippet to race against.
func (s *Service) Ghost(snippetID string) (steps []progress.GhostStep, cpm float64, ok bool) {
	var best *store.Session
	for _, x := range s.DB.ForSnippet(snippetID) {
		x := x
		if best == nil || x.NetCPM > best.NetCPM {
			best = &x
		}
	}
	if best == nil {
		return nil, 0, false
	}
	steps = progress.FoldGhost(s.DB.Keystrokes(best.ID))
	return steps, best.NetCPM, len(steps) > 0
}

// Lessons derives the unlock state of a path's lessons.
func (s *Service) Lessons(p content.Path) map[string]progress.LessonResult {
	ids := make([]string, len(p.Lessons))
	for i, l := range p.Lessons {
		ids[i] = l.ID
	}
	return progress.LessonProgress(ids, s.DB.LessonAttempts())
}

// LanguageProgress counts completed/total lessons of a language.
func (s *Service) LanguageProgress(lang string) (done, total int) {
	att := s.DB.LessonAttempts()
	for _, p := range s.Cat.PathsFor(lang) {
		ids := make([]string, len(p.Lessons))
		for i, l := range p.Lessons {
			ids[i] = l.ID
		}
		for _, r := range progress.LessonProgress(ids, att) {
			total++
			if r.State == progress.Completed {
				done++
			}
		}
	}
	return
}
