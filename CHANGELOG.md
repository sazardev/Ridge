# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y este proyecto usa [Semantic Versioning](https://semver.org/lang/es/). Las
entradas de una versión se generan automáticamente a partir de los
[Conventional Commits](https://www.conventionalcommits.org/es/v1.0.0/) desde
el último tag — ver `STACK.md §10.4` y `tool/version_bump.dart`. No edites a
mano una sección ya publicada; una corrección es siempre una entrada nueva.

## [Unreleased]

## [1.20.0] - 2026-10-03

### Added
- **brand:** unify the app icon with the R keycap mark (db34d32)
- **settings:** add performance mode for machines without a GPU (a775a2f)
- **ui:** springy Material 3 Expressive motion across the app (813d202)

## [1.19.0] - 2026-09-29

### Added
- **content:** add SwiftUI, TypeScript React and Kotlin Android course routes (5093e52)
- **content:** add go-wails-desktop-v1 desktop app course (70cd93f)

## [1.18.0] - 2026-09-25

### Added
- **content:** add Zig 0.16 learning paths (ff047e0)

## [1.17.0] - 2026-09-22

### Added
- **distribution:** open-source Ridge under AGPL-3.0 and prepare Linux desktop packaging (fb40ba2)

## [1.16.0] - 2026-09-14

### Added
- **content:** add Go CLI programs learning path (d92db60)

## [1.15.0] - 2026-09-13

### Added
- **profile:** full keyboard customization with 3D editor and firmware RGB (9003706)
- **scope:** ready (ab524f3)

## [1.14.0] - 2026-09-13

### Added
- **scope:** ready (1f3549d)

## [1.13.0] - 2026-09-12

### Added
- **scope:** ready (9c4fc26)

## [1.12.0] - 2026-09-12

### Added
- **content:** finalize Docker foundations, compose, and advanced routes (f4fae56)
- **scope:** ready (d8350a2)
- **scope:** ready (dac8ab9)
- **content:** add Haskell and TypeScript language wiring (fd1c61e)
- **scope:** ready (f3da766)
- **docs:** new module (32332db)

### Fixed
- **ci:** use a job env var for the keystore condition (0d1a8e2)
- **ci:** install ALSA headers in the release job (30996a7)
- **content:** bundle drift web assets and harden content-pack loading (edefeec)

## [1.11.0] - 2026-09-11

### Added
- add Algorithms/foundations courses for Go/Rust/Python/JS, plus deep links, build hardening, and fixes (85412d9)

### Changed
- **profile:** move rename into the edit-profile form, expand favorite-language list (5fd378a)

## [1.10.0] - 2026-09-11

### Added
- **docs:** new module (9437177)
- **splash:** add branded startup splash screen (2c5a14a)
- **branding:** redesign the app mark as a flat keycap with a Geist Mono "R" (0ece1dd)
- **progression:** add raw JSON view/export for a profile's progress stats (a95d888)
- **practice:** auto-skip blank lines on Enter, matching Tab's comfort rule (73bdd52)
- **daily-challenge:** add offline Daily Challenge practice mode (Phase 0) (f163ab0)

### Fixed
- **practice:** make a failed local session write recoverable via retry (40026e9)
- **settings:** eliminate default-theme flash on cold start (0c907a4)
- **a11y:** keep keyboard scroll shortcuts working on every scrollable screen (21bfe6d)
- **content:** stop guided lessons from requiring typed comments (3352946)

## [1.9.0] - 2026-09-10

### Added
- **settings:** render changelog with version headers and inline bold (d6d45c0)

## [1.8.0] - 2026-09-10

### Added
- rebrand product to Ridge and switch Lucide icons to weight 300 (fe284a6)

## [1.7.0] - 2026-09-10

### Added
- **content:** rebuild go-intermediate-syntax-v1 with a Go 1.27 block (e42516a)

## [1.6.0] - 2026-09-10

### Added
- **content:** add the go-tui-notes-v1 Bubble Tea course (7481669)

## [1.5.0] - 2026-09-10

### Added
- migrate icon set from Material Icons to Lucide (bf16b0f)
- add Rust foundations course, Go intermediate syntax path, and keyboard shape preview (33c9d97)

## [1.4.0] - 2026-09-10

### Added
- **content:** add the bash-toolkit-v1 course (95408b1)

## [1.3.0] - 2026-09-10

### Added
- add Bash and SQL learning routes and Survival mode (42cfc2f)

### Fixed
- **settings:** derive latest changelog heading in test (46dd367)

## [1.2.0] - 2026-09-10

### Added
- **lock:** add biometric unlock option (1aac79e)
- **profile:** auto-detect device platform, OS, and model (afcd8f5)
- initial commit (4ce19b6)

### Fixed
- **settings:** update stale changelog screen test assertion (bc1026f)

## [1.1.0] - 2026-09-10

### Added
- **docs:** new module (77b1813)
- **docs:** new module (5181c1a)
- implement SPEC.md offline core (content, practice, progression, learning paths, achievements, profile) (6bc8034)

## [1.0.0] - 2026-09-08

### Added

- Scaffold inicial de arquitectura hexagonal (Android + Linux): temas y
  color expresivo, bloqueo de la app por PIN, ajustes, práctica de
  mecanografía y seguimiento de progreso.
