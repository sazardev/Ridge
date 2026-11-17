// Package ui is the Bubble Tea presentation layer: one root model that stacks
// screens, owns the single frame ticker and composes header / body / help bar
// top-down (DESIGN.md).
package ui

import (
	"strings"
	"time"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/x/ansi"
)

// App is the root model.
type App struct {
	ctx      *Ctx
	stack    []Screen
	help     help.Model
	full     bool
	ticking  bool
	lastTick time.Time
	pal      *palette
}

// New wires the app and picks the first screen: lock → onboarding → home.
func New(ctx *Ctx) *App {
	a := &App{ctx: ctx, help: help.New()}
	a.enter()
	a.styleHelp()
	switch {
	case ctx.Set.LockEnabled && ctx.DB.HasPIN():
		a.stack = []Screen{newLock(ctx, lockVerify)}
	case !ctx.Set.OnboardingDone:
		a.stack = []Screen{newOnboarding(ctx)}
	default:
		a.stack = []Screen{newHome(ctx)}
	}
	return a
}

func (a *App) styleHelp() {
	s := a.ctx.S
	a.help.Styles.ShortKey, a.help.Styles.FullKey = s.Key, s.Key
	a.help.Styles.ShortDesc, a.help.Styles.FullDesc = s.Muted, s.Muted
	a.help.Styles.ShortSeparator, a.help.Styles.FullSeparator = s.Muted, s.Muted
	a.help.Styles.Ellipsis = s.Muted
}

func (a *App) top() Screen { return a.stack[len(a.stack)-1] }

// Init implements tea.Model.
func (a *App) Init() tea.Cmd { return tea.Batch(a.top().Init(), a.frame()) }

// frame starts the ticker only when something moves (60 fps) or an ambient
// effect asks for idle frames (60 fps); it stops with reduced motion.
// pending.
func (a *App) frame() tea.Cmd {
	// Watchdog: if a tick was ever lost (dropped message, program suspended),
	// the flag must not wedge the loop forever.
	if a.ticking && a.ctx.Now().Sub(a.lastTick) < 250*time.Millisecond {
		return nil
	}
	var d time.Duration
	switch {
	case a.ctx.Anim.Moving():
		d = frameInterval
	case !a.ctx.Anim.Reduced && a.ambient():
		d = idleInterval
	default:
		return nil
	}
	a.ticking = true
	a.lastTick = a.ctx.Now()
	return tea.Tick(d, func(t time.Time) tea.Msg { return frameMsg(t) })
}

// ambient is always on: the header mark breathes on every screen, so the idle
// ticker (60 fps) keeps running whenever motion is allowed. It only stops with
// reduced motion — never because a particular screen "has nothing to animate".
func (a *App) ambient() bool { return true }

// Update implements tea.Model.
func (a *App) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	// Data can only change on a key press or a screen change; frames never
	// invalidate, so animation never reaches the database.
	_, isKey := msg.(tea.KeyMsg)
	if isKey {
		a.ctx.Touch()
	}
	m, cmd := a.update(msg)
	if isKey {
		a.ctx.Touch()
	}
	switch msg.(type) {
	case pushMsg, popMsg, replaceMsg, homeMsg, themeMsg:
		a.ctx.Touch()
	}
	return m, tea.Batch(cmd, a.frame())
}

func (a *App) update(msg tea.Msg) (tea.Model, tea.Cmd) {
	c := a.ctx
	switch m := msg.(type) {
	case tea.WindowSizeMsg:
		c.W, c.H = m.Width, m.Height
		a.help.Width = contentWidth(c)
		return a, nil
	case frameMsg:
		a.ticking = false
		c.Anim.Step(time.Time(m))
		a.expireToasts()
		next, cmd := a.top().Update(m)
		a.stack[len(a.stack)-1] = next
		return a, cmd
	case pushMsg:
		a.stack = append(a.stack, m.s)
		a.pal = nil
		a.enter()
		return a, m.s.Init()
	case replaceMsg:
		a.stack[len(a.stack)-1] = m.s
		a.enter()
		return a, m.s.Init()
	case popMsg:
		if len(a.stack) > 1 {
			a.stack = a.stack[:len(a.stack)-1]
		}
		a.enter()
		return a, nil
	case homeMsg:
		a.stack = []Screen{newHome(c)}
		a.styleHelp()
		a.enter()
		return a, nil
	case themeMsg:
		a.styleHelp()
		return a, nil
	case tea.KeyMsg:
		if a.pal != nil {
			return a, a.pal.update(m, a)
		}
		switch m.String() {
		case "ctrl+c":
			return a, tea.Quit
		case "ctrl+p", ":":
			if a.canPalette() {
				a.pal = newPalette(c)
				return a, nil
			}
		case "?":
			if a.canPalette() {
				a.full = !a.full
				return a, nil
			}
		case "f1":
			return a, push(newGuide(c))
		}
	case tea.MouseMsg:
		return a.mouse(m)
	}
	next, cmd := a.top().Update(msg)
	a.stack[len(a.stack)-1] = next
	return a, cmd
}

// menuScreen marks a screen whose body is a menu, so the mouse can select a
// row and the wheel can scroll it without every screen reimplementing hit
// testing.
type menuScreen interface{ menuModel() *menu }

// clickBodyScreen is a screen with custom click regions (e.g. progress tabs).
type clickBodyScreen interface {
	clickBody(x, y int) (tea.Cmd, bool)
}

// wheelScreen is a non-menu screen that can scroll with the wheel.
type wheelScreen interface{ wheel(delta int) }

// mouse routes a click/wheel to the current screen. Coordinates are absolute
// terminal cells; the body starts after the one-line header and its blank line.
func (a *App) mouse(m tea.MouseMsg) (tea.Model, tea.Cmd) {
	if m.Action != tea.MouseActionPress {
		return a, nil
	}
	switch m.Button {
	case tea.MouseButtonWheelUp:
		return a.wheel(-1)
	case tea.MouseButtonWheelDown:
		return a.wheel(1)
	case tea.MouseButtonLeft:
		y := m.Y - 2 // header + blank line
		if a.pal != nil {
			if it, ok := a.pal.m.click(y); ok {
				p := a.pal
				a.pal = nil
				return a, p.acts[it.Value.(int)].Run(p.ctx)
			}
			return a, nil
		}
		if ms, ok := a.top().(menuScreen); ok {
			if _, hit := ms.menuModel().click(y); hit {
				return a.update(tea.KeyMsg{Type: tea.KeyEnter})
			}
		}
		if cb, ok := a.top().(clickBodyScreen); ok {
			if cmd, handled := cb.clickBody(m.X-a.pad(), y); handled {
				return a, cmd
			}
		}
	}
	return a, nil
}

// wheel scrolls the command palette, a menu, or a custom wheel screen.
func (a *App) wheel(delta int) (tea.Model, tea.Cmd) {
	if a.pal != nil {
		a.pal.m.scroll(delta)
		return a, nil
	}
	if ms, ok := a.top().(menuScreen); ok {
		ms.menuModel().scroll(delta)
		return a, nil
	}
	if ws, ok := a.top().(wheelScreen); ok {
		ws.wheel(delta)
	}
	return a, nil
}

// pad is the left margin of the centered content column.
func (a *App) pad() int { return max(0, (a.ctx.W-contentWidth(a.ctx))/2) }

// enter restarts the screen-entrance animation: content flows in top to
// bottom over ~150 ms (a spring), and bars/lists key off the same value.
func (a *App) enter() {
	a.ctx.Anim.Set("enter", 0)
	a.ctx.Anim.To("enter", 1, 14, 1)
}

// revealLines shows the first f of the lines (a quick top-down wipe-in).
func revealLines(s string, f float64) string {
	if f >= 0.999 {
		return s
	}
	lines := strings.Split(s, "\n")
	n := int(f * float64(len(lines)+2))
	for i := n; i < len(lines); i++ {
		lines[i] = ""
	}
	return strings.Join(lines, "\n")
}

// canPalette is false while a screen needs every key (typing, PIN, forms).
func (a *App) canPalette() bool {
	switch a.top().(type) {
	case *practiceScreen, *lockScreen, *formScreen, *onboardingScreen:
		return false
	}
	return true
}

// themeMsg is sent after settings changed the theme or palette.
type themeMsg struct{}

func (a *App) expireToasts() {
	now := a.ctx.Now()
	keep := a.ctx.Toast[:0]
	for _, t := range a.ctx.Toast {
		if now.Before(t.Until) {
			keep = append(keep, t)
		}
	}
	a.ctx.Toast = keep
}

// breadcrumb is "ridge › Courses › Go Foundations" built from the stack.
func (a *App) breadcrumb() string {
	c, s := a.ctx, a.ctx.S
	mark := s.Title.Render("ridge")
	if m := c.brailleMark(4); m != "" {
		mark += " " + m
	}
	parts := []string{mark}
	for _, sc := range a.stack {
		if t, ok := sc.(Titled); ok && t.Title() != "" {
			parts = append(parts, s.Muted.Render(t.Title()))
		}
	}
	return strings.Join(parts, s.Muted.Render(" "+c.G.Sep+" "))
}

// View implements tea.Model: header, body and help bar joined vertically, the
// whole thing centered with lipgloss.Place and never painted with a background.
func (a *App) View() string {
	c, s := a.ctx, a.ctx.S
	if c.W < 40 || c.H < 20 {
		out := lipgloss.Place(c.W, c.H, lipgloss.Center, lipgloss.Center, s.Warning.Render(c.T("tooSmall")))
		return a.maybeASCII(out)
	}
	w := contentWidth(c)
	if wd, ok := a.top().(Wide); ok && wd.Wide() && a.pal == nil {
		w = wideWidth(c)
	}
	a.help.ShowAll = a.full
	a.help.Width = w
	var footer string
	var body string
	if a.pal != nil {
		footer = a.help.View(a.pal.Help())
		body = a.pal.view(w, c.H-6)
	} else {
		footer = a.help.View(a.top().Help())
		body = a.top().View()
	}
	// Never overflow: truncate each help line with "…" instead of wrapping.
	var fl []string
	for _, ln := range strings.Split(footer, "\n") {
		fl = append(fl, ansi.Truncate(ln, w, "…"))
	}
	footer = strings.Join(fl, "\n")
	header := a.breadcrumb()
	if t := a.toastView(); t != "" {
		header = lipgloss.JoinHorizontal(lipgloss.Top, header, "   ", t)
	}
	if nw, ok := a.top().(NoWrap); !(ok && nw.NoWrap() && a.pal == nil) {
		body = lipgloss.NewStyle().Width(w).Render(body)
	}
	wrapped := revealLines(body, c.Anim.V("enter"))
	avail := c.H - lipgloss.Height(header) - 1 - lipgloss.Height(footer) - 1
	wrapped = clipLines(wrapped, avail)
	block := lipgloss.JoinVertical(lipgloss.Left, header, "", wrapped)
	gap := c.H - lipgloss.Height(block) - lipgloss.Height(footer)
	if gap < 1 {
		gap = 1
	}
	page := block + strings.Repeat("\n", gap) + footer
	// Center the column by prefixing each line (cheaper than lipgloss.Place).
	pad := strings.Repeat(" ", max(0, (c.W-w)/2))
	lines := strings.Split(page, "\n")
	for i := range lines {
		if lines[i] != "" {
			lines[i] = pad + lines[i]
		}
	}
	return a.maybeASCII(strings.Join(lines, "\n"))
}

// maybeASCII sanitizes the finished frame for non-UTF-8 terminals. It runs last
// so width math already done by lipgloss stays valid (every mapping is 1:1).
func (a *App) maybeASCII(s string) string {
	if a.ctx.G.utf8 {
		return s
	}
	return toASCII(s)
}

// toastView renders the newest toast with a fade-out in its last 400 ms.
func (a *App) toastView() string {
	c := a.ctx
	if len(c.Toast) == 0 {
		return ""
	}
	t := c.Toast[len(c.Toast)-1]
	left := t.Until.Sub(c.Now())
	f := clamp01(float64(left) / float64(400*time.Millisecond))
	col := c.Theme.Mix(RoleMuted, RoleSecondary, f)
	return fgStyle(col).Bold(true).Render(c.G.Star + " " + t.Text)
}

// clipLines keeps at most n lines, ending with "…" when something was cut.
func clipLines(s string, n int) string {
	if n < 1 {
		n = 1
	}
	lines := strings.Split(s, "\n")
	if len(lines) <= n {
		return s
	}
	lines = lines[:n]
	lines[n-1] = "…"
	return strings.Join(lines, "\n")
}
