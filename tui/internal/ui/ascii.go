package ui

import "strings"

// asciiGlyphs maps the decorative Unicode the TUI draws to one-cell ASCII
// equivalents. The mapping is deliberately width-preserving (one rune in, one
// rune out) so centering, truncation and table alignment computed before the
// sanitizer still hold. Letters (accents, non-Latin scripts) are content and
// are left untouched.
var asciiGlyphs = map[rune]rune{
	// Arrows and key labels.
	'←': '<', '→': '>', '↑': '^', '↓': 'v', '↔': '-',
	'↵': '<', '⏎': '<', '⌫': '<', '⇥': '>', '↹': '>', '␣': '_',

	// Status glyphs.
	'✓': '+', '✔': '+', '✗': 'x', '✘': 'x', '✕': 'x',
	'•': '*', '·': '.', '…': '~', '›': '>', '‹': '<',
	'★': '*', '☆': '*', '♥': '+', '❤': '+', '⚿': '#',
	'●': '*', '○': 'o', '◉': 'o', '◎': 'o',

	// Punctuation that would otherwise be invalid in a non-UTF-8 locale.
	'—': '-', '–': '-', '―': '-', '≥': '>', '≤': '<', '≠': '!',
	'×': 'x', '÷': '/', '±': '+', '°': 'o', '€': 'E', '£': 'L',
	'«': '"', '»': '"', '“': '"', '”': '"', '‘': '\'', '’': '\'',
	'′': '\'', '″': '"', '⚠': '!', '⏱': 't',

	// Blocks, bars and sparkline ramps.
	'█': '#', '▓': '%', '▒': ':', '░': '.', '▌': '|', '▐': '|',
	'▀': '-', '▄': '_', '▁': '_', '▂': '.', '▃': '-', '▅': '=',
	'▆': '+', '▇': '*', '▉': '#', '▊': '#', '▋': '#', '▏': '|',
	'▎': '|', '▍': '|', '▕': '|', '▬': '-', '▲': '^', '▼': 'v',
	'▶': '>', '►': '>', '◀': '<', '◂': '<', '▸': '>', '▹': '>',
	'╱': '/', '╲': '\\',

	// Box drawing: corners, tees and crosses become '+'; the rest keep their
	// orientation so big digits and any surviving frame still read.
	'─': '-', '━': '-', '═': '-', '╌': '-', '╍': '-', '┄': '-', '┅': '-',
	'│': '|', '┃': '|', '║': '|', '╎': '|', '╏': '|', '┆': '|', '┇': '|',
	'╺': '-', '╸': '-', '╻': '|', '╹': '|', '╼': '-', '╾': '-',
	'┌': '+', '┍': '+', '┎': '+', '┏': '+', '┐': '+', '┑': '+', '┒': '+', '┓': '+',
	'└': '+', '┕': '+', '┖': '+', '┗': '+', '┘': '+', '┙': '+', '┚': '+', '┛': '+',
	'├': '+', '┤': '+', '┬': '+', '┴': '+', '┼': '+', '╭': '+', '╮': '+', '╰': '+', '╯': '+',
	'╔': '+', '╗': '+', '╚': '+', '╝': '+', '╠': '+', '╣': '+', '╦': '+', '╩': '+', '╬': '+',
}

// toASCII rewrites the decorative glyphs of s for terminals whose locale is not
// UTF-8. Every replacement is exactly one rune, so display width is unchanged.
func toASCII(s string) string {
	if s == "" {
		return s
	}
	var b strings.Builder
	b.Grow(len(s))
	for _, r := range s {
		if r >= 0x2800 && r <= 0x28FF { // braille patterns (banner, marks)
			if r == 0x2800 {
				b.WriteByte(' ')
			} else {
				b.WriteByte('#')
			}
			continue
		}
		if a, ok := asciiGlyphs[r]; ok {
			b.WriteRune(a)
			continue
		}
		b.WriteRune(r)
	}
	return b.String()
}
