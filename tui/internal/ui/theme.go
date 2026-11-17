package ui

import (
	"math"
	"strconv"
	"strings"
	"sync"

	"github.com/charmbracelet/lipgloss"
	"github.com/muesli/termenv"
)

// Role is a semantic color slot. Views never name colors, only roles
// (DESIGN.md: "Read colors through one theme module").
type Role int

const (
	RoleFg Role = iota
	RoleMuted
	RolePrimary
	RoleSecondary
	RoleSuccess
	RoleWarning
	RoleDanger
	RoleSurface
	roleCount
)

type roleDef struct{ dark, light, ansi string }

// The DESIGN.md token table. `ansi` is used when the palette inherits the
// terminal's own theme ("auto"), so Gruvbox/Catppuccin/Solarized terminals
// keep their colors; the hex pair is the adaptive fallback everywhere else.
var baseRoles = [roleCount]roleDef{
	RoleFg:        {"#DDDDDD", "#1A1A1A", ""},
	RoleMuted:     {"#6C6C6C", "#8A8A8A", "8"},
	RolePrimary:   {"#9B7CFF", "#7D56F4", "4"},
	RoleSecondary: {"#F78CFF", "#EE6FF8", "5"},
	RoleSuccess:   {"#04D99A", "#02BA84", "2"},
	RoleWarning:   {"#F2C94C", "#C99700", "3"},
	RoleDanger:    {"#FF5F87", "#E0245E", "1"},
	RoleSurface:   {"#2A2438", "#F2F0FA", ""},
}

// paletteSeeds are the dark-terminal primary/secondary of each of the app's
// 25 palettes (lib/features/settings AppPaletteId); light variants are derived.
var paletteSeeds = map[string][2]string{
	"ember": {"#FF7A45", "#FFB347"}, "ocean": {"#4FA3FF", "#4FD1D9"}, "forest": {"#5CC97A", "#A3D977"},
	"grape": {"#A66BFF", "#D58CFF"}, "rose": {"#FF6B9A", "#FFA3C0"}, "sunflower": {"#FFD13F", "#FFA726"},
	"teal": {"#2EC4B6", "#7BE0D6"}, "crimson": {"#E5484D", "#FF8A8F"}, "mono": {"#C8C8C8", "#8A8A8A"},
	"nord": {"#88C0D0", "#81A1C1"}, "gruvbox": {"#FABD2F", "#FE8019"}, "dracula": {"#BD93F9", "#FF79C6"},
	"solarized": {"#268BD2", "#2AA198"}, "catppuccin": {"#CBA6F7", "#F5C2E7"}, "tokyoNight": {"#7AA2F7", "#BB9AF7"},
	"terminal": {"#33FF66", "#00D1B2"}, "matrix": {"#00FF41", "#00B82E"}, "fallout": {"#5CFF5C", "#FFB000"},
	"blackWhite": {"#FFFFFF", "#9A9A9A"}, "monokai": {"#A6E22E", "#F92672"}, "oneDark": {"#61AFEF", "#C678DD"},
	"cyberpunk": {"#00F0FF", "#FF2BD6"}, "synthwave": {"#FF2BD6", "#9D4EDD"}, "github": {"#2F81F7", "#3FB950"},
	"vscode": {"#007ACC", "#C586C0"},
}

// PaletteIDs lists "auto" (inherit the terminal) plus the app's 25 palettes,
// in the Flutter enum order.
var PaletteIDs = []string{"auto", "ember", "ocean", "forest", "grape", "rose", "sunflower", "teal", "crimson", "mono",
	"nord", "gruvbox", "dracula", "solarized", "catppuccin", "tokyoNight", "terminal", "matrix", "fallout",
	"blackWhite", "monokai", "oneDark", "cyberpunk", "synthwave", "github", "vscode"}

// Theme resolves roles to concrete colors for the terminal at hand.
//
// Rule: text, muted text and the semantic colors (success, warning, danger)
// ALWAYS come from the user's terminal theme — the default foreground, the
// same foreground dimmed, and the ANSI palette — in every palette, so Ridge
// can never show "white text" or a neon green the theme did not choose. A
// palette only contributes the primary/secondary accent pair.
type Theme struct {
	Dark    bool // terminal background is dark (only used to pick the accent variant)
	True    bool // accent gradients are available (truecolor + expressive + hex palette)
	Accent  bool // a hex palette supplies primary/secondary; "auto" uses ANSI 4 and 5
	Inherit bool // always true: semantic roles are the terminal's own
	High    bool // high-contrast: 7:1 on the accents
	BGKnown bool // the terminal answered the background query
	roles   [roleCount]roleDef
	res     [roleCount]string // accent hex, adapted to the terminal background
	BG      string            // terminal background as hex (measured, or assumed)
}

// NewTheme builds a theme. mode: system|light|dark; palette: one of PaletteIDs.
func NewTheme(mode, palette string, expressive, high bool) Theme {
	t := Theme{Dark: lipgloss.HasDarkBackground(), roles: baseRoles, High: high, Inherit: true}
	switch mode {
	case "light":
		t.Dark = false
	case "dark":
		t.Dark = true
	}
	if seeds, ok := paletteSeeds[palette]; ok {
		t.Accent = true
		t.True = expressive && lipgloss.ColorProfile() == termenv.TrueColor
		t.roles[RolePrimary] = roleDef{seeds[0], deriveLight(seeds[0]), ""}
		t.roles[RoleSecondary] = roleDef{seeds[1], deriveLight(seeds[1]), ""}
	}
	t.BG, t.BGKnown = termBackground(t.Dark)
	t.adapt()
	return t
}

// adapt fits the accent pair to the terminal. With a measured background the
// accents meet WCAG contrast against it (4.5:1, 7:1 in high contrast). When the
// terminal does not answer, they are pulled to a mid luminance that keeps
// at least ~3:1 on BOTH black and white — so a wrong guess still reads.
func (t *Theme) adapt() {
	if !t.Accent {
		return
	}
	for _, r := range []Role{RolePrimary, RoleSecondary} {
		h := t.roles[r].light
		if t.Dark {
			h = t.roles[r].dark
		}
		switch {
		case !t.BGKnown:
			t.res[r] = clampMidLuminance(h)
		case t.High:
			t.res[r] = ensureContrast(h, t.BG, 7)
		default:
			t.res[r] = ensureContrast(h, t.BG, 4.5)
		}
	}
}

// clampMidLuminance moves a color's lightness (keeping hue) until its relative
// luminance sits in [0.12, 0.28], which contrasts ≥ ~3:1 with black and white.
func clampMidLuminance(h string) string {
	x := toLCH(parseHex(h))
	for i := 0; i < 80; i++ {
		y := luminance(fromLCH(x))
		switch {
		case y < 0.12:
			x.l += 0.01
		case y > 0.28:
			x.l -= 0.01
		default:
			return x2hex(x)
		}
	}
	return x2hex(x)
}

// Color is the lipgloss color of a role: the terminal's own colors for
// everything except a hex palette's accent pair.
func (t Theme) Color(r Role) lipgloss.TerminalColor {
	if t.Accent && (r == RolePrimary || r == RoleSecondary) {
		return lipgloss.Color(t.hex(r))
	}
	switch t.roles[r].ansi {
	case "": // foreground and surface: the terminal's own defaults
		return lipgloss.NoColor{}
	case "faint": // muted = the default foreground, dimmed — never a fixed gray
		return faintColor{}
	}
	return lipgloss.Color(t.roles[r].ansi)
}

func isAccent(r Role) bool { return r == RolePrimary || r == RoleSecondary }

func (t Theme) hex(r Role) string { return t.res[r] }

// Mix blends two roles. Only the accent pair can blend (OKLCH, truecolor); any
// other pair snaps to the nearer role, since the terminal's own colors have no
// in-between tones we could draw faithfully.
func (t Theme) Mix(a, b Role, f float64) lipgloss.TerminalColor {
	if t.True && t.Accent && isAccent(a) && isAccent(b) {
		return lipgloss.Color(lerpHex(t.hex(a), t.hex(b), f))
	}
	if f < 0.5 {
		return t.Color(a)
	}
	return t.Color(b)
}

// Gradient returns n per-cell colors from a to b (DESIGN: OKLCH, 2–3 stops).
// Without truecolor it falls back to one solid accent.
func (t Theme) Gradient(a, b Role, n int) []lipgloss.TerminalColor {
	key := gradKey{t.res[a], t.res[b], n, t.True, t.Inherit, a, b}
	if v, ok := gradCache.Load(key); ok {
		return v.([]lipgloss.TerminalColor)
	}
	out := t.gradient(a, b, n)
	gradCache.Store(key, out)
	return out
}

type gradKey struct {
	a, b    string
	n       int
	tc, inh bool
	ra, rb  Role
}

var gradCache sync.Map

func (t Theme) gradient(a, b Role, n int) []lipgloss.TerminalColor {
	out := make([]lipgloss.TerminalColor, n)
	if !(t.True && t.Accent && isAccent(a) && isAccent(b)) {
		// Two accents in steps (ANSI 4/5 for "auto"): follows the terminal theme.
		for i := range out {
			if i*2 < n {
				out[i] = t.Color(a)
			} else {
				out[i] = t.Color(b)
			}
		}
		return out
	}
	for i := range out {
		f := 0.0
		if n > 1 {
			f = float64(i) / float64(n-1)
		}
		out[i] = lipgloss.Color(lerpHex(t.hex(a), t.hex(b), f))
	}
	return out
}

// --- OKLCH math --------------------------------------------------------------

type rgb struct{ r, g, b float64 }
type lch struct{ l, c, h float64 }

func parseHex(s string) rgb {
	s = strings.TrimPrefix(s, "#")
	v, _ := strconv.ParseUint(s, 16, 32)
	return rgb{float64(v>>16&255) / 255, float64(v>>8&255) / 255, float64(v&255) / 255}
}

func (c rgb) hex() string {
	f := func(x float64) int { return int(math.Round(math.Max(0, math.Min(1, x)) * 255)) }
	return "#" + hex2(f(c.r)) + hex2(f(c.g)) + hex2(f(c.b))
}

func hex2(n int) string {
	const d = "0123456789ABCDEF"
	return string([]byte{d[n>>4], d[n&15]})
}

func lin(x float64) float64 {
	if x <= 0.04045 {
		return x / 12.92
	}
	return math.Pow((x+0.055)/1.055, 2.4)
}

func gam(x float64) float64 {
	if x <= 0.0031308 {
		return 12.92 * x
	}
	return 1.055*math.Pow(x, 1/2.4) - 0.055
}

func toLCH(c rgb) lch {
	r, g, b := lin(c.r), lin(c.g), lin(c.b)
	l := math.Cbrt(0.4122214708*r + 0.5363325363*g + 0.0514459929*b)
	m := math.Cbrt(0.2119034982*r + 0.6806995451*g + 0.1073969566*b)
	s := math.Cbrt(0.0883024619*r + 0.2817188376*g + 0.6299787005*b)
	L := 0.2104542553*l + 0.7936177850*m - 0.0040720468*s
	a := 1.9779984951*l - 2.4285922050*m + 0.4505937099*s
	bb := 0.0259040371*l + 0.7827717662*m - 0.8086757660*s
	return lch{L, math.Hypot(a, bb), math.Atan2(bb, a)}
}

func fromLCH(x lch) rgb {
	a, b := x.c*math.Cos(x.h), x.c*math.Sin(x.h)
	l := math.Pow(x.l+0.3963377774*a+0.2158037573*b, 3)
	m := math.Pow(x.l-0.1055613458*a-0.0638541728*b, 3)
	s := math.Pow(x.l-0.0894841775*a-1.2914855480*b, 3)
	return rgb{
		gam(4.0767416621*l - 3.3077115913*m + 0.2309699292*s),
		gam(-1.2684380046*l + 2.6097574011*m - 0.3413193965*s),
		gam(-0.0041960863*l - 0.7034186147*m + 1.7076147010*s),
	}
}

// lerpCache memoizes OKLCH blends: factors are quantized to 1/64, which is
// below what a terminal can show, and the same few colors repeat every frame.
var lerpCache sync.Map

func lerpHex(a, b string, f float64) string {
	q := int(math.Round(math.Max(0, math.Min(1, f)) * 64))
	if q == 0 {
		return a
	}
	if q == 64 {
		return b
	}
	k := a + b + string(rune('A'+q))
	if v, ok := lerpCache.Load(k); ok {
		return v.(string)
	}
	v := lerpHexExact(a, b, float64(q)/64)
	lerpCache.Store(k, v)
	return v
}

func lerpHexExact(a, b string, f float64) string {
	f = math.Max(0, math.Min(1, f))
	x, y := toLCH(parseHex(a)), toLCH(parseHex(b))
	dh := y.h - x.h
	for dh > math.Pi {
		dh -= 2 * math.Pi
	}
	for dh < -math.Pi {
		dh += 2 * math.Pi
	}
	if x.c < 0.02 { // achromatic endpoints have no meaningful hue
		x.h = y.h
		dh = 0
	}
	if y.c < 0.02 {
		dh = 0
	}
	return fromLCH(lch{x.l + (y.l-x.l)*f, x.c + (y.c-x.c)*f, x.h + dh*f}).hex()
}

// deriveLight darkens a dark-terminal accent so it keeps contrast on light ones.
func deriveLight(h string) string {
	x := toLCH(parseHex(h))
	x.l = math.Min(x.l*0.8, 0.62)
	return fromLCH(x).hex()
}

// Hex is the resolved hex of a role for the current background (used for
// per-frame mixes such as fades).
func (t Theme) Hex(r Role) string { return t.hex(r) }

// shimmerText paints s with the primary→secondary gradient and, when phase is
// in [0,1], a bold band sweeping across it (idle animation). The band is a
// weight change, not a color, so it stays correct on any terminal theme.
func (t Theme) shimmerText(s string, a, b Role, phase float64, bold bool) string {
	rs := []rune(s)
	cols := t.Gradient(a, b, len(rs))
	var sb strings.Builder
	n := len(rs)
	for i, r := range rs {
		if r == ' ' || r == '\n' {
			sb.WriteRune(r)
			continue
		}
		st := fgStyle(cols[i]).Bold(bold)
		if phase >= 0 && n > 1 {
			if d := float64(i)/float64(n-1) - phase; d*d < 0.004 {
				st = st.Bold(true)
			}
		}
		sb.WriteString(st.Render(string(r)))
	}
	return sb.String()
}

var (
	cachedBG    string
	cachedKnown bool
	bgQueried   bool
)

// termBackground measures the terminal background once (OSC 11) before the
// program takes over the tty. known is false when the terminal does not answer;
// the guess is then only used to pick between the dark and light accent variant.
func termBackground(dark bool) (hex string, known bool) {
	if !bgQueried {
		bgQueried = true
		if c := termenv.BackgroundColor(); c != nil {
			if _, none := c.(termenv.NoColor); !none {
				cachedBG, cachedKnown = termenv.ConvertToRGB(c).Hex(), true
			}
		}
	}
	if cachedKnown {
		return cachedBG, true
	}
	if dark {
		return "#000000", false
	}
	return "#FFFFFF", false
}

func luminance(c rgb) float64 {
	return 0.2126*lin(c.r) + 0.7152*lin(c.g) + 0.0722*lin(c.b)
}

// contrast is the WCAG contrast ratio between two hex colors.
func contrast(a, b string) float64 {
	la, lb := luminance(parseHex(a)), luminance(parseHex(b))
	if la < lb {
		la, lb = lb, la
	}
	return (la + 0.05) / (lb + 0.05)
}

// ensureContrast nudges lightness (in OKLCH, keeping hue) away from the
// background until the ratio is met.
func ensureContrast(h, bg string, min float64) string {
	if contrast(h, bg) >= min {
		return h
	}
	x := toLCH(parseHex(h))
	dir := 1.0
	if luminance(parseHex(bg)) > 0.4 {
		dir = -1
	}
	for i := 0; i < 60 && contrast(x2hex(x), bg) < min; i++ {
		x.l = math.Max(0, math.Min(1, x.l+dir*0.015))
	}
	return x2hex(x)
}

func x2hex(x lch) string { return fromLCH(x).hex() }

// GradientHex returns n hex stops from a to b (OKLCH); solid when not truecolor.
func (t Theme) GradientHex(a, b Role, n int) []string {
	out := make([]string, n)
	for i := range out {
		f := 0.0
		if n > 1 {
			f = float64(i) / float64(n-1)
		}
		out[i] = lerpHex(t.hex(a), t.hex(b), f)
	}
	return out
}

// Opacity is a role's color at the given opacity. The terminal's own colors
// have no in-between tones, so it snaps: full color when op is high, the dimmed
// default text color otherwise — which reads on any theme, light or dark.
func (t Theme) Opacity(r Role, op float64) lipgloss.TerminalColor {
	if op >= 0.55 {
		return t.Color(r)
	}
	return t.Color(RoleMuted)
}

// faintColor stands for "the terminal's default foreground, dimmed" (SGR 2).
// Bright-black (ANSI 8) is near-white in several light themes, so muted text
// is never a color at all: it is the user's own text color with the faint
// attribute, which stays legible on any theme.
type faintColor struct{ lipgloss.NoColor } // embedding satisfies lipgloss.TerminalColor

// styleOf is a foreground style for any theme color, honoring faintColor.
func styleOf(col lipgloss.TerminalColor) lipgloss.Style {
	if _, ok := col.(faintColor); ok {
		return lipgloss.NewStyle().Faint(true)
	}
	return lipgloss.NewStyle().Foreground(col)
}
