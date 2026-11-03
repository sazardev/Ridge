// Command ridge is the terminal edition of Ridge, the typing game for programmers.
package main

import (
	"fmt"
	"os"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/omar/ridge/tui/internal/content"
	"github.com/omar/ridge/tui/internal/service"
	"github.com/omar/ridge/tui/internal/store"
	"github.com/omar/ridge/tui/internal/ui"
)

func main() {
	cat, err := content.Load()
	if err != nil {
		fmt.Fprintln(os.Stderr, "✗ could not load content:", err)
		os.Exit(1)
	}
	db, err := store.Open(store.DefaultPath())
	if err != nil {
		fmt.Fprintln(os.Stderr, "✗ could not open the database:", err, "\n  → set RIDGE_DATA to another directory or move the file aside")
		os.Exit(1)
	}
	defer db.Close()
	ctx := ui.NewCtx(&service.Service{DB: db, Cat: cat})
	// Alt screen restores the terminal on exit, crash or Ctrl+C.
	opts := []tea.ProgramOption{tea.WithAltScreen()}
	if _, err := tea.NewProgram(ui.New(ctx), opts...).Run(); err != nil {
		fmt.Fprintln(os.Stderr, "✗", err)
		os.Exit(1)
	}
}
