package ui

import "strings"

// A 3×3 heavy-line digit font (data, not view logic) for the big stat numbers.
var bigDigits = map[rune][3]string{
	'0': {"┏━┓", "┃ ┃", "┗━┛"}, '1': {"╺┓ ", " ┃ ", "╺┻╸"}, '2': {"╺━┓", "┏━┛", "┗━╸"},
	'3': {"╺━┓", " ━┫", "╺━┛"}, '4': {"╻ ╻", "┗━┫", "  ╹"}, '5': {"┏━╸", "┗━┓", "╺━┛"},
	'6': {"┏━╸", "┣━┓", "┗━┛"}, '7': {"╺━┓", "  ┃", "  ╹"}, '8': {"┏━┓", "┣━┫", "┗━┛"},
	'9': {"┏━┓", "┗━┫", "╺━┛"}, '%': {"╻ ╱", " ╱ ", "╱ ╹"}, '.': {"   ", "   ", " ╹ "}, ' ': {"  ", "  ", "  "},
}

// bigNumber renders s (digits, '.', '%') three rows tall, ASCII-safe fallback
// is the caller's job (it passes plain=true in accessible/non-UTF-8 mode).
func bigNumber(s string) []string {
	rows := make([]strings.Builder, 3)
	for _, r := range s {
		g, ok := bigDigits[r]
		if !ok {
			g = bigDigits[' ']
		}
		for i := 0; i < 3; i++ {
			rows[i].WriteString(g[i])
			rows[i].WriteString(" ")
		}
	}
	return []string{rows[0].String(), rows[1].String(), rows[2].String()}
}
