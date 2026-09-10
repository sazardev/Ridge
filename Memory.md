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
  | Go | 148 snippets | `go-foundations-v1` (~51 lecciones) + `go-intermediate-syntax-v1` (25, con bloque Go 1.27) + notas DDD + `go-tui-notes-v1` (29, TUI Bubble Tea) | práctica libre (grid denso) |
  | Bash (Arch) | 50 snippets | `bash-foundations-v1` (50) | solo-curso |
  | SQL (PostgreSQL) | 60 snippets | `sql-foundations-v1` (60) | solo-curso |

- Curso SQL: base de datos de ejemplo compartida tipo biblioteca
  (`authors`, `books`, `members`, `loans`), 8 categorías contiguas:
  `sqlBasics` (6), `sqlSchema` (13), `sqlQueries` (7), `sqlFiltering` (9),
  `sqlAggregation` (7), `sqlJoins` (7), `sqlModifications` (5),
  `sqlAdvancedQueries` (6). Dificultad 30/22/7/1.
- Gate de calidad: `bash tool/check.sh` (format + analyze + arquitectura +
  tests). Última corrida (post-merge del rebranding con `origin/main`):
  **315 tests verdes**, format/analyze limpios, sin violaciones duras de
  arquitectura (solo warnings informativos de "varios tipos por archivo").
- Set de íconos: **Lucide** (`lucide_icons_flutter`), no Material `Icons.*`
  — elegido por combinar con Geist (misma familia visual que usa Vercel/
  shadcn). `cupertino_icons` (vestigial, nunca usado) fue removido.
- Último release: **v1.6.0** (`9dfe43c`). El siguiente push a `main`
  genera release automático desde los Conventional Commits.

---

## Historial de sesiones

### 2026-09-10 — Rebranding: Just In Time → Ridge

- Producto renombrado de "Just In Time" a **Ridge** en toda la app y el
  repo (branding puro — `SPEC.md`/`STACK.md` solo cambiaron el título y el
  correo sintético de ejemplo de Supabase Auth §7, ninguna regla de negocio).
- Paquete Dart: `just_in_time` → `ridge` (`pubspec.yaml` `name:` +
  ~230 `package:` imports vía sed en `lib/`, `test/`, `tool/`).
- Clase raíz `JustInTimeApp` → `RidgeApp` (`lib/app.dart`, `lib/main.dart`).
- Android: `applicationId`/`namespace` `dev.omarcodes.just_in_time` →
  `dev.omarcodes.ridge`; `MainActivity.kt` movido de paquete; `android:label`
  → "Ridge". Sin riesgo de romper nada publicado: la app nunca tuvo firma de
  release real (usa la debug key) ni presencia en Play Store.
- Linux: `BINARY_NAME`/`APPLICATION_ID` en `CMakeLists.txt` → `ridge` /
  `dev.omarcodes.ridge`; título de ventana GTK en `my_application.cc` →
  "Ridge".
- l10n: `appName` y strings de bloqueo/PIN en `app_en.arb`/`app_es.arb` →
  "Ridge"; regenerado con `flutter gen-l10n`.
- DB local: `driftDatabase(name: 'jit.db')` → `'ridge.db'`
  (`app_database.dart`) — instalaciones de dev existentes arrancan con base
  vacía bajo el nuevo nombre; el `jit.db` viejo queda en disco sin usarse,
  no se borra nada.
- Referencias a `jit.db.sqlite`/`jit-sql-pg` en este archivo y en
  `.claude/skills/content-curriculum/` actualizadas a
  `ridge.db.sqlite`/`ridge-sql-pg`.
- `dart fix --apply` corrigió automáticamente 36 archivos con
  `directives_ordering` roto por el cambio alfabético de
  `package:ridge/*` vs `package:lucide_icons_flutter/*` (ver nota debajo).
- Verificado con `bash tool/check.sh` tras el rebrand: format/analyze
  limpios, arquitectura sin violaciones nuevas, **314 tests verdes**.
- **Continuación en la misma sesión** (con confirmación del usuario):
  - Repo de GitHub renombrado `sazardev/Just-In-Time` → `sazardev/Ridge`
    (`gh repo rename`; GitHub deja redirect automático del nombre viejo).
    Remote local actualizado con `git remote set-url origin`.
  - Carpeta local renombrada `/home/omar/personal/just_in_time` →
    `/home/omar/personal/ridge` (`mv`); se limpió y regeneró
    `build/linux` porque CMake cachea la ruta absoluta del build anterior
    y falla si no coincide con la carpeta actual.
  - Ícono de launcher Android reemplazado: squircle plano en el naranja
    ember de marca (`AppColors.seed`, `0xFFFF5A36`) con una marca de dos
    picos ("ridge"). Fuente de 1024×1024 en
    `assets/icons/ridge_launcher_master.png`, generada con `rsvg-convert`
    + `magick` (sin depender de `flutter_launcher_icons`) y aplicada a los
    5 tamaños existentes en `android/app/src/main/res/mipmap-*/ic_launcher.png`.
    Linux sigue sin `.desktop`/ícono empaquetado (no existía antes tampoco).
- Verificado de nuevo tras repo+carpeta+ícono: `bash tool/check.sh` limpio
  y `flutter build linux --debug` compila desde la ruta nueva.
- **Merge con `origin/main`**: el remoto había avanzado con la ruta Go
  1.27 y el curso TUI (v1.5.0/v1.6.0) mientras corría esta sesión de
  rebranding; se integró sin `--force`, resolviendo conflicto solo en
  este archivo (dos entradas de historial añadidas al mismo punto, y la
  ruta de `jit.db.sqlite` → `ridge.db.sqlite` en "Progreso por
  `lessonId`"). El resto (pubspec.yaml, l10n, content_labels.dart, etc.)
  fusionó limpio porque los cambios cayeron en líneas distintas.

### 2026-09-10 — Ruta Go intermedia v2 + contenido Go 1.27

- **`go-intermediate-syntax-v1` reescrita de 7 a 25 lecciones** (working
  tree, sin commitear aún): bloques contiguos `structs` (4) → `pointers`
  (4) → `interfaces` (3) → `concurrency` (4) → `generics` (4) →
  `modernGo` (6), ordenadas a mano por dependencia conceptual (no por tag
  de dificultad ni longitud). La versión vieja era un muestreo aleatorio
  que arrancaba con un bloque `var` alineado.
- **6 snippets nuevos Go 1.27** (`go-modern-001..006`, catálogo Go
  142→148): `strings.CutLast`, `uuid.NewV7/Parse`, claves de campo
  promovido en struct literals, inferencia generalizada de tipos de
  función (literales/conversiones/envíos), perfil `goroutineleak` de
  pprof, y métodos genéricos. Cada `code` verificado con toolchain real
  **go1.27.0** (`gofmt` + `go run`, salida esperada); el resto del
  catálogo usa go1.26.5.
- **Categoría nueva `modernGo`** (enum + ARB en/es + `content_labels` +
  l10n regenerado) como bloque final "qué hay de nuevo" del que cuelgan
  los 6 snippets.
- **Bloqueo del agente adversarial**: la ruta original ya estaba en
  v1.5.0, así que reutilizar `go-intermediate-syntax-v1-stepNN` para
  otros snippets habría marcado mal progreso de usuarios reales. Los ids
  pasaron al esquema `-o2-stepNN` (como `go-foundations-v1-o2`). La DB
  local no tenía intentos, pero el tag publicado manda.
- **Dos prosa corregidas en snippets existentes**: `go-concurrency-001`
  explicaba el peligro de la variable de bucle como si Go 1.22 no
  existiera; `go-concurrency-004` ES usaba "filtrada" (calco) ahora
  "filtrarse".
- **Integración**: `content_drift_integration_test` 309→315 y beginner
  87→89; set de `findContainingSymbols` para `%` + `go-modern-004`.
- **Verificado**: `audit_lesson_order.py` verde; **dos pasadas de
  revisión adversarial** (la primera cazó el blocker de ids y 4 hallazgos
  más, la segunda confirmó los fixes y dejó solo nits de estilo); `bash
  tool/check.sh` verde (format, analyze, arquitectura, **314 tests**).
- **Trade-off aceptado**: `go-struct-004` conserva su tag `expert` del
  catálogo aunque en la ruta sea la lección 2; retaggearlo dejaría
  `structs/expert` en 0 y la regla de grid exige ≥1 por celda.

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
  `ridge/*` por convención visual) — tras el rebranding a Ridge,
  `lucide_icons_flutter` ahora cae **antes** de `ridge/*` (`l` < `r`),
  al revés que con `just_in_time/*` (`j` < `l`).

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
  con progreso real, consultar `~/Documents/ridge.db.sqlite`
  (`lesson_progress_cache`). Si la ruta ya salió en un release, **bumpear
  el sufijo de versión de los ids** (`...-o2-stepNN`) aunque la DB local
  no tenga intentos: el release implica usuarios reales.

## Pendientes / próximos pasos

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
flutter test                               # suite (315 tests)
python3 .claude/skills/content-curriculum/scripts/audit_lesson_order.py \
  assets/content/snippets/sql_v1.json \
  assets/content/learning_paths/sql_foundations_v1.json
# Postgres para verificar snippets SQL:
podman run -d --rm --name ridge-sql-pg -e POSTGRES_PASSWORD=postgres \
  docker.io/library/postgres:16-alpine
```
