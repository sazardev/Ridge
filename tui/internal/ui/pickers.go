package ui

import (
	"fmt"
	"math/rand"
	"sort"
	"strings"
	"time"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/progress"
	"github.com/omar/ridge/tui/internal/service"
	"github.com/omar/ridge/tui/internal/typing"
)

func init() {
	addStrings(map[string][2]string{
		"free.title":   {"Free practice", "Práctica libre"},
		"warm.title":   {"Warm-up", "Calentamiento"},
		"warm.chars":   {"Weak characters", "Caracteres débiles"},
		"warm.finger":  {"Weakest finger", "Dedo más débil"},
		"warm.hand":    {"Weakest hand", "Mano más débil"},
		"warm.none":    {"Play a few sessions first — Ridge needs data to find your weak spots.", "Juega unas sesiones primero — Ridge necesita datos para encontrar tus puntos débiles."},
		"daily.today":  {"Today", "Hoy"},
		"daily.start":  {"press enter to start — one counted attempt per day", "pulsa enter para empezar — un intento cuenta por día"},
		"daily.score":  {"Score", "Puntaje"},
		"daily.global": {"The same snippet for everyone, picked from the UTC date.", "El mismo snippet para todos, elegido por la fecha UTC."},
	})
}

// freeScreen is the free-practice hub. lang is this screen's own language
// pick (like the app's free-practice chip); empty follows the active language.
type freeScreen struct {
	ctx  *Ctx
	m    *menu
	lang string
}

func newFree(c *Ctx) *freeScreen {
	return &freeScreen{c, newMenu(c, "free", []item{
		{Label: c.T("home.zen"), Detail: c.T("home.zen.d"), Value: "zen"},
		{Label: c.T("home.sprint"), Detail: c.T("home.sprint.d"), Value: "sprint"},
		{Label: c.T("home.prec"), Detail: c.T("home.prec.d"), Value: "precision"},
		{Label: c.T("home.surv"), Detail: c.T("home.surv.d"), Value: "survival"},
	}), ""}
}

func (f *freeScreen) currentLang() string {
	if f.lang != "" {
		return f.lang
	}
	return f.ctx.Lang()
}

func (f *freeScreen) Title() string { return f.ctx.T("free.title") }
func (f *freeScreen) Init() tea.Cmd { return nil }

func (f *freeScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return f, nil
	}
	switch k.String() {
	case "up", "k":
		f.m.move(-1)
	case "down", "j":
		f.m.move(1)
	case "L":
		return f, push(newLanguagePicker(f.ctx, f.currentLang(), func(l string) { f.lang = l }))
	case "esc", "q":
		return f, pop()
	case "enter":
		it, _ := f.m.selected()
		switch v := it.Value.(string); v {
		case "sprint":
			return f, push(newSprintPicker(f.ctx, f.currentLang()))
		default:
			return f, push(newSnippetPicker(f.ctx, v, f.currentLang()))
		}
	}
	return f, nil
}

func (f *freeScreen) View() string {
	return lipgloss.JoinVertical(lipgloss.Left, f.ctx.S.Muted.Render(langName(f.currentLang())), "", f.m.view(contentWidth(f.ctx), 8))
}

func (f *freeScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"), kb("enter", "enter", "open"), kb("L", "L", "language"), kb("esc", "esc", "back"))}
}

// languagePicker chooses one language for the screen that pushed it, without
// changing the active course language (the app's free-practice chip behavior).
type languagePicker struct {
	ctx    *Ctx
	m      *menu
	onPick func(string)
}

func newLanguagePicker(c *Ctx, current string, onPick func(string)) *languagePicker {
	var items []item
	cur := 0
	for i, l := range c.Cat.Languages() {
		badge := ""
		if l == current {
			badge = c.S.Success.Render(c.G.Check)
			cur = i
		}
		items = append(items, item{Label: langName(l), Value: l, Badge: badge})
	}
	m := newMenu(c, "langs.pick", items)
	m.cursor = cur
	m.filterable = true
	m.syncHeat(true)
	return &languagePicker{c, m, onPick}
}

func (p *languagePicker) Title() string { return p.ctx.T("lang.title") }
func (p *languagePicker) Init() tea.Cmd { return nil }

func (p *languagePicker) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return p, nil
	}
	if p.m.handleFilter(k.String(), k.Runes) {
		return p, nil
	}
	switch k.String() {
	case "up", "k":
		p.m.move(-1)
	case "down", "j":
		p.m.move(1)
	case "esc", "q":
		return p, pop()
	case "enter":
		if it, ok := p.m.selected(); ok {
			p.onPick(it.Value.(string))
			return p, pop()
		}
	}
	return p, nil
}

func (p *languagePicker) View() string { return p.m.view(contentWidth(p.ctx), p.ctx.H-10) }

func (p *languagePicker) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"),
		kb("enter", "enter", "select"), kb("/", "/", "filter"), kb("esc", "esc", "back"))}
}

// snippetPicker lists the active language's snippets (Zen / Precision /
// Survival) with "/" filtering, difficulty locks by account level and — on
// wide terminals — a preview pane with the bilingual explanation.
type snippetPicker struct {
	ctx  *Ctx
	mode string
	lang string
	m    *menu
}

var diffRank = map[content.Difficulty]int{content.Beginner: 0, content.Intermediate: 1, content.Advanced: 2, content.Expert: 3}

func newSnippetPicker(c *Ctx, mode, lang string) *snippetPicker {
	lvl := typing.LevelForXP(c.TotalXP())
	done := c.DB.SnippetsDone()
	list := append([]content.Snippet(nil), c.Cat.SnippetsFor(lang)...)
	sort.SliceStable(list, func(i, j int) bool { return diffRank[list[i].Difficulty] < diffRank[list[j].Difficulty] })
	var items []item
	for _, sn := range list {
		need := typing.UnlockLevel[string(sn.Difficulty)]
		it := item{Label: sn.Title(c.Loc()), Detail: categoryLabel(sn.Category), Value: sn, Badge: c.S.Muted.Render(string(sn.Difficulty))}
		if lvl < need {
			it.Disabled = true
			it.Badge = c.S.Warning.Render(fmt.Sprintf("%s %s %d", c.G.Lock, c.T("level"), need))
		} else if done[sn.ID] {
			it.Badge = c.S.Success.Render(c.G.Check) + " " + it.Badge
		}
		items = append(items, it)
	}
	m := newMenu(c, "snip."+mode, items)
	m.filterable = true
	return &snippetPicker{c, mode, lang, m}
}

func (p *snippetPicker) Title() string { return p.ctx.T("mode." + p.mode) }
func (p *snippetPicker) Init() tea.Cmd { return nil }

func (p *snippetPicker) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return p, nil
	}
	if p.m.handleFilter(k.String(), k.Runes) {
		return p, nil
	}
	switch k.String() {
	case "up", "k":
		p.m.move(-1)
	case "down", "j":
		p.m.move(1)
	case "esc", "q":
		return p, pop()
	case "enter":
		if it, ok := p.m.selected(); ok && !it.Disabled {
			return p, push(newPractice(p.ctx, runSpec{Mode: p.mode, Snippet: it.Value.(content.Snippet)}))
		}
	}
	return p, nil
}

func (p *snippetPicker) View() string {
	c, s := p.ctx, p.ctx.S
	w := contentWidth(c)
	title := s.Muted.Render(langName(p.lang))
	if c.W >= 120 {
		lw := w/2 + 4
		list := p.m.view(lw, c.H-10)
		it, ok := p.m.selected()
		prev := ""
		if ok {
			sn := it.Value.(content.Snippet)
			prev = s.Title.Render(sn.Title(c.Loc())) + "\n" + c.inline(sn.Tldr(c.Loc()), s.Muted) + "\n\n" +
				c.renderMarkdown(sn.Explanation(c.Loc()), sn.Language, w-lw-6)
		}
		return lipgloss.JoinVertical(lipgloss.Left, title, "", lipgloss.JoinHorizontal(lipgloss.Top, list, "  ",
			s.Pane.Width(w-lw-6).Render(prev)))
	}
	return lipgloss.JoinVertical(lipgloss.Left, title, "", p.m.view(w, c.H-10))
}

func (p *snippetPicker) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"),
		kb("enter", "enter", "start"), kb("/", "/", "filter"), kb("esc", "esc", "back"))}
}

// categoryLabel makes a camelCase category readable ("variablesAndTypes" → "variables and types").
func categoryLabel(cat string) string {
	var b strings.Builder
	for i, r := range cat {
		if i > 0 && r >= 'A' && r <= 'Z' {
			b.WriteByte(' ')
			b.WriteRune(r + 32)
			continue
		}
		b.WriteRune(r)
	}
	return b.String()
}

// sprintPicker chooses the window, then starts a chained run.
type sprintPicker struct {
	ctx  *Ctx
	lang string
	m    *menu
}

func newSprintPicker(c *Ctx, lang string) *sprintPicker {
	return &sprintPicker{c, lang, newMenu(c, "sprint", []item{{Label: "30 s", Value: 30}, {Label: "60 s", Value: 60}, {Label: "120 s", Value: 120}})}
}

func (p *sprintPicker) Title() string { return p.ctx.T("mode.sprint") }
func (p *sprintPicker) Init() tea.Cmd { return nil }

func (p *sprintPicker) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return p, nil
	}
	switch k.String() {
	case "up", "k":
		p.m.move(-1)
	case "down", "j":
		p.m.move(1)
	case "esc", "q":
		return p, pop()
	case "enter":
		it, _ := p.m.selected()
		d := content.Beginner
		for _, cand := range []content.Difficulty{content.Intermediate, content.Beginner} {
			if typing.LevelForXP(p.ctx.TotalXP()) >= typing.UnlockLevel[string(cand)] {
				d = cand
				break
			}
		}
		return p, push(newPractice(p.ctx, runSpec{Mode: "sprint", Snippet: randomSnippet(p.ctx, p.lang, d), Window: time.Duration(it.Value.(int)) * time.Second}))
	}
	return p, nil
}

// randomSnippet is a random snippet of a language at a difficulty.
func randomSnippet(c *Ctx, lang string, d content.Difficulty) content.Snippet {
	var pool []content.Snippet
	for _, s := range c.Cat.SnippetsFor(lang) {
		if s.Difficulty == d {
			pool = append(pool, s)
		}
	}
	if len(pool) == 0 {
		pool = c.Cat.SnippetsFor(lang)
	}
	return pool[rand.Intn(len(pool))]
}

func (p *sprintPicker) View() string { return p.m.view(contentWidth(p.ctx), 6) }

func (p *sprintPicker) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"), kb("enter", "enter", "start"), kb("esc", "esc", "back"))}
}

// dailyScreen is the Daily Challenge (SPEC §5.4): the same Go snippet for the
// whole world, picked from the UTC date; one counted attempt per day.
type dailyScreen struct{ ctx *Ctx }

func newDaily(c *Ctx) Screen { return &dailyScreen{c} }

func (d *dailyScreen) Title() string { return d.ctx.T("home.daily") }
func (d *dailyScreen) Init() tea.Cmd { return nil }

func (d *dailyScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return d, nil
	}
	switch k.String() {
	case "esc", "q":
		return d, pop()
	case "enter":
		now := d.ctx.Now()
		if _, done := d.ctx.DailyFor(progress.DayKey(now)); !done {
			if sn, ok := d.ctx.DailySnippet(now); ok {
				return d, replace(newPractice(d.ctx, runSpec{Mode: "daily", Snippet: sn}))
			}
		}
	}
	return d, nil
}

func (d *dailyScreen) View() string {
	c, s := d.ctx, d.ctx.S
	now := c.Now()
	sn, ok := c.DailySnippet(now)
	if !ok {
		return s.Error.Render(c.G.Cross + " no Go snippets available")
	}
	lines := []string{
		s.BadgeAccent.Render(c.T("daily.today")) + " " + s.Badge.Render(progress.DayKey(now)) + " " +
			s.Badge.Render(fmt.Sprintf("%d %s", c.DailyStreak(now), c.T("daily.streak"))),
		"", s.Title.Render(sn.Title(c.Loc())), c.inline(sn.Tldr(c.Loc()), s.Muted), "",
	}
	if x, done := c.DailyFor(progress.DayKey(now)); done {
		v := s.Success.Render(c.G.Check + " " + c.T("daily.done"))
		lines = append(lines, v, s.Muted.Render(fmt.Sprintf("%s %d/10", c.T("daily.score"), x.Score)))
	} else {
		lines = append(lines, s.Muted.Render(c.G.Arrow+" "+c.T("daily.start")))
	}
	return strings.Join(lines, "\n") + "\n\n" + s.Muted.Render(c.T("daily.global"))
}

func (d *dailyScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("enter", "enter", "start"), kb("esc", "esc", "back"))}
}

// warmUpScreen drills the user's weak characters / finger / hand (SPEC §4.3).
type warmUpScreen struct {
	ctx *Ctx
	m   *menu
}

func newWarmUp(c *Ctx) *warmUpScreen {
	return &warmUpScreen{c, newMenu(c, "warm", []item{
		{Label: c.T("warm.chars"), Value: service.WarmChars},
		{Label: c.T("warm.finger"), Value: service.WarmFinger},
		{Label: c.T("warm.hand"), Value: service.WarmHand},
	})}
}

func (w *warmUpScreen) Title() string { return w.ctx.T("warm.title") }
func (w *warmUpScreen) Init() tea.Cmd { return nil }

func (w *warmUpScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return w, nil
	}
	switch k.String() {
	case "up", "k":
		w.m.move(-1)
	case "down", "j":
		w.m.move(1)
	case "esc", "q":
		return w, pop()
	case "enter":
		it, _ := w.m.selected()
		sn, found := w.ctx.Svc.Recommended(w.ctx.Lang(), it.Value.(service.WarmUpTarget), w.ctx.Now())
		if !found {
			w.ctx.Notify(w.ctx.T("warm.none"))
			return w, nil
		}
		return w, replace(newPractice(w.ctx, runSpec{Mode: "zen", Snippet: sn}))
	}
	return w, nil
}

func (w *warmUpScreen) View() string {
	c, s := w.ctx, w.ctx.S
	snap := c.Snapshot()
	hint := s.Muted.Render(c.G.Bullet + " " + c.T("warm.none"))
	if len(snap.Characters) > 0 {
		var cs []string
		for _, e := range snap.Characters[:min(6, len(snap.Characters))] {
			cs = append(cs, s.Error.Render(e.Key))
		}
		hint = s.Muted.Render(c.T("weak")+": ") + strings.Join(cs, " ")
	}
	return lipgloss.JoinVertical(lipgloss.Left, hint, "", w.m.view(contentWidth(c), 6))
}

func (w *warmUpScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"), kb("enter", "enter", "start"), kb("esc", "esc", "back"))}
}
