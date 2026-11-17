# Ridge TUI

Terminal edition of Ridge (Go · Bubble Tea · Lip Gloss · Bubbles · harmonica),
designed per [`../DESIGN.md`](../DESIGN.md). Same content and rules as the
Flutter app (`../SPEC.md`), different UI.

```sh
cd tui
make run        # syncs ../assets/content into the embed dir, then runs
make build      # -> bin/ridge
make test       # go test ./...   (go test ./internal/ui -update rewrites goldens)
make matrix     # PTY smoke test: dark/light, truecolor/256/ANSI, NO_COLOR, dumb, 40x20–200x60, C locale
make install    # -> ~/.local/bin/ridge (PREFIX=/usr/local make install to change)
```

Data lives in `$RIDGE_DATA/ridge.db` (default: your config dir under `ridge/`).
`NO_COLOR=1` drops colors; a non-UTF-8 locale switches to ASCII glyphs.

Keyboard-first, mouse-friendly: `?` expands the inline help, `F1` opens the
guide (also in Home → Guide & shortcuts), `:` or `Ctrl+P` opens the command
palette. Clicking a menu row selects and runs it, and the wheel scrolls lists.
`RIDGE_NO_MOUSE=1` disables mouse reporting so the terminal keeps its native
text selection.

Layout follows the terminal's **orientation** (aspect ratio, not a fixed
width): landscape uses side-by-side panes, square stacks the level/facts panel
under the menu, and portrait stacks list + preview and gives the typing view
more vertical room. Tested from 40×20 up to 200×60, plus portrait/square panes
(60×80, 80×80, 60×50, 100×26).
Motion runs on a single 60 fps ticker (including the ambient shimmer) and
stops with reduced motion; the progress bar and the typed
code flash animate on the same ticker.

The default palette is `auto`: Ridge reads the terminal's real background
(OSC 11) and paints only with the terminal's own foreground and ANSI colors,
so Gruvbox, Catppuccin or Solarized keep their look. Picking one of the
app's palettes only swaps the accent pair; semantic colors stay inherited.
`RIDGE_PALETTE=auto ridge` overrides the saved palette for one run.
Accessible mode drops color and motion; non-UTF-8 locales get width-preserving
ASCII glyphs. `make matrix` exercises those cases in a PTY.

## Layout

| Path | Role |
| --- | --- |
| `internal/content` | Embedded snippet + learning-path catalog (same JSON as the app) |
| `internal/typing` | Keystroke recorder, metrics, XP/levels, survival — ports of the Dart domain |
| `internal/progress` | Weakness/activity ranking, mastery, achievements, lessons, daily, ghost |
| `internal/store` | SQLite persistence (sessions, samples, mastery, settings, PIN) |
| `internal/service` | Use cases (finish session, snapshot, warm-up, daily, ghost) |
| `internal/ui` | Screens; colors/styles only in `theme.go` / `styles.go` |

## Parity with the Flutter app

Done: Zen, Sprint, Precision, Survival, Daily (offline), Courses/lessons,
language catalog, Warm-ups, Ghost races, per-finger / per-character /
n-gram / key-transition profiles, keyboard heat map + live keyboard, Progress,
Achievements, Mastery certification, Profile (+edit, favorite languages,
keyboard setup), Onboarding, PIN lock, Settings (25 palettes + auto, theme,
reduced motion, large text, high contrast), Data management, en/es.

Deliberately different: accounts are Guest-only (Linux has no FlutterFire,
`STACK.md §5.1`); the daily reminder is an in-app nudge (no OS notifications);
sound packs map to the terminal bell; the 3D keyboard editor is not ported;
accessible mode is a plain, motionless rendering rather than a separate
line-based CLI.

Not implemented anywhere yet (also unimplemented in the app): duels, squads,
leaderboards, history sync.
