# Just In Time

**El juego de mecanografía para programadores.** Aprende a escribir código más rápido y con menos errores practicando con código Go real — no frases al azar — mientras un motor de métricas captura cada carácter, cada dedo y cada combinación de teclas para decirte exactamente qué te cuesta trabajo.

> Repositorio privado. La lógica de negocio (`SPEC.md`) y la arquitectura técnica completa (`STACK.md`) ya están cerradas; el código de este repo hoy es el esqueleto de arquitectura (hexagonal, Riverpod, diseño) sobre el que se construyen las features del juego descritas en esos documentos.

![Flutter](https://img.shields.io/badge/Flutter-3.13%2B-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.13%2B-0175C2?logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Backend-Supabase-3FCF8E?logo=supabase&logoColor=white)
![Architecture](https://img.shields.io/badge/architecture-hexagonal-8A2BE2)
![State management](https://img.shields.io/badge/state-Riverpod%203-blueviolet)
![License](https://img.shields.io/badge/license-proprietary-lightgrey)
![Status](https://img.shields.io/badge/status-spec--first-orange)

**Plataformas objetivo:**

![Android](https://img.shields.io/badge/Android-3DDC84?logo=android&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)
![Windows](https://img.shields.io/badge/Windows-0078D6?logo=windows&logoColor=white)
![Web](https://img.shields.io/badge/Web-4285F4?logo=googlechrome&logoColor=white)

---

## Qué es esto

Just In Time convierte el "calentamiento" antes de programar en un juego con datos reales de desempeño:

- **Contenido real**: se practica con código Go idiomático, no con lorem ipsum ni citas.
- **Metadata ultra detallada**: tiempo por carácter, dedo y mano usados, n-gramas típicos de código (`:=`, `err`, `{}`), consistencia, rachas y curva de fatiga.
- **Offline-first**: todo el modo individual funciona sin conexión; la nube solo entra para lo social.
- **Competencia online**: duelos 1 vs 1 con matchmaking, escuadrones/equipos, leaderboards, todo en tiempo real vía Supabase.
- **Multiplataforma real**: Android, Windows, Linux y Web con el mismo código y la misma cuenta.
- **Identidad mínima**: solo *username*, sin correo ni datos personales — invitado local o cuenta con contraseña.

## Documentación

Este repositorio se gobierna por dos documentos fuente de verdad, en este orden:

| Documento | Qué contiene |
|---|---|
| [`SPEC.md`](./SPEC.md) | La lógica de negocio completa: modos de juego, sistema de métricas, cuentas, competencia, leaderboards, modelo de negocio. Cero detalle técnico. |
| [`STACK.md`](./STACK.md) | Cómo se construye: Flutter + Riverpod + arquitectura hexagonal, Supabase (Auth/DB/Realtime/Edge Functions), sincronización offline, matriz de compatibilidad por sistema operativo, versionamiento y despliegue. |

Cualquier decisión de código debe poder trazarse a una regla escrita en alguno de los dos.

## Stack actual del código

| Concern | Choice |
|---|---|
| State management | Riverpod 3 (`flutter_riverpod` + `riverpod_generator`, `@riverpod` codegen) |
| Navigation | `go_router`, adaptive shell (rail on desktop, bottom bar on phone) |
| Architecture | Hexagonal — domain / application / infrastructure / presentation per feature |
| Persistence | `shared_preferences` (`SharedPreferencesAsync`) behind repository ports |
| Security | `flutter_secure_storage` (Keystore on Android, libsecret on Linux) for a salted-hash PIN app-lock |
| i18n | Flutter `gen-l10n`, English + Spanish |
| Immutability | `freezed` for domain entities and DTOs |
| Motion | Hand-tuned Material 3 Expressive-style motion tokens + `flutter_animate` |
| Fonts | Geist / Geist Mono (SIL OFL, bundled in `assets/fonts`) |

El stack objetivo completo (Supabase, `drift`, sincronización offline, multiplataforma) está en [`STACK.md`](./STACK.md) — incluida la matriz de compatibilidad de cada paquete por sistema operativo en [`STACK.md §3`](./STACK.md#3-compatibilidad-de-paquetes-y-requisitos-por-sistema-operativo).

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
See `test/features/tasks/application/create_task_usecase_test.dart` for what
this buys you — the use case is tested with a fake repository, zero Flutter,
zero platform channels.

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

## Features shipped so far (architecture scaffold)

These aren't the game yet — they're the reference implementation of the
hexagonal pattern that every real feature from `SPEC.md` will follow:

- **Tasks** — create, edit, complete, and swipe-to-delete (with undo) tasks
  grouped into Overdue / Today / Upcoming / Done, with priority and an
  optional due date+time.
- **Settings** — theme mode, expressive color toggle, language (system /
  English / Spanish), app-lock.
- **App lock** — an optional 4-digit PIN gate backed by secure storage.
  Only a salted SHA-256 digest of the PIN is ever persisted; the router
  redirects to the lock screen whenever the app is locked and the current
  session hasn't unlocked it yet.

Next up, per [`STACK.md §4.5`](./STACK.md#45-mapeo-de-los-módulos-de-negocio-specmd-a-features-técnicos):
`auth`, `typing`, `daily_challenge`, `duels`, `squads`, `leaderboard`, `achievements`.

## Running

```sh
flutter pub get
flutter gen-l10n                 # regenerate lib/core/i18n/gen/ after editing lib/l10n/*.arb
dart run build_runner build --delete-conflicting-outputs   # freezed / json_serializable / riverpod_generator

flutter run -d linux
flutter run -d android
```

Regenerate code after touching any `@freezed`, `@riverpod`, `@JsonSerializable`,
or `.arb` file:

```sh
dart run build_runner watch --delete-conflicting-outputs
```

Windows and Web aren't scaffolded yet — `flutter create --platforms=windows,web .`
before the first `flutter run -d windows` / `-d chrome` (see
[`STACK.md §1`](./STACK.md#1-plataformas-objetivo-y-matriz-de-soporte)).

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

### Verified in this environment

- `flutter analyze` — clean.
- `flutter test` — unit test for the Tasks use case layer + a widget test
  asserting the flat theme.
- `flutter build linux --debug` — compiles and links; the resulting binary
  launches under Xvfb with no plugin or framework errors.
- Android wasn't build-verified here (no Android SDK in this sandbox) — the
  project targets `flutter.minSdkVersion`/`targetSdkVersion` from the
  installed Flutter SDK, which is compatible with every plugin used.

## Notes

- Geist and Geist Mono are bundled under `assets/fonts/` (SIL Open Font
  License — see `assets/fonts/LICENSE.txt`).
- The launcher icon is still the Flutter default; swap
  `android/app/src/main/res/mipmap-*` and the Linux desktop file/icon before
  shipping.

## Status

Fase de especificación cerrada (`SPEC.md` + `STACK.md`); implementación de las
features del juego en curso sobre el esqueleto de arquitectura descrito arriba.
Repositorio privado — sin licencia de código abierto.
