# Contributing to Ridge

Thanks for considering a contribution. Ridge is a hexagonal-architecture
Flutter app, and it's opinionated on purpose — most of what looks like a
convention here is actually a rule enforced by tooling, not a style
preference. Reading this file before your first PR will save you a review
round-trip.

## Before you start

- **Read `CLAUDE.md`/`AGENTS.md` first** (kept byte-identical — pick either).
  It's the single entry point for how this repo works: which docs govern
  which decisions, the full command list, the architecture rules, the
  quality gates, and the constructor-naming convention
  (`new(...)` instead of repeating the class name) used throughout the
  codebase.
- **`SPEC.md`** (business logic — game modes, metrics engine, accounts,
  competition, business model) and **`STACK.md`** (technical architecture —
  stack, Supabase plan, hexagonal rules, versioning/deployment) are the two
  sources of truth. Both are written in Spanish; code, identifiers, and
  comments are in English. Any non-trivial code decision should trace back
  to a rule written in one of these two documents — if it doesn't, that's
  either a bug in the docs (open an issue) or a sign the change needs more
  discussion before a PR.
- **`Memory.md`** is the running session log — current state, decisions,
  and what's pending. Skim its "Estado actual" and "Pendientes" sections
  before starting anything non-trivial; it'll tell you if something you're
  about to build is already half-done or intentionally deferred.
- **`CODE_STANDARDS.md`** explains *why* each quality gate exists (formatter,
  analyzer, architecture check, tests) — read it if a gate rejects your PR
  and the reason isn't obvious from the error message.

## Setting up

```sh
flutter pub get
bash tool/install_hooks.sh        # once per clone — wires tool/git-hooks/ via core.hooksPath
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

On Linux, building or testing also compiles `flutter_soloud`'s native build
hook, which links ALSA — install `libasound2-dev` (Debian/Ubuntu) or
`alsa-lib` (Arch) first, or those commands fail.

## Architecture rules (enforced, not optional)

Every feature under `lib/features/<name>/` is a hexagon: `domain/` (pure
Dart, no Flutter/JSON/storage imports), `application/` (use cases),
`infrastructure/` (adapters implementing domain ports), `presentation/`
(Riverpod + widgets, the only layer allowed to import Flutter). Dependency
direction is inward only. This isn't a convention you can skip in a pinch —
`dart run tool/check_architecture.dart` hard-fails the build (and blocks
`pre-push`/CI) if a `domain/` or `application/` file imports
`package:flutter/`, an `infrastructure/` path, or a `presentation/` path,
and it also hard-fails any hand-authored file over 500 lines. See
`STACK.md §4`/`§8` for the full rationale.

## Before opening a PR

```sh
bash tool/check.sh   # format check, flutter analyze --fatal-infos --fatal-warnings,
                      # tool/check_architecture.dart, flutter test — the exact gate CI runs
```

This is the same script `pre-push` runs locally once you've run
`tool/install_hooks.sh`, so a clean push almost always means a clean CI run.
Regenerate code (`dart run build_runner build --delete-conflicting-outputs`)
after touching any `@freezed`, `@riverpod`/`@Riverpod`,
`@JsonSerializable`/DTO, drift `Table`/DAO, or `.arb` file — CI fails if the
generated output (`*.g.dart`, `*.freezed.dart`) doesn't match what you
committed.

## Commit messages

**Conventional Commits** (`<type>(<scope>)?: description`, type one of
`feat fix perf refactor docs style test chore build ci revert`) — enforced
by the `commit-msg` hook. This isn't just style: `tool/version_bump.dart`
derives the next semver bump and the auto-generated `CHANGELOG.md` entries
directly from this history, so a wrong prefix produces a wrong release.

## Content/curriculum changes

If you're touching a snippet catalog (`assets/content/snippets/*.json`) or a
Learning Path's lesson order (`assets/content/learning_paths/*.json`), read
the `content-curriculum` skill notes referenced from `CLAUDE.md` first —
there's hard-won guidance there (two earlier automated lesson-ordering
approaches both produced real beginner-incoherence bugs) and a hard rule
that every new snippet must actually run in its real toolchain before merge.

## Reporting bugs / requesting features

Use the issue templates — they ask for the information that's actually
needed to act on a report (repro steps, platform, expected vs. actual).

## Security issues

Please don't open a public issue for a security vulnerability — see
`SECURITY.md` for how to report one privately.

## License

By contributing, you agree that your contribution is licensed under the
project's [GNU AGPL-3.0](./LICENSE), same as the rest of the codebase.
