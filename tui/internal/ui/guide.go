package ui

import (
	"strings"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
)

func init() {
	addStrings(map[string][2]string{
		"guide.title":    {"Guide & shortcuts", "Guía y atajos"},
		"guide.home.d":   {"Commands, mouse, shortcuts and comfort", "Comandos, ratón, atajos y comodidad"},
		"guide.lead":     {"Ridge is keyboard-first. Everything below also works with the mouse where it makes sense.", "Ridge está pensado para teclado. Todo lo de abajo también funciona con ratón donde tiene sentido."},
		"guide.move":     {"Getting around", "Moverse"},
		"guide.move.d":   {"↑/↓ or j/k move • enter opens • esc goes back • q quits • tab/shift+tab switches sections", "↑/↓ o j/k mueve • enter abre • esc vuelve • q sale • tab/shift+tab cambia sección"},
		"guide.cmd":      {"Commands", "Comandos"},
		"guide.cmd.d":    {"`:` or Ctrl+P opens the command palette: type to filter, enter runs, esc closes. Every command is also a menu entry.", "`:` o Ctrl+P abre la paleta de comandos: escribe para filtrar, enter ejecuta, esc cierra. Cada comando también está en el menú."},
		"guide.mouse":    {"Mouse", "Ratón"},
		"guide.mouse.d":  {"Click a row to select and run it; the wheel scrolls lists. Typing itself is always keyboard only.", "Haz clic en una fila para seleccionarla y ejecutarla; la rueda desplaza listas. Para escribir, siempre teclado."},
		"guide.typing":   {"While typing", "Mientras tecleas"},
		"guide.typing.d": {"Type the highlighted code • backspace undoes • tab/enter consume indentation • ctrl+r restarts • esc leaves", "Teclea el código resaltado • backspace deshace • tab/enter consumen indentación • ctrl+r reinicia • esc sale"},
		"guide.theme":    {"Theme", "Tema"},
		"guide.theme.d":  {"Settings → Palette: `auto` follows the terminal's foreground/ANSI colors; a named palette only changes the accent pair. `t` cycles light/system/dark in onboarding.", "Ajustes → Paleta: `auto` sigue el foreground/ANSI de la terminal; una paleta con nombre solo cambia el par de acentos. `t` alterna claro/sistema/oscuro en el onboarding."},
		"guide.access":   {"Comfort", "Comodidad"},
		"guide.access.d": {"Settings has high contrast, reduced motion, accessible mode (no color or animation), large text and a daily reminder. `NO_COLOR=1` and non-UTF-8 locales are supported.", "Ajustes tiene alto contraste, movimiento reducido, modo accesible (sin color ni animación), texto grande y recordatorio diario. Se soportan `NO_COLOR=1` y locales no UTF-8."},
		"guide.data":     {"Your data", "Tus datos"},
		"guide.data.d":   {"Guest/offline only; Data exports JSON or wipes everything. The TUI keeps its own SQLite file (RIDGE_DATA overrides its folder), separate from the Flutter app.", "Solo Invitado/offline; Datos exporta JSON o borra todo. La TUI guarda su propio SQLite (RIDGE_DATA cambia la carpeta), separado de la app Flutter."},
	})
}

// guideScreen is the in-app manual: commands, mouse, typing and comfort. It is
// reachable with F1, from Home and from the command palette, so it is never
// hidden behind one shortcut.
type guideScreen struct {
	ctx    *Ctx
	offset int
}

func newGuide(c *Ctx) *guideScreen { return &guideScreen{ctx: c} }

func (g *guideScreen) Title() string { return g.ctx.T("guide.title") }
func (g *guideScreen) Init() tea.Cmd { return nil }

func (g *guideScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	switch m := msg.(type) {
	case tea.KeyMsg:
		switch m.String() {
		case "esc", "q":
			return g, pop()
		case "up", "k":
			g.offset = max(0, g.offset-1)
		case "down", "j":
			g.offset++
		case "home", "g":
			g.offset = 0
		}
	case tea.MouseMsg:
		if m.Action == tea.MouseActionPress {
			switch m.Button {
			case tea.MouseButtonWheelUp:
				g.offset = max(0, g.offset-3)
			case tea.MouseButtonWheelDown:
				g.offset += 3
			}
		}
	}
	return g, nil
}

func (g *guideScreen) wheel(delta int) {
	g.offset = max(0, g.offset+delta*3)
}

func (g *guideScreen) View() string {
	c, s := g.ctx, g.ctx.S
	section := func(title, body string) string {
		return s.Title.Render(title) + "\n" + s.Body.Render(c.inline(body, s.Muted))
	}
	lines := []string{
		s.Body.Render(c.inline(c.T("guide.lead"), s.Muted)),
		"",
		section(c.T("guide.move"), c.T("guide.move.d")),
		section(c.T("guide.cmd"), c.T("guide.cmd.d")),
		section(c.T("guide.mouse"), c.T("guide.mouse.d")),
		section(c.T("guide.typing"), c.T("guide.typing.d")),
		section(c.T("guide.theme"), c.T("guide.theme.d")),
		section(c.T("guide.access"), c.T("guide.access.d")),
		section(c.T("guide.data"), c.T("guide.data.d")),
	}
	body := strings.Split(strings.Join(lines, "\n\n"), "\n")
	off := min(g.offset, max(0, len(body)-1))
	return strings.Join(body[off:], "\n")
}

func (g *guideScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "scroll"), kb("down|j", "↓/j", "scroll"),
		kb("esc", "esc", "back"), kb(":", ":", "commands"), kb("f1", "f1", "guide"))}
}
