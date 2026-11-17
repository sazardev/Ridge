package ui

import (
	"strings"
	"testing"
)

// Mojo comments start with '#', like Python, not '//' — otherwise every
// comment in the Mojo catalog would render as plain text.
func TestMojoLineCommentsUseHash(t *testing.T) {
	const code = "# a note\nvar value = 1"
	cls := classify(code, "mojo")
	line := strings.Index(code, "\n")
	for i := 0; i < line; i++ {
		if cls[i] != clsComment {
			t.Fatalf("rune %d (%q) = %v, want comment", i, code[i], cls[i])
		}
	}
	if cls[line+1] != clsKeyword {
		t.Fatalf("var after the comment = %v, want keyword", cls[line+1])
	}
}

func TestMojoAndZigComptimeIsAKeyword(t *testing.T) {
	const code = "comptime for i in range(3):\n    var x = i"
	cls := classify(code, "mojo")
	start := strings.Index(code, "comptime")
	for i := start; i < start+len("comptime"); i++ {
		if cls[i] != clsKeyword {
			t.Fatalf("rune %d of comptime = %v, want keyword", i, cls[i])
		}
	}
}
