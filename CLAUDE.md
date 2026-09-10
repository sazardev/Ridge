# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Just In Time is a typing-practice game for programmers (Flutter, hexagonal
architecture). Business logic lives in **`SPEC.md`** (game modes, metrics
engine, accounts, competition, business model — zero technical detail);
technical architecture lives in **`STACK.md`** (Flutter/Riverpod stack,
Supabase plan, offline sync, hexagonal rules, per-OS package compatibility
matrix, versioning/deployment). Any non-trivial code decision should trace
to a rule written in one of these two docs. Both are in Spanish; code,
identifiers, and comments are in English.

Currently implemented (`lib/features/`): `content`, `practice`,
`progression`, `learning_paths`, `achievements`, `profile`, `settings`,
`lock`, `onboarding`, `data_management`. Everything online — auth, duels,
squads, leaderboards, Supabase sync (`STACK.md §5`–`§6`) — is specified but
**not yet implemented**; there is no Supabase dependency in `pubspec.yaml`
yet and the app is offline-only today (local `drift`/SQLite +
`flutter_secure_storage` + `shared_preferences`).

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
dart run tool/check_architecture.dart   # just the layering + 500-line-file rules
```

Regenerate code (`build_runner`) after touching any `@freezed`,
`@riverpod`/`@Riverpod`, `@JsonSerializable`/DTO, drift `Table`/DAO, or
`.arb` file — CI fails the build if generated output (`*.g.dart`,
`*.freezed.dart`) is stale.

Windows and Web aren't scaffolded yet (`flutter create
--platforms=windows,web .` before first run on those targets).

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

Cross-cutting code (design system, `Result`/`AppFailure` error vocabulary,
router, secure storage, shared preferences, the drift database) lives under
`lib/core/`.

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
block to the `onUpgrade` migration (see the existing v1→v12 history there
for the pattern: additive `addColumn`/`createTable`, comments explaining
what changed and why existing rows are unaffected). Custom indices that
drift's `Table` class can't express inline are created via a helper
(`_createPracticeIndices`-style) called from both `onCreate` and the
migration step that introduces the table.

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
  `tool/check_architecture.dart`, `flutter test`. CI additionally
  re-runs `build_runner build` and fails if generated output differs
  from what's committed.
- Lints: `very_good_analysis` (strict superset of `flutter_lints`) plus
  `strict-casts`/`strict-inference`/`strict-raw-types`, configured in
  `analysis_options.yaml`. Any disabled rule there carries an inline
  `# Disabled:` comment explaining why.

## Content / curriculum editing

Editing snippets (`assets/content/snippets/{go,bash,sql}_v1.json`), a
Learning Path's lesson order (`assets/content/learning_paths/*.json`), or
adding a new bilingual (en/es) content field is covered by the
`content-curriculum` skill — use it rather than hand-editing these JSON
files, since lesson ordering has produced real beginner-incoherence bugs
before. Note the two catalog tiers (SPEC.md §3.2): Go backs free practice
and keeps a dense (category, difficulty) grid; Bash and SQL are
course-only and contain exactly the snippets `bash-foundations-v1` and
`sql-foundations-v1` use, respectively.

## Design system

- Flat, no shadows/gradients — every elevation-bearing widget is themed
  `elevation: 0`; depth comes from Material 3 tonal surface-container
  roles (`lib/core/theme/app_theme.dart`).
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
