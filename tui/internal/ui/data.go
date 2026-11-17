package ui

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

func init() {
	addStrings(map[string][2]string{
		"data.title":        {"Data", "Datos"},
		"data.reset.lesson": {"Reset this lesson's progress", "Reiniciar el progreso de esta lección"},
		"data.reset.all":    {"Reset every lesson", "Reiniciar todas las lecciones"},
		"data.reset.all.d":  {"Forgets lesson attempts; other history stays", "Olvida los intentos de lecciones; el resto del historial se conserva"},
		"data.export":       {"Export my data (JSON)", "Exportar mis datos (JSON)"},
		"data.export.d":     {"Writes a file in your home directory", "Escribe un archivo en tu carpeta personal"},
		"data.wipe":         {"Delete all data", "Borrar todos los datos"},
		"data.wipe.d":       {"Sessions, progress, settings and profile — cannot be undone", "Sesiones, progreso, ajustes y perfil — no se puede deshacer"},
		"data.wipe.q":       {"Delete ALL data permanently?", "¿Borrar TODOS los datos de forma permanente?"},
		"data.path":         {"Database", "Base de datos"},
		"data.exported":     {"Exported to", "Exportado a"},
	})
}

type dataScreen struct {
	ctx *Ctx
	m   *menu
}

func newData(c *Ctx) *dataScreen {
	return &dataScreen{c, newMenu(c, "data", []item{
		{Label: c.T("data.reset.all"), Detail: c.T("data.reset.all.d"), Value: "reset"},
		{Label: c.T("data.export"), Detail: c.T("data.export.d"), Value: "export"},
		{Label: c.T("data.wipe"), Detail: c.T("data.wipe.d"), Value: "wipe"},
	})}
}

func (d *dataScreen) Title() string { return d.ctx.T("data.title") }
func (d *dataScreen) Init() tea.Cmd { return nil }

func (d *dataScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return d, nil
	}
	c := d.ctx
	switch k.String() {
	case "up", "k":
		d.m.move(-1)
	case "down", "j":
		d.m.move(1)
	case "esc", "q":
		return d, pop()
	case "enter":
		it, _ := d.m.selected()
		switch it.Value {
		case "reset":
			return d, push(newConfirm(c, c.T("data.reset.all"), func() { _ = c.DB.ResetAllLessons(); c.Notify(c.T("done")) }))
		case "export":
			path, err := exportData(c)
			if err != nil {
				c.Notify(err.Error())
			} else {
				c.Notify(c.T("data.exported") + " " + path)
			}
		case "wipe":
			return d, push(newConfirm(c, c.T("data.wipe.q"), func() {
				_ = c.DB.Wipe()
				c.Set = c.DB.LoadSettings()
				c.Reload()
			}))
		}
	}
	return d, nil
}

func (d *dataScreen) View() string {
	return lipgloss.JoinVertical(lipgloss.Left, d.ctx.S.Muted.Render(d.ctx.T("data.path")+": "+d.ctx.DB.Path), "", d.m.view(contentWidth(d.ctx), 6))
}

func (d *dataScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "up"), kb("down|j", "↓/j", "down"), kb("enter", "enter", "run"), kb("esc", "esc", "back"))}
}

// exportData writes a portable JSON snapshot (profile, settings without the
// PIN, sessions, achievements) to the home directory.
func exportData(c *Ctx) (string, error) {
	type sess struct {
		At                      time.Time
		Mode, Snippet, Language string
		NetCPM, Accuracy        float64
		XP                      int
	}
	var ss []sess
	for _, s := range c.DB.All() {
		ss = append(ss, sess{s.At, s.Mode, s.SnippetID, s.Language, s.NetCPM, s.Accuracy, s.XP})
	}
	unlocked := map[string]time.Time{}
	for k, v := range c.DB.Unlocked() {
		unlocked[k] = v
	}
	out := map[string]any{"exportedAt": time.Now().UTC(), "profile": c.DB.LoadProfile(), "settings": c.DB.LoadSettings(),
		"totalXp": c.DB.TotalXP(), "sessions": ss, "achievements": unlocked, "mastery": c.DB.AllMastery()}
	b, err := json.MarshalIndent(out, "", "  ")
	if err != nil {
		return "", err
	}
	home, err := os.UserHomeDir()
	if err != nil {
		home = "."
	}
	path := filepath.Join(home, fmt.Sprintf("ridge-export-%s.json", time.Now().Format("20060102-150405")))
	return path, os.WriteFile(path, b, 0o600)
}
