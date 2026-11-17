package ui

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/progress"
)

func init() {
	addStrings(map[string][2]string{
		"ach.title":     {"Achievements", "Logros"},
		"ach.count":     {"unlocked", "desbloqueados"},
		"ach.milestone": {"Milestones", "Hitos"},
		"ach.mastery":   {"Category mastery", "Dominio por categoría"},
		"ach.cero":      {"Zero Errors", "Cero errores"},
		"ach.cero.d":    {"Finish a session with 100% accuracy and no corrections", "Termina una sesión con 100% de precisión y sin correcciones"},
		"ach.ambi":      {"Ambidextrous", "Ambidiestro"},
		"ach.ambi.d":    {"Finish a 100+ character session with near-perfect hand balance", "Termina una sesión de 100+ caracteres con balance de manos casi perfecto"},
		"ach.mara":      {"Marathoner", "Maratonista"},
		"ach.mara.d":    {"Type %s correct characters in your lifetime", "Teclea %s caracteres correctos en total"},
		"ach.streak":    {"%d-Day Streak", "Racha de %d días"},
		"ach.streak.d":  {"Practice %d days in a row", "Practica %d días seguidos"},
		"ach.mastery.t": {"%s · %s Mastery", "Dominio de %s · %s"},
		"ach.bronze":    {"Bronze", "Bronce"},
		"ach.silver":    {"Silver", "Plata"},
		"ach.gold":      {"Gold", "Oro"},
	})
}

func fmtThousands(n int) string {
	s := fmt.Sprint(n)
	var out []string
	for len(s) > 3 {
		out = append([]string{s[len(s)-3:]}, out...)
		s = s[:len(s)-3]
	}
	return strings.Join(append([]string{s}, out...), ",")
}

// achievementTitle is the localized title of an achievement storage key.
func achievementTitle(c *Ctx, key string) string {
	switch {
	case key == progress.CeroErrores:
		return c.T("ach.cero")
	case key == progress.Ambidiestro:
		return c.T("ach.ambi")
	case strings.HasPrefix(key, "maratonista_"):
		return c.T("ach.mara") + " · " + c.T("ach."+strings.TrimPrefix(key, "maratonista_"))
	case strings.HasPrefix(key, "streak_"):
		for _, t := range progress.StreakTiers {
			if "streak_"+t.Name == key {
				return fmt.Sprintf(c.T("ach.streak"), t.Days)
			}
		}
	case strings.HasPrefix(key, "category_mastery_"):
		rest := strings.TrimPrefix(key, "category_mastery_")
		for _, d := range difficulties {
			if strings.HasSuffix(rest, "_"+d) {
				return fmt.Sprintf(c.T("ach.mastery.t"), categoryLabel(strings.TrimSuffix(rest, "_"+d)), d)
			}
		}
	}
	return key
}

type achievementsScreen struct {
	ctx    *Ctx
	offset int
}

func newAchievements(c *Ctx) *achievementsScreen { return &achievementsScreen{ctx: c} }

func (a *achievementsScreen) Title() string { return a.ctx.T("ach.title") }
func (a *achievementsScreen) Init() tea.Cmd { return nil }

// wheel scrolls three rows per notch.
func (a *achievementsScreen) wheel(delta int) { a.offset = max(0, a.offset+delta*3) }

func (a *achievementsScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	if k, ok := msg.(tea.KeyMsg); ok {
		switch k.String() {
		case "esc", "q":
			return a, pop()
		case "down", "j":
			a.offset++
		case "up", "k":
			a.offset = max(0, a.offset-1)
		}
	}
	return a, nil
}

func (a *achievementsScreen) View() string {
	c, s := a.ctx, a.ctx.S
	have := c.Unlocked()
	type row struct{ key, title, desc string }
	var miles []row
	miles = append(miles, row{progress.CeroErrores, c.T("ach.cero"), c.T("ach.cero.d")}, row{progress.Ambidiestro, c.T("ach.ambi"), c.T("ach.ambi.d")})
	for _, t := range progress.MaratonistaTiers {
		miles = append(miles, row{"maratonista_" + t.Name, achievementTitle(c, "maratonista_"+t.Name), fmt.Sprintf(c.T("ach.mara.d"), fmtThousands(t.Chars))})
	}
	for _, t := range progress.StreakTiers {
		miles = append(miles, row{"streak_" + t.Name, fmt.Sprintf(c.T("ach.streak"), t.Days), fmt.Sprintf(c.T("ach.streak.d"), t.Days)})
	}
	total := len(miles) + len(c.Cat.Categories())*4
	unlocked := len(have)
	lines := []string{s.Muted.Render(fmt.Sprintf("%d / %d %s", unlocked, total, c.T("ach.count"))),
		renderBar(c, float64(unlocked)/float64(total), min(30, contentWidth(c)-4)), "", s.Title.Render(c.T("ach.milestone"))}
	for _, m := range miles {
		mark, st := c.G.Dot, s.Muted
		suffix := ""
		if at, ok := have[m.key]; ok {
			mark, st = c.G.Star, s.Accent
			suffix = s.Muted.Render("  " + at.Local().Format("2006-01-02"))
		}
		lines = append(lines, fmt.Sprintf("%s %s  %s%s", st.Render(mark), st.Render(fmt.Sprintf("%-22s", m.title)), s.Muted.Render(trunc(m.desc, max(10, contentWidth(c)-40))), suffix))
	}
	lines = append(lines, "", s.Title.Render(c.T("ach.mastery")), s.Muted.Render(c.T("prog.legend")))
	for _, cat := range c.Cat.Categories() {
		cells := make([]string, 4)
		for j, d := range difficulties {
			if _, ok := have[progress.MasteryKey(cat, d)]; ok {
				cells[j] = s.Success.Render(c.G.Check)
			} else {
				cells[j] = s.Muted.Render(c.G.Dot)
			}
		}
		labelW := max(12, min(28, contentWidth(c)-12))
		lines = append(lines, fmt.Sprintf("%-*s %s", labelW, s.Body.Render(trunc(categoryLabel(cat), labelW)), strings.Join(cells, "  ")))
	}
	off := min(a.offset, max(0, len(lines)-3))
	return lipgloss.JoinVertical(lipgloss.Left, strings.Join(lines[off:], "\n"))
}

func (a *achievementsScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("up|k", "↑/k", "scroll"), kb("down|j", "↓/j", "scroll"), kb("esc", "esc", "back"))}
}
