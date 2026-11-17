package ui

import (
	"fmt"
	"reflect"
	"regexp"
	"strings"
	"testing"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/muesli/termenv"
	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/service"
	"github.com/omar/ridge/tui/internal/store"
)

func newCtx(t *testing.T, onboarded bool) *Ctx {
	t.Helper()
	lipgloss.SetColorProfile(termenv.Ascii) // goldens/tests never depend on the terminal
	cat, err := content.Load()
	if err != nil {
		t.Fatal(err)
	}
	db, err := store.Open(":memory:")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { db.Close() })
	st := db.LoadSettings()
	st.OnboardingDone = onboarded
	st.Locale = "en"
	st.ReducedMotion = true // tests read settled frames; motion tests opt back in
	_ = db.SaveSettings(st)
	return NewCtx(&service.Service{DB: db, Cat: cat})
}

func newApp(t *testing.T, onboarded bool) *App {
	t.Helper()
	a := New(newCtx(t, onboarded))
	a.Update(tea.WindowSizeMsg{Width: 80, Height: 24})
	return a
}

// run executes a command like the runtime would, following navigation and
// batch/sequence messages but dropping timers (ticks, cursor blink).
func run(a *App, cmd tea.Cmd) {
	if cmd == nil {
		return
	}
	done := make(chan tea.Msg, 1)
	go func() { done <- cmd() }()
	var msg tea.Msg
	select {
	case msg = <-done:
	case <-time.After(15 * time.Millisecond):
		return
	}
	if msg == nil {
		return
	}
	if v := reflect.ValueOf(msg); v.Kind() == reflect.Slice && v.Type().Elem() == reflect.TypeOf(cmd) {
		for i := 0; i < v.Len(); i++ {
			run(a, v.Index(i).Interface().(tea.Cmd))
		}
		return
	}
	switch msg.(type) {
	case pushMsg, popMsg, replaceMsg, homeMsg, themeMsg:
		_, next := a.Update(msg)
		run(a, next)
	}
}

func send(a *App, msg tea.Msg) {
	_, cmd := a.Update(msg)
	run(a, cmd)
}

func press(a *App, keys ...string) {
	for _, k := range keys {
		switch k {
		case "enter":
			send(a, tea.KeyMsg{Type: tea.KeyEnter})
		case "esc":
			send(a, tea.KeyMsg{Type: tea.KeyEsc})
		case "tab":
			send(a, tea.KeyMsg{Type: tea.KeyTab})
		case "right":
			send(a, tea.KeyMsg{Type: tea.KeyRight})
		case "down":
			send(a, tea.KeyMsg{Type: tea.KeyDown})
		default:
			send(a, tea.KeyMsg{Type: tea.KeyRunes, Runes: []rune(k)})
		}
	}
}

func typeCode(a *App, code string) {
	for _, r := range code {
		switch r {
		case '\n':
			send(a, tea.KeyMsg{Type: tea.KeyEnter})
		case '\t':
			send(a, tea.KeyMsg{Type: tea.KeyTab})
		case ' ':
			send(a, tea.KeyMsg{Type: tea.KeySpace})
		default:
			send(a, tea.KeyMsg{Type: tea.KeyRunes, Runes: []rune{r}})
		}
	}
}

func TestOnboardingCreatesProfileThenHome(t *testing.T) {
	a := newApp(t, false)
	if _, ok := a.top().(*onboardingScreen); !ok {
		t.Fatalf("first run starts onboarding, got %T", a.top())
	}
	for i := 0; i < obPages-1; i++ {
		press(a, "enter")
	}
	press(a, "enter") // empty username is rejected with a fix-it message
	if _, ok := a.top().(*onboardingScreen); !ok || !strings.Contains(a.View(), "required") {
		t.Fatal("empty username must be rejected inline")
	}
	press(a, "a", "d", "a")
	press(a, "enter")
	if _, ok := a.top().(*homeScreen); !ok {
		t.Fatalf("expected home, got %T", a.top())
	}
	if a.ctx.DB.LoadProfile().Username != "ada" || !a.ctx.DB.LoadSettings().OnboardingDone {
		t.Fatal("profile and onboarding flag persist")
	}
}

func TestZenFlowEndToEnd(t *testing.T) {
	a := newApp(t, true)
	press(a, "f") // free practice
	press(a, "enter")
	press(a, "enter") // zen picker → first snippet
	p, ok := a.top().(*practiceScreen)
	if !ok {
		// Zen opens the snippet picker first; one more enter starts the snippet.
		t.Fatalf("expected practice, got %T", a.top())
	}
	typeCode(a, p.snippet.Code)
	r, ok := a.top().(*resultsScreen)
	if !ok {
		t.Fatalf("expected results, got %T", a.top())
	}
	o := r.r.Out
	if o.Metrics.Accuracy != 100 || o.XP <= 0 || a.ctx.DB.TotalXP() != o.XP {
		t.Fatalf("outcome %+v", o)
	}
	if !strings.Contains(a.View(), "xp") {
		t.Fatal("results show the XP line")
	}
}

func TestAnimationTickerStopsWhenSettled(t *testing.T) {
	a := newApp(t, true)
	a.ctx.Set.ReducedMotion = false
	a.ctx.Reload()
	a.ticking = false
	a.ctx.Anim.To("x", 1, 8, 1)
	a.ctx.Anim.Set("x", 0)
	a.ctx.Anim.To("x", 1, 8, 1)
	if a.frame() == nil {
		t.Fatal("a moving spring must start the 60 fps ticker")
	}
	a.ticking = false
	for i := 0; i < 600 && a.ctx.Anim.Moving(); i++ {
		a.ctx.Anim.Step(a.ctx.Anim.last.Add(frameInterval))
	}
	if a.ctx.Anim.Moving() || a.ctx.Anim.V("x") != 1 {
		t.Fatalf("spring must settle exactly on target, v=%v", a.ctx.Anim.V("x"))
	}
	// Settled, but motion is allowed: the ambient mark keeps the 60 fps idle ticker alive.
	if a.frame() == nil {
		t.Fatal("ambient motion must keep ticking when idle")
	}
	// With reduced motion nothing is pending → the ticker really stops.
	a.ticking = false
	a.ctx.Set.ReducedMotion = true
	a.ctx.Reload()
	if a.frame() != nil {
		t.Fatal("reduced motion + settled springs must not tick")
	}
}

func TestReducedMotionJumpsToTarget(t *testing.T) {
	c := newCtx(t, true)
	c.Set.ReducedMotion = true
	c.Reload()
	c.Anim.Set("v", 0)
	c.Anim.To("v", 1, 8, 1)
	if c.Anim.V("v") != 1 || c.Anim.Moving() {
		t.Fatal("reduced motion must jump, not ease")
	}
}

func TestLockGate(t *testing.T) {
	c := newCtx(t, true)
	c.DB.SetPIN("1234")
	c.Set.LockEnabled = true
	c.SaveSettings()
	a := New(c)
	a.Update(tea.WindowSizeMsg{Width: 80, Height: 24})
	c.Set.ReducedMotion = false
	c.Reload()
	if _, ok := a.top().(*lockScreen); !ok {
		t.Fatalf("locked app starts on the PIN screen, got %T", a.top())
	}
	press(a, "9", "9", "9", "9")
	if _, ok := a.top().(*lockScreen); !ok || !strings.Contains(a.View(), "Incorrect") {
		t.Fatal("wrong PIN stays locked with an error")
	}
	if a.ctx.Anim.V("lock.shake") == 0 && !a.ctx.Anim.Moving() {
		t.Fatal("wrong PIN triggers the shake")
	}
	press(a, "1", "2", "3", "4")
	if _, ok := a.top().(*homeScreen); !ok {
		t.Fatalf("correct PIN unlocks to home, got %T", a.top())
	}
}

func TestSetPINFlow(t *testing.T) {
	a := newApp(t, true)
	a.stack = append(a.stack, newLock(a.ctx, lockSet))
	press(a, "1", "2", "3", "4", "1", "2", "3", "4")
	if !a.ctx.DB.VerifyPIN("1234") || !a.ctx.Set.LockEnabled {
		t.Fatal("matching PIN twice stores it and enables the lock")
	}
}

func TestPalettePreviewRevertsOnEsc(t *testing.T) {
	a := newApp(t, true)
	orig := a.ctx.Set.Palette
	a.stack = append(a.stack, newPalettePicker(a.ctx))
	press(a, "down", "down")
	if a.ctx.Set.Palette == orig {
		t.Fatal("moving previews the palette")
	}
	press(a, "esc")
	if a.ctx.Set.Palette != orig {
		t.Fatal("esc restores the original palette")
	}
}

func TestCommandPalette(t *testing.T) {
	a := newApp(t, true)
	press(a, ":")
	if a.pal == nil {
		t.Fatal(": opens the command palette")
	}
	press(a, "s", "e", "t")
	press(a, "enter")
	if _, ok := a.top().(*settingsScreen); !ok {
		t.Fatalf("palette runs the filtered action, got %T", a.top())
	}
}

func TestEveryScreenFitsTheTerminal(t *testing.T) {
	for _, sz := range [][2]int{{80, 24}, {40, 20}, {60, 24}, {200, 60}, {120, 40}} {
		a := newApp(t, true)
		a.Update(tea.WindowSizeMsg{Width: sz[0], Height: sz[1]})
		c := a.ctx
		sn := c.Cat.SnippetsFor("go")[0]
		screens := []Screen{
			newHome(c), newFree(c), newLanguages(c), newCourses(c), newSettings(c), newProfile(c), newAchievements(c),
			newProgress(c), newKeyboardHeat(c), newSnippetPicker(c, "zen", "go"), newSprintPicker(c, "go"), newLanguagePicker(c, "go", func(string) {}), newDaily(c), newWarmUp(c),
			newLessons(c, c.Cat.PathsFor("go")[0]), newData(c), newPalettePicker(c), newGuide(c), newLock(c, lockVerify), newOnboarding(c),
			newPractice(c, runSpec{Mode: "zen", Snippet: sn}), newConfirm(c, "x", func() {}),
		}
		for i := 0; i < 4; i++ {
			p := newProgress(c)
			p.tab = progressTab(i)
			screens = append(screens, p)
		}
		for _, s := range screens {
			a.stack = []Screen{s}
			out := a.View()
			if h, w := lipgloss.Height(out), lipgloss.Width(out); h > sz[1] || w > sz[0] {
				t.Errorf("%T at %dx%d renders %dx%d", s, sz[0], sz[1], w, h)
			}
			if strings.TrimSpace(out) == "" {
				t.Errorf("%T rendered nothing", s)
			}
		}
	}
}

func TestSprintAndSurvivalChain(t *testing.T) {
	a := newApp(t, true)
	sn := a.ctx.Cat.SnippetsFor("go")[0]
	a.stack = []Screen{newPractice(a.ctx, runSpec{Mode: "survival", Snippet: sn})}
	p := a.top().(*practiceScreen)
	typeCode(a, p.snippet.Code)
	if _, ok := a.top().(*practiceScreen); !ok || p.surv.Cleared != 1 {
		t.Fatalf("survival chains to the next snippet, top=%T cleared=%d", a.top(), p.surv.Cleared)
	}
	for i := 0; i < 5; i++ {
		send(a, tea.KeyMsg{Type: tea.KeyRunes, Runes: []rune{'\x01'}})
	}
	if _, ok := a.top().(*resultsScreen); !ok {
		t.Fatalf("run should be over, top=%T", a.top())
	}
}

func TestPasteIsIgnored(t *testing.T) {
	a := newApp(t, true)
	sn := a.ctx.Cat.SnippetsFor("go")[0]
	a.stack = []Screen{newPractice(a.ctx, runSpec{Mode: "zen", Snippet: sn})}
	send(a, tea.KeyMsg{Type: tea.KeyRunes, Runes: []rune(sn.Code), Paste: true})
	if a.top().(*practiceScreen).rec.Cursor() != 0 {
		t.Fatal("pasted text must not count")
	}
}

func TestLessonProgressionUnlocksNext(t *testing.T) {
	a := newApp(t, true)
	press(a, "enter") // Home first item = Continue (lesson 1 of the first go path)
	p, ok := a.top().(*practiceScreen)
	if !ok || p.spec.Mode != "lesson" {
		t.Fatalf("continue starts the next lesson, got %T", a.top())
	}
	typeCode(a, p.snippet.Code)
	r, ok := a.top().(*resultsScreen)
	if !ok || !r.r.Out.Passed {
		t.Fatalf("a flawless lesson passes, top=%T", a.top())
	}
	if _, ok := r.nextSpec(); !ok {
		t.Fatal("passing offers the next lesson")
	}
}

func TestFuzzyAndSpark(t *testing.T) {
	if !fuzzy("go to settings", "gts") || fuzzy("settings", "xyz") {
		t.Fatal("fuzzy subsequence match")
	}
	if got := spark([]float64{1, 2, 3}); len([]rune(got)) != 3 {
		t.Fatal("sparkline has one rune per value")
	}
}

func BenchmarkPracticeView(b *testing.B) {
	lipgloss.SetColorProfile(termenv.TrueColor)
	cat, _ := content.Load()
	db, _ := store.Open(":memory:")
	defer db.Close()
	c := NewCtx(&service.Service{DB: db, Cat: cat})
	c.Set.ReducedMotion = false
	c.Reload()
	a := New(c)
	a.Update(tea.WindowSizeMsg{Width: 120, Height: 40})
	var sn content.Snippet
	for _, s := range cat.SnippetsFor("go") {
		if len(s.Code) > len(sn.Code) && len(s.Code) < 900 {
			sn = s
		}
	}
	p := newPractice(c, runSpec{Mode: "zen", Snippet: sn})
	a.stack = []Screen{p}
	for i := 0; i < 120; i++ {
		p.rec.Char([]rune(sn.Code)[i], time.Now())
	}
	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		c.Anim.T = float64(i) * 0.033
		_ = a.View()
	}
}

func BenchmarkHomeView(b *testing.B) {
	lipgloss.SetColorProfile(termenv.TrueColor)
	cat, _ := content.Load()
	db, _ := store.Open(":memory:")
	defer db.Close()
	c := NewCtx(&service.Service{DB: db, Cat: cat})
	c.Set.ReducedMotion = false
	c.Reload()
	a := New(c)
	a.Update(tea.WindowSizeMsg{Width: 120, Height: 40})
	a.stack = []Screen{newHome(c)}
	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		c.Anim.T = float64(i) * 0.033
		_ = a.View()
	}
}

// Regression: animations froze on idle screens because the ticker stopped when
// the current screen had nothing "ambient". It must keep ticking everywhere.
func TestIdleAnimationNeverFreezes(t *testing.T) {
	for _, sz := range [][2]int{{80, 24}, {60, 22}, {120, 40}} {
		a := newApp(t, true)
		a.ctx.Set.ReducedMotion = false
		a.ctx.Reload()
		a.Update(tea.WindowSizeMsg{Width: sz[0], Height: sz[1]})
		for _, s := range []Screen{newHome(a.ctx), newFree(a.ctx), newSettings(a.ctx), newProgress(a.ctx), newAchievements(a.ctx)} {
			a.stack = []Screen{s}
			a.ticking = false
			now := time.Now()
			for i := 0; i < 400; i++ { // ~13 s of frames with no input at all
				if a.frame() == nil && !a.ticking {
					t.Fatalf("%T at %dx%d: ticker stopped after %d idle frames", s, sz[0], sz[1], i)
				}
				now = now.Add(idleInterval)
				_, cmd := a.Update(frameMsg(now))
				if cmd == nil {
					t.Fatalf("%T at %dx%d: frame %d returned no follow-up tick", s, sz[0], sz[1], i)
				}
			}
		}
	}
}

func TestLostTickIsRecovered(t *testing.T) {
	a := newApp(t, true)
	a.ctx.Set.ReducedMotion = false
	a.ctx.Reload()
	a.ticking = true
	a.lastTick = a.ctx.Now().Add(-time.Second) // a tick that never arrived
	if a.frame() == nil {
		t.Fatal("the watchdog must restart a wedged ticker")
	}
}

// The default "auto" palette must use only the terminal's own colors: no
// truecolor escapes anywhere (they would ignore a light/dark terminal theme).
func TestAutoPaletteEmitsNoHexColors(t *testing.T) {
	lipgloss.SetColorProfile(termenv.TrueColor)
	defer lipgloss.SetColorProfile(termenv.Ascii)
	for _, dark := range []bool{true, false} {
		c := newCtx(t, true)
		c.Set.Palette, c.Set.ReducedMotion = "auto", false
		c.Theme = NewTheme("system", "auto", true, false)
		c.Theme.Dark = dark
		c.S = NewStyles(c.Theme, false)
		a := New(c)
		a.Update(tea.WindowSizeMsg{Width: 110, Height: 36})
		sn := c.Cat.SnippetsFor("go")[0]
		for _, s := range []Screen{newHome(c), newPractice(c, runSpec{Mode: "zen", Snippet: sn}), newSettings(c), newProgress(c),
			newAchievements(c), newKeyboardHeat(c), newLessons(c, c.Cat.PathsFor("go")[0])} {
			a.stack = []Screen{s}
			out := a.View()
			if strings.Contains(out, "38;2;") || strings.Contains(out, "48;2;") {
				t.Fatalf("%T (dark=%v) used a baked-in truecolor, which ignores the terminal theme", s, dark)
			}
		}
	}
}

// For hex palettes the only truecolor allowed is the palette's own accent pair
// (and blends between them): text, muted text and states are the terminal's.
func TestHexPaletteOnlyColorsTheAccents(t *testing.T) {
	lipgloss.SetColorProfile(termenv.TrueColor)
	defer lipgloss.SetColorProfile(termenv.Ascii)
	for _, pal := range []string{"nord", "forest", "terminal", "ember"} {
		c := newCtx(t, true)
		c.Set.Palette, c.Set.ReducedMotion = pal, false
		c.Reload()
		allowed := map[string]bool{}
		for k := 0; k <= 64; k++ {
			h := lerpHex(c.Theme.hex(RolePrimary), c.Theme.hex(RoleSecondary), float64(k)/64)
			p := parseHex(h)
			allowed[fmt.Sprintf("%d;%d;%d", int(p.r*255+.5), int(p.g*255+.5), int(p.b*255+.5))] = true
		}
		a := New(c)
		a.Update(tea.WindowSizeMsg{Width: 110, Height: 36})
		sn := c.Cat.SnippetsFor("go")[0]
		re := regexp.MustCompile(`[34]8;2;(\d+;\d+;\d+)`)
		for _, s := range []Screen{newHome(c), newPractice(c, runSpec{Mode: "zen", Snippet: sn}), newSettings(c), newProgress(c), newAchievements(c)} {
			a.stack = []Screen{s}
			for _, m := range re.FindAllStringSubmatch(a.View(), -1) {
				if !allowed[m[1]] {
					t.Fatalf("palette %s, %T: color %s is not on the accent path — text/states must stay terminal-owned", pal, s, m[1])
				}
			}
		}
	}
}

func TestUnknownBackgroundStillReadable(t *testing.T) {
	for _, h := range []string{"#FFFFFF", "#000000", "#F7FF3C", "#0B0612"} {
		got := clampMidLuminance(h)
		if contrast(got, "#000000") < 2.9 || contrast(got, "#FFFFFF") < 2.9 {
			t.Fatalf("%s → %s has contrast %.1f on black / %.1f on white, want ≥ ~3 on both", h, got, contrast(got, "#000000"), contrast(got, "#FFFFFF"))
		}
	}
}

// Non-UTF-8 terminals get only ASCII glyphs: the sanitizer runs after layout,
// so the frame keeps its measured widths.
func TestASCIIModeUsesOnlyASCIIGlyphs(t *testing.T) {
	a := newApp(t, true)
	a.ctx.G = NewGlyphs(false)
	for _, s := range []Screen{newHome(a.ctx), newSettings(a.ctx), newProgress(a.ctx), newAchievements(a.ctx)} {
		a.stack = []Screen{s}
		out := a.View()
		for _, r := range out {
			if r == '\n' || r == '\r' || r == '\t' {
				continue
			}
			if r > 127 {
				t.Fatalf("%T left the non-ASCII rune %q in ASCII mode", s, r)
			}
		}
	}
}

func TestLocaleCyclesSystemEnglishSpanish(t *testing.T) {
	a := newApp(t, true)
	s := newSettings(a.ctx)
	if a.ctx.Set.Locale != "en" {
		t.Fatalf("test starts in English, got %q", a.ctx.Set.Locale)
	}
	enter := tea.KeyMsg{Type: tea.KeyEnter}
	for i, want := range []string{"es", "", "en"} {
		_, _ = s.Update(enter)
		if a.ctx.Set.Locale != want {
			t.Fatalf("cycle %d: locale = %q, want %q", i, a.ctx.Set.Locale, want)
		}
	}
}

func TestFreeLanguagePickerOnlyChangesThatScreen(t *testing.T) {
	c := newCtx(t, true)
	c.Set.ActiveLanguage = "go"
	picked := ""
	p := newLanguagePicker(c, "go", func(l string) { picked = l })
	for i, l := range c.Cat.Languages() {
		if l == "python" {
			p.m.cursor = i
		}
	}
	_, cmd := p.Update(tea.KeyMsg{Type: tea.KeyEnter})
	if picked != "python" {
		t.Fatalf("picked = %q, want python", picked)
	}
	if cmd == nil {
		t.Fatal("picking a language must pop the picker")
	}
	if c.Set.ActiveLanguage != "go" {
		t.Fatalf("free-practice picker changed the active course language to %q", c.Set.ActiveLanguage)
	}
}

func TestPaletteLabelsMatchTheApp(t *testing.T) {
	for _, want := range []struct{ id, label string }{
		{"blackWhite", "Black & White"}, {"tokyoNight", "Tokyo Night"}, {"vscode", "VS Code"}, {"auto", "auto"},
	} {
		if got := paletteLabel(want.id); got != want.label {
			t.Errorf("paletteLabel(%q) = %q, want %q", want.id, got, want.label)
		}
	}
}

func TestAccessibleModeDropsColor(t *testing.T) {
	a := newApp(t, true)
	a.ctx.Set.Accessible = true
	a.ctx.Reload()
	color := regexp.MustCompile(`\x1b\[(3[0-7]|9[0-7]|38;|48;)`)
	for _, s := range []Screen{newHome(a.ctx), newSettings(a.ctx), newProgress(a.ctx), newPractice(a.ctx, runSpec{Mode: "zen", Snippet: a.ctx.Cat.SnippetsFor("go")[0]})} {
		a.stack = []Screen{s}
		if m := color.FindString(a.View()); m != "" {
			t.Fatalf("%T still emits color %q in accessible mode", s, m)
		}
	}
}

func click(a *App, x, y int) {
	_, cmd := a.Update(tea.MouseMsg{X: x, Y: y, Action: tea.MouseActionPress, Button: tea.MouseButtonLeft})
	run(a, cmd)
}

func wheel(a *App, down bool) {
	button := tea.MouseButtonWheelUp
	if down {
		button = tea.MouseButtonWheelDown
	}
	_, cmd := a.Update(tea.MouseMsg{Action: tea.MouseActionPress, Button: button})
	run(a, cmd)
}

func TestMouseClickSelectsMenuRows(t *testing.T) {
	a := newApp(t, true)
	a.stack = []Screen{newHome(a.ctx)}
	_ = a.View()
	h := a.top().(*homeScreen)
	row := 0
	for i, it := range h.m.items {
		if it.Value == "daily" {
			row = i
		}
	}
	click(a, a.pad()+2, 2+h.m.top+row)
	if _, ok := a.top().(*dailyScreen); !ok {
		t.Fatalf("clicking Daily must open it, got %T", a.top())
	}
}

func TestMouseClickSettingsOpensPalettePicker(t *testing.T) {
	a := newApp(t, true)
	a.stack = []Screen{newSettings(a.ctx)}
	_ = a.View()
	s := a.top().(*settingsScreen)
	row := 0
	for i, it := range s.m.items {
		if it.Value == "palette" {
			row = i
		}
	}
	click(a, a.pad()+2, 2+s.m.top+row)
	if _, ok := a.top().(*palettePicker); !ok {
		t.Fatalf("clicking Palette must open its picker, got %T", a.top())
	}
}

func TestMouseWheelScrollsMenu(t *testing.T) {
	a := newApp(t, true)
	a.stack = []Screen{newHome(a.ctx)}
	h := a.top().(*homeScreen)
	start := h.m.cursor
	wheel(a, true)
	if h.m.cursor != start+1 {
		t.Fatalf("wheel down moved cursor %d -> %d", start, h.m.cursor)
	}
	wheel(a, false)
	if h.m.cursor != start {
		t.Fatalf("wheel up did not return to %d: %d", start, h.m.cursor)
	}
}

func TestMouseClickProgressTab(t *testing.T) {
	a := newApp(t, true)
	p := newProgress(a.ctx)
	a.stack = []Screen{p}
	_ = a.View()
	x := lipgloss.Width(p.tabNames()[0]) + 3
	click(a, a.pad()+x, 2)
	if p.tab != tabWeak {
		t.Fatalf("clicking the second tab selected %v, want weak", p.tab)
	}
}

func TestMouseClickPaletteRunsAction(t *testing.T) {
	a := newApp(t, true)
	press(a, ":")
	if a.pal == nil {
		t.Fatal("palette did not open")
	}
	_ = a.View()
	click(a, a.pad()+2, 2)
	if a.pal != nil {
		t.Fatal("palette must close after clicking an action")
	}
	if _, ok := a.top().(*snippetPicker); !ok {
		t.Fatalf("clicking Zen must open the snippet picker, got %T", a.top())
	}
}

func TestF1OpensTheGuide(t *testing.T) {
	a := newApp(t, true)
	send(a, tea.KeyMsg{Type: tea.KeyF1})
	if _, ok := a.top().(*guideScreen); !ok {
		t.Fatalf("F1 must open the guide, got %T", a.top())
	}
	if out := a.View(); !strings.Contains(out, "Guide") && !strings.Contains(out, "Guía") {
		t.Fatal("the guide rendered no title")
	}
}
