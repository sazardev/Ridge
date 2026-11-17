package ui

import (
	"github.com/charmbracelet/lipgloss"
)

// Every style of the app is built here from the Theme roles (DESIGN.md "Rules
// for agents": views only call styles). No background is ever painted on the
// screen — the terminal's own theme decides.

// Styles holds one named style per role, rebuilt when the theme changes.
type Styles struct {
	Title, Body, Muted, Key, Error, Success, Warning, Accent lipgloss.Style
	Badge, BadgeAccent, BadgeOK, BadgeWarn, BadgeErr         lipgloss.Style
	Pane, PaneFocus, Dialog                                  lipgloss.Style
	Marker, Selected, Item                                   lipgloss.Style
	Typed, Pending, Cursor, CursorBad, Wrong, Ghost          lipgloss.Style
}

// NewStyles builds the style table; plain strips borders for accessible mode.
func NewStyles(t Theme, plain bool) Styles {
	col := t.Color
	fg := func(r Role) lipgloss.Style { return styleOf(col(r)) }
	badge := lipgloss.NewStyle().Padding(0, 1).Background(col(RoleSurface))
	// Clean, borderless layout: structure comes from whitespace and type, not boxes.
	pane := func(Role) lipgloss.Style { return lipgloss.NewStyle().Padding(0, 2, 0, 0) }
	dlg := lipgloss.NewStyle().Padding(1, 3)
	_ = plain
	return Styles{
		Title:       fg(RolePrimary).Bold(true),
		Body:        fg(RoleFg),
		Muted:       fg(RoleMuted),
		Key:         lipgloss.NewStyle().Bold(true),
		Error:       fg(RoleDanger),
		Success:     fg(RoleSuccess),
		Warning:     fg(RoleWarning),
		Accent:      fg(RoleSecondary).Bold(true),
		Badge:       badge.Foreground(col(RoleFg)),
		BadgeAccent: badge.Foreground(col(RolePrimary)).Bold(true),
		BadgeOK:     badge.Foreground(col(RoleSuccess)).Bold(true),
		BadgeWarn:   badge.Foreground(col(RoleWarning)).Bold(true),
		BadgeErr:    badge.Foreground(col(RoleDanger)).Bold(true),
		Pane:        pane(RoleMuted),
		PaneFocus:   pane(RolePrimary),
		Dialog:      dlg,
		Marker:      fg(RolePrimary).Bold(true),
		Selected:    fg(RolePrimary).Bold(true),
		Item:        fg(RoleFg),
		Typed:       fg(RoleSuccess),
		Pending:     fg(RoleMuted),
		Cursor:      lipgloss.NewStyle().Reverse(true).Bold(true),
		CursorBad:   lipgloss.NewStyle().Reverse(true).Bold(true).Foreground(col(RoleDanger)),
		Wrong:       fg(RoleDanger).Underline(true),
		Ghost:       fg(RoleSecondary).Underline(true),
	}
}

// Glyphs are the Unicode symbols with ASCII fallbacks for non-UTF-8 locales.
type Glyphs struct {
	Check, Cross, Bullet, Arrow, Marker, Enter, Lock, Heart, Sep, Dot, Star, Up, Down, Flat string
	utf8                                                                                    bool
}

// NewGlyphs picks the Unicode or ASCII set.
func NewGlyphs(utf8 bool) Glyphs {
	if utf8 {
		return Glyphs{"✓", "✗", "•", "→", "▌", "↵", "⚿", "♥", "›", "·", "★", "▲", "▼", "▬", true}
	}
	return Glyphs{"+", "x", "*", "->", "|", "<", "#", "<3", ">", ".", "*", "^", "v", "-", false}
}
