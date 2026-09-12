# CODE_STANDARDS.md — Gates de calidad

Para humanos y agentes: **por qué** existe cada gate de calidad del repo y
cómo se conectan entre sí. La fuente de verdad ejecutable es
`tool/check.sh` — si este documento y el script discrepan, manda el script.
Este archivo es el que referencian `tool/check.sh`, `tool/check_architecture.dart`,
`analysis_options.yaml` y `tool/git-hooks/pre-commit`.

## Los cuatro gates (en orden)

`bash tool/check.sh` los corre en este orden y aborta al primer fallo:

1. **Formato** — `dart format --output=none --set-exit-if-changed .`
   El formatter canónico del SDK es la única definición de "bien
   formateado"; ningún archivo está exento. Arreglarlo es
   `bash tool/format.sh` (`check.sh` solo verifica, nunca reescribe).
2. **Analyzer** — `flutter analyze --fatal-infos --fatal-warnings`
   Cualquier info o warning es error. Base `very_good_analysis` (superset
   estricto de `flutter_lints`, ~190 reglas) más `strict-casts`,
   `strict-inference` y `strict-raw-types` en `analysis_options.yaml`.
   Reglas extra activadas: `unawaited_futures` y `avoid_dynamic_calls`.
   `sort_pub_dependencies` está deshabilitada a propósito (el pubspec
   agrupa dependencias por propósito, con comentario por grupo) — toda
   regla deshabilitada debe llevar un comentario `// Disabled:` que
   explique por qué. Excluidos: `build/`, `android/`, `linux/`, `web/`,
   `windows/` y todo el código generado.
3. **Arquitectura** — `dart run tool/check_architecture.dart`
   Reglas duras (exit 1, bloquea commit/push/CI):
   - Ningún archivo no generado bajo `lib/` supera **500 líneas**.
   - Los archivos bajo un segmento `domain/` o `application/` no importan
     `package:flutter/`, ni rutas `infrastructure/` ni `presentation/`
     (dirección inward-only de la arquitectura hexagonal).
   Regla suave (solo warning, nunca falla): más de un tipo público
   top-level por archivo — las jerarquías sealed lo necesitan
   legítimamente. Generados exentos: `*.g.dart`, `*.freezed.dart`,
   `lib/core/i18n/gen/**`.
4. **Tests** — `flutter test`
   Suite completa. Un solo archivo:
   `flutter test test/features/practice/finish_practice_session_usecase_test.dart`.
   CI además re-corre `dart run build_runner build
   --delete-conflicting-outputs` y falla si los `*.g.dart`/`*.freezed.dart`
   commiteados difieren de lo regenerado: **el código generado se
   commitea**, nunca es output efímero.

## Dónde corre cada gate

- `tool/git-hooks/pre-push` → `bash tool/check.sh` (idéntico a CI: un solo
  script que actualizar).
- CI, `.github/workflows/ci.yml`, job `quality-gate` (Flutter 3.47.2
  stable): `bash tool/check.sh` + chequeo de generados. En push a `main`
  corre además el job `release` (ver abajo).
- Instalación una vez por clon: `bash tool/install_hooks.sh`, que hace
  `git config core.hooksPath tool/git-hooks`.

## pre-commit (rápido, solo staged)

`tool/git-hooks/pre-commit` **no** corre la suite completa a propósito:
cada commit debe ser barato, y el suite entero vive en pre-push/CI. Hace
solo tres cosas:

1. `dart format` sobre los `.dart` staged y los re-agrega al índice.
2. `dart run tool/check_architecture.dart`.
3. Escaneo del diff staged en busca de secretos: claves privadas PEM
   (`-----BEGIN … PRIVATE KEY-----`), claves AWS (`AKIA…`) y asignaciones
   tipo `password|secret|api_key|token = "…"` de 8+ caracteres. Los
   `*.lock` quedan excluidos del escaneo. Ante un hallazgo: quitar el
   secreto y **rotar la credencial** — si estuvo commiteada alguna vez, ya
   está comprometida.

Saltarse el hook local no evita el gate (pre-push y CI corren lo mismo),
solo lo demora.

## Conventional Commits y release

El hook `commit-msg` exige `<type>(<scope>)?: descripción` — scope y `!`
opcionales — con type ∈ `feat fix perf refactor docs style test chore
build ci revert`. El tipo no es cosmético; de él depende la versión:

- `tool/version_bump.dart` calcula el siguiente SemVer desde el último tag
  `vX.Y.Z`: `fix`/`perf` → PATCH, `feat` → MINOR, `!` o footer
  `BREAKING CHANGE:` → MAJOR. `refactor`/`revert` solo entran al
  CHANGELOG, no disparan release. Si no hay commits release-worthy sale
  con código 3 ("nada que releasar", no es error).
- `tool/release.sh` es el **único** camino que mueve la versión: corre el
  bump, commitea `pubspec.yaml` + `CHANGELOG.md` como
  `chore(release): vX.Y.Z [skip ci]` y crea el tag anotado. Nunca
  bumpear `pubspec.yaml` ni editar `CHANGELOG.md` a mano.
- En CI, el job `release` (solo push a `main`) hace ese commit y lo empuja
  con `--follow-tags`.
- `.github/workflows/release-builds.yml` se gatilla solo con tags
  `v*.*.*` (nunca en PR ni push normal): compila y sube artefactos por
  plataforma; todavía no publica a ninguna tienda.

## Por qué existe cada regla

El rationale de negocio y técnico vive en `STACK.md`: gates y estándares en
§8/§11/§12, contrato de versionado en §10.4, arquitectura hexagonal en §4.
Este documento solo explica los gates ejecutables; no redefine esas reglas.
