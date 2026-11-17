package ui

import (
	_ "embed"
	"fmt"
	"math"
	"strings"

	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/bubbles/key"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/progress"
	"github.com/omar/ridge/tui/internal/typing"
)

//go:embed banner.txt
var bannerArt string // art is data, never hand-typed into view code

var bannerCache = map[string]string{}

func init() {
	addStrings(map[string][2]string{
		"home.free":           {"Free practice", "Práctica libre"},
		"home.free.d":         {"Zen, Sprint, Precision, Survival", "Zen, Sprint, Precisión, Supervivencia"},
		"home.continue":       {"Continue", "Continuar"},
		"home.warmup":         {"Warm-up", "Calentamiento"},
		"home.warmup.d":       {"A snippet dense in your weak spots", "Un snippet denso en tus puntos débiles"},
		"home.progress":       {"Progress", "Progreso"},
		"home.progress.d":     {"Weak spots, activity, mastery, week", "Puntos débiles, actividad, dominio, semana"},
		"home.achievements":   {"Achievements", "Logros"},
		"home.achievements.d": {"Milestones and category mastery", "Hitos y dominio por categoría"},
		"home.keyboard":       {"Keyboard heat map", "Mapa de calor del teclado"},
		"home.keyboard.d":     {"Where you are fast, slow or miss", "Dónde eres rápido, lento o fallas"},
		"home.data":           {"Data", "Datos"},
		"home.data.d":         {"Reset lessons, export, wipe", "Reiniciar lecciones, exportar, borrar"},
		"pal.home":            {"Go to Home", "Ir al inicio"},
		"daily.streak":        {"day daily streak", "días de racha diaria"},
		"nudge":               {"A few minutes keeps your streak alive.", "Unos minutos mantienen viva tu racha."},
	})
}

type homeScreen struct {
	ctx  *Ctx
	m    *menu
	snap struct{ xp, lvl, lo, hi, streak int }
}

func newHome(ctx *Ctx) *homeScreen {
	h := &homeScreen{ctx: ctx}
	h.refresh()
	h.m = newMenu(ctx, "home", h.items())
	ctx.Anim.Set("home.xp", 0)
	ctx.Anim.To("home.xp", h.frac(), 6, 1)
	return h
}

func (h *homeScreen) frac() float64 {
	if h.snap.hi <= h.snap.lo {
		return 0
	}
	return float64(h.snap.xp-h.snap.lo) / float64(h.snap.hi-h.snap.lo)
}

func (h *homeScreen) refresh() {
	c := h.ctx
	h.snap.xp = c.TotalXP()
	h.snap.lvl = typing.LevelForXP(h.snap.xp)
	h.snap.lo, h.snap.hi = typing.XPForLevel(h.snap.lvl), typing.XPForLevel(h.snap.lvl+1)
	h.snap.streak = progress.Streak(c.PlayedDays(), c.Now().Local())
}

// nextLesson finds the first unlocked, not-yet-completed lesson of the active language.
func (h *homeScreen) nextLesson() (content.Path, int, bool) {
	c := h.ctx
	for _, p := range c.Cat.PathsFor(c.Lang()) {
		res := c.Lessons(p)
		for i, l := range p.Lessons {
			if res[l.ID].State == progress.Unlocked {
				return p, i, true
			}
		}
	}
	return content.Path{}, 0, false
}

func (h *homeScreen) items() []item {
	c := h.ctx
	var out []item
	if p, i, ok := h.nextLesson(); ok {
		out = append(out, item{Label: c.T("home.continue"), Detail: p.Lessons[i].Title(c.Loc()),
			Badge: c.S.Key.Render("↵"), Value: "continue"})
	}
	daily := c.T("home.daily.d")
	badge := c.S.Key.Render("d")
	if x, ok := c.DailyFor(progress.DayKey(c.Now())); ok {
		daily = fmt.Sprintf("%s %s", c.G.Check, c.T("daily.done"))
		_ = x
	} else if st := c.DailyStreak(c.Now()); st > 0 {
		daily = fmt.Sprintf("%d %s", st, c.T("daily.streak"))
	}
	out = append(out,
		item{Label: c.T("home.daily"), Detail: daily, Badge: badge, Value: "daily"},
		item{Label: c.T("home.free"), Detail: c.T("home.free.d"), Badge: c.S.Key.Render("f"), Value: "free"},
		item{Label: c.T("home.warmup"), Detail: c.T("home.warmup.d"), Badge: c.S.Key.Render("w"), Value: "warmup"},
		item{Label: c.T("home.courses"), Detail: c.T("home.courses.d"), Badge: c.S.Key.Render("c"), Value: "courses"},
		item{Label: c.T("home.progress"), Detail: c.T("home.progress.d"), Badge: c.S.Key.Render("p"), Value: "progress"},
		item{Label: c.T("home.achievements"), Detail: c.T("home.achievements.d"), Badge: c.S.Key.Render("a"), Value: "achievements"},
		item{Label: c.T("home.keyboard"), Detail: c.T("home.keyboard.d"), Badge: c.S.Key.Render("m"), Value: "keyboard"},
		item{Label: c.T("home.profile"), Detail: c.T("home.profile.d"), Badge: c.S.Key.Render("u"), Value: "profile"},
		item{Label: c.T("home.settings"), Detail: c.T("home.settings.d"), Badge: c.S.Key.Render("s"), Value: "settings"},
		item{Label: c.T("home.quit"), Badge: c.S.Key.Render("q"), Value: "quit"},
	)
	return out
}

func (h *homeScreen) Init() tea.Cmd { return nil }

// Ambient: the banner shimmer needs idle frames.
func (h *homeScreen) Ambient() bool { return h.showBanner() }

func (h *homeScreen) showBanner() bool {
	return h.ctx.W >= 50 && h.ctx.H >= 30 && h.ctx.G.utf8 && !h.ctx.Set.Accessible
}

var homeKeys = map[string]string{"d": "daily", "f": "free", "w": "warmup", "c": "courses", "p": "progress",
	"a": "achievements", "m": "keyboard", "u": "profile", "s": "settings", "q": "quit"}

func (h *homeScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return h, nil
	}
	switch k.String() {
	case "up":
		h.m.move(-1)
	case "down":
		h.m.move(1)
	case "enter", " ":
		it, _ := h.m.selected()
		return h, h.open(it.Value.(string))
	default:
		if v, ok := homeKeys[k.String()]; ok {
			return h, h.open(v)
		}
	}
	return h, nil
}

func (h *homeScreen) open(v string) tea.Cmd {
	c := h.ctx
	switch v {
	case "continue":
		if p, i, ok := h.nextLesson(); ok {
			l := p.Lessons[i]
			if sn, ok := c.Cat.Snippet(l.SnippetID); ok {
				return push(newPractice(c, runSpec{Mode: "lesson", Snippet: sn, LessonID: l.ID, Path: p.ID, Index: i}))
			}
		}
	case "daily":
		return push(newDaily(c))
	case "free":
		return push(newFree(c))
	case "warmup":
		return push(newWarmUp(c))
	case "courses":
		return push(newCourses(c))
	case "progress":
		return push(newProgress(c))
	case "achievements":
		return push(newAchievements(c))
	case "keyboard":
		return push(newKeyboardHeat(c))
	case "profile":
		return push(newProfile(c))
	case "settings":
		return push(newSettings(c))
	case "quit":
		return tea.Quit
	}
	return nil
}

// banner renders the wordmark with the gradient and the shimmer sweep.
func (h *homeScreen) banner() string {
	c := h.ctx
	phase := -1.0
	if !c.Anim.Reduced {
		phase = math.Mod(c.Anim.T/5, 1.6) - 0.3
	}
	// The shimmer repeats every few seconds on a 1/40 grid, so frames are
	// rendered once and replayed from a cache.
	key := fmt.Sprintf("%s|%s|%d", c.Theme.hex(RolePrimary), c.Theme.hex(RoleSecondary), int(phase*40))
	if v, ok := bannerCache[key]; ok {
		return v
	}
	var out []string
	for _, ln := range strings.Split(strings.TrimRight(bannerArt, "\n"), "\n") {
		out = append(out, c.Theme.shimmerText(ln, RolePrimary, RoleSecondary, phase, false))
	}
	v := strings.Join(out, "\n")
	if len(bannerCache) > 200 {
		bannerCache = map[string]string{}
	}
	bannerCache[key] = v
	return v
}

func (h *homeScreen) View() string {
	c, s := h.ctx, h.ctx.S
	w := contentWidth(c)
	var head string
	if h.showBanner() {
		head = h.banner() + "\n" + s.Muted.Render(c.T("tagline"))
	} else {
		head = s.Muted.Render(c.T("tagline"))
	}
	xp := int(math.Round(c.Anim.V("home.xp") * float64(h.snap.hi-h.snap.lo)))
	bar := renderBar(c, c.Anim.V("home.xp"), min(28, w-30))
	status := lipgloss.JoinHorizontal(lipgloss.Top,
		s.BadgeAccent.Render(fmt.Sprintf("%s %d", c.T("level"), h.snap.lvl)), " ", bar,
		s.Muted.Render(fmt.Sprintf(" %d/%d", xp, h.snap.hi-h.snap.lo)), "  ",
		s.Badge.Render(fmt.Sprintf("%d %s", h.snap.streak, c.T("streakdays"))), " ",
		s.Badge.Render(langName(c.Lang())))
	if lipgloss.Width(status) > w { // narrow terminals: drop the streak badge first
		bar = renderBar(c, c.Anim.V("home.xp"), max(4, min(12, w-24)))
		status = lipgloss.JoinHorizontal(lipgloss.Top,
			s.BadgeAccent.Render(fmt.Sprintf("%s %d", c.T("level"), h.snap.lvl)), " ", bar,
			s.Muted.Render(fmt.Sprintf(" %d/%d", xp, h.snap.hi-h.snap.lo)), " ",
			s.Badge.Render(langName(c.Lang())))
	}
	wide := c.W >= 112
	lw := w
	if wide {
		lw = 62
	}
	body := h.m.view(lw, c.H-lipgloss.Height(head)-8)
	if wide {
		body = lipgloss.JoinHorizontal(lipgloss.Top, body, "      ", h.today())
		status = ""
	}
	nudge := ""
	if h.reminderDue() {
		nudge = "\n" + s.Warning.Render(c.G.Bullet+" "+c.T("nudge"))
	}
	if status == "" {
		return lipgloss.JoinVertical(lipgloss.Left, head, "", body) + nudge
	}
	return lipgloss.JoinVertical(lipgloss.Left, head, "", status, "", body) + nudge
}

// reminderDue is the in-app stand-in for the daily notification: after the
// chosen time of day, if nothing was played today, the home screen nudges.
func (h *homeScreen) reminderDue() bool {
	c := h.ctx
	if !c.Set.ReminderOn {
		return false
	}
	now := c.Now().Local()
	if now.Hour()*60+now.Minute() < c.Set.ReminderMinutes {
		return false
	}
	return !c.PlayedDays()[now.Format("2006-01-02")]
}

func (h *homeScreen) Help() help.KeyMap {
	return bindings{
		short: []key.Binding{kb("up|down", "↑↓", "move"), kb("enter", "enter", "open"), kb(":", ":", "commands"), kb("?", "?", "more"), kb("q", "q", "quit")},
		full: []key.Binding{kb("d", "d", "daily"), kb("f", "f", "free"), kb("w", "w", "warm-up"), kb("c", "c", "courses"),
			kb("p", "p", "progress"), kb("a", "a", "achievements"), kb("m", "m", "keyboard"), kb("u", "u", "profile"),
			kb("s", "s", "settings"), kb(":", ":", "commands"), kb("q", "q", "quit")},
	}
}

// today is the wide-screen side column: a big level readout, the XP bar and
// the day's facts — borderless, set apart by whitespace only.
func (h *homeScreen) today() string {
	c, s := h.ctx, h.ctx.S
	lvl := bigNumber(fmt.Sprint(h.snap.lvl))
	var lv []string
	for _, r := range lvl {
		lv = append(lv, s.Accent.Render(r))
	}
	xp := int(math.Round(c.Anim.V("home.xp") * float64(h.snap.hi-h.snap.lo)))
	row := func(k, v string) string { return s.Muted.Render(fmt.Sprintf("%-18s", k)) + v }
	daily := s.Muted.Render("—")
	if x, ok := c.DailyFor(progress.DayKey(c.Now())); ok {
		daily = s.Success.Render(fmt.Sprintf("%s %d/10", c.G.Check, x.Score))
	}
	lines := []string{s.Muted.Render(strings.ToUpper(c.T("level"))), strings.Join(lv, "\n"),
		renderBar(c, c.Anim.V("home.xp"), 30), s.Muted.Render(fmt.Sprintf("%d / %d XP", xp, h.snap.hi-h.snap.lo)), "",
		row(c.T("streakdays"), s.Body.Render(fmt.Sprint(h.snap.streak))),
		row(c.T("home.daily"), daily),
		row(c.T("home.progress"), s.Body.Render(langName(c.Lang())))}
	if r := c.Recent(1); len(r) == 1 {
		lines = append(lines, "", s.Muted.Render(c.T("prog.recent")),
			s.Body.Render(fmt.Sprintf("%s · %.0f wpm · %.0f%%", r[0].Mode, r[0].NetCPM/5, r[0].Accuracy)))
	}
	return strings.Join(lines, "\n")
}
