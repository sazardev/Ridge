package ui

import (
	"fmt"
	"sort"
	"strings"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/service"
	"github.com/omar/ridge/tui/internal/typing"
)

func init() {
	addStrings(map[string][2]string{
		"mode.zen":       {"Zen", "Zen"},
		"mode.sprint":    {"Sprint", "Sprint"},
		"mode.precision": {"Precision", "Precisión"},
		"mode.survival":  {"Survival", "Supervivencia"},
		"mode.lesson":    {"Lesson", "Lección"},
		"mode.daily":     {"Daily challenge", "Reto diario"},
		"mode.warmup":    {"Warm-up", "Calentamiento"},
		"pb":             {"New personal best", "Nuevo récord personal"},
		"vs.history":     {"vs your last 5", "vs tus últimas 5"},
		"mastered":       {"Mastered", "Dominada"},
		"mastery.prog":   {"Mastery", "Dominio"},
		"mastery.lost":   {"Mastery slipped — keep practicing", "El dominio bajó — sigue practicando"},
		"mastery.need":   {"needs 5 precision runs", "requiere 5 pruebas de precisión"},
		"toast.unlocked": {"Achievement unlocked:", "Logro desbloqueado:"},
		"first":          {"first time", "primera vez"},
		"fingers.err":    {"Fingers", "Dedos"},
		"ex.title":       {"What you typed", "Lo que escribiste"},
		"ex.key":         {"explain", "explicar"},
		"ex.back":        {"summary", "resumen"},
		"ex.hint":        {"e  explain this snippet", "e  explicar este snippet"},
	})
}

type result struct {
	Spec     runSpec
	Out      service.Outcome
	Surv     *typing.Survival
	Cleared  int
	Complete bool
}

type resultsScreen struct {
	ctx     *Ctx
	r       *result
	explain bool // e toggles the explanation of the snippet you just typed
	hist    struct {
		cpm, acc float64
		n        int
	}
}

func newResults(c *Ctx, r *result) *resultsScreen {
	s := &resultsScreen{ctx: c, r: r}
	c.Anim.Set("r.n", 0)
	c.Anim.To("r.n", 1, 7, 1)
	// XP bar: starts where the level bar stood before the run, springs to the new value.
	lo, hi := typing.XPForLevel(r.Out.LevelBefore), typing.XPForLevel(r.Out.LevelBefore+1)
	c.Anim.Set("r.xp", clamp01(float64(r.Out.TotalXP-r.Out.XP-lo)/float64(hi-lo)))
	if r.Out.LevelAfter > r.Out.LevelBefore {
		c.Anim.To("r.xp", 1, 5, 1)
	} else {
		c.Anim.To("r.xp", clamp01(float64(r.Out.TotalXP-lo)/float64(hi-lo)), 5, 1)
	}
	// Personal history: the five sessions of this snippet before this one.
	var prev []float64
	var accs []float64
	all := c.DB.ForSnippet(r.Spec.Snippet.ID)
	for i := len(all) - 1; i >= 0 && len(prev) < 5; i-- {
		if all[i].ID != r.Out.SessionID {
			prev = append(prev, all[i].NetCPM)
			accs = append(accs, all[i].Accuracy)
		}
	}
	for i := range prev {
		s.hist.cpm += prev[i]
		s.hist.acc += accs[i]
	}
	if s.hist.n = len(prev); s.hist.n > 0 {
		s.hist.cpm /= float64(s.hist.n)
		s.hist.acc /= float64(s.hist.n)
	}
	return s
}

func (r *resultsScreen) Title() string { return r.ctx.T("done") }
func (r *resultsScreen) Init() tea.Cmd { return nil }

func (r *resultsScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return r, nil
	}
	switch k.String() {
	case "e":
		r.explain = !r.explain
		r.ctx.Anim.Set("r.ex", 0)
		r.ctx.Anim.To("r.ex", 1, 10, 1)
	case "r":
		return r, replace(newPractice(r.ctx, r.r.Spec))
	case "n":
		if next, ok := r.nextSpec(); ok {
			return r, replace(newPractice(r.ctx, next))
		}
	case "enter", "esc", "q":
		if r.explain {
			r.explain = false
			return r, nil
		}
		return r, pop()
	}
	return r, nil
}

// explanationView explains the snippet that was just typed: a quiet heading,
// the title and one-line summary, the highlighted code, and the long
// explanation rendered as Markdown at a comfortable measure.
func (r *resultsScreen) explanationView() string {
	c, s := r.ctx, r.ctx.S
	sn := r.r.Spec.Snippet
	f := c.Anim.V("r.ex")
	code := revealLines(strings.Join(c.codeBlock(sn.Code, sn.Language), "\n"), f)
	body := revealLines(c.renderMarkdown(sn.Explanation(c.Loc()), sn.Language, contentWidth(c)), f)
	label := s.Muted.Render(strings.ToUpper(c.T("ex.title")))
	return strings.Join([]string{label, "", s.Title.Render(sn.Title(c.Loc())), c.inline(sn.Tldr(c.Loc()), s.Muted), "", code, "", body}, "\n")
}

// nextSpec is the "next lesson" / "next snippet" follow-up, when one exists.
func (r *resultsScreen) nextSpec() (runSpec, bool) {
	sp, c := r.r.Spec, r.ctx
	switch sp.Mode {
	case "lesson":
		if !r.r.Out.Passed {
			return sp, false
		}
		p, ok := c.Cat.Path(sp.Path)
		if !ok || sp.Index+1 >= len(p.Lessons) {
			return sp, false
		}
		l := p.Lessons[sp.Index+1]
		sn, ok := c.Cat.Snippet(l.SnippetID)
		if !ok {
			return sp, false
		}
		return runSpec{Mode: "lesson", Snippet: sn, LessonID: l.ID, Path: p.ID, Index: sp.Index + 1}, true
	case "zen", "precision", "sprint", "survival":
		sp.Snippet = nextSnippet(c, sp.Snippet)
		return sp, true
	}
	return sp, false
}

func (r *resultsScreen) verdict() string {
	c, s, o := r.ctx, r.ctx.S, r.r.Out
	switch {
	case r.r.Spec.Mode == "precision" || r.r.Spec.Mode == "lesson" || r.r.Spec.Mode == "daily":
		if o.Passed {
			return s.Success.Bold(true).Render(c.G.Check + " " + c.T("passed"))
		}
		return s.Error.Bold(true).Render(c.G.Cross + " " + c.T("failed"))
	case r.r.Spec.Mode == "sprint":
		return s.Warning.Bold(true).Render(c.T("timeup"))
	case r.r.Spec.Mode == "survival":
		return s.Error.Bold(true).Render(c.T("gameover"))
	}
	return s.Success.Bold(true).Render(c.G.Check + " " + c.T("done"))
}

func (r *resultsScreen) View() string {
	if r.explain {
		return r.explanationView()
	}
	c, s, o := r.ctx, r.ctx.S, r.r.Out
	m := o.Metrics
	w := contentWidth(c)
	k := c.Anim.V("r.n") // 0 → 1: numbers count up

	head := r.verdict() + "  " + s.Title.Render(r.r.Spec.Snippet.Title(c.Loc()))
	if o.PersonalBest {
		head += "  " + s.Accent.Render(c.G.Star+" "+c.T("pb"))
	}
	lines := []string{head, c.inline(r.r.Spec.Snippet.Tldr(c.Loc()), s.Muted), ""}

	// Hero: the three numbers that matter, large. Quiet details follow.
	delta := func(now, base float64) string {
		if r.hist.n == 0 {
			return ""
		}
		switch d := now - base; {
		case d > 0.5:
			return s.Success.Render(fmt.Sprintf(" %s%.0f", c.G.Up, d))
		case d < -0.5:
			return s.Warning.Render(fmt.Sprintf(" %s%.0f", c.G.Down, -d))
		}
		return ""
	}
	hero := func(n, label string, st lipgloss.Style, extra string) string {
		if c.H < 32 || c.Set.Accessible { // small windows: plain text instead of big digits
			return st.Render(n) + " " + s.Muted.Render(label) + extra
		}
		rows := bigNumber(n)
		for i := range rows {
			rows[i] = st.Render(rows[i])
		}
		return strings.Join(rows, "\n") + "\n" + s.Muted.Render(label) + extra
	}
	accStyle := s.Success
	if m.Accuracy < 90 {
		accStyle = s.Warning
	}
	cols := []string{
		hero(fmt.Sprintf("%.0f", m.NetCPM*k), c.T("cpm"), s.Accent, delta(m.NetCPM, r.hist.cpm)),
		hero(fmt.Sprintf("%.0f%%", m.Accuracy*k), strings.ToLower(c.T("acc")), accStyle, delta(m.Accuracy, r.hist.acc)),
		hero(fmt.Sprintf("%d", int(float64(o.XP)*k)), "xp", s.Body, ""),
	}
	if r.r.Surv != nil {
		cols = append(cols, hero(fmt.Sprint(r.r.Surv.Score), strings.ToLower(c.T("score")), s.Body, ""))
	}
	if c.H < 32 || c.Set.Accessible {
		lines = append(lines, strings.Join(cols, s.Muted.Render("  ·  ")))
	} else {
		var spaced []string
		for i, col := range cols {
			if i > 0 {
				spaced = append(spaced, "      ")
			}
			spaced = append(spaced, col)
		}
		lines = append(lines, lipgloss.JoinHorizontal(lipgloss.Top, spaced...))
	}
	f := m.FatigueCPM
	dot := s.Muted.Render("  ·  ")
	facts := []string{
		fmt.Sprintf("%s %.0f %s", s.Muted.Render(c.T("raw")), m.RawCPM, c.T("cpm")),
		fmt.Sprintf("%s %.0f%%", s.Muted.Render(strings.ToLower(c.T("cons"))), m.Consistency),
		fmt.Sprintf("%s %d", s.Muted.Render(strings.ToLower(c.T("streak"))), m.MaxStreak),
		fmt.Sprintf("%s %d", s.Muted.Render(strings.ToLower(c.T("corr"))), m.Corrections),
		fmt.Sprintf("%s %.0f%%", s.Muted.Render(strings.ToLower(c.T("hands"))), m.HandBalance*100),
		fmt.Sprintf("%.1fs", m.Duration.Seconds()),
	}
	if r.r.Surv != nil {
		facts = append(facts, fmt.Sprintf("%s %d", s.Muted.Render(strings.ToLower(c.T("cleared"))), r.r.Cleared))
	}
	lines = append(lines, "", s.Body.Render(strings.Join(facts, dot)),
		s.Muted.Render(strings.ToLower(c.T("fatigue"))+" ")+s.Accent.Render(spark([]float64{f[0], f[1], f[2]})), "")

	lo, hi := typing.XPForLevel(o.LevelAfter), typing.XPForLevel(o.LevelAfter+1)
	level := s.Body.Render(fmt.Sprintf("%s %d  ", c.T("level"), o.LevelAfter)) + renderBar(c, c.Anim.V("r.xp"), min(32, w-24)) +
		s.Muted.Render(fmt.Sprintf("  %d/%d", o.TotalXP-lo, hi-lo))
	if o.First {
		level += s.Muted.Render(fmt.Sprintf("  +%d %s", typing.FirstCompletionBonus, c.T("first")))
	}
	if o.LevelAfter > o.LevelBefore {
		level += "  " + s.Accent.Render(c.G.Star+" "+c.T("levelup"))
	}
	lines = append(lines, level)
	if o.Mastery != nil {
		lines = append(lines, r.masteryLine())
	}
	for _, u := range o.Unlocked {
		lines = append(lines, s.Accent.Render(c.G.Star+" "+achievementTitle(c, u)))
	}
	// Weak spots only when there is room: they never push the essentials out.
	if c.H >= 38 {
		if ws := strings.TrimRight(r.weakSpots(), "\n"); ws != "" {
			lines = append(lines, "", ws)
		}
	}
	lines = append(lines, "", s.Muted.Render(c.T("ex.hint")))
	return strings.Join(lines, "\n")
}

func (r *resultsScreen) masteryLine() string {
	c, s, m := r.ctx, r.ctx.S, r.r.Out.Mastery
	label := fmt.Sprintf("%s · %s", categoryLabel(m.Category), m.Difficulty)
	switch {
	case m.PassCount < 0:
		return s.Muted.Render(c.T("mastery.prog") + ": " + label + " — " + c.T("mastery.need"))
	case m.IsMastered:
		return s.Success.Render(fmt.Sprintf("%s %s: %s (%d/5)", c.G.Check, c.T("mastered"), label, m.PassCount))
	}
	return s.Muted.Render(fmt.Sprintf("%s: %s %d/5", c.T("mastery.prog"), label, m.PassCount))
}

// weakSpots lists the worst characters of the run (SPEC §4.3 diagnostics).
func (r *resultsScreen) weakSpots() string {
	chars := append([]typing.CharStat(nil), r.r.Out.Metrics.Chars...)
	sort.Slice(chars, func(i, j int) bool {
		a, b := chars[i], chars[j]
		ea, eb := float64(a.Errors)/float64(a.Attempts), float64(b.Errors)/float64(b.Attempts)
		if ea != eb {
			return ea > eb
		}
		return a.AvgFlight > b.AvgFlight
	})
	c, s := r.ctx, r.ctx.S
	var out []string
	for _, cs := range chars {
		if cs.Errors == 0 || len(out) == 5 {
			break
		}
		out = append(out, fmt.Sprintf("%s  %s", s.Error.Render(fmt.Sprintf("%-6s", charName(c, cs.Char))),
			s.Muted.Render(fmt.Sprintf("%d/%d  %.0f ms", cs.Errors, cs.Attempts, float64(cs.AvgFlight.Milliseconds())))))
	}
	if len(out) == 0 {
		return ""
	}
	return s.Title.Render(c.T("weak")) + "\n" + strings.Join(out, "\n") + "\n"
}

// fingerBars shows attempts per finger as bars with error counts (SPEC §4.2).
func (r *resultsScreen) fingerBars() string {
	c, s := r.ctx, r.ctx.S
	fs := r.r.Out.Metrics.Fingers
	if len(fs) == 0 {
		return ""
	}
	mx := 1
	for _, f := range fs {
		mx = max(mx, f.Attempts)
	}
	out := []string{"", s.Title.Render(c.T("fingers.err"))}
	for _, f := range fs {
		n := f.Attempts * 12 / mx
		bar := s.Accent.Render(strings.Repeat("█", n)) + s.Muted.Render(strings.Repeat("░", 12-n))
		e := ""
		if f.Errors > 0 {
			e = " " + s.Error.Render(fmt.Sprintf("%s%d", c.G.Cross, f.Errors))
		}
		out = append(out, fmt.Sprintf("%-9s %s%s", s.Muted.Render(string(f.Finger)), bar, e))
	}
	return strings.Join(out, "\n") + "\n"
}

func charName(c *Ctx, ch rune) string {
	switch ch {
	case '\n':
		return c.G.Enter
	case '\t':
		return "tab"
	case ' ':
		return "space"
	}
	return string(ch)
}

func (r *resultsScreen) Help() help.KeyMap {
	c := r.ctx
	if r.explain {
		return bindings{short: kbs(kb("e", "e", c.T("ex.back")), kb("enter|esc", "enter", "back"))}
	}
	b := kbs(kb("r", "r", "retry"), kb("e", "e", "explain"))
	if _, ok := r.nextSpec(); ok {
		b = append(b, kb("n", "n", "next"))
	}
	return bindings{short: append(b, kb("enter|esc", "enter", "back"))}
}
