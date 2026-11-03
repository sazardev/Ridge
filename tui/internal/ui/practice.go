package ui

import (
	"fmt"
	"math/rand"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/progress"
	"github.com/omar/ridge/tui/internal/service"
	"github.com/omar/ridge/tui/internal/typing"
)

func init() {
	addStrings(map[string][2]string{
		"ghost":   {"ghost", "fantasma"},
		"ahead":   {"ahead", "adelante"},
		"behind":  {"behind", "atrás"},
		"restart": {"restart", "reiniciar"},
	})
}

// runSpec describes one practice run; it is also what "retry" re-launches.
type runSpec struct {
	Mode     string // zen | sprint | precision | survival | lesson | daily
	Snippet  content.Snippet
	Window   time.Duration // sprint only
	LessonID string
	Path     string // course id (lesson mode)
	Index    int    // lesson index inside the course (lesson mode)
}

type practiceScreen struct {
	ctx      *Ctx
	spec     runSpec
	rec      *typing.Recorder
	events   []typing.Keystroke // finished snippets of a chained run
	snippet  content.Snippet
	started  bool
	startAt  time.Time
	surv     *typing.Survival
	cleared  int
	correct  int
	total    int
	streak   int
	notice   string
	lastKey  rune
	lastGood bool
	ghost    []progress.GhostStep
	ghostCPM float64
	typedAt  []time.Time // when each character was committed (drives the fade trail)
	win      codeWindow
	classes  []tokClass // syntax class of every character of the current snippet
}

func newPractice(ctx *Ctx, spec runSpec) *practiceScreen {
	p := &practiceScreen{ctx: ctx, spec: spec, snippet: spec.Snippet, rec: typing.NewRecorder(spec.Snippet.Code)}
	p.typedAt = make([]time.Time, len(p.rec.Expected()))
	p.classes = classify(spec.Snippet.Code, spec.Snippet.Language)
	if spec.Mode == "survival" {
		p.surv = typing.NewSurvival()
	}
	if spec.Mode != "sprint" && spec.Mode != "survival" {
		if g, cpm, ok := ctx.Svc.Ghost(spec.Snippet.ID); ok {
			p.ghost, p.ghostCPM = g, cpm
		}
	}
	for _, k := range []string{"p.pulse", "p.err", "p.bar", "p.wpm", "p.hurt", "p.scroll", "p.acc"} {
		ctx.Anim.Set(k, 0)
	}
	return p
}

// Title is the breadcrumb segment.
func (p *practiceScreen) Title() string { return p.ctx.T("mode." + p.spec.Mode) }

func (p *practiceScreen) Init() tea.Cmd { return nil }

// Ambient: the caret pulse and the ghost need idle frames while typing.
func (p *practiceScreen) Ambient() bool { return true }

func (p *practiceScreen) remaining() time.Duration {
	if !p.started {
		return p.spec.Window
	}
	r := p.spec.Window - p.ctx.Now().Sub(p.startAt)
	if r < 0 {
		return 0
	}
	return r
}

func (p *practiceScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	switch m := msg.(type) {
	case frameMsg:
		if p.started && p.spec.Mode == "sprint" && p.remaining() == 0 {
			return p, p.finish(false)
		}
	case tea.KeyMsg:
		if m.Paste { // paste would defeat the metrics (SPEC §14)
			p.notice = p.ctx.T("paste")
			return p, nil
		}
		return p.key(m)
	}
	return p, nil
}

func (p *practiceScreen) key(k tea.KeyMsg) (Screen, tea.Cmd) {
	c := p.ctx
	now := c.Now()
	switch k.Type {
	case tea.KeyEsc:
		return p, pop()
	case tea.KeyCtrlR:
		return p, replace(newPractice(c, p.spec))
	}
	if !p.started {
		p.started, p.startAt = true, now
	}
	p.notice = ""
	before := p.rec.Cursor()
	var evs []typing.Keystroke
	switch k.Type {
	case tea.KeyTab:
		evs = p.rec.Tab(now)
	case tea.KeyEnter:
		evs = p.rec.Enter(now)
	case tea.KeyBackspace:
		p.rec.Backspace(now)
	case tea.KeySpace:
		if e := p.rec.Char(' ', now); e != nil {
			evs = []typing.Keystroke{*e}
		}
	case tea.KeyRunes:
		for _, r := range k.Runes {
			if e := p.rec.Char(r, now); e != nil {
				evs = append(evs, *e)
			}
		}
	}
	for i := before; i < p.rec.Cursor() && i < len(p.typedAt); i++ {
		p.typedAt[i] = now
	}
	for _, e := range evs {
		p.total++
		p.lastKey, p.lastGood = e.Actual, e.Result == typing.Correct
		// A pulse springs from 1 to 0 on every key: typed-char flash, ripple.
		c.Anim.Set("p.pulse", 1)
		c.Anim.To("p.pulse", 0, 16, 1)
		if e.Result == typing.Correct {
			p.correct++
			p.streak++
		} else {
			p.streak = 0
			c.Anim.Set("p.err", 1)
			c.Anim.To("p.err", 0, 9, 1)
			if c.Set.Bell {
				_, _ = fmt.Print("\a")
			}
		}
		if p.surv != nil {
			hurt := p.surv.Record(e.Result)
			if e.Result != typing.Correct {
				c.Anim.Set("p.hurt", 1)
				c.Anim.To("p.hurt", 0, 8, 1)
			}
			if hurt {
				return p, p.finish(false)
			}
		}
	}
	c.Anim.To("p.bar", p.progressFrac(), 12, 1)
	if p.rec.Complete() {
		switch p.spec.Mode {
		case "sprint", "survival":
			p.cleared++
			if p.surv != nil {
				p.surv.Cleared++
			}
			p.events = append(p.events, p.rec.Events()...)
			p.snippet = nextSnippet(c, p.spec.Snippet)
			p.rec = typing.NewRecorder(p.snippet.Code)
			p.typedAt = make([]time.Time, len(p.rec.Expected()))
			p.classes = classify(p.snippet.Code, p.snippet.Language)
			c.Anim.Set("p.bar", 0)
		default:
			return p, p.finish(true)
		}
	}
	return p, nil
}

func (p *practiceScreen) progressFrac() float64 {
	n := len(p.rec.Expected())
	if n == 0 {
		return 0
	}
	return float64(p.rec.Cursor()) / float64(n)
}

// nextSnippet picks another snippet of the same language and difficulty.
func nextSnippet(c *Ctx, like content.Snippet) content.Snippet {
	var pool []content.Snippet
	for _, s := range c.Cat.SnippetsFor(like.Language) {
		if s.Difficulty == like.Difficulty && s.ID != like.ID {
			pool = append(pool, s)
		}
	}
	if len(pool) == 0 {
		return like
	}
	return pool[rand.Intn(len(pool))]
}

// finish persists the run through the service and opens the results.
func (p *practiceScreen) finish(complete bool) tea.Cmd {
	c := p.ctx
	now := c.Now()
	elapsed := now.Sub(p.startAt)
	if p.spec.Mode == "sprint" && !complete {
		elapsed = p.spec.Window
	}
	all := append(append([]typing.Keystroke{}, p.events...), p.rec.Events()...)
	out, err := c.Svc.FinishSession(service.Run{
		Mode: p.spec.Mode, Snippet: p.spec.Snippet, LessonID: p.spec.LessonID,
		Events: all, Elapsed: elapsed, Complete: complete, Now: now,
	})
	if err != nil {
		c.Notify(err.Error())
		return pop()
	}
	for _, k := range out.Unlocked {
		c.Notify(c.T("toast.unlocked") + " " + achievementTitle(c, k))
	}
	return replace(newResults(c, &result{Spec: p.spec, Out: out, Surv: p.surv, Cleared: p.cleared, Complete: complete}))
}
