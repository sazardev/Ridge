package ui

import (
	"flag"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	tea "github.com/charmbracelet/bubbletea"
)

var fixedNow = time.Date(2026, 11, 3, 10, 0, 0, 0, time.UTC)

var update = flag.Bool("update", false, "rewrite golden files")

// golden renders at a fixed size with colors forced off (so snapshots never
// depend on the terminal) and compares against testdata/<name>.golden.
func golden(t *testing.T, name string, w, h int, build func(*Ctx) Screen) {
	t.Helper()
	a := newApp(t, true)
	a.ctx.Now = func() time.Time { return fixedNow }
	a.Update(tea.WindowSizeMsg{Width: w, Height: h})
	a.stack = []Screen{build(a.ctx)}
	got := strings.TrimRight(a.View(), "\n")
	// Trailing spaces are layout noise.
	var lines []string
	for _, l := range strings.Split(got, "\n") {
		lines = append(lines, strings.TrimRight(l, " "))
	}
	got = strings.Join(lines, "\n") + "\n"
	path := filepath.Join("testdata", name+".golden")
	if *update {
		if err := os.WriteFile(path, []byte(got), 0o644); err != nil {
			t.Fatal(err)
		}
		return
	}
	want, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("missing golden %s (run: go test ./internal/ui -update)", path)
	}
	if string(want) != got {
		t.Errorf("%s differs from golden.\n--- want\n%s\n--- got\n%s", name, want, got)
	}
}

func TestGoldenScreens(t *testing.T) {
	sn := func(c *Ctx) runSpec { return runSpec{Mode: "zen", Snippet: c.Cat.SnippetsFor("go")[0]} }
	golden(t, "home_80x24", 80, 24, func(c *Ctx) Screen { return newHome(c) })
	golden(t, "home_40x20", 40, 20, func(c *Ctx) Screen { return newHome(c) })
	golden(t, "practice_80x24", 80, 24, func(c *Ctx) Screen { return newPractice(c, sn(c)) })
	golden(t, "settings_80x24", 80, 24, func(c *Ctx) Screen { return newSettings(c) })
	golden(t, "keyboard_80x24", 80, 24, func(c *Ctx) Screen { return newKeyboardHeat(c) })
	golden(t, "lock_80x24", 80, 24, func(c *Ctx) Screen { return newLock(c, lockVerify) })
}
