package ui

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/content"
)

func init() {
	addStrings(map[string][2]string{
		"set.title":      {"Settings", "Ajustes"},
		"set.theme":      {"Color mode", "Modo de color"},
		"set.palette":    {"Palette", "Paleta"},
		"set.expressive": {"Expressive color (gradients)", "Color expresivo (degradados)"},
		"set.access":     {"Accessible mode (plain, no motion)", "Modo accesible (plano, sin movimiento)"},
		"set.bell":       {"Terminal bell on a wrong key", "Campana de la terminal al fallar"},
		"set.large":      {"Centered code with focus lines", "Código centrado con líneas con foco"},
		"set.contrast":   {"High contrast (7:1)", "Alto contraste (7:1)"},
		"set.livekb":     {"Live keyboard while typing", "Teclado en vivo al teclear"},
		"set.reminder":   {"Daily reminder", "Recordatorio diario"},
		"set.remtime":    {"Reminder time", "Hora del recordatorio"},
		"set.lock":       {"App lock (PIN)", "Bloqueo con PIN"},
		"set.system":     {"system", "sistema"},
		"set.light":      {"light", "claro"},
		"set.dark":       {"dark", "oscuro"},
		"set.auto":       {"auto (terminal colors)", "auto (colores de la terminal)"},
		"set.reminder.n": {"Shown on Home after this time if you haven't played today.", "Se muestra en el inicio después de esta hora si hoy no has jugado."},
	})
}

type settingsScreen struct {
	ctx *Ctx
	m   *menu
}

func newSettings(c *Ctx) *settingsScreen {
	s := &settingsScreen{ctx: c}
	s.m = newMenu(c, "settings", s.items())
	return s
}

func onOff(c *Ctx, v bool) string {
	if v {
		return c.S.Success.Render(c.T("on"))
	}
	return c.S.Muted.Render(c.T("off"))
}

// paletteNames are the display names used by the Flutter app's palette picker.
var paletteNames = map[string]string{
	"ember": "Ember", "ocean": "Ocean", "forest": "Forest", "grape": "Grape", "rose": "Rose",
	"sunflower": "Sunflower", "teal": "Teal", "crimson": "Crimson", "mono": "Mono", "nord": "Nord",
	"gruvbox": "Gruvbox", "dracula": "Dracula", "solarized": "Solarized", "catppuccin": "Catppuccin",
	"tokyoNight": "Tokyo Night", "terminal": "Terminal", "matrix": "Matrix", "fallout": "Fallout",
	"blackWhite": "Black & White", "monokai": "Monokai", "oneDark": "One Dark", "cyberpunk": "Cyberpunk",
	"synthwave": "Synthwave", "github": "GitHub", "vscode": "VS Code",
}

func paletteLabel(id string) string {
	if n, ok := paletteNames[id]; ok {
		return n
	}
	return id
}

func (s *settingsScreen) items() []item {
	c, st := s.ctx, s.ctx.Set
	theme := map[string]string{"system": c.T("set.system"), "light": c.T("set.light"), "dark": c.T("set.dark")}[st.ThemeMode]
	pal := paletteLabel(st.Palette)
	if st.Palette == "auto" {
		pal = c.T("set.auto")
	}
	loc := c.T("set.system")
	if st.Locale != "" {
		loc = strings.ToUpper(st.Locale)
	}
	return []item{
		{Label: c.T("set.locale"), Badge: c.S.Accent.Render(loc), Value: "locale"},
		{Label: c.T("set.lang"), Badge: c.S.Accent.Render(langName(c.Lang())), Value: "lang"},
		{Label: c.T("set.theme"), Badge: c.S.Accent.Render(theme), Value: "theme"},
		{Label: c.T("set.palette"), Badge: c.S.Accent.Render(pal), Value: "palette"},
		{Label: c.T("set.expressive"), Badge: onOff(c, st.Expressive), Value: "expressive"},
		{Label: c.T("set.motion"), Badge: onOff(c, st.ReducedMotion), Value: "motion"},
		{Label: c.T("set.large"), Badge: onOff(c, st.LargeText), Value: "large"},
		{Label: c.T("set.contrast"), Badge: onOff(c, st.HighContrast), Value: "contrast"},
		{Label: c.T("set.access"), Badge: onOff(c, st.Accessible), Value: "access"},
		{Label: c.T("set.bell"), Badge: onOff(c, st.Bell), Value: "bell"},
		{Label: c.T("set.livekb"), Badge: onOff(c, st.LiveKeyboard), Value: "livekb"},
		{Label: c.T("set.reminder"), Detail: c.T("set.reminder.n"), Badge: onOff(c, st.ReminderOn), Value: "reminder"},
		{Label: c.T("set.remtime"), Badge: c.S.Accent.Render(fmt.Sprintf("%02d:%02d", st.ReminderMinutes/60, st.ReminderMinutes%60)), Value: "remtime"},
		{Label: c.T("set.lock"), Badge: onOff(c, st.LockEnabled && c.HasPIN()), Value: "lock"},
		{Label: c.T("home.data"), Detail: c.T("home.data.d"), Value: "data"},
	}
}

func (s *settingsScreen) Title() string { return s.ctx.T("set.title") }
func (s *settingsScreen) Init() tea.Cmd { return nil }

func (s *settingsScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return s, nil
	}
	c := s.ctx
	switch k.String() {
	case "up", "k":
		s.m.move(-1)
	case "down", "j":
		s.m.move(1)
	case "esc", "q":
		return s, pop()
	case "enter", " ", "right", "l":
		it, _ := s.m.selected()
		st := &c.Set
		var cmd tea.Cmd
		switch it.Value {
		case "locale":
			switch st.Locale {
			case "":
				st.Locale = string(content.EN)
			case string(content.EN):
				st.Locale = string(content.ES)
			default:
				st.Locale = "" // follow $LANG again
			}
		case "lang":
			return s, push(newLanguages(c))
		case "theme":
			next := map[string]string{"system": "light", "light": "dark", "dark": "system"}
			st.ThemeMode = next[st.ThemeMode]
			cmd = func() tea.Msg { return themeMsg{} }
		case "palette":
			return s, push(newPalettePicker(c))
		case "expressive":
			st.Expressive = !st.Expressive
			cmd = func() tea.Msg { return themeMsg{} }
		case "large":
			st.LargeText = !st.LargeText
		case "contrast":
			st.HighContrast = !st.HighContrast
			cmd = func() tea.Msg { return themeMsg{} }
		case "motion":
			st.ReducedMotion = !st.ReducedMotion
		case "access":
			st.Accessible = !st.Accessible
			cmd = func() tea.Msg { return themeMsg{} }
		case "bell":
			st.Bell = !st.Bell
		case "livekb":
			st.LiveKeyboard = !st.LiveKeyboard
		case "reminder":
			st.ReminderOn = !st.ReminderOn
		case "remtime":
			st.ReminderMinutes = (st.ReminderMinutes + 30) % (24 * 60)
		case "lock":
			if st.LockEnabled && c.HasPIN() {
				return s, push(newLock(c, lockDisable))
			}
			return s, push(newLock(c, lockSet))
		case "data":
			return s, push(newData(c))
		}
		c.SaveSettings()
		s.m.items = s.items()
		return s, cmd
	}
	s.m.items = s.items()
	return s, nil
}

func (s *settingsScreen) View() string { return s.m.view(contentWidth(s.ctx), s.ctx.H-8) }

func (s *settingsScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"), kb("enter", "enter", "change"), kb("esc", "esc", "back"))}
}

// palettePicker previews each palette live as the cursor moves; Esc restores.
type palettePicker struct {
	ctx      *Ctx
	m        *menu
	original string
}

func newPalettePicker(c *Ctx) *palettePicker {
	var items []item
	cur := 0
	for i, id := range PaletteIDs {
		label := paletteLabel(id)
		sw := swatch(c, id)
		if id == "auto" {
			label = c.T("set.auto")
		}
		if id == c.Set.Palette {
			cur = i
		}
		items = append(items, item{Label: label, Badge: sw, Value: id})
	}
	m := newMenu(c, "palette.pick", items)
	m.cursor = cur
	m.syncHeat(true)
	return &palettePicker{ctx: c, m: m, original: c.Set.Palette}
}

// swatch is a small primary→secondary strip of a palette.
func swatch(c *Ctx, id string) string {
	t := NewTheme(c.Set.ThemeMode, id, true, false)
	cols := t.Gradient(RolePrimary, RoleSecondary, 8)
	var b strings.Builder
	for _, col := range cols {
		b.WriteString(fgStyle(col).Render("█"))
	}
	return b.String()
}

func (p *palettePicker) Title() string { return p.ctx.T("set.palette") }
func (p *palettePicker) Init() tea.Cmd { return nil }

func (p *palettePicker) preview() tea.Cmd {
	if it, ok := p.m.selected(); ok {
		p.ctx.Set.Palette = it.Value.(string)
		p.ctx.Reload()
	}
	return func() tea.Msg { return themeMsg{} }
}

func (p *palettePicker) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return p, nil
	}
	switch k.String() {
	case "up", "k":
		p.m.move(-1)
		return p, p.preview()
	case "down", "j":
		p.m.move(1)
		return p, p.preview()
	case "enter":
		p.preview()
		p.ctx.SaveSettings()
		return p, tea.Batch(pop(), func() tea.Msg { return themeMsg{} })
	case "esc", "q":
		p.ctx.Set.Palette = p.original
		p.ctx.Reload()
		return p, tea.Batch(pop(), func() tea.Msg { return themeMsg{} })
	}
	return p, nil
}

func (p *palettePicker) View() string {
	c, s := p.ctx, p.ctx.S
	sample := lipgloss.JoinHorizontal(lipgloss.Top, s.Title.Render("Aa Title"), "  ", s.Accent.Render("accent"), "  ",
		s.Success.Render(c.G.Check+" ok"), "  ", s.Warning.Render("warn"), "  ", s.Error.Render(c.G.Cross+" error"), "  ", s.Muted.Render("muted"))
	return lipgloss.JoinVertical(lipgloss.Left, sample, "", p.m.view(contentWidth(c), c.H-12))
}

func (p *palettePicker) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "preview"), kb("down|j", "↓/j", "preview"), kb("enter", "enter", "apply"), kb("esc", "esc", "revert"))}
}
