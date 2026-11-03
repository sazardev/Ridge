package ui

import (
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/x/ansi"
	"github.com/omar/ridge/tui/internal/progress"
	"github.com/omar/ridge/tui/internal/typing"
)

// Wide screens ask the root for a wider column than the 100-cell default.
type Wide interface{ Wide() bool }

func (p *practiceScreen) Wide() bool { return true }

// wideWidth is the typing view's column: nearly the whole window, ≤ 140.
func wideWidth(c *Ctx) int { return max(36, min(c.W-4, 140)) }

func (p *practiceScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("esc", "esc", "back"), kb("ctrl+r", "ctrl+r", "restart"), kb("backspace", "⌫", "undo"), kb("tab", "tab", "indent"))}
}

func abs(n int) int {
	if n < 0 {
		return -n
	}
	return n
}

// NoWrap screens guarantee their lines fit, so the root skips re-wrapping them.
type NoWrap interface{ NoWrap() bool }

func (p *practiceScreen) NoWrap() bool { return true }

// View: the snippet is the hero. Around it only a muted title, one hairline of
// progress and one quiet stats line — nothing else competes for attention.
func (p *practiceScreen) View() string {
	c, s := p.ctx, p.ctx.S
	w := wideWidth(c)
	kbRows := 0
	var kbView string
	if c.Set.LiveKeyboard && w >= 60 && c.H >= 34 {
		kbView = drawKeyboard(c, p.liveKeyStyle)
		kbRows = lipgloss.Height(kbView) + 1
	}
	title := s.Muted.Render(p.snippet.Title(c.Loc()))
	if p.spec.Mode == "daily" {
		title = s.Accent.Render(c.T("home.daily")) + s.Muted.Render("  ·  ") + title
	}
	if !p.started { // the one-line hint disappears the moment you start
		title += s.Muted.Faint(true).Render("  ·  " + plainText(p.snippet.Tldr(c.Loc())))
	}
	title = ansi.Truncate(title, w, "…") // NoWrap screens must fit by themselves
	bar := renderBar(c, c.Anim.V("p.bar"), 20)
	// head(1) bar(1) gap(1) … gap(1) stats(1) + root chrome (header, help, margins)
	h := max(3, c.H-9-kbRows)
	code := p.renderCode(w, h)
	free := h - lipgloss.Height(code)
	top := strings.Repeat("\n", min(4, max(0, free*2/5)))
	parts := []string{title, bar, top + code, "", ansi.Truncate(p.stats(w), w, "…")}
	if kbView != "" {
		parts = append(parts, "", kbView)
	}
	if p.notice != "" {
		parts = append(parts, s.Warning.Render(p.notice))
	}
	return strings.Join(parts, "\n")
}

func (p *practiceScreen) liveKeyStyle(name string) (lipgloss.Style, bool) {
	c := p.ctx
	exp := p.rec.Expected()
	if p.rec.Cursor() < len(exp) && typing.PhysicalKey(exp[p.rec.Cursor()]) == name {
		return lipgloss.NewStyle().Reverse(true).Bold(true).Foreground(c.Theme.Color(RolePrimary)), true
	}
	if p.lastKey != 0 && typing.PhysicalKey(p.lastKey) == name {
		role := RoleSuccess
		if !p.lastGood {
			role = RoleDanger
		}
		return fgStyle(c.Theme.Mix(RoleMuted, role, c.Anim.V("p.pulse"))).Bold(true), true
	}
	return lipgloss.Style{}, false
}

// stats is one quiet line under the code; it appears once you start typing.
func (p *practiceScreen) stats(w int) string {
	c, s := p.ctx, p.ctx.S
	if !p.started {
		return ""
	}
	acc, wpm := 100.0, 0.0
	if p.total > 0 {
		acc = float64(p.correct) / float64(p.total) * 100
	}
	if mins := c.Now().Sub(p.startAt).Minutes(); mins > 0 {
		wpm = float64(p.correct) / 5 / mins
	}
	c.Anim.To("p.wpm", wpm, 6, 1) // eased readouts instead of jitter
	c.Anim.To("p.acc", acc, 6, 1)
	accStyle := s.Muted
	if c.Anim.V("p.acc") < 90 {
		accStyle = s.Warning
	}
	sep := s.Muted.Render("  ·  ")
	parts := []string{
		s.Accent.Render(fmt.Sprintf("%.0f", c.Anim.V("p.wpm"))) + s.Muted.Render(" wpm"),
		accStyle.Render(fmt.Sprintf("%.0f%%", c.Anim.V("p.acc"))),
	}
	if p.streak >= 10 {
		parts = append(parts, s.Muted.Render(fmt.Sprintf("%s %d", c.G.Check, p.streak)))
	}
	parts = append(parts, p.modeExtras()...)
	line := strings.Join(parts, sep)
	if lw := lipgloss.Width(line); lw < w {
		line = strings.Repeat(" ", (w-lw)/2) + line
	}
	return line
}

func (p *practiceScreen) modeExtras() []string {
	c, s := p.ctx, p.ctx.S
	var out []string
	switch p.spec.Mode {
	case "sprint":
		out = append(out, s.Warning.Render(fmt.Sprintf("%02.0fs", p.remaining().Seconds()+0.49)))
	case "survival":
		hearts := strings.TrimSpace(strings.Repeat(c.G.Heart+" ", p.surv.Lives))
		hs := s.Error
		if h := c.Anim.V("p.hurt"); h > 0.05 {
			hs = fgStyle(c.Theme.Mix(RoleDanger, RoleFg, h))
		}
		out = append(out, hs.Render(hearts), s.Accent.Render(fmt.Sprintf("x%d", p.surv.Multiplier())),
			s.Muted.Render(fmt.Sprintf("%d", p.surv.Score)))
	case "lesson":
		out = append(out, s.Muted.Render(fmt.Sprintf("#%d", p.spec.Index+1)))
	}
	if p.ghost != nil && p.started {
		gp := progress.GhostPosition(p.ghost, c.Now().Sub(p.startAt))
		d := p.rec.Cursor() - gp
		label, st := c.T("ahead"), s.Success
		if d < 0 {
			label, st = c.T("behind"), s.Warning
		}
		out = append(out, st.Render(fmt.Sprintf("%s %s %d", c.T("ghost"), label, abs(d))))
	}
	return out
}

type codeCell struct {
	idx  int    // index into the expected runes
	text string // what is shown (a newline is shown as nothing — the key just works)
	w    int    // display cells
}

type codeLine struct {
	cells  []codeCell
	indent int // hanging indent for wrapped continuations
}

// layoutCode splits the snippet into lines and, when a line does not fit,
// wraps it at the last space with a hanging indent. Tabs show as four cells.
func (p *practiceScreen) layoutCode(width int, wrap bool) []codeLine {
	var lines []codeLine
	cur := codeLine{}
	col, lead, inLead := 0, 0, true
	for i, r := range p.rec.Expected() {
		var cell codeCell
		switch r {
		case '\n':
			cur.cells = append(cur.cells, codeCell{i, " ", 1}) // room for the caret only
			lines = append(lines, cur)
			cur, col, lead, inLead = codeLine{}, 0, 0, true
			continue
		case '\t':
			cell = codeCell{i, "    ", 4}
		default:
			cell = codeCell{i, string(r), 1}
		}
		if inLead {
			if r == ' ' || r == '\t' {
				lead += cell.w
			} else {
				inLead = false
			}
		}
		if wrap && col+cell.w > width {
			// Break after the last space when it is not too far back.
			split := -1
			for k := len(cur.cells) - 1; k > len(cur.cells)/2; k-- {
				if cur.cells[k].text == " " {
					split = k + 1
					break
				}
			}
			next := codeLine{indent: min(lead+2, width/3)}
			if split > 0 {
				next.cells = append(next.cells, cur.cells[split:]...)
				cur.cells = cur.cells[:split]
			}
			lines = append(lines, cur)
			cur = next
			col = next.indent
			for _, ce := range next.cells {
				col += ce.w
			}
		}
		cur.cells = append(cur.cells, cell)
		col += cell.w
	}
	return append(lines, cur)
}

// codeWindow is where the last render looked (kept for tests and scroll logic).
type codeWindow struct{ start, end, caret, total int }

type seg struct {
	key  string
	st   lipgloss.Style
	text strings.Builder
}

// renderCode draws the snippet as the single protagonist: centered, no
// gutter, no markers. Lines fade with distance from the caret (focus), typed
// characters flash from the accent into success, the caret breathes between
// primary and secondary, a wrong key flashes it in danger, the ghost is
// underlined, and long snippets scroll with a spring that keeps the caret line
// near the upper third.
func (p *practiceScreen) renderCode(width, height int) string {
	c, s := p.ctx, p.ctx.S
	avail := width - 4
	lines := p.layoutCode(avail, false)
	widest := 0
	for _, l := range lines {
		n := 0
		for _, ce := range l.cells {
			n += ce.w
		}
		widest = max(widest, n)
	}
	if widest > avail { // too long for the window: wrap with hanging indent
		lines = p.layoutCode(avail, true)
		widest = 0
		for _, l := range lines {
			n := l.indent
			for _, ce := range l.cells {
				n += ce.w
			}
			widest = max(widest, n)
		}
	}
	exp, cur := p.rec.Expected(), p.rec.Cursor()
	curLine := len(lines) - 1
	for li, l := range lines {
		for _, ce := range l.cells {
			if ce.idx == cur {
				curLine = li
			}
		}
	}
	ghostAt := -1
	if p.ghost != nil && p.started {
		ghostAt = progress.GhostPosition(p.ghost, c.Now().Sub(p.startAt))
	}
	errV := c.Anim.V("p.err")
	glow := 0.5 + 0.5*math.Sin(2*math.Pi*0.8*c.Anim.T)
	if c.Anim.Reduced {
		glow = 0
	}
	caretCol := c.Theme.Mix(RolePrimary, RoleSecondary, glow)
	now := c.Now()
	_ = exp

	// Which lines can be on screen (the spring-eased scroll decides the window).
	c.Anim.To("p.scroll", float64(curLine), 9, 1)
	focus := int(math.Round(c.Anim.V("p.scroll")))
	start := max(0, min(focus-height*2/5, max(0, len(lines)-height)))
	end := min(start+height, len(lines))
	p.win = codeWindow{start, end, curLine, len(lines)}

	out := make([]string, 0, end-start)
	for li := start; li < end; li++ {
		l := lines[li]
		// Typed text takes its syntax color from the terminal theme (keywords,
		// strings, numbers, calls…); untyped text is the theme's gray. The two
		// differ by hue, not only by brightness, so the contrast survives light
		// terminals where "dim" is barely visible. The 2–3 characters just ahead
		// of the caret keep the normal text color as a halo.
		typedAt := func(idx int) (string, lipgloss.Style) {
			k := clsPlain
			if idx < len(p.classes) {
				k = p.classes[idx]
			}
			if c.Set.HighContrast {
				return "T", s.Body
			}
			return "T" + itoa(int(k)), c.classStyle(k)
		}
		pendingAt := func(ahead int) lipgloss.Style {
			op := 0.30 + 0.45*math.Exp(-float64(max(0, ahead))/3.5) // ≥ 0.55 for the next 2 characters
			if c.Set.HighContrast {
				op = 0.7
			}
			return fgStyle(c.Theme.Opacity(RoleFg, op))
		}
		var segs []*seg
		add := func(key string, st lipgloss.Style, text string) {
			if n := len(segs); n > 0 && segs[n-1].key == key {
				segs[n-1].text.WriteString(text)
				return
			}
			sg := &seg{key: key, st: st}
			sg.text.WriteString(text)
			segs = append(segs, sg)
		}
		if l.indent > 0 {
			add("ind", s.Muted, strings.Repeat(" ", l.indent))
		}
		for _, ce := range l.cells {
			txt := ce.text
			if ce.w == 4 {
				txt = "    "
			}
			switch {
			case ce.idx < cur:
				if ce.idx < len(p.typedAt) && !p.typedAt[ce.idx].IsZero() {
					if age := now.Sub(p.typedAt[ce.idx]); age < 220*time.Millisecond {
						add("f"+itoa(ce.idx), fgStyle(c.Theme.Color(RoleSecondary)).Bold(true), txt) // a brief accent flash
						continue
					}
				}
				key, st := typedAt(ce.idx)
				add(key, st, txt)
			case ce.idx == cur:
				st := lipgloss.NewStyle().Reverse(true).Bold(true).Foreground(caretCol)
				if errV > 0.05 {
					st = st.Foreground(c.Theme.Mix(RolePrimary, RoleDanger, errV))
				}
				add("C", st, txt[:1]) // on a tab only the first cell is the caret
				if len(txt) > 1 {
					add("P0", pendingAt(0), txt[1:])
				}
			default:
				if ce.idx == ghostAt && ghostAt > cur {
					add("G", s.Ghost, txt)
				} else {
					ahead := ce.idx - cur
					q := ahead
					if ahead > 18 { // beyond the halo every char shares one style
						q = 99
					}
					add("P"+itoa(q), pendingAt(ahead), txt)
				}
			}
		}
		var b strings.Builder
		for _, sg := range segs { // one Render per run of equal style, not per character
			b.WriteString(sg.st.Render(sg.text.String()))
		}
		out = append(out, b.String())
	}
	pad := 0
	if c.Set.LargeText {
		pad = max(0, (width-widest)/2)
	}
	prefix := strings.Repeat(" ", pad)
	for i := range out {
		out[i] = prefix + out[i]
	}
	return strings.Join(out, "\n")
}
