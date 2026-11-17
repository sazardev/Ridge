package ui

import (
	"strings"
	"testing"

	"github.com/charmbracelet/lipgloss"
)

// The default "auto" palette is the terminal's own theme: text, muted text and
// the semantic roles resolve to the terminal's colors, never to Ridge hex.
func TestAutoPaletteInheritsTheTerminal(t *testing.T) {
	th := NewTheme("system", "auto", true, false)
	if th.Accent {
		t.Fatal("auto palette must not supply hex accents")
	}
	if _, ok := th.Color(RoleFg).(lipgloss.NoColor); !ok {
		t.Fatalf("fg = %T, want the terminal default (NoColor)", th.Color(RoleFg))
	}
	if _, ok := th.Color(RoleSurface).(lipgloss.NoColor); !ok {
		t.Fatalf("surface = %T, want the terminal background (NoColor)", th.Color(RoleSurface))
	}
	if _, ok := th.Color(RoleMuted).(faintColor); !ok {
		t.Fatalf("muted = %T, want the terminal fg dimmed (faintColor)", th.Color(RoleMuted))
	}
	for role, want := range map[Role]string{
		RolePrimary:   "4",
		RoleSecondary: "5",
		RoleSuccess:   "2",
		RoleWarning:   "3",
		RoleDanger:    "1",
	} {
		if got := th.Color(role); got != lipgloss.Color(want) {
			t.Errorf("role %d = %v, want ANSI %s", role, got, want)
		}
	}
}

// A named palette may choose the accent pair, but semantic text colors still
// come from the terminal so light and dark themes both stay readable.
func TestNamedPaletteKeepsSemanticRolesFromTheTerminal(t *testing.T) {
	th := NewTheme("dark", "ember", true, false)
	if !th.Accent {
		t.Fatal("a named palette must supply an accent pair")
	}
	if _, ok := th.Color(RoleFg).(lipgloss.NoColor); !ok {
		t.Fatalf("fg = %T, want the terminal default (NoColor)", th.Color(RoleFg))
	}
	if got := th.Color(RoleSuccess); got != lipgloss.Color("2") {
		t.Fatalf("success = %v, want ANSI 2 from the terminal", got)
	}
	accent, ok := th.Color(RolePrimary).(lipgloss.Color)
	if !ok || !strings.HasPrefix(string(accent), "#") {
		t.Fatalf("primary = %v (%T), want a resolved hex accent", th.Color(RolePrimary), th.Color(RolePrimary))
	}
}
