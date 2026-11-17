package ui

import (
	"os"
	"time"

	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/bubbles/key"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/service"
	"github.com/omar/ridge/tui/internal/store"
)

// Ctx is the state shared by every screen.
type Ctx struct {
	Svc   *service.Service
	DB    *store.DB
	Cat   *content.Catalog
	Set   store.Settings
	Theme Theme
	S     Styles
	G     Glyphs
	Anim  *Anim
	W, H  int
	Now   func() time.Time
	Toast []toast
	memo  map[string]memoEntry
	ver   int
}

type toast struct {
	Text  string
	Until time.Time
}

// NewCtx builds the shared context and applies the settings.
func NewCtx(svc *service.Service) *Ctx {
	c := &Ctx{Svc: svc, DB: svc.DB, Cat: svc.Cat, Now: time.Now, W: 80, H: 24}
	c.Anim = NewAnim(c.Now())
	c.Set = c.DB.LoadSettings()
	if p := os.Getenv("RIDGE_PALETTE"); p != "" { // escape hatch: RIDGE_PALETTE=auto ridge
		c.Set.Palette = p
	}
	c.Reload()
	return c
}

// Reload re-reads the theme/motion preferences (after a settings change).
func (c *Ctx) Reload() {
	c.Theme = NewTheme(c.Set.ThemeMode, c.Set.Palette, c.Set.Expressive, c.Set.HighContrast)
	c.S = NewStyles(c.Theme, c.Set.Accessible)
	c.G = NewGlyphs(utf8Locale() && !c.Set.Accessible)
	// No animation when asked, in accessible mode, in CI or on a dumb terminal.
	c.Anim.Reduced = c.Set.ReducedMotion || c.Set.Accessible || os.Getenv("CI") != "" || os.Getenv("TERM") == "dumb"
}

// SaveSettings persists and applies the settings.
func (c *Ctx) SaveSettings() { _ = c.DB.SaveSettings(c.Set); c.Reload() }

// Loc is the interface/content locale.
func (c *Ctx) Loc() content.Locale {
	if c.Set.Locale == "" {
		return defaultLocale()
	}
	return content.Locale(c.Set.Locale)
}

// T translates a key.
func (c *Ctx) T(k string) string {
	v, ok := strings_[k]
	if !ok {
		return k
	}
	if c.Loc() == content.ES {
		return v[1]
	}
	return v[0]
}

// Lang is the active programming language (defaults to Go).
func (c *Ctx) Lang() string {
	if c.Set.ActiveLanguage != "" {
		return c.Set.ActiveLanguage
	}
	return "go"
}

// Notify shows a transient toast.
func (c *Ctx) Notify(text string) {
	c.Toast = append(c.Toast, toast{text, c.Now().Add(3500 * time.Millisecond)})
}

// Screen is one full-screen view. Screens read size and state from Ctx.
type Screen interface {
	Init() tea.Cmd
	Update(tea.Msg) (Screen, tea.Cmd)
	View() string
	Help() help.KeyMap
}

// Titled screens contribute a breadcrumb segment.
type Titled interface{ Title() string }

// Ambient screens ask for idle animation frames (shimmer, caret pulse).
type Ambient interface{ Ambient() bool }

// Navigation + frame messages.
type (
	pushMsg    struct{ s Screen }
	popMsg     struct{}
	replaceMsg struct{ s Screen }
	homeMsg    struct{}
	frameMsg   time.Time
)

func push(s Screen) tea.Cmd    { return func() tea.Msg { return pushMsg{s} } }
func pop() tea.Cmd             { return func() tea.Msg { return popMsg{} } }
func replace(s Screen) tea.Cmd { return func() tea.Msg { return replaceMsg{s} } }
func goHome() tea.Cmd          { return func() tea.Msg { return homeMsg{} } }

// bindings is a tiny help.KeyMap built from a flat list.
type bindings struct{ short, full []key.Binding }

func (b bindings) ShortHelp() []key.Binding { return b.short }
func (b bindings) FullHelp() [][]key.Binding {
	if len(b.full) == 0 {
		return [][]key.Binding{b.short}
	}
	return [][]key.Binding{b.full}
}

func kb(keys, label, desc string) key.Binding {
	return key.NewBinding(key.WithKeys(splitKeys(keys)...), key.WithHelp(label, desc))
}

func kbs(b ...key.Binding) []key.Binding { return b }

func splitKeys(s string) []string {
	var out []string
	cur := ""
	for _, r := range s {
		if r == '|' {
			out = append(out, cur)
			cur = ""
			continue
		}
		cur += string(r)
	}
	return append(out, cur)
}

func langName(id string) string { return content.LanguageName(id) }

// contentWidth is the centered column: ≤ 100 cells, never wider than the window.
func contentWidth(c *Ctx) int {
	w := c.W - 4
	if w > 100 {
		w = 100
	}
	if w < 36 {
		w = 36
	}
	return w
}

// fgStyle is a one-off foreground style from a mixed color.
func fgStyle(col lipgloss.TerminalColor) lipgloss.Style { return styleOf(col) }
