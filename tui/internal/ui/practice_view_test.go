package ui

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
	"github.com/muesli/termenv"
	"testing"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/omar/ridge/tui/internal/content"
)

func practiceWith(t *testing.T, code string, w, h int) (*App, *practiceScreen) {
	t.Helper()
	a := newApp(t, true)
	a.Update(tea.WindowSizeMsg{Width: w, Height: h})
	sn := content.Snippet{ID: "synthetic", Language: "go", Difficulty: content.Beginner, Category: "x", Code: code, TitleEn: "Synthetic"}
	p := newPractice(a.ctx, runSpec{Mode: "zen", Snippet: sn})
	a.stack = []Screen{p}
	return a, p
}

func TestNoReturnIconsOrLineNumbers(t *testing.T) {
	a, _ := practiceWith(t, "if err != nil {\n\treturn err\n}\nfmt.Println(1)", 100, 30)
	out := a.View()
	if strings.Contains(out, a.ctx.G.Enter) {
		t.Fatal("the return key must not be drawn — it just works")
	}
	for _, line := range strings.Split(out, "\n") {
		if strings.HasPrefix(strings.TrimSpace(line), "1 ") || strings.HasPrefix(strings.TrimSpace(line), "2 ") {
			t.Fatalf("no line-number gutter expected, got %q", line)
		}
	}
	if !strings.Contains(out, "if err != nil {") {
		t.Fatal("the code is the protagonist and must be shown")
	}
}

func TestLongLinesWrapWithoutLosingCharacters(t *testing.T) {
	long := "result, err := service.DoSomethingVeryLongWithManyArguments(ctx, firstArgument, secondArgument, thirdArgument, fourthArgument)"
	for _, w := range []int{40, 60, 80, 120} {
		a, p := practiceWith(t, long+"\nreturn result, err", w, 24)
		avail := wideWidth(a.ctx) - 4
		lines := p.layoutCode(avail, true)
		seen := map[int]int{}
		for _, l := range lines {
			width := l.indent
			for _, ce := range l.cells {
				seen[ce.idx]++
				width += ce.w
			}
			if width > avail {
				t.Fatalf("w=%d: a wrapped line is %d cells, max %d", w, width, avail)
			}
		}
		for i := range []rune(long + "\nreturn result, err") {
			if seen[i] != 1 {
				t.Fatalf("w=%d: character %d drawn %d times", w, i, seen[i])
			}
		}
		out := a.View()
		for _, line := range strings.Split(out, "\n") {
			if len([]rune(line)) > a.ctx.W+10 { // ansi-free in tests
				t.Fatalf("w=%d: line exceeds the terminal: %q", w, line)
			}
		}
	}
}

func TestScrollKeepsCaretVisibleOnLongSnippets(t *testing.T) {
	var b strings.Builder
	for i := 0; i < 80; i++ {
		b.WriteString("value := compute(alpha, beta, gamma)\n")
	}
	code := strings.TrimRight(b.String(), "\n")
	a, p := practiceWith(t, code, 100, 24)
	now := time.Now()
	for i, r := range []rune(code) {
		switch r {
		case '\n':
			p.rec.Enter(now)
		case ' ':
			p.rec.Char(' ', now)
		default:
			p.rec.Char(r, now)
		}
		if i%37 == 0 { // sample the view along the way
			a.ctx.Anim.Step(now.Add(time.Duration(i) * time.Millisecond))
			_ = a.View()
			w := p.win
			if w.caret < w.start || w.caret >= w.end {
				t.Fatalf("caret line %d outside the visible window [%d,%d) of %d", w.caret, w.start, w.end, w.total)
			}
			if w.end-w.start > 24 {
				t.Fatalf("window larger than the screen: %d", w.end-w.start)
			}
		}
	}
	_ = a.View()
	if p.win.end != p.win.total {
		t.Fatalf("at the end the last line is shown, window=%+v", p.win)
	}
}

func TestStatsHiddenUntilTypingStarts(t *testing.T) {
	a, p := practiceWith(t, "x := 1", 100, 30)
	if strings.Contains(a.View(), "wpm") {
		t.Fatal("no stats before the first key")
	}
	send(a, tea.KeyMsg{Type: tea.KeyRunes, Runes: []rune{'x'}})
	if !strings.Contains(a.View(), "wpm") || p.started == false {
		t.Fatal("quiet stats appear once typing starts")
	}
}

func TestResultsExplainsWhatYouTyped(t *testing.T) {
	a := newApp(t, true)
	sn := a.ctx.Cat.SnippetsFor("go")[0]
	a.stack = []Screen{newPractice(a.ctx, runSpec{Mode: "zen", Snippet: sn})}
	typeCode(a, sn.Code)
	r, ok := a.top().(*resultsScreen)
	if !ok {
		t.Fatalf("expected results, got %T", a.top())
	}
	if !strings.Contains(a.View(), "explain") {
		t.Fatal("results advertise the explain command")
	}
	press(a, "e")
	out := a.View()
	first := plainText(strings.Fields(sn.Explanation(a.ctx.Loc()))[0])
	if !r.explain || !strings.Contains(out, plainText(sn.Tldr(a.ctx.Loc()))) || !strings.Contains(out, first) {
		t.Fatalf("e shows the snippet explanation, got:\n%s", out)
	}
	press(a, "esc")
	if _, still := a.top().(*resultsScreen); !still || r.explain {
		t.Fatal("esc leaves the explanation and stays on the summary")
	}
}

func TestMarkdownRendersCleanly(t *testing.T) {
	a := newApp(t, true)
	c := a.ctx
	src := "`1 << iota` doubles with each constant, so `ModeRead` and **ModeWrite** land on distinct bits.\n\n- first point with `code`\n- second point\n\n```go\nx := 1\n```"
	out := c.renderMarkdown(src, "go", 40)
	if strings.Contains(out, "`") || strings.Contains(out, "**") {
		t.Fatalf("markdown markers must not leak:\n%s", out)
	}
	for _, ln := range strings.Split(out, "\n") {
		if w := lipgloss.Width(ln); w > 40 {
			t.Fatalf("line wider than the measure (%d): %q", w, ln)
		}
	}
	if !strings.Contains(out, "1 << iota") || !strings.Contains(out, "x := 1") || !strings.Contains(out, "· first point") {
		t.Fatalf("content lost:\n%s", out)
	}
	if got := plainText("a `b` **c**"); got != "a b c" {
		t.Fatalf("plainText = %q", got)
	}
}

// Typed and untyped text must differ: typed text is the full syntax color,
// untyped text keeps that hue dimmed (SGR 2), mirroring the app's opacity.
// Never ANSI 8: bright black is near-white on light terminals.
func TestTypedAndPendingDifferByColor(t *testing.T) {
	defer lipgloss.SetColorProfile(termenv.Ascii)
	for _, mode := range []string{"light", "dark"} { // theme mode must not change the rule
		a, p := practiceWith(t, `func main() { fmt.Println("hi", 42) }`, 100, 30)
		lipgloss.SetColorProfile(termenv.ANSI) // after the helper, which forces Ascii
		a.ctx.Set.ThemeMode = mode
		a.ctx.Reload()
		now := time.Now()
		for _, r := range "func main() { fmt.Println(\"hi\"" {
			p.rec.Char(r, now)
		}
		p.started = true
		for i := range p.typedAt {
			p.typedAt[i] = now.Add(-time.Second) // flash is over: settled colors
		}
		out := a.View()
		if !strings.Contains(out, "\x1b[35m") { // keyword → magenta (theme's)
			t.Fatalf("%s: typed keywords should be colored by syntax, got %q", mode, out)
		}
		if !strings.Contains(out, "\x1b[32m") { // string → green (theme's)
			t.Fatalf("%s: typed strings should be colored by syntax", mode)
		}
		if !strings.Contains(out, "\x1b[2") { // untyped → same hue, dimmed
			t.Fatalf("%s: untyped text should be dimmed syntax color", mode)
		}
		if strings.Contains(out, "38;2;") {
			t.Fatalf("%s: no baked truecolor in auto", mode)
		}
	}
}
