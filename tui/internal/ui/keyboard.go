package ui

import (
	"fmt"
	"sort"
	"strings"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/typing"
)

func init() {
	addStrings(map[string][2]string{
		"kb.title":   {"Keyboard heat map", "Mapa de calor del teclado"},
		"kb.errors":  {"errors", "errores"},
		"kb.speed":   {"slowness", "lentitud"},
		"kb.presses": {"usage", "uso"},
		"kb.fingers": {"fingers", "dedos"},
		"kb.nodata":  {"Type a few sessions and your keyboard lights up here.", "Teclea unas sesiones y aquí se ilumina tu teclado."},
		"kb.worst":   {"Most missed keys", "Teclas más falladas"},
		"kb.slowest": {"Slowest keys", "Teclas más lentas"},
	})
}

// keyRows is the US-QWERTY layout the engine maps characters onto.
var keyRows = [][]string{
	{"`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="},
	{"tab", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\\"},
	{"a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'", "enter"},
	{"z", "x", "c", "v", "b", "n", "m", ",", ".", "/"},
	{"space"},
}

var keyIndent = []int{0, 0, 2, 4, 14}

func keyLabel(k string) string {
	switch k {
	case "tab":
		return "⇥"
	case "enter":
		return "⏎"
	case "space":
		return strings.Repeat(" ", 15)
	}
	return k
}

// drawKeyboard renders the physical keyboard; styleFn may restyle any key.
func drawKeyboard(c *Ctx, styleFn func(name string) (lipgloss.Style, bool)) string {
	var rows []string
	for ri, row := range keyRows {
		var b strings.Builder
		b.WriteString(strings.Repeat(" ", keyIndent[ri]))
		for _, k := range row {
			lbl := keyLabel(k)
			st := c.S.Muted.Padding(0, 1)
			if k == "space" {
				st = st.Padding(0)
			}
			if o, ok := styleFn(k); ok {
				st = o.Padding(0, 1)
				if k == "space" {
					st = o.Padding(0)
				}
			}
			b.WriteString(st.Render(lbl))
			b.WriteString(" ")
		}
		rows = append(rows, b.String())
	}
	return strings.Join(rows, "\n")
}

type heatMode int

const (
	heatErrors heatMode = iota
	heatSpeed
	heatPresses
	heatFingers
)

// keyboardHeat is the aggregate heat map (SPEC §4.2 "Mapa de calor del teclado").
type keyboardHeat struct {
	ctx  *Ctx
	mode heatMode
	data map[string]typing.KeyHeat
}

func newKeyboardHeat(c *Ctx) *keyboardHeat {
	return &keyboardHeat{ctx: c, data: c.DB.Heatmap()}
}

func (k *keyboardHeat) Title() string { return k.ctx.T("kb.title") }
func (k *keyboardHeat) Init() tea.Cmd { return nil }

func (k *keyboardHeat) Update(msg tea.Msg) (Screen, tea.Cmd) {
	if m, ok := msg.(tea.KeyMsg); ok {
		switch m.String() {
		case "esc", "q":
			return k, pop()
		case "tab", "right", "l":
			k.mode = (k.mode + 1) % 4
		case "shift+tab", "left", "h":
			k.mode = (k.mode + 3) % 4
		}
	}
	return k, nil
}

// fingerOf returns the Okabe-Ito color index for a physical key's finger.
func fingerColor(name string) lipgloss.Color {
	r := []rune(name)
	f, _, ok := typing.Lookup(r[0])
	if len(r) > 1 {
		switch name {
		case "tab":
			f, ok = typing.LPinky, true
		case "enter":
			f, ok = typing.RPinky, true
		case "space":
			f, ok = typing.Thumb, true
		}
	}
	if !ok {
		return chartColors[0]
	}
	order := []typing.Finger{typing.LPinky, typing.LRing, typing.LMiddle, typing.LIndex, typing.Thumb, typing.RIndex, typing.RMiddle, typing.RRing, typing.RPinky}
	for i, o := range order {
		if o == f {
			return chartColors[i%len(chartColors)]
		}
	}
	return chartColors[0]
}

var chartColors = []lipgloss.Color{"#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"}

func (k *keyboardHeat) value(name string) (float64, bool) {
	h, ok := k.data[name]
	if !ok || h.Presses == 0 {
		return 0, false
	}
	switch k.mode {
	case heatErrors:
		return clamp01(float64(h.Errors) / float64(h.Presses) * 4), true
	case heatSpeed:
		return clamp01((h.AvgFlightMs - 80) / 400), true
	default:
		return clamp01(float64(h.Presses) / 300), true
	}
}

func (k *keyboardHeat) keyStyle(name string) (lipgloss.Style, bool) {
	c := k.ctx
	if k.mode == heatFingers {
		return lipgloss.NewStyle().Background(fingerColor(name)).Foreground(lipgloss.Color("#101010")).Bold(true), true
	}
	v, ok := k.value(name)
	if !ok {
		return lipgloss.Style{}, false
	}
	role := RoleDanger
	if k.mode == heatPresses {
		role = RolePrimary
	}
	// Intensity as weight and inversion, in the terminal's own colors.
	st := fgStyle(c.Theme.Color(role))
	switch {
	case v > 0.66:
		st = st.Bold(true).Reverse(true)
	case v > 0.33:
		st = st.Bold(true)
	}
	return st, true
}

func (k *keyboardHeat) View() string {
	c, s := k.ctx, k.ctx.S
	if len(k.data) == 0 {
		return s.Muted.Render(c.G.Bullet + " " + c.T("kb.nodata"))
	}
	names := []string{c.T("kb.errors"), c.T("kb.speed"), c.T("kb.presses"), c.T("kb.fingers")}
	var tabs []string
	for i, n := range names {
		if heatMode(i) == k.mode {
			tabs = append(tabs, s.BadgeAccent.Render(n))
		} else {
			tabs = append(tabs, s.Muted.Render(" "+n+" "))
		}
	}
	kb := drawKeyboard(c, k.keyStyle)
	type kv struct {
		k string
		v float64
		h typing.KeyHeat
	}
	var rows []kv
	for name, h := range k.data {
		if h.Presses >= 5 {
			v := float64(h.Errors) / float64(h.Presses)
			if k.mode == heatSpeed {
				v = h.AvgFlightMs
			}
			rows = append(rows, kv{name, v, h})
		}
	}
	sort.Slice(rows, func(i, j int) bool { return rows[i].v > rows[j].v })
	title := c.T("kb.worst")
	if k.mode == heatSpeed {
		title = c.T("kb.slowest")
	}
	var worst []string
	for i, r := range rows {
		if i == 5 || r.v == 0 {
			break
		}
		detail := fmt.Sprintf("%d/%d  %.0f%%", r.h.Errors, r.h.Presses, float64(r.h.Errors)/float64(r.h.Presses)*100)
		if k.mode == heatSpeed {
			detail = fmt.Sprintf("%.0f ms", r.h.AvgFlightMs)
		}
		worst = append(worst, fmt.Sprintf("%s  %s", s.Error.Render(fmt.Sprintf("%-6s", r.k)), s.Muted.Render(detail)))
	}
	out := []string{strings.Join(tabs, " "), "", kb}
	if len(worst) > 0 {
		out = append(out, "", s.Title.Render(title), strings.Join(worst, "\n"))
	}
	return lipgloss.JoinVertical(lipgloss.Left, out...)
}

func (k *keyboardHeat) Help() help.KeyMap {
	return bindings{short: kbs(kb("tab|right", "tab", "mode"), kb("esc", "esc", "back"))}
}
