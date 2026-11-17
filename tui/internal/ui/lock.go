package ui

import (
	"math"
	"strings"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

func init() {
	addStrings(map[string][2]string{
		"lock.title":    {"Enter your PIN", "Ingresa tu PIN"},
		"lock.sub":      {"Ridge is locked", "Ridge está bloqueado"},
		"lock.set":      {"Set a PIN", "Define un PIN"},
		"lock.set.sub":  {"You'll need it to unlock the app", "Lo necesitarás para desbloquear la app"},
		"lock.confirm":  {"Confirm your PIN", "Confirma tu PIN"},
		"lock.error":    {"Incorrect PIN, try again", "PIN incorrecto, intenta de nuevo"},
		"lock.mismatch": {"PINs don't match", "Los PIN no coinciden"},
		"lock.off":      {"Enter your PIN to turn the lock off", "Ingresa tu PIN para desactivar el bloqueo"},
	})
}

type lockMode int

const (
	lockVerify lockMode = iota
	lockSet
	lockDisable
)

const pinLength = 4

// lockScreen is the PIN gate (SPEC §7): 4 digits, dots that fill in, and the
// PIN-entry shake — the only deliberately loud animation in the app.
type lockScreen struct {
	ctx   *Ctx
	mode  lockMode
	entry string
	first string // set mode: the PIN to confirm
	err   string
}

func newLock(c *Ctx, mode lockMode) *lockScreen {
	c.Anim.Set("lock.shake", 0)
	return &lockScreen{ctx: c, mode: mode}
}

func (l *lockScreen) Init() tea.Cmd { return nil }

func (l *lockScreen) shake() {
	l.ctx.Anim.Set("lock.shake", 1)
	l.ctx.Anim.To("lock.shake", 0, 22, 0.16) // under-damped: swings side to side, then settles
}

func (l *lockScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return l, nil
	}
	c := l.ctx
	switch k.String() {
	case "esc":
		if l.mode != lockVerify {
			return l, pop()
		}
		return l, nil
	case "ctrl+c":
		return l, tea.Quit
	case "backspace":
		if len(l.entry) > 0 {
			l.entry = l.entry[:len(l.entry)-1]
		}
		return l, nil
	}
	if len(k.Runes) == 1 && k.Runes[0] >= '0' && k.Runes[0] <= '9' && len(l.entry) < pinLength {
		l.entry += string(k.Runes[0])
		l.err = ""
	}
	if len(l.entry) < pinLength {
		return l, nil
	}
	entry := l.entry
	l.entry = ""
	switch l.mode {
	case lockVerify, lockDisable:
		if !c.DB.VerifyPIN(entry) {
			l.err = c.T("lock.error")
			l.shake()
			return l, nil
		}
		if l.mode == lockDisable {
			_ = c.DB.ClearPIN()
			c.Set.LockEnabled = false
			c.SaveSettings()
			return l, pop()
		}
		if !c.Set.OnboardingDone {
			return l, replace(newOnboarding(c))
		}
		return l, goHome()
	case lockSet:
		if l.first == "" {
			l.first = entry
			return l, nil
		}
		if entry != l.first {
			l.first, l.err = "", c.T("lock.mismatch")
			l.shake()
			return l, nil
		}
		_ = c.DB.SetPIN(entry)
		c.Set.LockEnabled = true
		c.SaveSettings()
		return l, pop()
	}
	return l, nil
}

func (l *lockScreen) View() string {
	c, s := l.ctx, l.ctx.S
	title, sub := c.T("lock.title"), c.T("lock.sub")
	switch {
	case l.mode == lockSet && l.first == "":
		title, sub = c.T("lock.set"), c.T("lock.set.sub")
	case l.mode == lockSet:
		title, sub = c.T("lock.confirm"), c.T("lock.set.sub")
	case l.mode == lockDisable:
		sub = c.T("lock.off")
	}
	var dots []string
	for i := 0; i < pinLength; i++ {
		if i < len(l.entry) {
			dots = append(dots, s.Accent.Render("●"))
		} else {
			dots = append(dots, s.Muted.Render("○"))
		}
	}
	row := strings.Join(dots, "  ")
	// The shake: a horizontal swing driven by the spring.
	off := int(math.Round(c.Anim.V("lock.shake") * 4))
	if off > 0 {
		row = strings.Repeat(" ", off) + row
	} else if off < 0 {
		row = row + strings.Repeat(" ", -off)
	}
	errLine := ""
	if l.err != "" {
		errLine = s.Error.Render(c.G.Cross + " " + l.err)
	}
	body := lipgloss.JoinVertical(lipgloss.Center, c.Theme.shimmerText(title, RolePrimary, RoleSecondary, -1, true), s.Muted.Render(sub), "", row, "", errLine)
	return lipgloss.Place(contentWidth(c), max(8, c.H-8), lipgloss.Center, lipgloss.Center, body)
}

func (l *lockScreen) Help() help.KeyMap {
	if l.mode == lockVerify {
		return bindings{short: kbs(kb("0-9", "0-9", "PIN"), kb("backspace", "⌫", "delete"), kb("ctrl+c", "ctrl+c", "quit"))}
	}
	return bindings{short: kbs(kb("0-9", "0-9", "PIN"), kb("backspace", "⌫", "delete"), kb("esc", "esc", "cancel"))}
}
