package ui

import (
	"fmt"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/progress"
)

func init() {
	addStrings(map[string][2]string{
		"lessons.reset": {"reset lesson", "reiniciar lección"},
		"lang.title":    {"Choose a language", "Elige un lenguaje"},
		"lang.switch":   {"switch language", "cambiar lenguaje"},
	})
}

// coursesScreen lists the active language's learning paths with progress.
type coursesScreen struct {
	ctx *Ctx
	m   *menu
}

func newCourses(c *Ctx) *coursesScreen {
	s := &coursesScreen{ctx: c}
	s.m = newMenu(c, "courses", s.items())
	return s
}

func (s *coursesScreen) items() []item {
	c := s.ctx
	var items []item
	for _, p := range c.Cat.PathsFor(c.Lang()) {
		done := 0
		for _, r := range c.Lessons(p) {
			if r.State == progress.Completed {
				done++
			}
		}
		bar := renderBar(c, float64(done)/float64(max(1, len(p.Lessons))), 8)
		items = append(items, item{Label: p.Title(c.Loc()), Detail: p.Tag(c.Loc()), Value: p,
			Badge: bar + c.S.Muted.Render(fmt.Sprintf(" %d/%d", done, len(p.Lessons)))})
	}
	return items
}

func (s *coursesScreen) Title() string    { return s.ctx.T("courses.title") }
func (s *coursesScreen) menuModel() *menu { return s.m }
func (s *coursesScreen) Init() tea.Cmd    { return nil }

func (s *coursesScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return s, nil
	}
	switch k.String() {
	case "up", "k":
		s.m.move(-1)
	case "down", "j":
		s.m.move(1)
	case "esc", "q":
		return s, pop()
	case "L":
		return s, push(newLanguages(s.ctx))
	case "enter":
		if it, ok := s.m.selected(); ok {
			return s, push(newLessons(s.ctx, it.Value.(content.Path)))
		}
	}
	// A language change (or finished lesson) refreshes progress when we return.
	s.m.setItems(s.items())
	return s, nil
}

func (s *coursesScreen) View() string {
	c := s.ctx
	s.m.top = 2
	return lipgloss.JoinVertical(lipgloss.Left, c.S.BadgeAccent.Render(langName(c.Lang())), "", s.m.view(contentWidth(c), c.H-10))
}

func (s *coursesScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"),
		kb("enter", "enter", "open"), kb("L", "L", "language"), kb("esc", "esc", "back"))}
}

// lessonsScreen shows a course; lessons unlock in order (≥ 80 % passes).
type lessonsScreen struct {
	ctx  *Ctx
	path content.Path
	m    *menu
}

func newLessons(c *Ctx, p content.Path) *lessonsScreen {
	l := &lessonsScreen{ctx: c, path: p}
	l.m = newMenu(c, "lessons."+p.ID, l.items())
	for i, ls := range p.Lessons {
		if c.Lessons(p)[ls.ID].State == progress.Unlocked {
			l.m.cursor = i
			break
		}
	}
	l.m.syncHeat(true)
	return l
}

func (l *lessonsScreen) items() []item {
	c := l.ctx
	res := c.Lessons(l.path)
	var items []item
	for i, ls := range l.path.Lessons {
		r := res[ls.ID]
		it := item{Label: fmt.Sprintf("%2d  %s", i+1, ls.Title(c.Loc())), Value: i}
		switch r.State {
		case progress.Completed:
			it.Badge = c.S.Success.Render(fmt.Sprintf("%s %.0f%%", c.G.Check, r.BestAccuracy))
		case progress.Locked:
			it.Disabled = true
			it.Badge = c.S.Muted.Render(c.G.Lock)
		case progress.Unlocked:
			if r.HasAttempt {
				it.Badge = c.S.Warning.Render(fmt.Sprintf("%.0f%%", r.BestAccuracy))
			}
		}
		items = append(items, it)
	}
	return items
}

func (l *lessonsScreen) menuModel() *menu { return l.m }

func (l *lessonsScreen) Title() string { return l.path.Title(l.ctx.Loc()) }
func (l *lessonsScreen) Init() tea.Cmd { return nil }

func (l *lessonsScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	if k, ok := msg.(tea.KeyMsg); ok {
		switch k.String() {
		case "up", "k":
			l.m.move(-1)
		case "down", "j":
			l.m.move(1)
		case "esc", "q":
			return l, pop()
		case "x":
			if it, ok := l.m.selected(); ok {
				ls := l.path.Lessons[it.Value.(int)]
				return l, push(newConfirm(l.ctx, l.ctx.T("data.reset.lesson")+": "+ls.Title(l.ctx.Loc()), func() {
					_ = l.ctx.DB.ResetLesson(ls.ID)
				}))
			}
		case "enter":
			it, ok := l.m.selected()
			if !ok || it.Disabled {
				return l, nil
			}
			i := it.Value.(int)
			ls := l.path.Lessons[i]
			if sn, found := l.ctx.Cat.Snippet(ls.SnippetID); found {
				return l, push(newPractice(l.ctx, runSpec{Mode: "lesson", Snippet: sn, LessonID: ls.ID, Path: l.path.ID, Index: i}))
			}
		}
	}
	l.m.items = l.items() // badges follow returns from a run or a reset
	return l, nil
}

func (l *lessonsScreen) View() string {
	c, s := l.ctx, l.ctx.S
	l.m.top = 2
	return lipgloss.JoinVertical(lipgloss.Left, c.inline(l.path.Description(c.Loc()), s.Muted), "", l.m.view(contentWidth(c), c.H-12))
}

func (l *lessonsScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"), kb("enter", "enter", "start"), kb("x", "x", "reset"), kb("esc", "esc", "back"))}
}

// languagesScreen is the catalog with per-language lesson progress (SPEC §5.7).
type languagesScreen struct {
	ctx *Ctx
	m   *menu
}

func newLanguages(c *Ctx) *languagesScreen {
	var items []item
	for _, l := range c.Cat.Languages() {
		done, total := c.LangProgress(l)
		badge := c.S.Muted.Render(fmt.Sprintf("%d/%d %s", done, total, c.T("lessons")))
		if l == c.Lang() {
			badge = c.S.Success.Render(c.G.Check) + " " + badge
		}
		items = append(items, item{Label: langName(l), Value: l, Badge: badge})
	}
	m := newMenu(c, "langs", items)
	m.filterable = true
	for i, it := range items {
		if it.Value.(string) == c.Lang() {
			m.cursor = i
		}
	}
	m.syncHeat(true)
	return &languagesScreen{c, m}
}

func (l *languagesScreen) Title() string    { return l.ctx.T("lang.title") }
func (l *languagesScreen) menuModel() *menu { return l.m }
func (l *languagesScreen) Init() tea.Cmd    { return nil }

func (l *languagesScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return l, nil
	}
	if l.m.handleFilter(k.String(), k.Runes) {
		return l, nil
	}
	switch k.String() {
	case "up", "k":
		l.m.move(-1)
	case "down", "j":
		l.m.move(1)
	case "esc", "q":
		return l, pop()
	case "enter":
		if it, ok := l.m.selected(); ok {
			l.ctx.Set.ActiveLanguage = it.Value.(string)
			l.ctx.SaveSettings()
			return l, pop()
		}
	}
	return l, nil
}

func (l *languagesScreen) View() string { return l.m.view(contentWidth(l.ctx), l.ctx.H-10) }

func (l *languagesScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"),
		kb("enter", "enter", "select"), kb("/", "/", "filter"), kb("esc", "esc", "back"))}
}
