package ui

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/x/ansi"
)

type item struct {
	Label, Detail, Badge string
	Disabled             bool
	Value                any
}

// menu is a scrolling list. The selected row eases into the primary color
// (a spring per row), rows fade in with a short stagger when the screen opens,
// and "/" filters. One row per item, no blank lines between rows (DESIGN).
type menu struct {
	ctx        *Ctx
	id         string
	items      []item
	cursor     int
	offset     int
	top        int // body-relative row where the first item is drawn
	height     int // visible item rows after the filter row
	filter     string
	filtering  bool
	filterable bool
}

func newMenu(ctx *Ctx, id string, items []item) *menu {
	m := &menu{ctx: ctx, id: id, items: items}
	ctx.Anim.Set(id+".rev", 0)
	ctx.Anim.To(id+".rev", 1, 7, 1)
	m.syncHeat(true)
	return m
}

func (m *menu) heatKey(i int) string { return m.id + ".h" + itoa(i) }

// syncHeat eases every row toward its highlighted/idle state.
func (m *menu) syncHeat(instant bool) {
	vis := m.visible()
	for pos, i := range vis {
		t := 0.0
		if pos == m.cursor {
			t = 1
		}
		if instant {
			m.ctx.Anim.Set(m.heatKey(i), t)
		} else {
			m.ctx.Anim.To(m.heatKey(i), t, 14, 1)
		}
	}
}

func (m *menu) setItems(items []item) { m.items = items; m.syncHeat(true) }

func (m *menu) visible() []int {
	var idx []int
	f := strings.ToLower(m.filter)
	for i, it := range m.items {
		if f == "" || strings.Contains(strings.ToLower(it.Label+" "+it.Detail), f) {
			idx = append(idx, i)
		}
	}
	return idx
}

func (m *menu) move(d int) {
	n := len(m.visible())
	if n == 0 {
		return
	}
	m.cursor = (m.cursor + d + n) % n
	m.syncHeat(false)
}

// scroll is the wheel's clamped move: it does not wrap at the ends.
func (m *menu) scroll(d int) {
	n := len(m.visible())
	if n == 0 {
		return
	}
	m.cursor = max(0, min(n-1, m.cursor+d))
	m.syncHeat(false)
}

// click selects the row at body-relative y. It returns the item so the caller
// can activate it with the screen's normal Enter handler.
func (m *menu) click(y int) (item, bool) {
	row := y - m.top
	if m.filtering || m.filter != "" {
		row--
	}
	if row < 0 || (m.height > 0 && row >= m.height) {
		return item{}, false
	}
	vis := m.visible()
	i := m.offset + row
	if i < 0 || i >= len(vis) {
		return item{}, false
	}
	m.cursor = i
	m.syncHeat(false)
	return m.items[vis[i]], true
}

func (m *menu) selected() (item, bool) {
	v := m.visible()
	if len(v) == 0 {
		return item{}, false
	}
	if m.cursor >= len(v) {
		m.cursor = len(v) - 1
	}
	return m.items[v[m.cursor]], true
}

// handleFilter consumes typing while the "/" prompt is open.
func (m *menu) handleFilter(key string, runes []rune) bool {
	if !m.filtering {
		if m.filterable && key == "/" {
			m.filtering = true
			return true
		}
		return false
	}
	switch key {
	case "esc":
		m.filtering, m.filter, m.cursor = false, "", 0
	case "enter":
		m.filtering = false
	case "backspace":
		if r := []rune(m.filter); len(r) > 0 {
			m.filter = string(r[:len(r)-1])
		}
		m.cursor = 0
	case "up", "down":
		return false
	default:
		if len(runes) > 0 {
			m.filter += string(runes)
			m.cursor = 0
		}
	}
	m.syncHeat(true)
	return true
}

func (m *menu) view(width, height int) string {
	c, s := m.ctx, m.ctx.S
	vis := m.visible()
	filterRow := m.filtering || m.filter != ""
	if filterRow {
		height--
	}
	if height < 1 {
		height = 1
	}
	m.height = height
	if m.cursor >= len(vis) {
		m.cursor = max(0, len(vis)-1)
	}
	if m.cursor < m.offset {
		m.offset = m.cursor
	}
	if m.cursor >= m.offset+height {
		m.offset = m.cursor - height + 1
	}
	var rows []string
	if filterRow {
		caret := ""
		if m.filtering {
			caret = "▏"
		}
		rows = append(rows, s.Marker.Render("/ ")+s.Body.Render(m.filter)+s.Muted.Render(caret))
	}
	if len(vis) == 0 {
		rows = append(rows, s.Muted.Render(c.G.Bullet+" "+c.T("empty")))
	}
	labelW := 0
	for _, i := range vis {
		labelW = max(labelW, lipgloss.Width(m.items[i].Label))
	}
	labelW = min(labelW, width/2)
	end := min(m.offset+height, len(vis))
	n := end - m.offset
	rev := c.Anim.V(m.id + ".rev")
	for pos := m.offset; pos < end; pos++ {
		it := m.items[vis[pos]]
		appear := clamp01(rev*(1+float64(n)*0.09) - float64(pos-m.offset)*0.09)
		rows = append(rows, m.row(it, c.Anim.V(m.heatKey(vis[pos])), appear, width, labelW))
	}
	// Scroll position hint when the list is longer than the window.
	if len(vis) > height {
		rows[len(rows)-1] += s.Muted.Render(" " + itoa(m.cursor+1) + "/" + itoa(len(vis)))
	}
	return strings.Join(rows, "\n")
}

func clamp01(v float64) float64 {
	if v < 0 {
		return 0
	}
	if v > 1 {
		return 1
	}
	return v
}

// rowColor eases a label from muted (appearing) through fg to primary (selected).
func (m *menu) rowColor(heat, appear float64, disabled bool) lipgloss.TerminalColor {
	t := m.ctx.Theme
	switch {
	case disabled:
		return t.Color(RoleMuted)
	case heat > 0.5:
		return t.Color(RolePrimary)
	case appear < 0.5:
		return t.Color(RoleMuted)
	}
	return t.Color(RoleFg)
}

func (m *menu) row(it item, heat, appear float64, width, labelW int) string {
	c, s := m.ctx, m.ctx.S
	mark := "  "
	if heat > 0.5 {
		mark = s.Marker.Render(c.G.Marker) + " "
	}
	label := fgStyle(m.rowColor(heat, appear, it.Disabled)).Bold(heat > 0.5 && !it.Disabled)
	left := mark + label.Render(it.Label) + strings.Repeat(" ", max(0, labelW-lipgloss.Width(it.Label)))
	rightW := lipgloss.Width(it.Badge)
	avail := width - lipgloss.Width(left) - rightW - 2
	detail := ""
	if it.Detail != "" && avail > 6 && appear > 0.6 {
		detail = "  " + s.Muted.Render(ansi.Truncate(it.Detail, avail-2, "…"))
	}
	gap := width - lipgloss.Width(left) - lipgloss.Width(detail) - rightW
	if gap < 1 {
		gap = 1
		left = ansi.Truncate(left, max(1, width-rightW-1), "…")
	}
	badge := it.Badge
	if appear < 0.5 {
		badge = ""
	}
	return left + detail + strings.Repeat(" ", gap) + badge
}

func itoa(n int) string { return fmtInt(n) }

func fmtInt(n int) string {
	if n == 0 {
		return "0"
	}
	neg := n < 0
	if neg {
		n = -n
	}
	var b []byte
	for n > 0 {
		b = append([]byte{byte('0' + n%10)}, b...)
		n /= 10
	}
	if neg {
		b = append([]byte{'-'}, b...)
	}
	return string(b)
}
