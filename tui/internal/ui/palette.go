package ui

import (
	"strings"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

// palette is the command palette (DESIGN.md): ":" or Ctrl+P opens a prompt with
// a ranked list; every action shows its shortcut; Esc cancels. It is never the
// only way to reach a feature — each action also has a menu entry.
type palette struct {
	ctx   *Ctx
	input string
	m     *menu
	acts  []action
}

type action struct {
	Label, Keys string
	Run         func(*Ctx) tea.Cmd
}

func paletteActions() []action {
	return []action{
		{"home.zen", "", func(c *Ctx) tea.Cmd { return pushHome(newSnippetPicker(c, "zen", c.Lang())) }},
		{"home.sprint", "", func(c *Ctx) tea.Cmd { return pushHome(newSprintPicker(c, c.Lang())) }},
		{"home.prec", "", func(c *Ctx) tea.Cmd { return pushHome(newSnippetPicker(c, "precision", c.Lang())) }},
		{"home.surv", "", func(c *Ctx) tea.Cmd { return pushHome(newSnippetPicker(c, "survival", c.Lang())) }},
		{"home.daily", "d", func(c *Ctx) tea.Cmd { return pushHome(newDaily(c)) }},
		{"home.warmup", "w", func(c *Ctx) tea.Cmd { return pushHome(newWarmUp(c)) }},
		{"home.courses", "c", func(c *Ctx) tea.Cmd { return pushHome(newCourses(c)) }},
		{"home.progress", "p", func(c *Ctx) tea.Cmd { return pushHome(newProgress(c)) }},
		{"home.achievements", "a", func(c *Ctx) tea.Cmd { return pushHome(newAchievements(c)) }},
		{"home.keyboard", "m", func(c *Ctx) tea.Cmd { return pushHome(newKeyboardHeat(c)) }},
		{"home.profile", "u", func(c *Ctx) tea.Cmd { return pushHome(newProfile(c)) }},
		{"home.settings", "s", func(c *Ctx) tea.Cmd { return pushHome(newSettings(c)) }},
		{"home.data", "", func(c *Ctx) tea.Cmd { return pushHome(newData(c)) }},
		{"set.lang", "L", func(c *Ctx) tea.Cmd { return pushHome(newLanguages(c)) }},
		{"pal.home", "", func(c *Ctx) tea.Cmd { return goHome() }},
		{"home.quit", "q", func(c *Ctx) tea.Cmd { return tea.Quit }},
	}
}

// pushHome opens a screen on top of Home so Esc always has somewhere to go.
func pushHome(s Screen) tea.Cmd { return tea.Sequence(goHome(), push(s)) }

func newPalette(c *Ctx) *palette {
	p := &palette{ctx: c, acts: paletteActions()}
	p.m = newMenu(c, "palette", p.items())
	return p
}

func (p *palette) items() []item {
	var out []item
	f := strings.ToLower(p.input)
	for i, a := range p.acts {
		label := p.ctx.T(a.Label)
		if f != "" && !fuzzy(strings.ToLower(label), f) {
			continue
		}
		it := item{Label: label, Value: i}
		if a.Keys != "" {
			it.Badge = p.ctx.S.Key.Render(a.Keys)
		}
		out = append(out, it)
	}
	return out
}

// fuzzy matches when the pattern's runes appear in order (tolerates skipped letters).
func fuzzy(s, pat string) bool {
	i := 0
	ps := []rune(pat)
	for _, r := range s {
		if i < len(ps) && r == ps[i] {
			i++
		}
	}
	return i == len(ps)
}

func (p *palette) update(k tea.KeyMsg, a *App) tea.Cmd {
	switch k.String() {
	case "esc", "ctrl+c":
		a.pal = nil
	case "up", "ctrl+k":
		p.m.move(-1)
	case "down", "ctrl+j", "tab":
		p.m.move(1)
	case "enter":
		if it, ok := p.m.selected(); ok {
			act := p.acts[it.Value.(int)]
			a.pal = nil
			return act.Run(p.ctx)
		}
	case "backspace":
		if r := []rune(p.input); len(r) > 0 {
			p.input = string(r[:len(r)-1])
		}
		p.m.setItems(p.items())
		p.m.cursor = 0
	default:
		if len(k.Runes) > 0 {
			p.input += string(k.Runes)
			p.m.setItems(p.items())
			p.m.cursor = 0
		}
	}
	return nil
}

func (p *palette) view(w, h int) string {
	s := p.ctx.S
	prompt := s.Marker.Render(": ") + s.Body.Render(p.input) + s.Muted.Render("▏")
	box := lipgloss.JoinVertical(lipgloss.Left, p.m.view(w-6, h-4), "", prompt)
	return lipgloss.NewStyle().Width(w).Render(box)
}

func (p *palette) Help() help.KeyMap {
	return bindings{short: kbs(kb("enter", "enter", "run"), kb("tab", "tab", "next"), kb("esc", "esc", "close"))}
}
