package ui

import (
	"fmt"
	"time"

	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/progress"
	"github.com/omar/ridge/tui/internal/service"
	"github.com/omar/ridge/tui/internal/store"
)

// Frames run at 30–60 fps, so a View must never touch SQLite. Reads that
// views need go through these memoized getters; the cache is invalidated
// (Touch) around every key press and screen change — the only moments data can
// change — so animation frames cost nothing.

type memoEntry struct {
	ver int
	val any
}

// Touch invalidates every memoized read.
func (c *Ctx) Touch() { c.ver++ }

func memo[T any](c *Ctx, key string, fn func() T) T {
	if c.memo == nil {
		c.memo = map[string]memoEntry{}
	}
	if e, ok := c.memo[key]; ok && e.ver == c.ver {
		return e.val.(T)
	}
	v := fn()
	c.memo[key] = memoEntry{c.ver, v}
	return v
}

// TotalXP is the cumulative XP.
func (c *Ctx) TotalXP() int { return memo(c, "xp", c.DB.TotalXP) }

// PlayedDays is the set of local days with a session.
func (c *Ctx) PlayedDays() map[string]bool { return memo(c, "days", c.DB.PlayedDays) }

// Recent returns the newest sessions.
func (c *Ctx) Recent(n int) []store.Session {
	return memo(c, fmt.Sprint("recent", n), func() []store.Session { return c.DB.Recent(n) })
}

// DailyFor returns today's counted attempt.
func (c *Ctx) DailyFor(day string) (store.Daily, bool) {
	type r struct {
		d  store.Daily
		ok bool
	}
	v := memo(c, "daily."+day, func() r { d, ok := c.DB.DailyFor(day); return r{d, ok} })
	return v.d, v.ok
}

// DailyStreak is the daily-challenge streak.
func (c *Ctx) DailyStreak(now time.Time) int {
	return memo(c, "dstreak", func() int { return c.Svc.DailyStreak(now) })
}

// DailySnippet is today's snippet.
func (c *Ctx) DailySnippet(now time.Time) (content.Snippet, bool) {
	type r struct {
		s  content.Snippet
		ok bool
	}
	v := memo(c, "dsnip."+progress.DayKey(now), func() r { s, ok := c.Svc.DailySnippet(now); return r{s, ok} })
	return v.s, v.ok
}

// Unlocked returns achievements held.
func (c *Ctx) Unlocked() map[string]time.Time { return memo(c, "unlocked", c.DB.Unlocked) }

// HasPIN reports whether a PIN is set.
func (c *Ctx) HasPIN() bool { return memo(c, "pin", c.DB.HasPIN) }

// Profile is the local profile.
func (c *Ctx) Profile() store.Profile { return memo(c, "profile", c.DB.LoadProfile) }

// Lessons derives the unlock state of a path.
func (c *Ctx) Lessons(p content.Path) map[string]progress.LessonResult {
	return memo(c, "lessons."+p.ID, func() map[string]progress.LessonResult { return c.Svc.Lessons(p) })
}

// LangProgress counts completed/total lessons of a language.
func (c *Ctx) LangProgress(l string) (int, int) {
	type r struct{ d, t int }
	v := memo(c, "lang."+l, func() r { d, t := c.Svc.LanguageProgress(l); return r{d, t} })
	return v.d, v.t
}

// Snapshot is the progress snapshot.
func (c *Ctx) Snapshot() service.Snapshot {
	return memo(c, "snapshot", func() service.Snapshot { return c.Svc.Snapshot(c.Now()) })
}
