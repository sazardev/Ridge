# Ridge

**El juego de mecanografía para programadores.** Aprende a escribir código más rápido y con menos errores practicando con código Go real — no frases al azar — mientras un motor de métricas captura cada carácter, cada dedo y cada combinación de teclas para decirte exactamente qué te cuesta trabajo.

> **"Type better, not just faster."** La lógica de negocio (`SPEC.md`) y la
> arquitectura técnica completa (`STACK.md`) gobiernan cualquier decisión de
> código no trivial — léelos antes de un PR. Ridge es **open source**
> (AGPL-3.0-or-later) desde 2026-09-21; ver `CONTRIBUTING.md`/`LICENSE`.

![Flutter](https://img.shields.io/badge/Flutter-3.13%2B-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13%2B-0175C2?logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Backend-Supabase-3FCF8E?logo=supabase&logoColor=white)
![Architecture](https://img.shields.io/badge/architecture-hexagonal-8A2BE2)
![State management](https://img.shields.io/badge/state-Riverpod%203-blueviolet)
![License](https://img.shields.io/badge/license-AGPL--3.0--or--later-blue)
![Status](https://img.shields.io/badge/status-offline--first%20MVP-orange)

**Plataformas objetivo:**

![Android](https://img.shields.io/badge/Android-3DDC84?logo=android&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)
![Windows](https://img.shields.io/badge/Windows-0078D6?logo=windows&logoColor=white)
![Web](https://img.shields.io/badge/Web-4285F4?logo=googlechrome&logoColor=white)

---

## Qué es esto

Ridge convierte el "calentamiento" antes de programar en un juego con datos reales de desempeño:

- **Contenido real**: se practica con código Go idiomático, no con lorem ipsum ni citas.
- **Metadata ultra detallada**: tiempo por carácter, dedo y mano usados, n-gramas típicos de código (`:=`, `err`, `{}`), consistencia, rachas y curva de fatiga.
- **Offline-first**: todo el modo individual funciona sin conexión; la nube solo entra para lo social.
- **Competencia online**: duelos 1 vs 1 con matchmaking, escuadrones/equipos, leaderboards, todo en tiempo real vía Supabase.
- **Multiplataforma real**: Android, Windows, Linux y Web con el mismo código y la misma cuenta.
- **Identidad mínima**: solo *username*, sin correo ni datos personales — invitado local o cuenta con contraseña.

## Documentación

Este repositorio se gobierna por documentos fuente de verdad — cualquier
decisión de código no trivial debería poder trazarse a una regla escrita en
alguno de ellos. Todos en español salvo donde se indica.

| Documento | Qué contiene |
|---|---|
| [`SPEC.md`](./SPEC.md) | La lógica de negocio completa: modos de juego, sistema de métricas, cuentas, competencia, leaderboards, modelo de negocio. Cero detalle técnico. |
| [`STACK.md`](./STACK.md) | Cómo se construye: Flutter + Riverpod + arquitectura hexagonal, Supabase (Auth/DB/Realtime/Edge Functions), sincronización offline, matriz de compatibilidad por sistema operativo, versionamiento y despliegue. |
| [`MARKETING.md`](./MARKETING.md) | Posicionamiento, eslogan, voz de marca e identidad visual. |
| [`Memory.md`](./Memory.md) | Bitácora viva: estado actual, historial de sesiones, decisiones duraderas y pendientes. |
| [`CODE_STANDARDS.md`](./CODE_STANDARDS.md) | Por qué existe cada *quality gate* (formatter, analyzer, chequeo de arquitectura, tests). |
| [`CLAUDE.md`](./CLAUDE.md) / [`AGENTS.md`](./AGENTS.md) | Guía operativa para agentes de IA (comandos, convenciones) — espejo byte a byte entre ambos. |
| [`CONTRIBUTING.md`](./CONTRIBUTING.md) (English) | Cómo contribuir: setup, reglas de arquitectura, *quality gates*, Conventional Commits. |
| [`SECURITY.md`](./SECURITY.md) (English) | Cómo reportar una vulnerabilidad de forma privada. |

## Stack actual del código

| Concern | Choice |
|---|---|
| State management | Riverpod 3 (`flutter_riverpod` + `riverpod_generator`, `@riverpod` codegen) |
| Navigation | `go_router`, adaptive shell (rail on desktop, bottom bar on phone) |
| Architecture | Hexagonal — domain / application / infrastructure / presentation per feature |
| Persistence | `drift`/SQLite (`lib/core/persistence/drift/`, per-feature tables/DAOs) + `shared_preferences` for simple prefs, behind repository ports |
| Security | `flutter_secure_storage` (Keystore on Android, libsecret on Linux) for a salted-hash PIN app-lock |
| i18n | Flutter `gen-l10n`, English + Spanish |
| Immutability | `freezed` for domain entities and DTOs |
| Motion | Hand-tuned Material 3 Expressive-style motion tokens + `flutter_animate` |
| Fonts | Geist / Geist Mono (SIL OFL, bundled in `assets/fonts`) |

El stack objetivo completo (Supabase, sincronización offline, multiplataforma) está en [`STACK.md`](./STACK.md) — incluida la matriz de compatibilidad de cada paquete por sistema operativo en [`STACK.md §3`](./STACK.md#3-compatibilidad-de-paquetes-y-requisitos-por-sistema-operativo).

## Architecture

Each feature under `lib/features/<name>/` is a self-contained hexagon:

```
domain/           Pure Dart. Entities, value objects, repository *ports*
                  (abstract interfaces). No Flutter, no JSON, no storage.
application/      Use cases — one class per user intent, orchestrating the
                  domain through a port. This is what you'd unit test.
infrastructure/   Adapters. DTOs + mappers + local data sources that
                  implement the domain ports (currently local storage;
                  swappable for a remote API without touching domain/
                  application/presentation).
presentation/     Riverpod providers, screens, widgets. The only layer
                  allowed to import Flutter *and* know about the use cases.
```

Dependency direction is inward only: `presentation → application → domain`,
with `infrastructure` implementing `domain` interfaces from the outside.
See `test/features/practice/finish_practice_session_usecase_test.dart` for
what this buys you — the use case is tested with a fake repository, zero
Flutter, zero platform channels.

Cross-cutting code (the design system, the error/`Result` vocabulary, the
router, secure storage, shared preferences) lives under `lib/core/`.

`tool/check_architecture.dart` enforces the hard rules (inward-only imports,
max file length) that `analysis_options.yaml` can't express — run it before
pushing:

```sh
dart run tool/check_architecture.dart
```

Full rationale for every architectural rule, including how new features
(typing, duels, squads, leaderboard, auth) must slot into this same shape,
is in [`STACK.md §4`](./STACK.md#4-arquitectura-de-software--hexagonal-ports--adapters).

## Design system

- **Flat, no shadows, no gradients.** Every elevation-bearing widget
  (`Card`, `AppBar`, `NavigationBar`, dialogs, sheets, buttons, pickers) is
  themed to `elevation: 0` with a transparent surface tint. Depth comes from
  Material 3's tonal *surface container* roles instead — see
  `lib/core/theme/app_theme.dart`.
- **Expressive color.** `ColorScheme.fromSeed(dynamicSchemeVariant:
  DynamicSchemeVariant.expressive)` generates the palette from a single seed
  (`lib/core/theme/app_colors.dart`); toggle it off in Settings for the more
  conservative `tonalSpot` variant.
- **Shape.** A Material 3 shape scale (`lib/core/theme/app_shapes.dart`)
  built on `RoundedSuperellipseBorder` — a true squircle, not a rounded
  rect — for a softer, more organic silhouette than a plain corner radius.
- **Motion.** `lib/core/theme/app_motion.dart` hand-tunes durations/curves to
  approximate Material 3 Expressive's spatial/effects springs (Flutter
  stable doesn't expose `MotionScheme` yet). Motion stays deliberately
  restrained — the only "loud" animation in the app is the PIN-entry shake
  on a wrong attempt.
- **Type.** Geist for UI text, Geist Mono for due-date stamps and PIN digits
  (`lib/core/theme/app_typography.dart`) — the same monospaced family the
  typing game will use for the code snippet display, where consistent
  character width is a functional requirement, not just style
  (see [`STACK.md §2.5`](./STACK.md#25-sistema-de-diseño-y-coherencia-visual-vigente--extendido)).

## Features shipped so far

Ridge is **offline-only today** — everything online (auth, duels, squads,
leaderboards, Supabase sync — `STACK.md §5`–`§6`) is fully specified in
`SPEC.md`/`STACK.md` but not yet implemented. Implemented under
`lib/features/`:

- **`practice`** — Zen, Sprint, Precision, and Survival typing modes (lives,
  combo, multiplier), plus the metrics engine (per-character/per-finger
  accuracy, n-grams, consistency).
- **`daily_challenge`** — Phase 0 (offline): the same snippet for everyone,
  computed deterministically from the UTC date, no server involved.
- **`content` / `learning_paths`** — bundled snippet catalogs (Go, Bash,
  SQL, Rust, Python, JavaScript, TypeScript, Haskell, C, C++, Java, Crystal,
  Swift, CSS, C#, Dart, Kotlin, PHP, Git, Linux, GitHub Actions, Docker) and
  guided Learning Paths, plus an on-device "content pack" extension point.
- **`progression` / `achievements`** — streaks, stats over time, unlockable
  achievements.
- **`profile`** — keyboard layout/brand/model, with a full 3D keycap +
  firmware-RGB customization editor.
- **`settings` / `onboarding` / `lock` / `data_management`** — theme,
  language (English/Spanish), app-lock (PIN backed by secure storage), a
  guided first-run flow, and local data export/import.

Next up, per [`STACK.md §4.5`](./STACK.md#45-mapeo-de-los-módulos-de-negocio-specmd-a-features-técnicos):
`auth`, `duels`, `squads`, `leaderboard`, and Phase 1 of the Daily Challenge
(global leaderboard, reinstall-proof streak). See `Memory.md`'s "Estado
actual" for the exact up-to-date status.

## Installing (desktop)

Not published yet — packaging is ready, distribution isn't live:

- **Linux**: Flatpak (`linux/packaging/dev.omarcodes.ridge.yml`, targeting
  Flathub) and an AUR package (`linux/packaging/aur/PKGBUILD`, `yay -S
  ridge` / `paru -S ridge` for Arch/Omarchy) — both build from the same
  release tarball CI publishes on each tag. See `STACK.md §12` for what's
  left before either goes live.
- **Windows**: MSIX (`pubspec.yaml`'s `msix_config`), targeting the
  Microsoft Store or a signed direct download.
- **Android**: not covered by this section — see `STACK.md §12` (Play
  Console).

## Running (development)

```sh
flutter pub get
flutter gen-l10n                 # regenerate lib/core/i18n/gen/ after editing lib/l10n/*.arb
dart run build_runner build --delete-conflicting-outputs   # freezed / json_serializable / riverpod_generator

flutter run -d linux
flutter run -d android
flutter run -d windows
flutter run -d chrome
```

Regenerate code after touching any `@freezed`, `@riverpod`, `@JsonSerializable`,
or `.arb` file:

```sh
dart run build_runner watch --delete-conflicting-outputs
```

All four target platforms are scaffolded; release-build packaging
(obfuscation, R8 minify/shrink, MSIX, Flatpak) runs per-platform in CI on a
version tag — see [`STACK.md §12`](./STACK.md#12-despliegue-cicd-por-plataforma).

## Quality gates

- `bash tool/install_hooks.sh` — run once per clone. Points git at the
  versioned hooks in `tool/git-hooks/`: `pre-commit` auto-formats staged
  Dart files and scans the staged diff for secrets; `pre-push` runs the
  full gate (`tool/check.sh`) — format check, `flutter analyze
  --fatal-infos --fatal-warnings`, `dart run tool/check_architecture.dart`
  (500-line file limit + hexagonal dependency direction), `flutter test`.
- The same `tool/check.sh` runs in CI (`.github/workflows/ci.yml`).
- Full rationale and the non-negotiable coherence checklist live in
  `STACK.md` (§8, §11, §12).

CI (`.github/workflows/ci.yml`) runs the same gate on every PR and push to
`main`; check its badge/history for current status rather than relying on a
point-in-time note here.

## Notes

- Geist and Geist Mono are bundled under `assets/fonts/` (SIL Open Font
  License — see `assets/fonts/LICENSE.txt`).
- Android's launcher icon (`android/app/src/main/res/mipmap-*`) is the
  Ridge mark (flat squircle, brand ember orange, `assets/icons/
  ridge_launcher_master.png` is the 1024×1024 source), reused as-is for
  the MSIX logo and, resized into the standard `hicolor` sizes
  (`linux/packaging/icons/`), for the Linux Flatpak/AUR icon.

## Contributing, security, and license

- See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for setup, architecture rules,
  and the PR checklist, and [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md) for
  community expectations.
- See [`SECURITY.md`](./SECURITY.md) to report a vulnerability privately —
  please don't open a public issue for one.
- Ridge is licensed under the **GNU Affero General Public License v3.0 or
  later** — see [`LICENSE`](./LICENSE). If you run a modified version of
  Ridge as a network service, the AGPL requires you to make your modified
  source available to its users.

## Status

Implementación activa sobre `SPEC.md`/`STACK.md`: la app es hoy
**offline-only** (ver "Features shipped so far" arriba y `Memory.md` para el
estado exacto). Repositorio open source (AGPL-3.0-or-later) desde
2026-09-21.
