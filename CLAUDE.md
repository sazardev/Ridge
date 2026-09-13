# Ridge — Agent Guide

> Mirror file: `AGENTS.md` and `CLAUDE.md` are kept byte-identical. If you
> edit one, copy it over the other (`cp AGENTS.md CLAUDE.md`).

This file provides guidance to coding agents (OpenCode, Claude Code, etc.)
when working in this repository.

## What this is

Ridge is a typing-practice game for programmers (Flutter, hexagonal
architecture). Business logic lives in **`SPEC.md`** (game modes, metrics
engine, accounts, competition, business model — zero technical detail);
technical architecture lives in **`STACK.md`** (Flutter/Riverpod stack,
Supabase plan, offline sync, hexagonal rules, per-OS package compatibility
matrix, versioning/deployment). Any non-trivial code decision should trace
to a rule written in one of these two docs. Both are in Spanish; code,
identifiers, and comments are in English.

Brand/marketing (positioning, tagline, voice, mark/logo rules) lives in
**`MARKETING.md`** (repo root, Spanish) — any user-facing copy or visual
brand asset should trace to it the same way a code decision traces to
`SPEC.md`/`STACK.md`.

Progress/status lives in **`Memory.md`** (repo root, Spanish): current
state, dated session log, durable decisions, and next steps. Read it at the
start of a work session and update it when you finish one — it exists so
context survives across sessions. `CHANGELOG.md` is auto-generated from
Conventional Commits and is never edited by hand.

`README.md` is partially stale — its "Features shipped" section still
describes a removed Tasks scaffold. Trust `lib/features/` and `Memory.md`
over it.

Currently implemented (`lib/features/`): `content`, `practice`,
`progression`, `learning_paths`, `achievements`, `profile`, `settings`,
`lock`, `onboarding`, `data_management`, `daily_challenge`. Everything
online — auth, duels, squads, leaderboards, Supabase sync (`STACK.md
§5`–`§6`) — is specified but **not yet implemented**; there is no Supabase
dependency in `pubspec.yaml` yet and the app is offline-only today (local
`drift`/SQLite + `flutter_secure_storage` + `shared_preferences`).

## Commands

```sh
flutter pub get
bash tool/install_hooks.sh        # once per clone — wires tool/git-hooks/ via core.hooksPath

flutter gen-l10n                  # regen lib/core/i18n/gen/ after editing lib/l10n/*.arb
dart run build_runner build --delete-conflicting-outputs   # freezed / json_serializable / riverpod_generator / drift
dart run build_runner watch --delete-conflicting-outputs   # same, watching

flutter run -d linux
flutter run -d android

flutter test                      # whole suite
flutter test test/features/practice/finish_practice_session_usecase_test.dart   # single file

bash tool/check.sh                 # the full gate: format check, analyze, architecture check, tests — same as pre-push/CI
bash tool/format.sh                # auto-format the whole repo (check.sh only verifies formatting)
dart run tool/check_architecture.dart   # just the layering + 500-line-file rules
```

On Linux, `flutter test` and any `dart run tool/*` resolve the package and
therefore compile flutter_soloud's native build hook, which links ALSA —
install `libasound2-dev` (Debian/Ubuntu) / `alsa-lib` (Arch) first or those
commands fail. CI installs it in both jobs for this reason.

Regenerate code (`build_runner`) after touching any `@freezed`,
`@riverpod`/`@Riverpod`, `@JsonSerializable`/DTO, drift `Table`/DAO, or
`.arb` file — CI fails the build if generated output (`*.g.dart`,
`*.freezed.dart`) is stale.

All four target platforms (Android, Linux, Windows, Web) are scaffolded.
Release-build hardening — Android R8 minify/shrink + release signing
(`android/key.properties`, gitignored, see `key.properties.example`),
Dart `--obfuscate --split-debug-info` on Android/Windows/Linux, Web
COOP/COEP headers (`web/_headers`) for `drift`/OPFS, and per-platform
packaging (AAB, MSIX, Flatpak) — is wired in
`.github/workflows/release-builds.yml`, but that workflow only runs on a
`v*.*.*` tag push (never on a PR or a plain push to `main`); it builds and
uploads artifacts, it does not publish to any store yet. Known gap: the
release tag is pushed by CI with `GITHUB_TOKEN`, and GitHub does not
trigger workflows from that token, so release-builds currently does not
run automatically after a release — see `Memory.md`.

## Architecture

Each feature under `lib/features/<name>/` is a self-contained hexagon:

```
domain/           Pure Dart. Entities, value objects, repository *ports*
                  (abstract interfaces). No Flutter, no JSON, no storage.
application/      Use cases — one class per user intent, orchestrating the
                  domain through a port.
infrastructure/   Adapters: DTOs + mappers + drift Table/DAO implementing
                  the domain ports.
presentation/     Riverpod providers, screens, widgets. The only layer
                  allowed to import Flutter and know about use cases.
```

Dependency direction is inward only: `presentation → application → domain`,
with `infrastructure` implementing `domain` interfaces from the outside.
This is not just convention — `tool/check_architecture.dart` **hard-fails**
(exits 1, blocks commit/push/CI) if any file under a `domain/` or
`application/` segment imports `package:flutter/`, an `infrastructure/`
path, or a `presentation/` path. It also hard-fails any non-generated file
under `lib/` exceeding 500 lines. Generated files (`*.g.dart`,
`*.freezed.dart`, `lib/core/i18n/gen/**`) are exempt from every hand-authored
rule (analyzer, architecture check, line limit).

Cross-cutting code lives under `lib/core/`: design system (`theme/`),
`Result`/`AppFailure` error vocabulary (`error/`, `utils/`), router
(`router/`), secure storage (`security/`), shared preferences
(`persistence/preferences_provider.dart`), the drift database
(`persistence/drift/`), the custom desktop titlebar/window-frame chrome on
Linux/Windows via `window_manager` (`window/`), and the on-device
directory for user-supplied "content pack" JSON (`content_packs/` — see
below). Keystroke SFX live in `audio/` on `flutter_soloud` (PCM WAV only:
`mechanical` is hand-recorded, the rest regenerate with
`dart run tool/generate_sound_packs.dart`; pubspec's
`flutter_soloud.no_xiph_libs: true` hook deliberately skips the Xiph
codecs).

### Error handling

Every port boundary returns `Result<S, F>` (`lib/core/utils/result.dart`, an
`Ok`/`Err` sealed pair with `fold`/`map`) wrapping `AppFailure`
(`lib/core/error/app_failure.dart`: `ValidationFailure`, `NotFoundFailure`,
`StorageFailure`, `UnauthorizedFailure`, `UnexpectedFailure`) — never a
thrown exception across a port. Follow this in new use cases/repositories.

### Persistence

One shared drift (SQLite) database, `lib/core/persistence/drift/app_database.dart`.
Each feature owns its own `Table`/DAO under its own `infrastructure/`
(`infrastructure/tables/*.dart` + a DAO), but they're all registered on the
single `AppDatabase` — schema and migrations are centralized in that one
file. Any schema change bumps `schemaVersion` and adds an `if (from < N)`
block to the `onUpgrade` migration (see the existing v1→v16 history there
for the pattern: additive `addColumn`/`createTable`, comments explaining
what changed and why existing rows are unaffected). Custom indices that
drift's `Table` class can't express inline are created via a helper
(`_createPracticeIndices`-style) called from both `onCreate` and the
migration step that introduces the table.

On Web the DB opener loads `web/sqlite3.wasm` + `web/drift_worker.js`,
checked-in copies of the drift release matching `pubspec.lock` (currently
2.35.0) — bumping `drift` requires re-copying both from that same drift
release or Web silently loses its database.

### Content sourcing

Snippet/Learning Path catalogs come from two merged sources, combined by a
`composite_snippet_catalog_source.dart`-style adapter in each content
feature's `infrastructure/`: the bundled read-only assets
(`assets/content/{snippets,learning_paths}/*.json`, edited per the
`content-curriculum` skill) and an optional on-device "content pack"
directory (`lib/core/content_packs/content_packs_directory.dart` resolves
it under app-support storage; `external_snippet_pack_source.dart` reads
it). The app never writes to the pack directory itself — it's a
drop-in extension point for externally supplied JSON in the same DTO
shape, not a user-facing feature yet.

The profile feature's `assets/content/keyboard_layouts/` (a `manifest.json`
model→file map plus one curated JSON per model, real physical key
geometry extracted from public open-source keyboard-firmware repos, with
attribution/license in that directory's `THIRD_PARTY_SOURCES.md`) is
another bundled-asset content bank, following Learning Paths' simpler
variant of the pattern: no drift table, no external-pack seam, read
straight from the bundle (`keyboard_visual_layout_local_data_source.dart`)
since it's static, never user-mutated reference content.

### Riverpod

State management is Riverpod 3 with `@riverpod`/`@Riverpod(keepAlive: true)`
codegen (`riverpod_generator`) — providers live in
`presentation/providers/*.dart` with a generated `.g.dart` part file.
Navigation is `go_router`, wired reactively to auth/lock/settings state via
a `ChangeNotifier` refresh listener in `lib/core/router/app_router.dart`.

## Codebase-wide constructor convention

Constructors throughout this codebase are declared as `new(...)` rather
than repeating the class name (e.g. `const new(this.value);` inside class
`Ok<S, F>`, `const new(super.message);` inside `ValidationFailure`,
`new(Ref ref) { ... }` inside `_RouterRefreshNotifier`). This is
deliberate and used in ~all hand-written files, not a typo — match it when
writing new constructors instead of writing `const ClassName(...)`.

## Quality gates

- `tool/git-hooks/pre-commit` (staged files only): auto-formats staged
  Dart, runs the architecture check, and scans the staged diff for
  likely secrets.
- `tool/git-hooks/commit-msg`: enforces Conventional Commits
  (`<type>(<scope>)?: description`, type one of `feat fix perf refactor
  docs style test chore build ci revert`) — `tool/version_bump.dart` /
  `tool/release.sh` derive the next semver bump and `CHANGELOG.md`
  entries from this history on every push to `main`, so a wrong prefix
  produces the wrong release.
- `tool/git-hooks/pre-push` and CI both run `tool/check.sh`: format
  check, `flutter analyze --fatal-infos --fatal-warnings`,
  `tool/check_architecture.dart`, `flutter test`. CI
  (`.github/workflows/ci.yml`, Flutter 3.47.2 stable) additionally
  re-runs `build_runner build` and fails if generated output differs
  from what's committed.
- Lints: `very_good_analysis` (strict superset of `flutter_lints`) plus
  `strict-casts`/`strict-inference`/`strict-raw-types`, configured in
  `analysis_options.yaml`. Any disabled rule there carries an inline
  `# Disabled:` comment explaining why.
- Full rationale for the gate split, what each gate enforces, and the
  Conventional Commits → release contract lives in `CODE_STANDARDS.md`.

## Content / curriculum editing

Snippet catalogs (`assets/content/snippets/*_v1.json`) and Learning Path
lesson order (`assets/content/learning_paths/*.json`) are versioned JSON
assets, not code. Two catalog tiers (SPEC.md §3.2): Go backs free practice
with a dense (category, difficulty) grid; every other language is
course-only — its catalog contains exactly the snippets its bundled
Learning Path(s) reference, no orphans (Bash, SQL, Rust, Python — including
the three Django courses — JavaScript, TypeScript, Haskell, C, C++, Java,
Crystal, Swift, CSS, C#, Dart, Kotlin, PHP, Git, Linux, GitHub Actions, and
Docker). Foundations routes target beginners and mostly reuse Go's generic
categories; CSS and PHP are full exceptions with categories of their own.
Per-route details (categories, snippet counts, special cases) live in
`Memory.md` and the skill below — trust those over any summary.

Use the `content-curriculum` skill (`.claude/skills/`) before editing
either JSON: it encodes the DTO/domain/drift mapping, the two failed
automated lesson-ordering approaches (strict difficulty blocks and pure
code-length sort — both produced real beginner-incoherence bugs), and the
rule that every new snippet must be executed for real in its toolchain (Go,
PostgreSQL 16, Docker, disposable Arch containers, etc.) before merge.
Adding a new bilingual field means touching schema + domain + drift +
presentation in lockstep. `dart run tool/validate_content_pack.dart
--type=<snippets|learning-path> <file.json>` validates external content-pack
JSON against the real DTOs.

## Design system

- Flat, no shadows/gradients — every elevation-bearing widget is themed
  `elevation: 0`; depth comes from Material 3 tonal surface-container
  roles (`lib/core/theme/app_theme.dart`). One sanctioned exception: the
  profile keyboard visual (`KeyboardLayoutPainter` + `keyboard_scene_3d
  .dart`), a real-3D software renderer whose tapered keycaps and extruded
  case carry per-face directional lighting plus a subtle two-stop
  gradient on the top faces, with Geist Mono cap legends projected onto
  the key planes by the same camera — never blur shadows; see
  `STACK.md` §2.5.
- Expressive color from a single seed (`ColorScheme.fromSeed(...,
  DynamicSchemeVariant.expressive)`), toggleable in Settings
  (`lib/core/theme/app_colors.dart`).
- Shape: a Material 3 shape scale built on `RoundedSuperellipseBorder`
  (true squircle) — `lib/core/theme/app_shapes.dart`.
- Motion: hand-tuned durations/curves approximating Material 3
  Expressive springs — `lib/core/theme/app_motion.dart`. Deliberately
  restrained; the PIN-entry shake is the only "loud" animation.
- Type: Geist / Geist Mono (bundled, SIL OFL) — Mono is also the typing
  game's snippet-display font, where consistent character width is
  functional, not stylistic.
- i18n: `en`/`es` via `.arb` files in `lib/l10n/`, generated output in
  `lib/core/i18n/gen/` (excluded from analysis/architecture checks).

Full rationale for every design/architecture rule is in `STACK.md`
(§2.5 for design, §4 for architecture, §11–§12 for testing/deployment).
