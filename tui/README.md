# Ridge TUI

Terminal edition of Ridge (Go · Bubble Tea · Lip Gloss · Bubbles · harmonica),
designed per [`../DESIGN.md`](../DESIGN.md). Same content and rules as the
Flutter app (`../SPEC.md`), different UI.

```sh
cd tui
make run        # syncs ../assets/content into the embed dir, then runs
make build      # -> bin/ridge
make test       # go test ./...   (go test ./internal/ui -update rewrites goldens)
```

Data lives in `$RIDGE_DATA/ridge.db` (default: your config dir under `ridge/`).
`NO_COLOR=1` drops colors; a non-UTF-8 locale switches to ASCII glyphs.

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
