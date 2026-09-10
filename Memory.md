# Memory — Bitácora de avances

Documento vivo para humanos y agentes de IA: registra **en qué punto está el
proyecto, qué se verificó y qué sigue**. No sustituye a los otros docs:

- `SPEC.md` — lógica de negocio (qué hace el producto).
- `STACK.md` — arquitectura técnica (cómo está construido).
- `CHANGELOG.md` — historial de releases (autogenerado desde Conventional
  Commits; no editar a mano).
- `CLAUDE.md` — guía operativa para agentes (comandos, convenciones).

**Cómo actualizarlo:** al cerrar una sesión de trabajo, añade una entrada
fechada al historial, actualiza "Estado actual" si cambió, y ajusta
"Pendientes". Sé breve: hechos verificables y comandos, no prosa.

---

## Estado actual (2026-09-10)

- App **offline-only** (drift/SQLite + secure storage + shared_preferences).
  Todo lo online (auth, duelos, escuadrones, leaderboards, sync Supabase)
  está especificado en `SPEC.md`/`STACK.md` pero **sin implementar**.
- Features implementadas: `content`, `practice`, `progression`,
  `learning_paths`, `achievements`, `profile`, `settings`, `lock`,
  `onboarding`, `data_management`.
- Modos de práctica: Zen, Sprint, Precisión y **Survival** (SPEC.md §5.8:
  vidas, combo, multiplicador).
- Catálogos y rutas (contenido bilingüe en/es):

  | Lenguaje | Catálogo | Ruta | Tier |
  |---|---|---|---|
  | Go | 142 snippets | `go-foundations-v1` (~51 lecciones) + notas DDD + `go-tui-notes-v1` (29, TUI Bubble Tea) | práctica libre (grid denso) |
  | Bash (Arch) | 50 snippets | `bash-foundations-v1` (50) | solo-curso |
  | SQL (PostgreSQL) | 60 snippets | `sql-foundations-v1` (60) | solo-curso |

- Curso SQL: base de datos de ejemplo compartida tipo biblioteca
  (`authors`, `books`, `members`, `loans`), 8 categorías contiguas:
  `sqlBasics` (6), `sqlSchema` (13), `sqlQueries` (7), `sqlFiltering` (9),
  `sqlAggregation` (7), `sqlJoins` (7), `sqlModifications` (5),
  `sqlAdvancedQueries` (6). Dificultad 30/22/7/1.
- Gate de calidad: `bash tool/check.sh` (format + analyze + arquitectura +
  tests). Última corrida: **314 tests verdes**, format/analyze limpios.
  Arquitectura tiene **1 violación pre-existente** (no de esta sesión):
  `syntax_tokenizer.dart` en 524 líneas (límite 500) por el WIP de Rust
  sin commitear — pendiente de partir en part files.
- Set de íconos: **Lucide** (`lucide_icons_flutter`), no Material `Icons.*`
  — elegido por combinar con Geist (misma familia visual que usa Vercel/
  shadcn). `cupertino_icons` (vestigial, nunca usado) fue removido.
- Último release: **v1.2.0** (CI, `df00321`). El siguiente push a `main`
  genera release automático desde los Conventional Commits.

---

## Historial de sesiones

### 2026-09-10 — Curso Go: TUI con Bubble Tea (`go-tui-notes-v1`)

- **Curso nuevo de 29 lecciones** que construye una TUI de notas con
  **Bubble Tea + Lip Gloss + Bubbles** (v1.3.10 / v1.1.0 / v1.0.0) sobre un
  núcleo DDD/hexagonal: dominio → puertos → casos de uso → adaptadores
  (memoria, system, jsonfile) → TUI (estilos → componentes → `model`,
  `Init`, mensajes, `tea.Cmd`, `Update`, `handleKey`, `renderList`, `View`)
  → `main` → tests. Cuatro categorías nuevas de capa de arquitectura
  (`tuiArchitecture`, `tuiStyling`, `tuiComponents`, `tuiAdapter`), exentas
  del grid denso con la misma regla que las 6 de DDD.
- **Contenido**: 29 snippets nuevos en `go_v1.json` (113→142), extraídos
  **verbatim** de una app Go de referencia que pasa `gofmt` + `go build` +
  `go vet` + `go test` (incluye un test headless del loop real con
  `tea.WithInput`/`WithOutput`). Prosa bilingüe delegada a un agente y
  fusionada con validación independiente del orquestador.
- **Orden**: la revisión adversarial (agente fresco) detectó referencias
  hacia adelante en el bloque TUI (estilos/componentes usados antes de su
  lección) → se reordenó por dependencia real (estilos → componentes →
  arquitectura), se renumeraron los snippets y una segunda pasada confirmó
  el arreglo. `audit_lesson_order.py` verde (solo quedan flags de tamaño
  informativos ya evaluados).
- **Integración**: `pubspec`, `LearningPathRepositoryImpl`, test de
  completitud; labels ARB en/es + `content_labels.dart`; conteos de
  `content_drift_integration_test` 280→309 (beginner sigue 87); sets de
  `findContainingSymbols` (`_`, `%`) actualizados.
- **Verificado**: `bash tool/check.sh` verde (314 tests; format, analyze y
  arquitectura limpios).

### 2026-09-10 — Migración de íconos: Material → Lucide

- **Decisión** (con el usuario): Material `Icons.*` no combinaba con Geist
  (tipografía dev-tool de Vercel); se evaluaron Lucide vs Phosphor y se
  eligió **Lucide** (`lucide_icons_flutter` v3.1.19) por su adopción
  (191k descargas vs 20.4k de `flutter_lucide`) y porque soporta
  variantes de grosor de trazo (`100`–`600`) vía sufijo numérico en el
  nombre del ícono (mismo `IconData`, distinto `fontFamily` empaquetado).
- **Convención nueva**: sin sufijo (`LucideIcons.x`) = trazo por defecto
  (stroke 2.0, antes "outlined"/no-seleccionado); sufijo `600` = trazo
  grueso (stroke 3.0, antes "rounded"/seleccionado o énfasis). Aplicada en
  los 5 destinos de `app_shell.dart` (nav bar/rail) y en un puñado de
  toggles filled-vs-empty (corazones de vidas en Survival, check de
  maestría en Progress) — Lucide no tiene variante "filled" real, solo
  trazo, así que el contraste de grosor + opacidad ya existente hace ese
  trabajo.
- **Alcance**: ~27 archivos bajo `lib/features/**/presentation` y
  `lib/core/{router,window}` con `Icons.*` → mapeo semántico 1:1 a
  Lucide (ver diffs; no hay tabla separada). `cupertino_icons` (nunca
  usado) se quitó de `pubspec.yaml` al agregar `lucide_icons_flutter`.
- **Tests**: 3 widget tests afirmaban `Icons.*` explícitamente
  (`session_result_footer_test.dart`,
  `survival_lives_badge_test.dart` ×2 casos) — actualizados a
  `LucideIcons.*`. Resto de la suite no tocaba íconos por nombre.
- **Verificado**: `flutter analyze` limpio, `flutter test` 314/314,
  `flutter build linux --release` compila (confirma que el
  font-subsetting de Lucide encontró todos los constantes usados). No se
  pudo verificar visualmente — este entorno (WSL2) no tiene servidor
  gráfico.
- **Nota**: `directives_ordering` (lint de `very_good_analysis`) ordena
  **todos** los imports `package:` como una sola secuencia alfabética
  (ignora los saltos de línea que separan "paquetes externos" de
  `just_in_time/*` por convención visual) — `lucide_icons_flutter` cae
  después de `just_in_time/*` (`j` < `l`) en casi todos los archivos.

### 2026-09-10 — Curso SQL/PostgreSQL + integración de WIP (Bash y Survival)

- **Curso SQL completo** (`sql-foundations-v1`, 60 lecciones), decidido con
  el usuario:
  - Dialecto **PostgreSQL**; schema compartido "biblioteca"; **solo-curso**
    (mismo tier que Bash); ~50 lecciones objetivo → 60 finales.
  - `ProgrammingLanguage.sql` + `SqlSyntaxTokenizer` (en part file de
    `syntax_tokenizer.dart` para no pasar el límite de 500 líneas) +
    8 `ContentCategory` nuevas + labels ARB en/es.
  - Prosa bilingüe delegada a un agente; código autorado y verificado por
    el orquestador.
- **Verificación de contenido**: los 60 snippets se ejecutaron contra
  **PostgreSQL 16 real** (contenedor `podman` desechable): bloque
  `sqlSchema` acumulativo (crea la DB `library`), el resto contra una copia
  recién sembrada, con asserts de counts de seed (5/8/3/5). Los scripts
  vivieron en `/tmp/opencode/` (efímeros); el procedimiento quedó
  documentado en la skill `content-curriculum`.
- **Doble revisión adversarial** (agentes frescos) → 12 hallazgos
  corregidos: entre ellos un `UPDATE` no-op, un `ILIKE` que no demostraba
  case-insensitivity, un `LEFT JOIN` enseñado ya como anti-join, y
  `symbolFocus` con valores crudos que rompían la carga del catálogo
  (el enum `SymbolFocus` es Go-específico; SQL usa `[]`, como Bash).
- **Fix extra**: el selector de rutas ordenaba idiomas alfabéticamente
  (default Bash); ahora usa orden de declaración del enum → default Go.
- **Integración**: el working tree tenía WIP sin commitear de Bash y
  Survival entrelazado en archivos compartidos; se commiteó junto y se
  pusheó: `42cfc2f` (feat) + `b54e0b4` (chore). Rebase limpio sobre el
  release v1.2.0 del remoto.
- **Incidente**: un proceso externo (buffers viejos de editor, aparente)
  revirtió `lib/l10n/*.arb` y `lib/core/i18n/gen/*` justo tras commitear.
  Se restauró desde el commit y se re-verificó. **Antes de commitear/pushear,
  comprobar `git status` y que las claves nuevas sigan en los ARB.**

### 2026-09-09/10 — Núcleo offline y features iniciales

- `6bc8034` núcleo offline según SPEC.md (content, practice, progression,
  learning paths, achievements, profile).
- `1aac79e` biometría en lock; `afcd8f5` auto-detección de plataforma en
  perfil; `bc1026f` fix de test de changelog. Releases v1.0.0–v1.2.0
  (ver `CHANGELOG.md`).
- Sesión previa (WIP ahora commiteado con `42cfc2f`): curso **Bash/Arch
  Linux**, selector de idioma en práctica libre/Sprint y browser de
  snippets, y modo **Survival**.

---

## Decisiones duraderas

- **Agregar un lenguaje** = nuevo case en `ProgrammingLanguage` + tokenizer
  (part file) + asset de catálogo + ruta + categorías si aplica + labels en
  `content_labels.dart` + claves ARB en/es. Nada de rediseño.
- **Tiers de catálogo** (SPEC.md §3.2): práctica libre exige grid denso
  (≥3 por celda en categorías núcleo); solo-curso exige exactamente los
  snippets que usa su ruta (cero huérfanos). Lo verifica
  `snippet_catalog_completeness_test.dart`.
- **Código del catálogo es ASCII-only** (el `key_layout_map_test` exige que
  cada carácter mapee a una tecla US-QWERTY). Los acentos van solo en la
  prosa en/es.
- **Ordenar lecciones** es a mano por dependencia conceptual, luego
  `scripts/audit_lesson_order.py` y **revisión adversarial** por un agente
  fresco (ver skill `content-curriculum`).
- **Verificar todo contenido ejecutándolo**: Go `gofmt` + `go run`; SQL
  PostgreSQL 16 real; Bash smoke run; snippets de TUI con dependencias
  externas, extraídos verbatim de una app de referencia compilada y con
  test headless del loop (ver `references/snippet-authoring.md`).
- **Progreso por `lessonId`**: antes de reasignar snippet a un id de lección
  con progreso real, consultar `~/Documents/jit.db.sqlite`
  (`lesson_progress_cache`).

## Pendientes / próximos pasos

- Confirmar que CI generó el release (v1.3.0 previsible) tras `42cfc2f`.
- Todo lo online de `SPEC.md` §5/§9 y `STACK.md` §5–6 (Supabase, sync,
  duelos, escuadrones, leaderboards).
- Scaffold de Windows/Web (`flutter create --platforms=windows,web .`).
- Evaluar si `symbolFocus` merece valores SQL (hoy `[]`, como Bash) si se
  le da uso real en recomendaciones.
- Considerar versionar el harness de verificación de contenido SQL dentro
  de `tool/` (hoy efímero en `/tmp`).

## Comandos clave

```sh
bash tool/check.sh                         # gate completo
flutter test                               # suite (314 tests)
python3 .claude/skills/content-curriculum/scripts/audit_lesson_order.py \
  assets/content/snippets/sql_v1.json \
  assets/content/learning_paths/sql_foundations_v1.json
# Postgres para verificar snippets SQL:
podman run -d --rm --name jit-sql-pg -e POSTGRES_PASSWORD=postgres \
  docker.io/library/postgres:16-alpine
```
