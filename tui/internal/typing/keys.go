package typing

import "strings"

// Finger follows the standard touch-typing assignment (SPEC §4.1).
type Finger string

const (
	LPinky  Finger = "L-pinky"
	LRing   Finger = "L-ring"
	LMiddle Finger = "L-middle"
	LIndex  Finger = "L-index"
	Thumb   Finger = "thumb"
	RIndex  Finger = "R-index"
	RMiddle Finger = "R-middle"
	RRing   Finger = "R-ring"
	RPinky  Finger = "R-pinky"
)

// Hand of a finger: "L", "R" or "" for thumbs.
func (f Finger) Hand() string {
	switch f {
	case LPinky, LRing, LMiddle, LIndex:
		return "L"
	case RIndex, RMiddle, RRing, RPinky:
		return "R"
	}
	return ""
}

// Row is the keyboard row a character lives on.
type Row string

const (
	RowNumber Row = "number"
	RowTop    Row = "top"
	RowHome   Row = "home"
	RowBottom Row = "bottom"
	RowSpace  Row = "space"
)

type keyInfo struct {
	finger Finger
	row    Row
}

var layout = buildLayout()

func buildLayout() map[rune]keyInfo {
	m := map[rune]keyInfo{}
	put := func(chars string, f Finger, r Row) {
		for _, c := range chars {
			m[c] = keyInfo{f, r}
		}
	}
	// Unshifted + shifted pairs share a physical key, hence a finger.
	put("1!`~", LPinky, RowNumber)
	put("2@", LRing, RowNumber)
	put("3#", LMiddle, RowNumber)
	put("4$5%", LIndex, RowNumber)
	put("6^7&", RIndex, RowNumber)
	put("8*", RMiddle, RowNumber)
	put("9(", RRing, RowNumber)
	put("0)-_=+", RPinky, RowNumber)
	put("qQ", LPinky, RowTop)
	put("wW", LRing, RowTop)
	put("eE", LMiddle, RowTop)
	put("rRtT", LIndex, RowTop)
	put("yYuU", RIndex, RowTop)
	put("iI", RMiddle, RowTop)
	put("oO", RRing, RowTop)
	put("pP[{]}\\|", RPinky, RowTop)
	put("aA", LPinky, RowHome)
	put("sS", LRing, RowHome)
	put("dD", LMiddle, RowHome)
	put("fFgG", LIndex, RowHome)
	put("hHjJ", RIndex, RowHome)
	put("kK", RMiddle, RowHome)
	put("lL", RRing, RowHome)
	put(";:'\"", RPinky, RowHome)
	put("zZ", LPinky, RowBottom)
	put("xX", LRing, RowBottom)
	put("cC", LMiddle, RowBottom)
	put("vVbB", LIndex, RowBottom)
	put("nNmM", RIndex, RowBottom)
	put(",<", RMiddle, RowBottom)
	put(".>", RRing, RowBottom)
	put("/?", RPinky, RowBottom)
	put(" ", Thumb, RowSpace)
	put("\t", LPinky, RowTop)
	put("\n", RPinky, RowHome)
	return m
}

// Lookup returns the finger and row of a character; ok is false when the
// character has no US-QWERTY physical key.
func Lookup(c rune) (Finger, Row, bool) {
	k, ok := layout[c]
	return k.finger, k.row, ok
}

// HomeRow reports whether the characters are on the home row (display helper).
func HomeRow(s string) bool { return strings.Trim(s, "asdfghjkl;'") == "" }

var unshift = map[rune]rune{
	'!': '1', '@': '2', '#': '3', '$': '4', '%': '5', '^': '6', '&': '7', '*': '8', '(': '9', ')': '0',
	'_': '-', '+': '=', '{': '[', '}': ']', '|': '\\', ':': ';', '"': '\'', '<': ',', '>': '.', '?': '/', '~': '`',
}

// PhysicalKey names the physical US-QWERTY key a character is typed on
// (shifted symbols and capitals map to their base key).
func PhysicalKey(c rune) string {
	switch c {
	case ' ':
		return "space"
	case '\n':
		return "enter"
	case '\t':
		return "tab"
	}
	if u, ok := unshift[c]; ok {
		return string(u)
	}
	if c >= 'A' && c <= 'Z' {
		return string(c + 32)
	}
	return string(c)
}

// CharsForFinger lists every character typed by a finger (warm-ups, SPEC §4.3).
func CharsForFinger(f Finger) []rune {
	var out []rune
	for c, k := range layout {
		if k.finger == f && c != '\n' && c != '\t' {
			out = append(out, c)
		}
	}
	return out
}

// CharsForHand lists every character typed by a hand ("L" or "R").
func CharsForHand(h string) []rune {
	var out []rune
	for c, k := range layout {
		if k.finger.Hand() == h && c != '\n' && c != '\t' {
			out = append(out, c)
		}
	}
	return out
}
