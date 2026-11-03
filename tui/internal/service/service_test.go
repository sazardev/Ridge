package service

import (
	"testing"
	"time"

	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/store"
	"github.com/omar/ridge/tui/internal/typing"
)

func newSvc(t *testing.T) *Service {
	t.Helper()
	cat, err := content.Load()
	if err != nil {
		t.Fatal(err)
	}
	db, err := store.Open(":memory:")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { db.Close() })
	return &Service{DB: db, Cat: cat}
}

// perfectRun types a snippet flawlessly at ~dur total.
func perfectRun(sn content.Snippet, start time.Time, perKey time.Duration) ([]typing.Keystroke, time.Duration) {
	r := typing.NewRecorder(sn.Code)
	now := start
	for _, c := range sn.Code {
		now = now.Add(perKey)
		r.Char(c, now)
	}
	return r.Events(), now.Sub(start)
}

func snippetOf(t *testing.T, s *Service, d content.Difficulty) content.Snippet {
	for _, sn := range s.Cat.SnippetsFor("go") {
		if sn.Difficulty == d {
			return sn
		}
	}
	t.Fatal("no snippet")
	return content.Snippet{}
}

func TestFinishSessionAwardsXPFirstBonusAndAchievements(t *testing.T) {
	s := newSvc(t)
	sn := snippetOf(t, s, content.Beginner)
	now := time.Now()
	ev, el := perfectRun(sn, now, 60*time.Millisecond)
	out, err := s.FinishSession(Run{Mode: "zen", Snippet: sn, Events: ev, Elapsed: el, Complete: true, Now: now})
	if err != nil {
		t.Fatal(err)
	}
	if !out.First || out.XP < typing.FirstCompletionBonus || out.Metrics.Accuracy != 100 {
		t.Fatalf("outcome = %+v", out)
	}
	has := map[string]bool{}
	for _, k := range out.Unlocked {
		has[k] = true
	}
	if !has["cero_errores"] {
		t.Fatalf("a flawless run earns Zero Errors, got %v", out.Unlocked)
	}
	// Second run of the same snippet is no longer a first completion.
	out2, _ := s.FinishSession(Run{Mode: "zen", Snippet: sn, Events: ev, Elapsed: el, Complete: true, Now: now.Add(time.Minute)})
	if out2.First {
		t.Fatal("first-time bonus is one-shot")
	}
	if len(out2.Unlocked) != 0 {
		t.Fatal("achievements unlock once")
	}
}

func TestPrecisionRunsCertifyMasteryAndLessonsUnlock(t *testing.T) {
	s := newSvc(t)
	sn := snippetOf(t, s, content.Beginner)
	now := time.Now()
	ev, _ := perfectRun(sn, now, 10*time.Millisecond) // very fast: clears the 150 cpm floor
	var last Outcome
	for i := 0; i < 5; i++ {
		var err error
		last, err = s.FinishSession(Run{Mode: "precision", Snippet: sn, Events: ev, Elapsed: time.Duration(len(sn.Code)) * 10 * time.Millisecond,
			Complete: true, Now: now.Add(time.Duration(i) * time.Minute)})
		if err != nil {
			t.Fatal(err)
		}
	}
	if last.Mastery == nil || !last.Mastery.IsMastered {
		t.Fatalf("5 passing precision runs certify mastery, got %+v", last.Mastery)
	}
	if _, ok := s.DB.Unlocked()["category_mastery_"+sn.Category+"_beginner"]; !ok {
		t.Fatal("mastery achievement unlocked")
	}

	p := s.Cat.PathsFor("go")[0]
	l0 := p.Lessons[0]
	lsn, _ := s.Cat.Snippet(l0.SnippetID)
	lev, lel := perfectRun(lsn, now, 50*time.Millisecond)
	out, _ := s.FinishSession(Run{Mode: "lesson", Snippet: lsn, LessonID: l0.ID, Events: lev, Elapsed: lel, Complete: true, Now: now})
	if !out.Passed {
		t.Fatal("a perfect lesson run passes")
	}
	if st := s.Lessons(p)[p.Lessons[1].ID].State; st != 1 /* progress.Unlocked */ {
		t.Fatalf("lesson 2 should unlock, state=%v", st)
	}
}

func TestDailyIsDeterministicAndSingleAttempt(t *testing.T) {
	s := newSvc(t)
	now := time.Date(2026, 11, 3, 10, 0, 0, 0, time.UTC)
	a, ok := s.DailySnippet(now)
	b, _ := s.DailySnippet(now.Add(5 * time.Hour))
	if !ok || a.ID != b.ID {
		t.Fatal("same UTC day → same snippet")
	}
	if c, _ := s.DailySnippet(now.AddDate(0, 0, 1)); c.ID == "" {
		t.Fatal("next day has a snippet")
	}
	if a.Difficulty != content.Beginner && a.Difficulty != content.Intermediate {
		t.Fatal("daily draws from beginner+intermediate Go")
	}
}

func TestGhostAndRecommendation(t *testing.T) {
	s := newSvc(t)
	sn := snippetOf(t, s, content.Beginner)
	now := time.Now()
	if _, _, ok := s.Ghost(sn.ID); ok {
		t.Fatal("no ghost before a first run")
	}
	ev, el := perfectRun(sn, now, 40*time.Millisecond)
	s.FinishSession(Run{Mode: "zen", Snippet: sn, Events: ev, Elapsed: el, Complete: true, Now: now})
	steps, cpm, ok := s.Ghost(sn.ID)
	if !ok || len(steps) != len([]rune(sn.Code)) || cpm <= 0 {
		t.Fatalf("ghost = %d steps cpm=%v", len(steps), cpm)
	}
	// Ranking also weighs slowness (like the app), so any history yields a recommendation.
	if rec, found := s.Recommended("go", WarmChars, now); !found || rec.Code == "" {
		t.Fatal("with history, warm-up recommends a snippet")
	}
	if _, found := (&Service{DB: newSvc(t).DB, Cat: s.Cat}).Recommended("go", WarmFinger, now); found {
		t.Fatal("without history there is nothing to recommend")
	}
}
