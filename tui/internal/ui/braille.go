package ui

import (
	"math"
	"strings"
)

// Braille is the app's single "living" visual language: every bar, the header
// mark and loading states are rows of braille cells (2×4 dots each). A
// filled stretch breathes — a slow wave runs through it — while the empty
// stretch rests as a flat dotted baseline. With reduced motion the wave is
// frozen; without UTF-8 it degrades to # and -.

// Dot bits, bottom-up, for the left and right column of a braille cell.
var (
	leftDots  = [5]rune{0, 0x40, 0x44, 0x46, 0x47}
	rightDots = [5]rune{0, 0x80, 0xA0, 0xB0, 0xB8}
)

// brailleCell builds one cell from two column heights (0–4 dots each).
func brailleCell(l, r int) string {
	l, r = max(0, min(4, l)), max(0, min(4, r))
	return string(rune(0x2800) + leftDots[l] + rightDots[r])
}

// waveHeights returns the two column heights of cell i of a breathing wave.
func (c *Ctx) waveHeights(i int) (int, int) {
	if c.Anim.Reduced {
		return 2, 2
	}
	t := c.Anim.T
	breathe := 0.5 + 0.5*math.Sin(2*math.Pi*0.25*t) // slow inhale/exhale of the amplitude
	h := func(x float64) int {
		return max(1, int(math.Round(2.2+(1.2+0.9*breathe)*math.Sin(x-2*math.Pi*0.8*t))))
	}
	return h(float64(i) * 0.7), h(float64(i)*0.7 + 0.35)
}

// renderBar draws a thin braille progress line: the filled part is the
// breathing wave in the primary→secondary gradient (sub-cell precision: the
// leading cell fills one column at a time), the rest is a faint baseline.
func renderBar(c *Ctx, frac float64, width int) string {
	width = max(4, width)
	frac = clamp01(frac)
	if !c.G.utf8 {
		n := int(math.Round(frac * float64(width)))
		cols := c.Theme.Gradient(RolePrimary, RoleSecondary, width)
		var b strings.Builder
		for i := 0; i < width; i++ {
			if i < n {
				b.WriteString(fgStyle(cols[i]).Render("#"))
			} else {
				b.WriteString(c.S.Muted.Faint(true).Render("-"))
			}
		}
		return b.String()
	}
	cols := c.Theme.Gradient(RolePrimary, RoleSecondary, width)
	filled := frac * float64(width) * 2 // in half-cells
	var b strings.Builder
	for i := 0; i < width; i++ {
		l, r := c.waveHeights(i)
		switch {
		case float64(2*i+2) <= filled+1e-9:
			b.WriteString(fgStyle(cols[i]).Render(brailleCell(l, r)))
		case float64(2*i+1) <= filled+1e-9:
			b.WriteString(fgStyle(cols[i]).Render(brailleCell(l, 0)))
		default:
			b.WriteString(c.S.Muted.Faint(true).Render(brailleCell(1, 1)))
		}
	}
	return b.String()
}

// brailleMark is the small living mark next to the wordmark: a short breathing
// wave in the accent gradient, present on every screen.
func (c *Ctx) brailleMark(width int) string {
	if !c.G.utf8 {
		return ""
	}
	cols := c.Theme.Gradient(RolePrimary, RoleSecondary, width)
	var b strings.Builder
	for i := 0; i < width; i++ {
		l, r := c.waveHeights(i + 2)
		b.WriteString(fgStyle(cols[i]).Render(brailleCell(l, r)))
	}
	return b.String()
}

// brailleSpinner is a one-cell activity indicator (the classic dots, ~12 fps).
func (c *Ctx) brailleSpinner() string {
	frames := []rune("⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏")
	if c.Anim.Reduced || !c.G.utf8 {
		return "…"
	}
	return string(frames[int(c.Anim.T*12)%len(frames)])
}
