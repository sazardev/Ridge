package ui

import (
	"fmt"
	"strings"
	"time"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/progress"
	"github.com/omar/ridge/tui/internal/service"
	"github.com/omar/ridge/tui/internal/typing"
)

func init() {
	addStrings(map[string][2]string{
		"prog.title":      {"Progress", "Progreso"},
		"prog.overview":   {"Overview", "Resumen"},
		"prog.weak":       {"Weak spots", "Puntos débiles"},
		"prog.activity":   {"Activity", "Actividad"},
		"prog.mastery":    {"Mastery", "Dominio"},
		"prog.chars":      {"Characters", "Caracteres"},
		"prog.fingers":    {"Fingers", "Dedos"},
		"prog.ngrams":     {"Chains", "Encadenamientos"},
		"prog.keys":       {"Key transitions", "Transiciones de teclas"},
		"prog.week":       {"This week", "Esta semana"},
		"prog.sessions":   {"sessions", "sesiones"},
		"prog.activedays": {"active days", "días activos"},
		"prog.most":       {"Most practiced categories", "Categorías más practicadas"},
		"prog.lowest":     {"Lowest scoring categories", "Categorías con menor puntaje"},
		"prog.mostex":     {"Most practiced exercises", "Ejercicios más practicados"},
		"prog.lowex":      {"Lowest scoring exercises", "Ejercicios con menor puntaje"},
		"prog.legend":     {"Each row: Beginner, Intermediate, Advanced, Expert", "Cada fila: Principiante, Intermedio, Avanzado, Experto"},
		"prog.nodata":     {"No data yet — finish a few sessions.", "Aún no hay datos — termina algunas sesiones."},
		"prog.nolow":      {"Not enough sessions (3+) in the last 60 days.", "No hay suficientes sesiones (3+) en los últimos 60 días."},
		"prog.recent":     {"Recent sessions", "Sesiones recientes"},
		"trend.better":    {"improving", "mejorando"},
		"trend.worse":     {"worsening", "empeorando"},
		"trend.stable":    {"stable", "estable"},
	})
}

type progressTab int

const (
	tabOverview progressTab = iota
	tabWeak
	tabActivity
	tabMastery
)

// progressScreen is the progress hub (SPEC §4.3): weak spots, activity,
// weekly summary and mastery, from the same snapshot the app computes.
type progressScreen struct {
	ctx  *Ctx
	tab  progressTab
	snap service.Snapshot
	sub  int // weak-spot sub-tab
}

func newProgress(c *Ctx) *progressScreen {
	s := &progressScreen{ctx: c, snap: c.Svc.Snapshot(c.Now())}
	c.Anim.Set("prog.xp", 0)
	c.Anim.To("prog.xp", s.xpFrac(), 6, 1)
	return s
}

func (p *progressScreen) xpFrac() float64 {
	sn := p.snap
	if sn.XPForNext <= sn.XPAtLevel {
		return 0
	}
	return float64(sn.TotalXP-sn.XPAtLevel) / float64(sn.XPForNext-sn.XPAtLevel)
}

func (p *progressScreen) Title() string { return p.ctx.T("prog.title") }
func (p *progressScreen) Init() tea.Cmd { return nil }

func (p *progressScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return p, nil
	}
	switch k.String() {
	case "esc", "q":
		return p, pop()
	case "right", "l", "tab":
		p.tab = (p.tab + 1) % 4
	case "left", "h", "shift+tab":
		p.tab = (p.tab + 3) % 4
	case "[":
		p.sub = (p.sub + 3) % 4
	case "]":
		p.sub = (p.sub + 1) % 4
	}
	return p, nil
}

func (p *progressScreen) tabNames() []string {
	c := p.ctx
	names := []string{c.T("prog.overview"), c.T("prog.weak"), c.T("prog.activity"), c.T("prog.mastery")}
	if contentWidth(c) < 48 {
		for i := range names {
			names[i] = firstRunes(names[i], 4)
		}
	}
	return names
}

func firstRunes(s string, n int) string {
	r := []rune(s)
	if len(r) <= n {
		return s
	}
	return string(r[:n])
}

// clickBody selects a tab when the first body row is clicked.
func (p *progressScreen) clickBody(x, y int) (tea.Cmd, bool) {
	if y != 0 {
		return nil, false
	}
	x0 := 0
	for i, n := range p.tabNames() {
		w := lipgloss.Width(n) + 2
		if x >= x0 && x < x0+w {
			p.tab = progressTab(i)
			return nil, true
		}
		x0 += w + 1
	}
	return nil, false
}

func (p *progressScreen) tabs() string {
	s := p.ctx.S
	names := p.tabNames()
	var out []string
	for i, n := range names {
		if progressTab(i) == p.tab {
			out = append(out, s.BadgeAccent.Render(n))
		} else {
			out = append(out, s.Muted.Render(" "+n+" "))
		}
	}
	return strings.Join(out, " ")
}

func (p *progressScreen) View() string {
	var body string
	switch p.tab {
	case tabOverview:
		body = p.overview()
	case tabWeak:
		body = p.weak()
	case tabActivity:
		body = p.activity()
	default:
		body = p.masteryGrid()
	}
	return lipgloss.JoinVertical(lipgloss.Left, p.tabs(), "", body)
}

func (p *progressScreen) trendGlyph(t progress.Trend, worseIsBad bool) string {
	c, s := p.ctx, p.ctx.S
	switch t {
	case progress.Improving:
		return s.Success.Render(c.G.Up)
	case progress.Worsening:
		return s.Warning.Render(c.G.Down)
	}
	return s.Muted.Render(c.G.Flat)
}

func (p *progressScreen) overview() string {
	c, s, sn := p.ctx, p.ctx.S, p.snap
	w := contentWidth(c)
	head := lipgloss.JoinHorizontal(lipgloss.Top,
		s.BadgeAccent.Render(fmt.Sprintf("%s %d", c.T("level"), sn.Level)), " ",
		renderBar(c, c.Anim.V("prog.xp"), min(30, w-34)), s.Muted.Render(fmt.Sprintf(" %d/%d XP", sn.TotalXP-sn.XPAtLevel, sn.XPForNext-sn.XPAtLevel)), " ",
		s.Badge.Render(fmt.Sprintf("%d %s", sn.StreakDays, c.T("streakdays"))))
	wk := sn.Weekly
	delta := func(a, b float64) string {
		switch {
		case a > b+0.5:
			return " " + s.Success.Render(c.G.Up)
		case a < b-0.5:
			return " " + s.Warning.Render(c.G.Down)
		}
		return ""
	}
	week := []string{
		s.Title.Render(c.T("prog.week")),
		fmt.Sprintf("%s %s", s.Body.Render(fmt.Sprint(wk.Sessions)), s.Muted.Render(c.T("prog.sessions")+delta(float64(wk.Sessions), float64(wk.PreviousSessions)))),
		fmt.Sprintf("%s %s", s.Body.Render(wk.Duration.Round(time.Minute).String()), s.Muted.Render(c.T("time"))),
		fmt.Sprintf("%s %s", s.Body.Render(fmt.Sprintf("%.0f", wk.AvgCPM)), s.Muted.Render(c.T("cpm")+delta(wk.AvgCPM, wk.PreviousAvgCPM))),
		fmt.Sprintf("%s %s", s.Body.Render(fmt.Sprintf("%.1f%%", wk.AvgAcc)), s.Muted.Render(c.T("acc"))),
		fmt.Sprintf("%s %s", s.Body.Render(fmt.Sprintf("+%d", wk.XP)), s.Muted.Render("XP")),
		fmt.Sprintf("%s %s", s.Body.Render(fmt.Sprintf("%d/7", wk.ActiveDays)), s.Muted.Render(c.T("prog.activedays"))),
	}
	recent := c.Recent(8)
	if len(recent) == 0 {
		return lipgloss.JoinVertical(lipgloss.Left, head, "", s.Muted.Render(c.G.Bullet+" "+c.T("prog.nodata")))
	}
	var cpms []float64
	for i := len(recent) - 1; i >= 0; i-- {
		cpms = append(cpms, recent[i].NetCPM)
	}
	lines := []string{s.Title.Render(c.T("prog.recent")) + "  " + s.Accent.Render(spark(cpms))}
	for _, r := range recent {
		lines = append(lines, fmt.Sprintf("%s  %s  %s  %s", s.Muted.Render(r.At.Local().Format("01-02 15:04")),
			s.Body.Render(fmt.Sprintf("%-9s", r.Mode)), s.Accent.Render(fmt.Sprintf("%4.0f %s", r.NetCPM, c.T("cpm"))),
			s.Muted.Render(fmt.Sprintf("%5.1f%%  +%d xp", r.Accuracy, r.XP))))
	}
	left, right := s.Pane.Render(strings.Join(week, "\n")), s.Pane.Render(strings.Join(lines, "\n"))
	if w >= 90 {
		return lipgloss.JoinVertical(lipgloss.Left, head, "", lipgloss.JoinHorizontal(lipgloss.Top, left, " ", right))
	}
	return lipgloss.JoinVertical(lipgloss.Left, head, "", left)
}

func (p *progressScreen) weak() string {
	c, s, sn := p.ctx, p.ctx.S, p.snap
	names := []string{c.T("prog.chars"), c.T("prog.fingers"), c.T("prog.ngrams"), c.T("prog.keys")}
	lists := [][]progress.RankEntry{sn.Characters, sn.Fingers, sn.Ngrams, sn.Keys}
	var sub []string
	for i, n := range names {
		if i == p.sub {
			sub = append(sub, s.Title.Render(n))
		} else {
			sub = append(sub, s.Muted.Render(n))
		}
	}
	rows := []string{strings.Join(sub, s.Muted.Render("  ·  ")), ""}
	list := lists[p.sub]
	if len(list) == 0 {
		return strings.Join(rows, "\n") + s.Muted.Render(c.G.Bullet+" "+c.T("prog.nodata"))
	}
	for i, e := range list {
		label := e.Key
		if p.sub == 0 && len([]rune(label)) == 1 {
			label = charName(c, []rune(label)[0])
		}
		rows = append(rows, fmt.Sprintf("%2d  %-10s %s  %s %s", i+1, s.Body.Render(label), renderBar(c, e.Score*c.Anim.V("enter"), 16),
			s.Muted.Render(fmt.Sprintf("%3.0f", e.Score*100)), p.trendGlyph(e.Trend, true)))
	}
	return strings.Join(rows, "\n")
}

func (p *progressScreen) activity() string {
	c, s, a := p.ctx, p.ctx.S, p.snap.Activity
	section := func(title string, st []progress.ActivityStat, empty string, label func(string) string) []string {
		out := []string{s.Title.Render(title)}
		if len(st) == 0 {
			return append(out, s.Muted.Render(c.G.Bullet+" "+empty), "")
		}
		for _, x := range st {
			out = append(out, fmt.Sprintf("%-26s %s", s.Body.Render(trunc(label(x.Key), 26)),
				s.Muted.Render(fmt.Sprintf("%d× · %.0f%% · %.0f %s · %s", x.Sessions, x.AvgAccuracy, x.AvgNetCPM, c.T("cpm"), x.Time.Round(time.Second)))+
					" "+p.trendGlyph(x.Trend, false)))
		}
		return append(out, "")
	}
	exLabel := func(id string) string {
		if sn, ok := c.Cat.Snippet(id); ok {
			return sn.Title(c.Loc())
		}
		return id
	}
	var all []string
	all = append(all, section(c.T("prog.most"), a.MostPracticedCategories, c.T("prog.nodata"), categoryLabel)...)
	all = append(all, section(c.T("prog.lowest"), a.LowestCategories, c.T("prog.nolow"), categoryLabel)...)
	all = append(all, section(c.T("prog.mostex"), a.MostPracticedExercises, c.T("prog.nodata"), exLabel)...)
	all = append(all, section(c.T("prog.lowex"), a.LowestExercises, c.T("prog.nolow"), exLabel)...)
	return strings.Join(all, "\n")
}

func trunc(s string, n int) string {
	r := []rune(s)
	if len(r) <= n {
		return s
	}
	return string(r[:n-1]) + "…"
}

var difficulties = []string{"beginner", "intermediate", "advanced", "expert"}

// masteryGrid is the category × difficulty certification table (SPEC §6.4).
func (p *progressScreen) masteryGrid() string {
	c, s := p.ctx, p.ctx.S
	have := map[string]progress.MasteryStatus{}
	for _, m := range p.snap.Mastery {
		have[m.Category+"/"+m.Difficulty] = m
	}
	rows := []string{s.Muted.Render(c.T("prog.legend")), ""}
	cats := c.Cat.Categories()
	maxRows := max(3, c.H-12)
	for i, cat := range cats {
		if i >= maxRows {
			rows = append(rows, s.Muted.Render(fmt.Sprintf("… +%d", len(cats)-i)))
			break
		}
		cells := make([]string, 4)
		for j, d := range difficulties {
			m, ok := have[cat+"/"+d]
			switch {
			case ok && m.IsMastered:
				cells[j] = s.Success.Render(c.G.Check)
			case ok && m.PassCount >= 0:
				cells[j] = s.Warning.Render(fmt.Sprint(m.PassCount))
			default:
				cells[j] = s.Muted.Render(c.G.Dot)
			}
		}
		labelW := max(12, min(28, contentWidth(c)-12))
		rows = append(rows, fmt.Sprintf("%-*s %s", labelW, s.Body.Render(trunc(categoryLabel(cat), labelW)), strings.Join(cells, "  ")))
	}
	return strings.Join(rows, "\n")
}

func (p *progressScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("tab|right", "tab", "section"), kb("[", "[ ]", "list"), kb("esc", "esc", "back"))}
}

var _ = typing.XP
