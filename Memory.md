# Memory — Bitácora de avances

Documento vivo para humanos y agentes de IA: registra **en qué punto está el
proyecto, qué se verificó y qué sigue**. No sustituye a los otros docs:

- `SPEC.md` — lógica de negocio (qué hace el producto).
- `STACK.md` — arquitectura técnica (cómo está construido).
- `MARKETING.md` — posicionamiento, voz de marca e identidad visual
  (nuevo, ver sesión de hoy).
- `CHANGELOG.md` — historial de releases (autogenerado desde Conventional
  Commits; no editar a mano).
- `CLAUDE.md` / `AGENTS.md` — guía operativa para agentes (comandos,
  convenciones), espejo byte a byte entre ambos.
- `CODE_STANDARDS.md` — por qué existe cada gate de calidad (referenciado
  por `tool/check.sh`, `analysis_options.yaml`, `tool/check_architecture.dart`
  y el hook `pre-commit`).

**Cómo actualizarlo:** al cerrar una sesión de trabajo, añade una entrada
fechada al historial, actualiza "Estado actual" si cambió, y ajusta
"Pendientes". Sé breve: hechos verificables y comandos, no prosa.

---

## Estado actual (2026-09-25)

- App **offline-only** (drift/SQLite + secure storage + shared_preferences).
  Todo lo online (auth, duelos, escuadrones, leaderboards, sync Supabase)
  está especificado en `SPEC.md`/`STACK.md` pero **sin implementar**.
- Features implementadas: `content`, `practice`, `progression`,
  `learning_paths`, `achievements`, `profile`, `settings`, `lock`,
  `onboarding`, `data_management`, `daily_challenge`.
- Modos de práctica: Zen, Sprint, Precisión, **Survival** (SPEC.md §5.8:
  vidas, combo, multiplicador) y **Reto Diario** (SPEC.md §5.4, Fase 0
  offline-only: mismo snippet para todo el mundo calculado
  determinísticamente por fecha UTC, sin Supabase — ver sesión de hoy).
- Catálogos y rutas (contenido bilingüe en/es):

  | Lenguaje | Catálogo | Ruta | Tier |
  |---|---|---|---|
  | Go | 293 snippets | `go-foundations-v1` (~51 lecciones) + `go-intermediate-syntax-v1` (25, con bloque Go 1.27) + notas DDD + `go-tui-notes-v1` (29, TUI Bubble Tea) + `go-algorithms-v1` (12) + `go-interfaces-v1` (24, interfaces/type/struct → JSON y diseño testeable) + `go-rest-http-v1` (33, API REST/HTTP/CRUD, cliente y SQLite) + `go-modern-idioms-v1` (34, lenguaje/stdlib 1.26-1.27, iteradores, JSON v2, diseño de API y errores) + `go-production-v1` (24, concurrencia, fugas, testing, perfilado, observabilidad y tooling) + `go-cli-programs-v1` (20, programas CLI completos e independientes — no incrementales: aritmética, texto, menús interactivos con `bufio.Scanner` y desafíos con maps/rand; 4 categorías nuevas `cli*`, ver sesión de hoy) | práctica libre (grid denso) |
  | Bash (Arch) | 95 snippets | `bash-foundations-v1` + `bash-toolkit-v1` | solo-curso |
  | SQL (PostgreSQL) | 60 snippets | `sql-foundations-v1` (60) | solo-curso |
  | Rust | 24 snippets | `rust-foundations-v1` (12, solo principiante) + `rust-algorithms-v1` (12) | solo-curso |
  | Zig | 46 snippets | `zig-foundations-v1` (34, Zig 0.16.0: tipos, slices, control, funciones, recursión, `comptime`, errores, structs, punteros, opcionales, enums/uniones, allocators, `ArrayList` y tests) + `zig-algorithms-v1` (12) | solo-curso |
  | Python | 79 snippets | `python-foundations-v1` (12) + `python-algorithms-v1` (12) + `python-django-foundations-v1` (21, proyecto/modelos/vistas/plantillas/forms/admin/tests) + `python-django-orm-v1` (17, relaciones/QuerySets/migraciones) + `python-django-rest-v1` (17, DRF/token/paginación/tests) — los tres de Django nuevos, ver sesión de hoy | solo-curso |
  | JavaScript | 24 snippets | `javascript-foundations-v1` (12, solo principiante) + `javascript-algorithms-v1` (12) — ambos nuevos, ver sesión de hoy | solo-curso |
  | TypeScript | 29 snippets | `typescript-foundations-v1` (17, tour amplio) + `typescript-algorithms-v1` (12) — ambos nuevos, ver sesión de hoy | solo-curso |
  | Haskell | 24 snippets | `haskell-foundations-v1` (12, solo principiante) + `haskell-algorithms-v1` (12) — ambos nuevos, ver sesión de hoy | solo-curso |
  | C | 45 snippets | `c-foundations-v1` (15, introducción) + `c-algorithms-v1` (12) + `c-systems-v1` (18, structs/memoria/preprocesador/archivos) — los tres nuevos, ver sesión de hoy | solo-curso |
  | C++ | 45 snippets | `cpp-foundations-v1` (18, introducción) + `cpp-algorithms-v1` (12) + `cpp-advanced-v1` (15, RAII/STL/plantillas/concurrencia) — los tres nuevos, ver sesión de hoy | solo-curso |
  | Java | 36 snippets | `java-foundations-v1` (24, introducción) + `java-algorithms-v1` (12) | solo-curso |
  | Crystal | 28 snippets | `crystal-foundations-v1` (16, tour amplio) + `crystal-algorithms-v1` (12) — ambos nuevos, ver sesión de hoy | solo-curso |
  | CSS | 45 snippets | `css-foundations-v1` (16, introducción) + `css-layout-v1` (16, flexbox/grid/posicionamiento/responsive) + `css-advanced-v1` (13, cascada/variables/animaciones) — los tres nuevos, ver sesión de hoy | solo-curso |
  | C# (.NET 10) | 52 snippets | `csharp-foundations-v1` (25, introducción) + `csharp-algorithms-v1` (12) + `csharp-advanced-v1` (15, records/patrones/generics/delegados/LINQ/async/`IDisposable`) — los tres nuevos, ver sesión de hoy | solo-curso |
  | Swift | 47 snippets | `swift-foundations-v1` (20, tour amplio con proyecto final) + `swift-algorithms-v1` (12) + `swift-advanced-v1` (15, ARC/genéricos/opacos/Codable/property wrappers/actores/task groups) — los tres nuevos, ver sesión de hoy | solo-curso |
  | Dart | 53 snippets | `dart-foundations-v1` (25, tour amplio) + `dart-advanced-v1` (16, streams/isolates/patrones/mixins/genéricos) + `dart-algorithms-v1` (12) — los tres nuevos, ver sesión de hoy | solo-curso |
| Kotlin | 53 snippets | `kotlin-foundations-v1` (22, introducción) + `kotlin-algorithms-v1` (12) + `kotlin-advanced-v1` (19, selladas/`object`/delegación/genéricos y varianza/`lateinit`/extensiones/lambdas/`Result`/corrutinas) — los tres nuevos, ver sesión de hoy | solo-curso |
  | PHP | 48 snippets | `php-foundations-v1` (24, tour: tipos/null-coalescing/strings/condicionales/arreglos/ciclos/funciones/POO/enums/excepciones/namespaces) + `php-web-v1` (12, superglobales/formularios/sesiones/PDO/JSON/archivos) + `php-algorithms-v1` (12) — los tres nuevos, ver sesión de hoy | solo-curso |
  | Git | 70 snippets | `git-foundations-v1` (33, de `git init` a remotos) + `git-workflows-v1` (24, historial/deshacer/rebase/tags/hooks) + `git-internals-v1` (15, objetos/referencias/mantenimiento) — los tres nuevos, ver sesión de hoy | solo-curso |
  | Linux (Arch) | 85 snippets | `linux-foundations-v1` (35, distro/kernel/FHS/archivos/permisos/usuarios/procesos/paquetes/servicios/logs) + `linux-admin-v1` (30, cuentas+sudo/ACL/señales/discos/systemd/journald/pacman/timers/tar) + `linux-networking-v1` (20, `ip`/rutas/DNS/`curl`/`ss`/nftables/resolved) — los tres nuevos, ver sesión de hoy | solo-curso |
  | GitHub Actions | 74 snippets | `github-actions-foundations-v1` (25, anatomía del workflow/expresiones/triggers/jobs/matrices/secretos) + `github-actions-pipelines-v1` (24, caché/artefactos/compuestas/reutilizables/contenedores/patrones) + `github-actions-devops-v1` (25, seguridad/OIDC/CodeQL/releases/entornos/`gh`) — los tres nuevos, ver sesión de hoy | solo-curso |
  | Docker | 58 snippets | `docker-foundations-v1` (25, CLI/Dockerfiles/imágenes/contenedores/volúmenes/redes) + `docker-compose-v1` (16, servicios/healthchecks/redes/réplicas/capstone) + `docker-advanced-v1` (17, multi-stage/caché/registry/digest/límites/debug) — los tres nuevos, ver sesión de hoy | solo-curso |

- Curso SQL: base de datos de ejemplo compartida tipo biblioteca
  (`authors`, `books`, `members`, `loans`), 8 categorías contiguas:
  `sqlBasics` (6), `sqlSchema` (13), `sqlQueries` (7), `sqlFiltering` (9),
  `sqlAggregation` (7), `sqlJoins` (7), `sqlModifications` (5),
  `sqlAdvancedQueries` (6). Dificultad 30/22/7/1.
- Gate de calidad: `bash tool/check.sh` (format + analyze + arquitectura +
  tests). Última corrida (2026-09-25, cierre de Zig): **verde de punta a
  punta — 831 tests**, format/analyze/arquitectura limpios. La primera
  corrida tuvo el flake conocido de
  `survival_controller_drift_integration_test.dart`; aislado y en la
  repetición completa pasó. `content_category.dart` quedó en **379
  líneas** (límite duro 500): el formatter tall obliga línea en blanco
  alrededor de cada constante documentada con `///` (llevaba el archivo a
  532), así que los docs por-valor son `//` empaquetados con
  `ignore_for_file: public_member_api_docs` justificado.
- **`git pull --rebase` externo resuelto** (sesión de `go-cli-programs-v1`,
  ver entrada de hoy más abajo): apareció a medio resolver, con conflictos
  reales sin quitar en 7 archivos de personalización de teclado
  (`STACK.md`, `edit_profile_screen.dart`, `keyboard_keycap_style.dart`,
  `keyboard_layout_painter.dart`, `keyboard_visual.dart`, y sus dos
  tests). Causa: un commit local `fix` (WIP, versión temprana y más
  simple de la misma feature) chocó al rebasar sobre el remoto, que ya
  tenía esa feature completa y probada (`9003706`, "full keyboard
  customization..."). Se resolvió tomando la versión remota en los 7
  archivos (estrictamente más completa: RGB, teclas extra, remapeos,
  transparencia de keycaps — nada se perdió, el commit local quedó
  recuperable por reflog) y se aplastaron los dos commits `fix`
  resultantes en uno solo, bien formado: `feat(content): add Go CLI
  programs learning path`. `content_category.dart` quedó en **375
  líneas** tras las 4 categorías `cli*` nuevas. **Gate completo
  verificado tras la resolución: `bash tool/check.sh` verde — 822
  tests** (un flake aislado de
  `survival_controller_drift_integration_test.dart` en una corrida no se
  repitió al re-correr la suite completa ni en aislado), format/analyze/
  arquitectura limpios. Rama local 1 commit adelante de `origin/main`,
  lista para `git push`.
- Set de íconos: **Lucide** (`lucide_icons_flutter`), no Material `Icons.*`
  — elegido por combinar con Geist (misma familia visual que usa Vercel/
  shadcn). `cupertino_icons` (vestigial, nunca usado) fue removido.
- Splash de arranque (`lib/core/splash/app_startup_splash.dart`): logo +
  wordmark + eslogan (`splashSlogan` en/es) sobre `colorScheme.surface` al
  abrir la app, ver sesión de hoy.
- **Eslogan oficial**: "Type better, not just faster." / "Escribe mejor,
  no solo más rápido." (`splashSlogan`) — ver `MARKETING.md` §3 para el
  porqué (conecta directo con SPEC.md principio #2, "la métrica es el
  producto").
- Mark de marca (`assets/icons/r_mark.svg`, usado en `WindowBar` y el
  splash): **cuadrado redondeado plano (radio 60, sin bisel/dish) con la
  R recortada en negativo** — el trazo real de Geist Mono Bold, no
  dibujada a mano. Pasó por 3 iteraciones con el usuario en la misma
  tarde (keycap con bisel falso-3D → R sola sin fondo → este cuadrado
  plano), ver sesión de hoy.
- Exports PNG del mark (`marketing/logo/r-mark-{16..1024}.png`, fondo
  transparente, Ember `#FF5A36` quemado) — material de referencia, **no**
  listado en `pubspec.yaml` (no se empaqueta en la app). Comando de
  regeneración en `MARKETING.md` §6.
- **Lenguaje activo** (SPEC.md §5.7, sesión de hoy): Practice arranca en un
  catálogo de lenguajes con el progreso de cada uno; al activar uno muestra
  su guía y se puede cambiar en cualquier momento ("Cambiar lenguaje").
  Sin candados: todos los lenguajes están disponibles desde el inicio.
- **Sonido de tecleo** sobre `flutter_soloud` (motor SoLoud): cada tecla es
  una voz polifónica independiente (~11 ms tecla→sonido vía render-ahead ring
  en nativo), sin pools de players que reciclar — reemplaza al fix
  pool+breaker de `audioplayers` (sesión de hoy).
- **Teclado del perfil en 3D real con leyendas** (sesión de hoy):
  renderer 3D propio por software (sin paquetes nuevos) — caja extruida,
  plate hundido, keycaps como frustums con esquinas redondeadas, cámara
  con perspectiva, auto-fit al bounding proyectado, culling, z-sorting e
  iluminación por cara (las tapas también se sombrean); hover/press por
  tecla, parallax que sigue al puntero y drag-to-orbit (el ángulo
  persiste), y contraste tecla↔board garantizado por test para las 24
  paletas × 2 brightness. Cada keycap muestra su **leyenda impresa** en
  Geist Mono (proyectada por la misma cámara, auto-ajustada al ancho del
  cap), derivada de los keymaps default reales de QMK para los 24 layouts
  curados y canónica en las familias genéricas. Única excepción
  sancionada al "flat" (`STACK.md` §2.5). El botón de expandir de la
  tarjeta abre `/profile/keyboard`, un inspector a pantalla completa con
  orbit, zoom (rueda/pellizco/botones), press de teclas, reset y pista de
  uso (ver sesión de hoy).
- **Personalización total del teclado** (sesión de hoy): editor dedicado
  `/profile/keyboard/customize` con preview 3D fijo en vivo (pitch 20°,
  órbita por arrastre, tap directo a la edición de la tecla) — formas de
  keycap (redondeado/cuadrado/redondo), **transmisión de luz de la
  tecla** (opaca/shine-through/pudding/translúcida), colores propios de
  keycaps y carcasa, RGB con **11 efectos de firmware** (fijo,
  respiración, arcoíris, ciclo, onda, aurora, estrellas, lluvia,
  degradado, reactivo y onda expansiva) y **luz propia por tecla**,
  geometría **100 % libre** (elegir formato reemplaza la del modelo e
  incluye un lienzo en blanco), metadata de interruptores/materiales/
  formato/conexión/hot-swap/año/notas, leyendas por tecla, teclas extra
  y remapeos funcionales reflejados en las tapas — todo en
  `KeyboardCustomization`, persistido como blob JSON en
  `guest_profiles.keyboard_customization_json` (schema drift **v17**). El
  hero card muestra un resumen de specs y el viewer una ficha completa;
  el visor y el preview reaccionan al teclado físico real (hundir,
  iluminar y sonar); el capture engine de `practice` aplica los remapeos
  (única excepción documentada a "el layout no afecta la clasificación",
  `SPEC.md` §7.3).
- Último release: **v1.11.0** (`5cf284a`). El siguiente push a `main`
  genera release automático desde los Conventional Commits.
- **Deep link a una lección** (`/practice/:pathId/lessons/:lessonId`,
  `LessonDeepLinkScreen`) + compartir enlace de una lección
  (`share_plus`) — ver sesión de hoy. Esquema propio `ridge://app/...`
  (`app_links`), solo Android por ahora. Notificaciones push siguen sin
  implementar (v2, `STACK.md §14`); esto solo deja una lección
  *direccionable* por URL para cuando lleguen.
- **Web ya abre drift** (sesión de hoy): `web/sqlite3.wasm` +
  `web/drift_worker.js` (release `drift-2.35.0`, el mismo del
  `pubspec.lock`) versionados y `DriftWebOptions` en `AppDatabase` — sin
  esto la DB nunca abría en web y las guías/progreso quedaban vacíos.
- **TypeScript es el séptimo lenguaje** (sesión de hoy): curso doble
  `typescript-foundations-v1` (17 lecciones, tour amplio) +
  `typescript-algorithms-v1` (12), 29 snippets solo-curso con dos
  categorías propias (`classesAndObjects`, `modules`).
- **Django vive bajo Python** (sesión de hoy): tres rutas nuevas
  (`python-django-foundations-v1` 21, `python-django-orm-v1` 17,
  `python-django-rest-v1` 17) que llevan una app de bookmarks de
  `django-admin startproject` a una API REST con DRF 3.16, auth por token
  y tests; Python suma 16 categorías propias (`djangoProject` …
  `djangoRestTesting`) y pasa de 24 a 79 snippets.
- **Links del perfil** (sesión de hoy): GitHub + página web personal como
  tarjeta "Links" propia en Profile (`ProfileLinksCard`), editables en
  `EditProfileScreen`; al tocar abren el navegador del sistema
  (`url_launcher ^6.3.2`, dependencia nueva). Handle/URL se normalizan en
  `UpdateProfileCustomizationUseCase` antes de persistir; esquema drift
  **v16** (dos columnas nullable nuevas en `guest_profiles`).
- **Git es el decimonoveno lenguaje** (sesión de hoy): tres rutas
  (`git-foundations-v1` 33, `git-workflows-v1` 24, `git-internals-v1` 15),
  70 snippets solo-curso y diez categorías propias (`gitBasics` …
  `gitMaintenance`). Cada comando se ejecutó de verdad con `git` 2.55 en
  repos desechables deterministas (HOME aislado, autor/fecha fijos) —
  ver sesión de hoy.
- **Linux es el vigésimo lenguaje** (sesión de hoy): tres rutas
  (`linux-foundations-v1` 35, `linux-admin-v1` 30, `linux-networking-v1` 20),
  85 snippets solo-curso y doce categorías propias (`linuxBasics` …
  `backupAndArchives`). Cada comando se ejecutó de verdad en contenedores
  desechables de Arch (`--privileged` para `ip`/`nft`, `--systemd=always`
  con `/sbin/init` para systemd/journal) — ver sesión de hoy.
- **Docker es el vigésimo primer lenguaje** (sesión de hoy): tres rutas
  (`docker-foundations-v1` 25, `docker-compose-v1` 16,
  `docker-advanced-v1` 17), 58 snippets solo-curso y nueve categorías
  propias (`dockerBasics` … `dockerMaintenance`). Cada snippet se ejecutó
  de verdad contra Docker 29 + Compose 5.5 (comandos, Dockerfiles,
  `.dockerignore`, `compose.yaml`, registry local) — ver sesión de hoy.
  Incluye la reparación documentada del árbol de módulos del kernel
  `7.2.2` que tenía roto el bridge de Docker en esta máquina.

---

## Historial de sesiones

### 2026-09-29 — Movimiento Material 3 Expressive (springs, rebote, stagger)

- **Alcance:** pasada de UI "más viva". `AppMotion` gana `SpringCurve`
  (`snappy`/`bouncy`/`gentle`) y tokens (`pressedScale`, `stagger`, estilos
  `sheet`/`dialog`). `spatial` se queda acotado (sin overshoot) porque lo
  usan scrolls y controllers clamped; los springs solo van en animaciones
  implícitas/`flutter_animate`/`CurvedAnimation`.
- **Piezas nuevas:** `core/widgets/bouncy_tap.dart` (escala al presionar),
  `core/widgets/staggered_entrance.dart` (`staggeredIn`/`poppedIn`),
  `core/theme/spring_page_transitions.dart` (todas las plataformas salvo
  Android, que conserva el back predictivo) y
  `core/router/animated_branch_container.dart` (entrada animada al cambiar
  de pestaña, mantiene estado).
- **Aplicado en:** práctica libre, rutas, detalle de lección, progreso,
  perfil, ajustes, logros, catálogo de lenguajes, snippet browser, nav
  bar/rail (ícono seleccionado rebota), diálogos y sheets.
- **Segunda pasada:** botones con morph de forma al presionar
  (`_pressMorph` en `AppTheme`, pill→squircle), switches con check en el
  thumb, `AppFilterChip`, `BouncyTap` en tiles/swatches/paleta, latido del
  contador de Sprint cuando es urgente, corazones de Survival con pop,
  resultado de sesión con stagger, splash/onboarding/PIN con springs.
- **Gotcha tests:** `flutter_animate` arranca cada `Animate` con un `Timer`
  de duración 0; los tests que montan widgets animados deben hacer
  `pump(Duration(milliseconds: 1))` para no dejar timers pendientes. Los
  ítems de `ListView` perezosos (p. ej. secciones del editor de teclado)
  no llevan stagger para no re-animar al hacer scroll.
- **Pendiente:** verificar a ojo en `flutter run -d linux`; ajustar
  intensidades si algo se siente excesivo.

### 2026-09-25 — Zig 0.16.0 como lenguaje solo-curso

- **Alcance:** se añadió Zig como vigésimo tercer lenguaje de contenido:
  `zig_v1.json` (46 snippets activos), `zig-foundations-v1` (34 lecciones) y
  `zig-algorithms-v1` (12). El contenido es solo-curso, sin snippets
  huérfanos ni material de práctica libre.
- **Verificación real:** se descargó el binario oficial x86_64 Linux de Zig
  **0.16.0** (sha256 publicado verificado) y se ejecutaron los 46 harnesses
  con el código exacto del catálogo: 44 con `zig run`, 2 con `zig test`,
  todos con `zig fmt --check` limpio. Los 12 algoritmos se condujeron y
  fuzzearon diferencialmente (ordenamientos contra `std.mem`, búsquedas
  contra escaneos independientes, BFS/DFS contra traversals independientes
  y Dijkstra contra Bellman-Ford, más grafos malformados, opcionales,
  errores, fugas de allocator y límites de desborde).
- **Correcciones reales encontradas por las auditorías adversariales:**
  fuga de `left` en Merge Sort; `catch` antes de enseñarse; `if` sin
  llaves; explanation de slices con límites de compilación; grafos con
  aristas inválidas; `const`/pointee; `ArrayList` de 0.16; recursión,
  `orelse`, switch-expresión y tests introducidos antes de sus usos;
  Dijkstra pasó de centinela ambiguo a `[]?u64` (`null` = inalcanzable).
  La versión final es V3 (34+12), no la primera borrador.
- **Integración:** `ProgrammingLanguage.zig`, tokenizador Zig con test
  propio, assets en `SnippetLocalDataSource`/`LearningPathRepositoryImpl`/
  `pubspec.yaml`, listas de tests, l10n en/es, y dos categorías nuevas
  genéricas `comptime` y `testing` (sin migración de DB; la categoría se
  guarda como texto). `SPEC.md`, `README.md`, `AGENTS.md`/`CLAUDE.md` y la
  skill `content-curriculum` quedaron alineados.
- **Gate:** `dart run tool/validate_content_pack.dart` pasó para los tres
  assets; el audit mecánico pasó; `bash tool/check.sh` terminó verde con
  **831 tests** (el primer intento chocó con el flake de Survival ya
  documentado; aislado y en la repetición completa pasó).
- No se creó commit ni push en esta sesión.

### 2026-09-21 (continuación 2) — Relicenciamiento a open source (AGPL-3.0)

- **Pedido del usuario** (mensaje enviado a mitad de turno, mientras se
  probaba el PKGBUILD): "al finalizar, pushea, genera documento, abrelo a
  open source ridge, docuimenta, con permiso, licencia, libre,
  documentado, estándares, corrección, seguridad, readme, protección de
  rama, publicación, pull request, etc." — interpretado como el checklist
  estándar de "community health files" de GitHub. Se preguntó la licencia
  (dado que Ridge era `proprietary` y `SPEC.md` tiene modelo de negocio) —
  el usuario eligió **AGPL-3.0-or-later** sobre MIT/Apache.
- **`LICENSE`** (repo root): texto completo AGPL-3.0 obtenido verbatim vía
  `api.github.com/licenses/agpl-3.0` (no reconstruido de memoria, para
  exactitud legal).
- **`CODE_OF_CONDUCT.md`**: Contributor Covenant 2.1 verbatim (bajado de
  `contributor-covenant.org/version/2/1/code_of_conduct/code_of_conduct.md`
  — el primer intento a `raw.githubusercontent.com/EthicalSource/...` dio
  404, la URL de contributor-covenant.org sí sirvió el markdown crudo),
  con `[INSERT CONTACT METHOD]` reemplazado por el email del usuario.
- **`CONTRIBUTING.md`** y **`SECURITY.md`** nuevos (en inglés, a diferencia
  de los docs de gobierno del proyecto que son en español — ver razón en
  el propio `README.md`: mayor alcance para contribuidores OSS
  internacionales). `SECURITY.md` documenta honestamente que hoy no hay
  backend online desplegado (superficie de ataque = solo local).
- **`.github/PULL_REQUEST_TEMPLATE.md`**, **`.github/ISSUE_TEMPLATE/bug_report.md`**,
  **`.github/ISSUE_TEMPLATE/feature_request.md`**, **`.github/ISSUE_TEMPLATE/config.yml`**
  (deshabilita issues en blanco, enlaza a `SECURITY.md` para
  vulnerabilidades) nuevos.
- **`README.md`** reescrito parcialmente: badge de licencia actualizado,
  tabla de documentación ampliada (`MARKETING.md`/`Memory.md`/
  `CODE_STANDARDS.md`/`CONTRIBUTING.md`/`SECURITY.md`), sección "Features
  shipped so far" reemplazada (ya no describe el scaffold de "Tasks"
  eliminado hace tiempo — CLAUDE.md ya advertía que esa sección estaba
  obsolesta — ahora lista las features reales de `lib/features/`), tabla
  de stack corregida (persistencia es `drift` hoy, no solo
  `shared_preferences`), referencia rota a un test de Tasks corregida a
  `finish_practice_session_usecase_test.dart`, nueva sección "Installing
  (desktop)" (honesta: packaging listo, nada publicado todavía), nueva
  sección "Contributing, security, and license", sección "Status"
  reescrita.
- **`linux/packaging/dev.omarcodes.ridge.metainfo.xml`**: `project_license`
  cambiado de `LicenseRef-proprietary` a `AGPL-3.0-or-later`. Revalidado
  con `appstreamcli validate` — mismo único warning esperado de siempre
  (`url-not-reachable`, repo aún privado).
- **`linux/packaging/aur/PKGBUILD`**: `license=('custom')` →
  `license=('AGPL3')` (nombre corto de Arch para AGPLv3), se agregó
  instalar `LICENSE` en `/usr/share/licenses/ridge/LICENSE` en
  `package()`. `release-builds.yml` y el manifiesto Flatpak actualizados
  para incluir `LICENSE` dentro del mismo tarball público
  (`/app/share/licenses/dev.omarcodes.ridge/LICENSE` en el Flatpak).
- **Bug real encontrado y descartado durante la re-verificación**: al
  re-probar el PKGBUILD con el nuevo paso de `LICENSE` usando
  `--skipchecksums` y reutilizando el mismo nombre de archivo de tarball
  entre corridas, `makepkg` sirvió una copia **cacheada y desactualizada**
  del tarball (guarda una copia local de fuentes `file://` junto al
  `PKGBUILD`, indexada por nombre de archivo, y no la refresca si el
  archivo remoto/local cambió pero el nombre no) — el `LICENSE` faltaba en
  el paquete resultante. **No es un bug del `PKGBUILD` real**: al repetir
  la prueba con verificación de `sha256sums` real (sin `--skipchecksums`)
  y un directorio de trabajo limpio, todo instaló correctamente
  (confirmado con `tar -tvf` sobre el `.pkg.tar.zst` y `.PKGINFO` mostrando
  `license = AGPL3`). Lección para pruebas futuras con `makepkg` local:
  nunca combinar `--skipchecksums` con reutilizar un nombre de archivo de
  fuente entre iteraciones — el cacheo por nombre de archivo de `file://`
  es real y silencioso.
- **`STACK.md §12`** documenta la decisión de relicenciamiento (por qué
  AGPL y no MIT/Apache: copyleft de red, protege contra un fork-SaaS sin
  devolver cambios) y deja una nota para el usuario: revisar si el modelo
  de negocio de `SPEC.md`/`MARKETING.md` (monetización, competencia) sigue
  siendo coherente con un cliente 100% abierto — no se tocó ninguno de los
  dos documentos porque no mencionan explícitamente "cerrado"/"propietario"
  en el texto, así que no hay conflicto textual, pero sí una posible
  tensión estratégica que es decisión del usuario, no del agente.
- **Protección de rama intentada y bloqueada** (pedida en el mismo
  mensaje): `gh api repos/sazardev/Ridge/branches/main/protection -X PUT
  ...` devolvió 403: *"Upgrade to GitHub Pro or make this repository
  public to enable this feature."* — GitHub no ofrece branch protection en
  repos privados del plan free. Depende del mismo bloqueo de visibilidad
  de arriba: en cuanto el usuario haga público el repo (o si prefiere,
  pague GitHub Pro), este mismo comando queda listo para reintentarse.
- **Push final**: se hizo commit y push de todo lo de esta sesión a `main`
  (ver el commit correspondiente en el historial de git — mensaje
  Conventional Commits `feat(distribution): ...`).

### 2026-09-21 (continuación) — Paquete AUR para Omarchy/Arch (yay/paru)

- **Pedido del usuario**: "vamos preparando todo para que esté disponible
  para Omarchy, ya sea yay o paru para escritorio o el flatpak también
  para debian, etc." — confirma que Flatpak (ya preparado, ver entrada de
  arriba) cubre Debian/Ubuntu/etc., y que Arch/Omarchy necesita su propio
  canal nativo: AUR.
- **`linux/packaging/aur/PKGBUILD`** nuevo. Paquete llamado `ridge` (no
  `ridge-bin` — no hay ni habrá variante compilable desde código fuente,
  así que el sufijo no aplica según la convención de Arch). Verificado
  libre en AUR: `curl .../rpc/v5/info?arg[]=ridge` y `...=ridge-bin` →
  `resultcount: 0` ambos.
- El tarball de release (`ridge-linux-x64.tar.gz`, mismo que consume
  Flathub) se reestructuró para llevar también `dev.omarcodes.ridge.desktop`,
  `dev.omarcodes.ridge.metainfo.xml` y `icons/hicolor/` — un `PKGBUILD`
  externo (repo separado en AUR) no tiene forma de leer nuestro repo, así
  que todo lo que necesita debe ir en esa única descarga pública. El
  manifiesto Flatpak se simplificó de paso: ya no necesita una segunda
  fuente `type: dir` para esos archivos, ahora vienen en el mismo
  `type: archive`.
- **Probado de verdad en esta máquina** (Omarchy trae `makepkg`/`pacman`
  nativamente): armé un tarball sintético con la misma forma que el real
  (ejecutable falso + `lib/`/`data/` + los archivos de packaging reales) y
  corrí `makepkg -f --nodeps --skipchecksums` contra el `PKGBUILD` apuntando
  a ese tarball local — compiló limpio y el `.pkg.tar.zst` resultante tiene
  exactamente el árbol esperado (`/usr/bin/ridge` symlink → `/usr/lib/ridge/ridge`,
  `lib/`/`data/` junto a él, `.desktop`/metainfo/los 4 tamaños de ícono en
  sus rutas `/usr/share/*`). También corrí `makepkg --printsrcinfo` (genera
  `.SRCINFO` válido) y `desktop-file-validate` sobre el `.desktop` (pasa,
  con un *hint* no bloqueante sobre tener dos categorías principales
  `Development;Education;` — intencional, ver `MARKETING.md` §2 "doble
  comunidad").
- **CI** (`.github/workflows/release-builds.yml`, job `aur` nuevo, corre
  después de `linux`): bumpea `pkgver`/`source`/`sha256sums` del PKGBUILD
  en cada tag (siempre), regenera `.SRCINFO` con `makepkg` dentro de un
  contenedor `archlinux:latest` oficial (el runner `ubuntu-latest` no
  tiene `pacman`), y solo si existe el secret `AUR_SSH_PRIVATE_KEY` hace
  `git push` a `ssh://aur@aur.archlinux.org/ridge.git` — mismo patrón
  "materializa solo si el secret real existe" que ya usa la firma de
  Android (`ANDROID_KEYSTORE_BASE64`) en este mismo archivo. **A
  propósito, no se usó ninguna GitHub Action de terceros** para el paso de
  push (a diferencia del `flatpak-github-actions/flatpak-builder@v6` que sí
  se usa para Flatpak) — maneja una llave SSH real con permiso de escritura
  sobre el namespace de AUR, así que se implementó con git/ssh plano +
  `ssh-keyscan` (TOFU, el patrón estándar documentado por el wiki de Arch
  para CI contra AUR) en vez de confiar esa llave a una Action publicada
  por un tercero.
- **Importante — el primer push A ES la publicación**: en AUR no existe un
  paso separado de "crear el paquete"; clonar `ridge.git` (vacío, porque
  el nombre está libre) y hacer el primer `git push` con una llave SSH
  válida de una cuenta real **es** la submission. O sea: en cuanto el
  usuario complete el setup de abajo, el próximo tag publica Ridge en AUR
  automáticamente, sin ningún paso manual adicional de "crear/reclamar" el
  paquete.
- **Pendiente, acción del usuario** (no depende de código): (1) crear una
  cuenta en aur.archlinux.org, (2) generar un par de llaves SSH y
  registrar la pública en esa cuenta, (3) guardar la privada como el
  secret de GitHub Actions `AUR_SSH_PRIVATE_KEY` de este repo. Hasta
  entonces el job `aur` corre pero su paso final de `push` se salta
  (`if: env.AUR_SSH_PRIVATE_KEY != ''`), sin fallar el pipeline.
- Igual que con Flathub: el job `aur` también depende de que el repo sea
  público (bloqueado hoy — ver entrada anterior) para poder descargar el
  tarball al bumpear `sha256sums` locales de verificación manual, aunque
  el bump del PKGBUILD en sí no requiere descargar nada.

### 2026-09-21 — Auto-actualización desktop: preparación Flathub (Linux)

- **Pedido del usuario**: automatizar la actualización de Ridge en
  Linux/desktop (explícitamente no aplica a Android/mobile). Aclarado por
  preguntas: es para **usuarios reales (beta testers/lanzamiento)**, no
  solo para uso personal, y el alcance de esta sesión es **Linux**
  (Windows queda para otra sesión). El usuario eligió **Flathub oficial**
  como distribución (no un repo Flatpak propio ni GitHub Pages) —
  `STACK.md §12` ya documentaba esto como el plan a mediano plazo
  ("Auto-actualización: Gestionada por Flatpak").
- **Hecho esta sesión** (`linux/packaging/`):
  - Íconos hicolor generados con ImageMagick desde
    `assets/icons/ridge_launcher_master.png` (1024×1024) en 64/128/256/512
    (`packaging/icons/hicolor/<size>x<size>/apps/dev.omarcodes.ridge.png`) —
    resuelve el pendiente que ya estaba anotado más abajo.
  - `dev.omarcodes.ridge.metainfo.xml` (AppStream) nuevo: `project_license:
    LicenseRef-proprietary` (Ridge es cerrado — badge de licencia en
    README.md — y Flathub sí acepta apps propietarias bajo ese marcador,
    no exige FOSS), `metadata_license: CC0-1.0`, descripción/summary/
    keywords/categorías, `<developer>` (Omar Flores), `<content_rating
    type="oars-1.1">` vacío (sin contenido sensible) y `<releases>` con
    las últimas 2 versiones desde `CHANGELOG.md`. Validado con
    `appstreamcli validate` (instalado en esta máquina) — pasa salvo el
    warning esperado `url-not-reachable` en `<url type="homepage">`
    (apunta al repo privado como placeholder, ver TODO en el XML).
  - `dev.omarcodes.ridge.yml` (manifiesto Flatpak) actualizado para
    instalar el metainfo y los 4 tamaños de ícono (antes solo instalaba un
    256×256 desde el master sin redimensionar).
- **Descubrimiento importante, no resuelto todavía** (documentado en
  `STACK.md §12`): el manifiesto Flatpak actual empaqueta el `bundle/` que
  `flutter build linux --release` deja en el mismo runner de
  `release-builds.yml` (`type: dir` a una ruta local del propio CI). Eso
  funciona para nuestro CI, pero **no funciona para el builder real de
  Flathub** — no tiene acceso a nuestro repo privado ni a ese artefacto
  local. El patrón estándar de Flathub para apps propietarias (igual que
  Spotify/Slack/Discord/Zoom) es que el módulo descargue un **tarball
  público del bundle ya compilado** (`type: archive` + `sha256`), sin
  tocar el código fuente (que sigue privado). **Falta decidir dónde alojar
  ese tarball público** (repo de GitHub separado y público solo para
  binarios vs. servidor/bucket propio) antes de poder terminar el
  manifiesto y abrir el PR de submission — quedó como pregunta abierta
  para la próxima sesión, no se creó ningún recurso público todavía.
- **Resuelto tras la pregunta de hosting**: el usuario decidió hacer
  **público el repo existente** (`sazardev/Ridge`), no crear un repo
  separado solo para binarios. Con eso decidido, se implementó el resto de
  la tubería en esta misma sesión (`.github/workflows/release-builds.yml`,
  job `linux`): compila el bundle, lo empaqueta en
  `ridge-linux-x64.tar.gz` (contenido plano, sin carpeta `bundle/`
  envolvente — importante para que el `dest: bundle` del manifiesto
  cuadre), crea (si no existe) el GitHub Release del tag con notas
  extraídas de `CHANGELOG.md`, sube el tarball como *asset*, y **sustituye
  los placeholders `__RIDGE_TARBALL_URL__`/`__RIDGE_TARBALL_SHA256__`** del
  manifiesto Flatpak (`linux/packaging/dev.omarcodes.ridge.yml`, que ahora
  usa `type: archive` en vez de `type: dir`, con un bloque
  `x-checker-data` para que `flatpak-external-data-checker` de Flathub
  detecte releases nuevos solo). Este job ahora depende de que los
  *release assets* sean descargables sin autenticación — **solo funciona
  una vez el repo sea público**.
- **Bloqueado por el clasificador de seguridad de auto mode**: el intento
  de ejecutar `gh repo edit --visibility public` fue denegado
  automáticamente (categoría "Create Public Surface" — cambiar la
  visibilidad de un repo es una acción que el harness nunca autoriza solo).
  Se hizo antes un escaneo de `git log --all` buscando secretos reales
  (llaves AWS, private keys, tokens, contraseñas) — **no se encontró
  ninguno** (el único `password=` en todo el histórico es código de
  ejemplo Django dentro de un snippet de contenido curricular, no una
  credencial real); tampoco hay `.env`/`key.properties`/`*.jks` comiteados
  nunca (están en `.gitignore` desde el inicio). El usuario debe hacer el
  cambio de visibilidad él mismo (GitHub UI → Settings → Danger Zone, o
  `gh repo edit --visibility public` desde su propia terminal) — nótese
  que el badge `license-proprietary` de `README.md` sigue siendo válido
  con el repo público (código público ≠ código libre; "todos los derechos
  reservados" es perfectamente compatible), pero es una decisión de
  negocio que confirmó él, no algo que se infiera del código.
- **Pendiente todavía** (no depende de código, son acciones/decisiones del
  usuario): hacer público el repo (bloqueante para que el job `linux`
  vuelva a pasar en el próximo tag — hoy fallará con un 404/401 al intentar
  descargar el asset del Release hasta que se haga público), una captura
  de pantalla real de la app para `<screenshots>` del metainfo (Flathub la
  exige), un dominio real para `<url type="homepage">` (hoy apunta al repo
  como placeholder) y su verificación para el app-id `dev.omarcodes.*`, y
  finalmente abrir el PR a `flathub/flathub`. Windows quedó fuera de
  alcance de esta sesión a pedido del usuario.

### 2026-09-13 — Curso Go: Programas CLI completos (`go-cli-programs-v1`)

- **Pedido del usuario**: un curso de Go enfocado a "programas CLI",
  explícitamente **no** paso a paso como `go-foundations-v1` — cada
  lección debe ser un programa completo e independiente de inicio a fin
  (sumas, menús con secciones, tablas de multiplicar, cosas sencillas, y
  desafíos como voltear texto/fonts, mayúsculas), pensado "al máximo".
- **20 lecciones, 4 categorías nuevas** (`ContentCategory.cliArithmetic`,
  `cliTextTools`, `cliMenus`, `cliChallenges` — bloque contiguo cada una,
  patrón ya usado por `go-tui-notes-v1`/`go-ddd-hexagonal-notes-v1`: solo
  necesitan >=1 entrada activa total, no la grilla densa de las 5
  categorías core): `climath-{001..005}` (suma, C↔F, tabla de multiplicar,
  FizzBuzz, primos hasta 50), `clitext-{001..005}` (mayúsculas, invertir
  string, palíndromos, contar palabras/vocales, voltear texto de cabeza
  con `map[rune]rune` de escapes Unicode), `climenu-{001..005}` (menú
  simple con `bufio.Scanner`, calculadora interactiva con clausura,
  conversor de unidades, lista de tareas en memoria, libreta de
  contactos con struct) y `clichal-{001..005}` (adivinar número con
  `rand` sembrado, piedra-papel-tijera, frecuencia de palabras con
  `sort.Slice`, cifrado César, quiz de trivia con puntaje).
- **Cada snippet es el programa completo** (uno o más `func`/`type` de
  nivel de paquete, nunca un fragmento), siguiendo la convención ya
  usada por todo `go_v1.json`: el campo `code` omite `package main` y
  los `import`, igual que `go-http-001` y el resto del catálogo.
- **Verificación real, no confiada a la IA**: Go no estaba instalado en
  esta máquina ni había acceso a `docker.sock` (permiso denegado, sin
  grupo `docker`) — se resolvió con `mise install go@1.27.1` (sin sudo,
  aislado en `~/.local/share/mise`). Los 20 programas se compilaron y
  ejecutaron de verdad con `mise exec go@1.27.1 -- gofmt -l` / `go run`,
  incluyendo los interactivos con stdin real (`printf ... | go run`) para
  cubrir cada rama de sus menús; la matriz completa de piedra-papel-
  tijera se verificó por separado contra las 9 combinaciones. Bug real
  encontrado y corregido en el camino: escribir `ɐ` literal en un
  comando de shell lo convierte en el carácter Unicode real antes de que
  bash lo vea (la capa de tool-calling lo decodifica), así que el mapa de
  "voltear texto" se generó con un script Python que arma el escape en
  tiempo de ejecución (`chr(92) + "u0250"`) para que el `.go` final quede
  ASCII puro de verdad.
- **Integración completa**: 20 entradas nuevas en `go_v1.json` (273→293),
  archivo nuevo `go_cli_programs_v1.json`, registrado en
  `pubspec.yaml`, `learning_path_repository_impl.dart` y
  `_learningPathAssetPaths`/`_topicCategories` de
  `snippet_catalog_completeness_test.dart`; 4 claves ARB nuevas
  (`categoryCliArithmetic/CliTextTools/CliMenus/CliChallenges`) en
  ambos `.arb` + `content_labels.dart` + `flutter gen-l10n`;
  `content_drift_integration_test.dart` actualizado (1347→1367 total,
  489→495 beginner, y los 5/14 ids nuevos con `_`/`%` literal en su
  `code` añadidos a los sets hardcodeados de `findContainingSymbols`).
- **Bloqueador externo, no de este curso**: a mitad de sesión apareció un
  `git pull --rebase` ya en curso (no iniciado por este agente) con
  conflictos reales sin resolver en 7 archivos de personalización de
  teclado — ver el bullet de "Gate de calidad" arriba. No se tocó ese
  rebase; se verificó el curso CLI con `flutter test
  test/features/content/` (340 tests) y `check_architecture.dart` en vez
  del gate completo.

### 2026-09-13 — Personalización total del teclado (editor 3D dedicado, metadata, RGB y remapeo funcional)

- **Pedido del usuario**: llevar la personalización del teclado al máximo —
  verlo en 3D mientras se elige, forma de keycaps (redondo/cuadrado),
  teclas extra que el layout no tiene, mapeo tecla por tecla, RGB, más
  metadata — pidiendo explícitamente **primero la fundación de datos y su
  persistencia**. Decisiones acordadas por pregunta: pantalla dedicada
  `/profile/keyboard/customize`, tres formas de keycap (redondeado,
  cuadrado, redondo), RGB con color + efectos animados (fijo, respiración,
  arcoíris), mapeo = leyendas por tecla + teclas extra + **remapeo
  funcional real**, y metadata de interruptores/materiales/formato/
  conexión/notas.
- **Fundación (lo primero)**: `KeyboardCustomization` (freezed, dominio
  puro) + enums (`KeycapShape`, `RgbEffect`, `SwitchType`,
  `KeycapMaterial`, `CaseMaterial`, `KeyboardPhysicalLayout`,
  `KeyboardConnectionType`); `KeyboardShapeFamily` movido de
  `presentation` a `domain`; DTO + mapper JSON tolerante
  (`keyboard_customization_mapper.dart`: un enum desconocido degrada solo
  ese campo, un blob corrupto o un array no-objeto → `null`, las entradas
  a medio formar se podan); columna nueva
  `guest_profiles.keyboard_customization_json` (schema drift **v17**);
  separación de escrituras — `updateCustomization` (flair) y
  `updateKeyboardSetup` (layout+marca+modelo+blob) no comparten columnas,
  así los dos editores nunca se pisan (test de regresión en
  `profile_drift_integration_test.dart`); `UpdateKeyboardSetupUseCase`
  con límites reales. Tests: mapper round-trip/tolerancia, usecase,
  drift v17.
- **Render 3D**: `keyboard_customization_geometry.dart` (overrides de
  leyenda por posición física `keyboardKeyIdFor`, teclas extra
  autocolocadas en columnas a la derecha del tablero), `keyboard_scene_
  faces.dart` + `keyboard_scene_shading.dart` extraídos de
  `keyboard_scene_3d.dart` (el archivo pasó de 633 a ~440 líneas, límite
  500); formas de keycap con radio por forma (redondo = 6 segmentos por
  esquina y radio mitad del cap), colores ARGB propios de keycaps/carcasa,
  y RGB con halo radial + tinte de tapas/laterales/plate y un
  `AnimationController` que solo vive mientras el efecto es animado.
  `KeyboardVisual` gana `customization` y `onKeyTap` (disparado en
  pointer-up, para que abrir el editor no deje el press pegado).
- **Editor**: `/profile/keyboard/customize` (pantalla dedicada, preview
  3D fijo e interactivo arriba, formulario abajo) con secciones de
  marca/modelo/layout, forma, keycaps/colores, iluminación, hardware,
  historia (año/notas) y tecla por tecla (chips de leyendas, extras,
  remapeos); sheets de edición de tecla y de remapeo; `EditProfileScreen`
  pierde la sección de teclado y en su lugar enlaza con una tarjeta al
  editor; el hero card suma un botón de lápiz.
- **Práctica**: el capture field aplica los remapeos funcionales leyendo
  `keyboardRemapsByNameProvider` (keepAlive, índice por
  `PhysicalKeyId.name`) en cada keydown, con forma shift; las métricas
  siguen registrando la tecla física real. `SPEC.md` §7.3 documenta la
  excepción como la única pieza que cambia qué carácter produce una tecla
  (decisión del usuario, solo teclas imprimibles).
- **Vitrina**: `keyboard_specs.dart` (filas etiqueta/valor compartidas)
  alimenta el resumen del hero card y la ficha completa del viewer
  (acción de info).
- **Segunda vuelta (mismo día, pedido del usuario)**: luces **por
  tecla** (`KeyboardKeyLight`, color ARGB por posición física o por id de
  tecla extra): con RGB encendido, cada tecla con luz propia recibe un
  charco radial sobre el plate (`_plateGlowFaces`) y un glow aditivo a
  través de la tapa (`glowColor` de `KeyboardFace`, `BlendMode.plus` en el
  painter), con la leyenda teñida hacia la luz; el sheet de cada tecla
  gana el campo "Luz de la tecla" (default = color global). Libertad
  geométrica total: un formato elegido **reemplaza** la geometría del
  modelo (antes ganaba el layout curado), incluida
  `KeyboardShapeFamily.custom` — un lienzo en blanco construido solo con
  teclas extra (bloque macro-pad desde el origen). El preview del editor
  es ahora un product-shot en vivo (pitch 20°, órbita por arrastre con
  umbral para no romper el tap, botón de pantalla completa que abre el
  viewer con el estado **sin guardar**); los remapeos se reflejan en las
  tapas (carácter nuevo primario, viejo como leyenda secundaria, vía
  `_legendToPhysicalKeyName`) y las familias genéricas 60/65/75/TKL
  ganaron las leyendas de su clúster de navegación. El screen volvió a
  partirse (`keyboard_customize_preview.dart` con la órbita propia).
- **Tercera vuelta (mismo día, pedido del usuario)**: efectos típicos de
  teclado completos — se suman **onda** (banda gaussiana de luz que
  recorre el tablero) y **reactivo** (base tenue; cada pulsación destella
  y decae, las teclas sostenidas quedan encendidas), y **los clicks
  destellan en cualquier modo** con RGB encendido. El viewer y el preview
  del editor ahora **reaccionan al teclado físico real**: un `Focus`
  observa keydown/keyup, los mapea por posición física
  (`physicalKeyIdFor` de `practice`) y `KeyboardKeyEffects`
  (ticker propio, se detiene solo) hunde/ilumina la tapa equivalente;
  los remaps no mueven la reacción (se mapea contra el layout base). El
  scene volvió a partirse: `keyboard_scene_effects.dart` (onda + charcos
  de plate) y `keyboard_key_effects.dart` (niveles/pulsos), ambos < 500
  líneas. Render verificado con harness PNG (onda cian atravesando el
  75 % y reactivo magenta con WASD sostenidas + destellos).
- **Cuarta vuelta (mismo día, pedido del usuario — "más efectos estándar
  de la industria, transmisión de luz, escribir = tap, editor con UI")**:
  el set RGB pasa de 5 a **11 efectos de firmware** (fijo, respiración,
  arcoíris, ciclo de color, onda, aurora, estrellas, lluvia, degradado,
  reactivo y **onda expansiva/ripple**) elegidos en una **rejilla visual
  de tiles con ícono** (`keyboard_effect_grid.dart`, no chips de texto).
  Los efectos animados se resuelven por tecla en
  `keyboard_scene_effects.dart` (`effectIntensity`/`rgbTint` por
  posición: banda gaussiana, swells de aurora, twinkles con hash por
  tecla, gotas que caen con desfase por columna, blend vertical en el
  degradado, hue global en el ciclo) y el ripple se calcula por
  **distancia al origen de cada pulsación** (`rippleBoost`, radio a
  7 u/s, vida 1.4 s) — se esparce desde la tecla que escribes.
  **Transmisión de luz por keycap**: nuevo enum `KeycapTransparency`
  (opacas / shine-through / pudding / translúcidas) con factores en
  `KeyboardKeycapStyle` (top/side/lente/glow) — los opacos dejan la
  leyenda oscura y la luz solo entre teclas; pudding ilumina los
  laterales; shine-through la leyenda. Persistido en el blob (mapper con
  fallback `translucent`) y mostrado en la ficha de specs. El visor
  fullscreen y el preview del editor: **escribir en tu teclado real es
  como darle tap** — hunde, ilumina y ahora **suena** (se reproduce el
  click de `keystrokeSoundPlayer` del motor de práctica). El editor se
  rediseñó como configurador: **cards con ícono por sección**, tira de
  **navegación rápida** que hace scroll a cada sección
  (`keyboard_section_nav.dart`), y **reset total** en el AppBar.
  Refactor de límites: la edición por tecla pasó a un **mixin**
  (`keyboard_customize_key_editing.dart`), el preview ya era widget
  propio y `keyboard_scene_effects.dart` concentra el look de los
  efectos; todos los archivos <500. Render verificado con harness PNG
  (ripple anaranjado expandiéndose desde la G, lluvia cian, estrellas
  violeta, pudding vs opaco).
- **Verificación**: `bash tool/check.sh` verde de punta a punta —
  **822 tests**, format/analyze/arquitectura limpios. Tests nuevos:
  ripple (el anillo enciende la tecla lejana al llegar), ciclo de color,
  factores de transmisión por estilo, mapper con `keycapTransparency`;
  ajustados los tests de pantalla (títulos duplicados por la nav, scroll
  al ListView vertical) y el del viewer (copy nuevo).

### 2026-09-13 — Leyendas de teclas (font Geist Mono, datos reales de QMK)

- **Pedido del usuario**: que se vean las letras de las teclas en el
  teclado 3D.
- **Pipeline**: `KeyboardKeySpec` gana `label`/`label2` opcionales
  (freezed + DTO + mapper; `label2` = símbolo shift, dibujado arriba);
  `KeyboardCamera.canvasMatrix` expone la proyección como matriz de
  canvas (la traslación del centro de proyección va **pre-multiplicada**,
  no apilada: el término de perspectiva también la multiplica, si no el
  divide homogéneo no coincide con `project` — lo cazó un test); el
  painter dibuja el texto con `Canvas.transform(canvasMatrix)` en el
  plano de la tapa (perspectiva real, no texto escalado), con
  TextPainters cacheados a font-size 1 y auto-fit al ancho del cap
  (`maxWidth` en la leyenda) para que «Backspace» o «PrtSc» no invadan
  teclas vecinas; Geist Mono Medium, color `keyLegend` nuevo del
  `KeyboardKeycapStyle` (mix 0.82 hacia el extremo oscuro, contraste
  ≥2.5 por test en las 24 paletas × 2 brightness).
- **Datos**: los 24 layouts curados se enriquecieron con las leyendas
  **reales de los keymaps default de QMK** (`keymaps/default/keymap.c`,
  heredados de directorios padre cuando aplica), mapeando cada argumento
  del `LAYOUT(...)` a la clave física por coordenadas (x,y) del
  `info.json`; el script elige la capa más poblada (las capas Mac de
  Keychron dejan F3/F4 en `KC_NO`), normaliza mod-taps
  (`CTL_T(KC_ESC)` → `Esc`), nombres Mac (`KC_LCMD` → `Cmd`), rotary
  (`RM_VALU` → `Vol+`), flechas (`KC_RGHT` → `→`), etc. Combos como
  `G(KC_D)` (la tecla extra del GX87) quedan **en blanco a propósito**.
  Nota de procedencia añadida a `THIRD_PARTY_SOURCES.md` (las leyendas no
  son geometría extraída; salen del keymap default GPL-2.0). Las familias
  genéricas (`standard_family_key_specs.dart`) ahora llevan leyendas
  QWERTY canónicas escritas en Dart (incluye numpad completo y columnas
  del `splitErgo`).
- **Tests**: cámara (la matriz de canvas reproduce `project` con puntos y
  ángulos), escena (leyenda en la tapa, `label2` con tamaño menor, stepped
  keys la imprimen una sola vez, teclas sin leyenda no pintan nada),
  contraste de tinta, y el data source real exige ≥90% de teclas con
  leyenda en cada layout curado. `bash tool/check.sh` verde: **768 tests**
  (una corrida previa cayó por el flaky conocido de `survival_controller`
  bajo carga; pasa aislado y en la re-corrida).
- **Ajuste tras feedback del usuario**: las leyendas estaban algo
  grandes y descentradas. Tamaños bajados (primaria 0.34u→0.27u,
  secundaria 0.24u→0.19u) y par compactado (separación 0.185u→0.10u);
  además el painter ahora centra **por glifo**: mide el `ascent` real
  (`computeLineMetrics()`, 0.773em en Geist Mono Medium) y pinta en
  `-(ascent − capHeight/2)` con capHeight 0.7em, en vez de centrar la
  caja de línea con descendente (que dejaba las letras ~0.077em altas).
  Verificado con renders de acercamiento en reposo y con orbit.
- **Segundo ajuste (feedback: pantallas chicas)**: en mobile los keycaps
  se veían «rotados ~15° a la izquierda y más redonditos» — no era
  rotación real: los radios del theme en px (4/12) convertidos por el
  `unit` ajustado daban 0.19u por tecla y 0.57u por caja en una pantalla
  de 360px, y como cada esquina se muestrea con 3 segmentos, los chords
  del arco a 30° dominaban el contorno (bordes dominantes a ±15°) → el
  cap se leía como un octágono rotado, y el texto con él. Fix:
  `_maxKeyCornerFraction = 0.09` y `_maxCaseCornerFraction = 0.22`
  (fracciones independientes del tamaño) en `keyboard_scene_3d.dart`;
  desktop queda igual (0.073/0.218) y mobile se ve igual de cuadrado.
  Verificado con renders a 360×560 (viewer portrait) y crops al 500%.
- **Verificación visual**: harness temporal de render (painter→PNG con
  las fuentes Geist reales cargadas vía `FontLoader`) para GX87, GMMK
  Pro, HHKB, Voyager, ErgoDox y familia TKL en dark/light y con orbit —
  leyendas legibles, centradas y ajustadas; harness borrado antes de
  cerrar. La app de Linux ya no estaba corriendo al final de la sesión,
  así que la verificación en vivo quedó pendiente para el próximo
  `flutter run` (el pipeline es el mismo que renderizó el harness).
- **Docs**: `STACK.md` §2.5, `AGENTS.md`+`CLAUDE.md` espejados y
  `THIRD_PARTY_SOURCES.md`.

### 2026-09-13 — Teclado del perfil en 3D real (renderer propio, sin dependencias)

- **Pedido del usuario**: pasar la vista del teclado de "2D en entorno 3D"
  a **3D real** — profundidad de teclas, caja y todo lo demás.
- **Decisiones con el usuario** (preguntadas antes de codificar): renderer
  3D propio sobre Canvas (sin paquetes de motor, mantiene
  Android/Linux/Windows/Web y el CI livianos) y geometría 3D + luz por
  cara (sin dish, sin sombra de contacto, sin leyendas) — las dos
  recomendadas.
- **Arquitectura nueva** (todo bajo
  `lib/features/profile/presentation/widgets/keyboard/`):
  - `keyboard_geometry_3d.dart`: `Vec3`; `KeyboardCamera` con `yaw`/`pitch`,
    proyección en perspectiva (`D = 4.0 × lado mayor`, teleobjetivo
    suave), `unprojectToPlane` (rayo→plano para hit-testing),
    `depthOf` para ordenar y **auto-fit al bounding proyectado**: el
    `unit` de reposo es el tope y a ángulos grandes el tablero solo se
    encoge (nunca crece ni se corta); `roundedRectOutline` muestrea
    esquinas redondeadas en polilínea.
  - `keyboard_scene_3d.dart`: constructor de escena — case con paredes +
    tapa + plate hundido, keycaps como frustums (base, tapa inset por
    taper 0.075u, esquinas redondeadas), stepped keys como dos caps, z
    real para el press (`sink = keyDepthFraction`), culling de caras
    traseras, orden pintado por profundidad y luz direccional fija al
    espectador con wrap; las tapas también se sombrean.
  - `keyboard_layout_painter.dart` reescrito: solo vuelca caras
    ordenadas (gradiente sancionado en las tapas) y sella las grietas de
    antialiasing entre quads con un stroke del mismo color.
  - `keyboard_visual.dart` reescrito: parallax con `AnimationController`
    propio (ya no hay `Transform` interno), cámara por frame, hit-testing
    por desproyección al plano `keyTopZFor(style)`; API público intacto,
    los tres usos (hero, editor, viewer) no cambiaron.
  - `keyboard_keycap_style.dart`: defaults de profundidad subidos
    (`keyDepthFraction` 0.10→0.26, `caseDepthFraction` 0.16→0.40).
- **Bugs cazados durante el desarrollo** (por tests y renders de prueba):
  (1) `bezel` devolvía píxeles pero se usaba como unidades →
  plate vacío; (2) las paredes de cada keycap reusaban las coordenadas de
  la base arriba (quedaban verticales, normal z=0, el culling las
  borraba) → debían usar el outline superior inset; (3) con radio
  superior 0 el outline caía de 12 a 4 puntos → mismatch de índices (se
  fuerza radio > 0); (4) `Rect.toString()` redondea a 1 decimal en este
  Dart, lo que engañó los prints de debug un rato.
- **Tests**: `keyboard_geometry_3d_test.dart` (Vec3, outline, fit,
  round-trip project/unproject con ángulos, depth, hit-testing con
  rotación y stepped keys) y `keyboard_scene_3d_test.dart` (escena
  completa, press baja el centroide a pitch>0, hover tinta, la geometría
  cambia al orbitar, sombreado lateral variable); adaptados
  `keyboard_layout_geometry_test.dart`, `keyboard_visual_test.dart`,
  `profile_keyboard_hero_card_test.dart` y
  `keyboard_viewer_screen_test.dart` (se asserta
  `KeyboardLayoutPainter.yawDegrees/pitchDegrees` en vez del `Transform`).
  `bash tool/check.sh` verde: **761 tests**.
- **Verificación visual real**: harness temporal de render
  (painter→PNG, nunca commiteado) para iterar rest/turn/extreme/
  hover-press en dark y light y en los tamaños reales (hero 320×176,
  viewer 900×700); app Linux viva con hot reload y
  `ext.flutter.inspector.screenshot` por VM service (captura la app sin
  depender del compositor, clave cuando el usuario cambia de workspace);
  drag/hover/press sintéticos por `GestureBinding.handlePointerEvent` —
  confirmados el orbit con perspectiva, el hover tintado con hit-testing
  exacto y el press hundiendo la tecla. Los archivos temporales se
  borraron antes de cerrar.
- **Docs**: `STACK.md` §2.5 reescrito (renderer 3D real, auto-fit,
  iluminación por cara) y `AGENTS.md`+`CLAUDE.md` espejados.

### 2026-09-13 — Teclado del perfil a pantalla completa (`/profile/keyboard`)

- **Pedido del usuario**: poder dar click al teclado del Profile para
  abrirlo a pantalla completa y manipularlo/verlo con más detalle.
- **Decisiones con el usuario** (preguntadas antes de codificar): ruta
  dedicada no-shell `/profile/keyboard` (misma forma que `/achievements`),
  botón de expandir en la esquina de la tarjeta (el click sobre el
  tablero sigue hundiendo teclas, no abre el viewer), y dentro del viewer
  orbit con drag, zoom (rueda + pellizco + botones), press de teclas,
  botón de reset y pista de uso. Todas elegidas por el usuario.
- **Nuevo `KeyboardViewerScreen`**
  (`lib/features/profile/presentation/screens/keyboard_viewer_screen.dart`):
  el mismo `KeyboardVisual` a tamaño completo con `AppBar` (caption marca
  + modelo), `EscapeToPop` y una píldora tonal de controles
  (`zoom out`/`reset`/`zoom in`, deshabilitados en los límites). Orbit:
  `GestureDetector.onScale*`; pinch: `_zoomAtScaleStart * details.scale`
  (el recognizer re-baseliza al cambiar el número de punteros); rueda:
  `PointerScrollEvent`/`PointerScaleEvent` con paso multiplicativo `exp`;
  zoom 0.5–3.0 en pasos de 1.25; clamp de orbit ±75° yaw / ±45° pitch
  (más amplio que el hero card).
- **Hallazgo real de gestos**: al ser el único recognizer de la arena, el
  `ScaleGestureRecognizer` gana **en el pointer-down** (no tras el slop),
  así que suspender el press en `onScaleStart` mataba el click de tecla —
  lo cazó un test (press a través del zoom). Fix: umbral de 4 px sobre
  `ScaleStartDetails.localFocalPoint` antes de empezar a orbitar (mismo
  criterio que el hero card), y `_dragging` se activa recién en el primer
  `onScaleUpdate` que lo cruza. Documentado en el código.
- **Hero card**: `Stack` con `IconButton` (`LucideIcons.maximize2`,
  `profileKeyboardViewFullscreenAction`) en la esquina superior derecha
  que hace `context.push('/profile/keyboard', extra: profile)`; su target
  de 48 px queda por encima del tablero, así que no dispara el press de
  la tecla de abajo.
- **Router**: ruta no-shell `/profile/keyboard` junto a `/profile/edit`,
  `GuestProfile` en `extra` (misma forma).
- **l10n**: 5 claves nuevas en/es (`profileKeyboardViewFullscreenAction`,
  `profileKeyboardViewerHint`, `profileKeyboardZoomInTooltip`,
  `profileKeyboardZoomOutTooltip`, `profileKeyboardResetViewTooltip`) +
  `flutter gen-l10n`.
- **Tests**: `keyboard_viewer_screen_test.dart` (6: render con caption/
  controles/pista, drag de mouse orbita, pinch de dos dedos, rueda,
  botones+reset, press de tecla a través del `Transform.scale`) + test de
  navegación con `GoRouter` real en `profile_keyboard_hero_card_test.dart`
  (`tap` al botón → cae en la ruta). `bash tool/check.sh` verde: **740
  tests**, format/analyze/arquitectura limpios (una primera corrida cayó
  por el flaky conocido de `survival_controller` bajo carga; pasa aislado
  y en la re-corrida completa).
- **Verificación visual real (Linux/Hyprland, sin reiniciar la app)**:
  `dart_hot_reload` + `dart_hot_restart` sobre la sesión debug viva
  (pid 27814); `Ctrl+4` enviado con
  `hyprctl dispatch sendshortcut CTRL,4,pid:27814` para llegar a Profile;
  el click del botón se simuló por VM service evaluando
  `GestureBinding.instance.handlePointerEvent(PointerDownEvent(...))` en
  el scope de `keyboard_viewer_screen.dart` (importa
  `package:flutter/gestures.dart` completo) y las capturas con
  `grim -g "960,22 960x1058"` confirmaron el viewer abierto (AppBar
  "MCHOSE MCHOSE GX87", tablero completo, píldora de controles y pista).
  Drag/zoom/tap-reset también se despacharon así. **Truco reutilizable**
  para futuras sesiones: `ydotoold` no está corriendo y Ridge es Wayland
  nativo (xdotool no lo ve); esta vía (VM service evaluate + sendshortcut
  + grim) evita instalar/levantar nada.

### 2026-09-12 — Aviso "conectá un teclado" en Android (nuevo canal nativo)

- **Pedido del usuario**, tras la sesión de verificación de Android de más
  abajo: como `KeystrokeCaptureField` solo reacciona a `KeyEvent` físicos
  reales (nunca al IME táctil, STACK.md §2.8), hoy tocar el teclado en
  pantalla en un teléfono sin teclado físico/Bluetooth no hacía
  absolutamente nada — sin explicación. Pidió un aviso explícito.
- **Diseño**: puerto `HardwareKeyboardRepository` (nuevo, en
  `practice/domain/repositories/`) con `Stream<bool> watchConnected()`,
  implementado en `HardwareKeyboardRepositoryImpl`
  (`practice/infrastructure/`) — solo Android tiene ambigüedad real
  (STACK.md §1: el resto son desktops mouse+teclado), así que en
  cualquier otro `Platform` emite un único `true` y nunca cambia, sin
  rama especial en presentación. Sondea cada 2s vía un `MethodChannel`
  nuevo (`dev.omarcodes.ridge/hardware_keyboard`, primer canal nativo
  custom del proyecto — antes todo pasaba por plugins) que
  `MainActivity.kt` resuelve consultando `InputDevice.getDeviceIds()`:
  cuenta como teclado real cualquier `InputDevice` no-virtual con
  `keyboardType == KEYBOARD_TYPE_ALPHABETIC` y `SOURCE_KEYBOARD` (excluye
  el teclado en pantalla, que nunca es un `InputDevice`, y "teclados" no
  alfabéticos como los botones de volumen/power del propio teléfono). Uso
  de caso fino (`WatchHardwareKeyboardConnectedUseCase`, mismo patrón que
  `CheckBiometricAvailabilityUseCase` de `lock`) + provider
  `hardwareKeyboardConnectedProvider` (`Stream<bool>`, no `keepAlive` —
  solo vale la pena sondear mientras una pantalla de tipeo lo esté
  observando).
- **UI**: `PracticeSessionScreen` reemplaza `KeystrokeCaptureField` por
  `KeyboardRequiredNotice` (ícono `LucideIcons.keyboardOff` en círculo
  `errorContainer`, título + cuerpo explicando por qué) mientras el
  provider reporta `false` — es el único punto de entrada de
  `/practice/session` (lecciones, Reto Diario, Zen/Sprint/Precision/
  Survival pasan todos por acá), así que un solo gate cubre todos los
  modos. Vuelve a mostrar el campo de captura solo, sin acción manual,
  en cuanto el siguiente sondeo detecta un teclado. Copys nuevos en/es:
  `practiceKeyboardRequiredTitle`/`practiceKeyboardRequiredBody`.
- **Verificación real, no solo de código** (clave del hallazgo de esta
  sesión): en el emulador **x86_64** hay un `InputDevice` "AT Translated
  Set 2 keyboard" (`isa0060/serio0`, `KeyboardType: 2`, confirmado con
  `dumpsys input`) que **siempre está presente**, sin importar el toggle
  `hw.keyboard` del AVD (`~/.config/.android/avd/Medium_Phone.avd/
  config.ini`) — es el controlador i8042 que QEMU emula para cualquier
  PC x86, no algo que dependa de la config de Android. Un teléfono ARM
  real no tiene esto. Para probar la rama "sin teclado" de verdad, sin
  descargar una imagen ARM (lenta, pesada), se forzó temporalmente
  `result.success(false)` en el canal nativo, se verificó visualmente el
  aviso completo (ícono/título/cuerpo, que tocar el teclado en pantalla
  no hace nada) y se revirtió antes de dejar el código final — la lógica
  real (`hasPhysicalKeyboard()`) se validó por separado leyendo los
  campos crudos de `dumpsys input` (`isVirtual`/`KeyboardType`/
  `Sources`), no por observación en vivo. **Documentado para la próxima
  vez que haga falta forzar este estado**: es la única forma práctica en
  este entorno.
- **Tests**: `watch_hardware_keyboard_connected_usecase_test.dart` (fake
  de puerto, confirma que reenvía el stream) y
  `keyboard_required_notice_test.dart` (rendering puro, mismo patrón que
  `session_result_footer_test.dart`) — no se testeó
  `HardwareKeyboardRepositoryImpl` directamente (implica `Platform.isX`
  crudo sin seam de testing, mismo criterio ya aceptado en el repo para
  `device_info_source_impl.dart`, que tampoco tiene test). `flutter
  analyze`, `check_architecture.dart` (353 archivos, sin violaciones) y
  `flutter test` (733/733) limpios.

### 2026-09-12 — Verificación funcional completa en Android (emulador real, MCP)

- **Pedido del usuario**: instalar y probar Ridge en un emulador Android
  (API 33, ya levantado) vía las herramientas MCP de `android`/Chrome, y
  dejar Android tan funcional como Linux, incluyendo permisos correctos.
- **Build/instalación**: `flutter build apk --debug` compila limpio
  (ALSA ya estaba instalado); `flutter analyze` y
  `dart run tool/check_architecture.dart` sin violaciones. Nota de
  entorno: este host tiene **dos binarios `adb` distintos**
  (`/usr/bin/adb` del sistema vs. `/home/sazar/Android/Sdk/platform-tools/adb`)
  que no comparten protocolo de servidor — mezclarlos mata el emulador
  (`adb kill-server`/reinicios espontáneos). Siempre anteponer
  `PATH="$ANDROID_HOME/platform-tools:$PATH"` antes de `flutter`/`adb` en
  este host. El emulador también murió una vez por presión de memoria
  real (swap casi lleno) mientras había un daemon de Gradle 9.3.1 viejo
  residente (~2 GB) — `cd android && ./gradlew --stop` lo liberó.
- **Cómo probar tecleo real sin teclado físico**: `adb shell input
  keyevent`/`input text` **no sirven** para `KeystrokeCaptureField` — el
  widget resuelve `PhysicalKeyboardKey` a partir del scancode real del
  evento, y los eventos inyectados por `adb shell input` no traen uno
  válido, así que `physicalKeyIdFor()` devuelve `null` y la tecla se
  ignora en silencio. La forma que sí funciona: `xdotool` apuntando a la
  ventana del emulador vía **XTEST global** (`xdotool windowactivate
  <id>` + `xdotool key`/`type`, **sin** `--window`, que usa
  `XSendEvent` sintético y QEMU lo ignora) — así QEMU lo reenvía como
  teclado USB/virtio real con scancode válido. Documentado para
  cualquier sesión futura que necesite automatizar el motor de captura.
- **Bug real encontrado y arreglado** (cross-platform, no solo Android):
  tocar la tarjeta de Reto Diario en `Free` crasheaba con pantalla roja
  — `type '({_DailyChallenge mode, Null onContinue, _Snippet snippet})'
  is not a subtype of type '({String modeKind, Snippet snippet})'`.
  Causa: `daily_challenge_card.dart` empujaba `/practice/session` con un
  record de 3 campos (`snippet, mode, onContinue`), pero
  `app_router.dart` solo reconoce el shape de 4 campos que usa
  `lesson_navigation.dart` (con `onShare`) — al no matchear por aridad,
  caía al otro `as` (el de `modeKind` string) y tronaba. Fix: agregar
  `onShare: null` al record. Verificado en vivo end-to-end (sesión
  completa, "already played" con streak). El test existente
  (`daily_challenge_card_test.dart`) solo comprueba que `onTap` no sea
  null, nunca lo invoca contra un `GoRouter` real — por eso no lo
  atrapó; no se agregó test de router nuevo (el archivo declara
  explícitamente que quiere quedarse como rendering test puro, sin
  engancharse a `app_router.dart`) pero queda como hueco de cobertura
  conocido si se retoca esa ruta de nuevo.
- **Fix Android nativo**: `AndroidManifest.xml` no declaraba
  `android:enableOnBackInvokedCallback="true"`, así que Android 13+
  logueaba el warning `OnBackInvokedCallback is not enabled` y la app se
  quedaba en el dispatcher de back antiguo — pese a que el código ya usa
  `PopScope` deliberadamente para el back de Android (selector de
  lenguaje transitorio en `/practice`, ver sesión 2026-09-11). Agregado
  el atributo; verificado que el back del sistema (tecla/gesto) sigue
  funcionando igual tras el rebuild y que el warning desapareció de
  logcat.
- **Permisos Android revisados**: solo `USE_BIOMETRIC` (normal, sin
  diálogo, ya condicionado en UI a que `biometricAvailableProvider`
  reporte biometría disponible) e `INTERNET` (normal, sin diálogo, solo
  para el avatar de GitHub) — ambos ya estaban bien declarados y
  correctamente acotados a "solo si aplica". No hace falta
  `READ/WRITE_EXTERNAL_STORAGE` (content packs usan
  `getApplicationSupportDirectory`, almacenamiento privado de la app;
  `data_management` solo resetea/borra filas de drift, no exporta
  archivos) ni `RECORD_AUDIO` (`flutter_soloud` aquí es solo
  reproducción). No se tocó nada de permisos porque ya estaban
  correctos.
- **Cobertura funcional verificada en el emulador** (Android 13,
  `sdk_gphone64_x86_64`): onboarding, creación de perfil, selector de
  lenguaje (catálogo con barra de progreso), rutas Go y Bash completas
  (lista → sesión → resultado con métricas/logros), las 4 pestañas de
  Progress (Overview/Weakness/Activity/History), los 4 modos de Free
  Practice (Zen, Sprint con cronómetro, Precision, Survival con pérdida
  de vida real), Snippet Browser con filtros + selector de modo, Profile
  (auto-detección de dispositivo: "Android"/"Android 13"/modelo real vía
  `device_info_plus`), Achievements (709 logros, grid con desbloqueados),
  Settings completo (tema, color expresivo, esquina, paleta de 21
  colores, preview de sonido de tecleo vía AAudio confirmado en logcat,
  idioma, **App Lock**: set PIN → confirm → bloqueo inmediato →
  desbloqueo, todo funcionando), y Keyboard Shortcuts (pantalla visible
  y usable en Android).
- **Hallazgo menor, no arreglado**: los atajos de teclado globales
  (`AppNavigationShortcuts` para Ctrl+1–5, `EscapeToPop` en Achievements/
  Snippet Browser/Changelog/Edit Profile/Stats JSON) no disparan si
  ningún descendiente tiene foco de teclado — que es el estado normal
  justo después de tocar/clickear un elemento no enfocable. El propio
  código ya conoce este patrón de Flutter (`snippet_info_screen.dart` y
  `practice_session_screen.dart` lo evitan con un `Focus(autofocus:
  true)` propio) pero `EscapeToPop`/`AppNavigationShortcuts` no lo
  aplican. **No es específico de Android** — reproduciría igual en Linux
  tras un click de mouse en un widget no enfocable — así que se deja
  como pendiente general, no como bloqueante de esta tarea.
- **Biometría**: no se probó en vivo (el AVD no tenía huella
  enrolada y automatizar el enrolamiento vía la Settings del sistema no
  se intentó por tiempo/beneficio). Revisado por código:
  `MainActivity.kt` ya extiende `FlutterFragmentActivity` (requisito de
  `local_auth` para `BiometricPrompt`, `STACK.md §3.2`) y el toggle de
  Settings correctamente se oculta cuando `biometricAvailableProvider`
  no reporta biometría — comportamiento correcto, no bug.

### 2026-09-12 — Go: Modern & Idiomatic + Production Patterns (2 rutas nuevas, 58 snippets, 14 categorías)

- **Pedido del usuario**: curso de Go de nivel avanzado bilingüe (en/es) con
  "todo lo más top moderno de Go 1.27" y mejores prácticas idiomáticas para
  pros. Tras preguntarle eligió **dos rutas**, **categorías propias
  dedicadas**, **solo stdlib + tooling oficial** y el título **"Go: Modern &
  Idiomatic" / "Go: Moderno e Idiomático"** (tag Advanced/Avanzado); la ruta
  B quedó como **"Go: Production Patterns" / "Go: Patrones de Producción"**
  (tag Production/Producción).
- **Contenido**: 58 snippets solo-curso (dificultad 13/20/16/9; longitud
  17/36/5), 34+24 lecciones. `go-modern-idioms-v1`: evolución del lenguaje
  1.26/1.27 (`new(expr)`, claves de campos promovidos en literales,
  inferencia generalizada de tipos de función, constraints autorreferenciales),
  iteradores (`iter.Seq`/`Seq2`, adaptadores, `iter.Pull`, iteradores de
  `reflect`), modismos modernos (`min`/`max`, `range` sobre enteros,
  `SplitSeq`, `CutPrefix`, `slices.Backward`, atómicos tipados), métodos
  genéricos, `encoding/json/v2` + `jsontext`, stdlib moderna (`uuid`,
  `url.Clone`, `rand/v2.N`, `crypto/mldsa`, `os.Root`), diseño de API
  (constructores, functional options, interfaces del consumidor, composición
  `io`) y patrones de error (`Join`, `AsType`, `Unwrap`, `Is`).
  `go-production-v1`: patrones de concurrencia (`WaitGroup.Go`, causa de
  cancelación, `OnceValue`, worker pool, pipeline cancelable), fugas de
  goroutines y perfil `goroutineleak` GA, testing avanzado (tabla +
  `t.Parallel`, helpers + `t.Context`, fuzzing, `synctest` +
  `httptest.NewTestServer`, `t.ArtifactDir`), rendimiento (benchmarks
  `B.Loop`, preasignación, CPU profile, `runtime/metrics`), observabilidad
  (`slog`, grupos, `NewMultiHandler`) y tooling (`//go:embed`,
  `ReadBuildInfo`, `//go:generate`, `//go:fix inline` + modernizers de
  `go fix`).
- **Verificación real, no por ojo**: harness propio
  (`/tmp/opencode/go-adv-course/verify.py`) que extrae cada `code` del
  asset, lo envuelve (body/decls/test), lo pasa por el **gofmt del
  toolchain** y lo ejecuta con **go1.27.0** cacheado
  (`GOTOOLCHAIN=go1.27.0`; el gofmt del host 1.26 rechaza métodos
  genéricos): aserciones de stdout exactas y casos con `go generate` y
  `go fix` reales. **58/58 en verde**, y re-corrida `--against` contra el
  `go_v1.json` mergeado. Gotchas documentados en la skill: los tokens de
  `jsontext` se invalidan con la siguiente lectura, los builtins
  `min`/`max` no aceptan spread de slice, las claves promovidas son el
  nombre del campo (nunca `Point.X`), `//go:embed` a `string` necesita
  `import _ "embed"`, y la detección de `goroutineleak` es asíncrona (el
  test asevera cero fugas en código limpio, nunca `Count() > 0`).
- **Revisión adversarial fresca** (2 agentes sin contexto, ejecución
  independiente + currícula/prosa): 0 blockers de ejecución; 58/58
  compilados con el harness propio del revisor y sets/conteos del drift
  verificados exactos. Fixes reales aplicados: `go-genmeth-004` (título y
  prosa contradecían el código; ahora el snippet incluye
  `var _ Transformer = Box[int]{}` y enseña la restricción real de métodos
  genéricos vs. interfaces), `go-jsonv2-002` (v2 **ignora** miembros
  desconocidos por defecto; el título ahora dice opt-in y el código
  marshalea un `map` para demostrar `Deterministic`), `go-perf-004` (solo
  `goroutines-created` es 1.26; la métrica viva existe desde 1.16),
  `go-stdlib-004` (imprime `2420 <nil>`, no `true`), orden de `errors.Is`
  corregido, mito del constructor en `go-apidesign-001`, `Sorter[T any]`
  sin constraint sobrante, guard `!ok` en `ReadBuildInfo`, loop de
  `go-perf-003` ya no es código muerto (`runtime.KeepAlive`),
  `go-obs-001` ahora declara `dropTime`/`newLogger`, 11 re-etiquetados de
  longitud/dificultad, ~30 prosas ES pulidas y la ruta A **reordenada**
  (iteradores antes de modismos modernos) para eliminar los forward
  references de range-over-func.
- **Wiring**: 14 `ContentCategory` nuevas + labels en/es + `gen-l10n`;
  `content_category.dart` bajó a **358 líneas** porque el formatter tall
  obliga línea en blanco alrededor de cada constante documentada con `///`
  (llevaba el archivo a 532, sobre el límite de 500) — docs por-valor como
  `//` empaquetados con `ignore_for_file: public_member_api_docs`
  justificado; sets `_topicCategories` (test + audit script), 2 rutas en
  `pubspec.yaml`/`defaultAssetPaths`/`_learningPathAssetPaths`, y drift
  test 1289→**1347** activos y 476→**489** beginner (sets de `_` 384 y
  `%` 126 recalculados del catálogo real).
- **Docs**: `SPEC.md` §3.1 (categorías Go), skill `content-curriculum`
  (SKILL.md + receta "Go 1.26/1.27 snippets" en `snippet-authoring.md`).
- **Verificado**: `bash tool/check.sh` completo en verde — **731 tests**,
  format/analyze/arquitectura limpios; `audit_lesson_order.py` verde para
  las dos rutas.

### 2026-09-12 — Docker: Fundamentos + Compose + Avanzado (lenguaje nuevo, 3 rutas, 58 snippets)

- **Pedido del usuario**: un curso/guía de introducción a Docker bilingüe
  (en/es, mismos estándares). Tras preguntarle eligió **tres rutas**,
  **snippets autocontenidos** (comando, Dockerfile, `.dockerignore` o
  `compose.yaml`, uno por lección), **nueve categorías propias** y el copy
  "Docker from scratch" / "Docker desde cero" (tag Fundamentals/Fundamentos,
  blurb "Package it once, run it anywhere." / "Empaquétalo una vez,
  ejecútalo donde sea.").
- **Contenido**: 58 snippets solo-curso, dificultad 19/20/19, en tres rutas
  — `docker-foundations-v1` (25: CLI básica, Dockerfiles, imágenes,
  contenedores, volúmenes, redes), `docker-compose-v1` (16: servicios,
  puertos, build, env/env_file, volúmenes, redes, `depends_on`,
  healthcheck, config, réplicas, capstone nginx+redis) y
  `docker-advanced-v1` (17: multi-stage, `HEALTHCHECK`, usuario no root,
  caché de capas, ARG global, save/load, export/import, registry local,
  digest, login, límites, restart, read-only, `system df`/`stats`/`top`/
  `diff`).
- **Bug de entorno real y reparación**: el daemon Docker no podía crear
  veth ("operation not supported") porque el kernel en ejecución
  (`7.2.2-1-cachyos`) se había quedado sin su árbol de módulos al
  actualizar a `7.2.4` sin reiniciar. Se restauró
  `/usr/lib/modules/7.2.2-1-cachyos` desde el paquete oficial cacheado
  (`/var/cache/pacman/pkg/linux-cachyos-7.2.2-1-x86_64_v3.pkg.tar.zst`),
  `depmod 7.2.2-1-cachyos` y `modprobe` de `veth`/`xt_nat`/`nft_compat`/
  `br_netfilter`: bridge, DNAT, DNS interno y Compose quedaron 100%
  funcionales (antes solo funcionaban `--network host`/`none`). La
  restauración es aditiva y reversible (`rmmod` + borrar ese directorio).
- **Verificación real, no por ojo**: harness propio
  (`/tmp/opencode/docker-course/verify.py`) que lee el `code` del asset
  final y lo ejecuta verbatim contra Docker 29.8 + Compose 5.5: comandos
  línea por línea con asserts de salida y estado (`docker inspect
  --format`, `ps -a --filter`, puertos, ficheros, DNS por nombre),
  Dockerfiles/`.dockerignore`/`compose.yaml` escritos byte a byte y
  construidos/levantados de verdad (healthchecks, réplicas, persistencia
  de volúmenes entre `down`/`up`, push a `registry:2` local, fallo
  esperado del root `--read-only`). **58/58 en verde**, re-corrido contra
  el asset del repo (md5 idéntico). El review adversarial de código
  escribió su propio harness independiente: 58/58 y 732 asserts, 0 bugs.
- **Revisión adversarial de currícula** (agente fresco) + fixes aplicados:
  modelo de capas de `docker-image-003` (FROM no añade capa), `--rm`
  aparecía en la lección 3 y otra vez en la 19 (se quitó de la 3),
  `compose-013` decía "el stack de la primera lección en ejecución" cuando
  la 2 lo apaga, consejo falso de solapamiento en `compose-011`, clave de
  caché imprecisa en `adv-006`, `adv-007`/`adv-009` dependían de la imagen
  `hello` de otra ruta (ahora usan `alpine:3.22`), matiz de que
  `registry:2` sin configurar acepta cualquier credencial en `adv-011`, y
  pulido de títulos/prosa ES (multietapa, comprobación de estado, montaje
  de enlace, registros, `host:container`).
- **Wiring**: `ProgrammingLanguage.docker` + 9 `ContentCategory`
  (`dockerBasics` … `dockerMaintenance`, doc de una línea por valor para
  no romper el límite de 500: `content_category.dart` quedó en **490**),
  `DockerSyntaxTokenizer` (instrucciones de Dockerfile, subcomandos,
  claves de Compose, `$VAR`, flags con `=`, listas YAML, `#`) con 17
  tests, l10n (`languageDocker`/`languageDockerBlurb` + 9 categorías en
  ambos `.arb` + `gen-l10n`), assets en `pubspec.yaml` + ambos data
  sources, completeness/key-layout/`audit_lesson_order.py` (`docker` en
  `COURSE_ONLY_LANGUAGES`).
- **Drift test**: 1215 activos / 447 beginner con Linux+Docker en ese
  momento; los sets de `_`/`%` ya venían actualizados por la sesión de
  Linux (verificado exacto contra los assets reales: 363/118).
- **Nota de concurrencia**: el mismo working tree traía sesiones activas
  de Linux y GitHub Actions (mismos archivos compartidos: enum, l10n,
  data sources, tests compartidos); el wiring de Docker se hizo después
  del de Linux y se verificó en conjunto. `AGENTS.md` + `CLAUDE.md`
  re-espejados tras la edición. `bash tool/check.sh` **completo en verde —
  731 tests**, format/analyze/arquitectura limpios (una corrida previa vio
  un flaky de `survival_controller` por carga, ajeno: pasa aislado y en la
  suite completa).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum` (SKILL.md,
  content-model, snippet-authoring con la receta de Docker).
- **Push y release (misma sesión, pedido del usuario)**: se commitearon
  el asset/rutas finales + docs (`f4fae56`) y el código generado stale que
  rompía la CI (`bf6fd90`, `practice_session_controller.g.dart`), y al
  verificar la CI se arreglaron **dos bugs preexistentes**:
  `fix(ci)` con `libasound2-dev` en el job `release` (sin eso
  `dart run tool/version_bump.dart` moría compilando el hook nativo de
  `flutter_soloud`) y el `secrets` inválido dentro de un `if:` en
  `release-builds.yml` (contexto no permitido → workflow inválido, rojo en
  cada push). Con eso CI quedó **quality-gate ✓ + release ✓** y publicó
  **v1.12.0** (`657e6b6`, tag empujado).
- **Pendiente detectado (no arreglado)**: el tag lo pushea el job
  `release` usando `GITHUB_TOKEN`, y GitHub no dispara workflows desde
  eventos de ese token, así que `release-builds.yml` nunca corre solo para
  el tag recién creado (los artefactos por plataforma no se construyen).
  Opciones: añadir `workflow_dispatch:` a `release-builds.yml` y
  dispararlo a mano con `--ref vX.Y.Z`, o usar una App/PAT para el push
  del tag.

### 2026-09-12 — GitHub Actions: Fundamentos + Pipelines + DevOps (lenguaje nuevo, 3 rutas, 74 snippets)

- **Pedido del usuario**: un curso/guía de introducción a GitHub Actions
  (YAML/CI/DevOps) bilingüe (en/es, mismos estándares que las otras guías).
  Tras preguntarle eligió **tres rutas**, el título **"CI/CD with GitHub
  Actions" / "CI/CD con GitHub Actions"** y el enfoque **GitHub Actions +
  DevOps real**.
- **Contenido**: 74 snippets solo-curso, dificultad 29/28/17/0, en tres rutas —
  `github-actions-foundations-v1` (25: anatomía del workflow, expresiones y
  contextos, disparadores, jobs/pasos, runners y matrices, secretos y
  variables) + `github-actions-pipelines-v1` (24: caché y artefactos,
  acciones compuestas y workflows reutilizables, contenedores/servicios/Docker,
  patrones de pipeline) + `github-actions-devops-v1` (25: permisos/pinning/OIDC/
  CodeQL/Dependabot, entornos/releases/Pages/atestaciones/registros, y 7
  comandos `gh`).
- **13 categorías propias** (`workflowBasics`, `workflowTriggers`,
  `jobsAndSteps`, `expressionsAndContexts`, `runnersAndMatrix`,
  `secretsAndVariables`, `cachingAndArtifacts`, `reusableAndComposite`,
  `containersAndDocker`, `pipelinePatterns`, `securityHardening`,
  `deploymentsAndReleases`, `ciOperations`): enum comprimido a **490 líneas**
  para respetar el límite de 500 + `.arb` en/es + `gen-l10n` +
  `content_labels.dart`.
- **Verificación real, no por ojo**: harness propio
  (`/tmp/opencode/gha-course/`) con **actionlint 1.7.12 + ShellCheck 0.11**,
  `action-validator` 0.6.0, `check-jsonschema` (esquema de Dependabot),
  `gh 2.100.0 <cmd> --help` para los comandos, y **33 de los 74 snippets
  ejecutados de verdad** con `act 0.2.89` + podman sobre
  `catthehacker/ubuntu:act-latest` (los artefactos v7 y los healthchecks de
  servicios fallan por limitaciones de act/podman, así que se validaron
  aparte). Versiones de acciones contrastadas contra la API de GitHub
  (checkout@v7, setup-node@v7, cache@v6, upload-artifact@v7,
  download-artifact@v8, build-push-action@v7, codeql-action@v4,
  action-gh-release@v3…).
- **Revisión adversarial fresca** (2 agentes sin contexto: código y
  currícula/prosa) con hallazgos reales corregidos: `npm publish` sin
  `registry-url` (no autenticaba), `az webapp deploy` sin `--resource-group`,
  `gcloud run deploy` sin `--region`, inyección de datos de evento en `run:`
  (`github.ref_name`, `release.tag_name`, `workflow_run.head_branch` → `env:`),
  `dorny/paths-filter` sin `pull-requests: read`, tag GHCR con mayúsculas
  (ahora `docker/metadata-action`), guard de `cache-hit` muerto, `types:` sin
  `ready_for_review` (el título prometía ejecutar al marcar listo), prosa con
  el default amplio de `GITHUB_TOKEN` desactualizada, `@v1` mutable y alcance
  real de `secrets: inherit`, y ~15 precisiones más (títulos, calcos, ES).
- **Wiring**: `ProgrammingLanguage.githubActions` +
  `GithubActionsSyntaxTokenizer` (YAML: claves GHA, `${{ }}` keyword incluso
  dentro de strings y block scalars, comentarios `#` solo a inicio de palabra,
  vocabulario `gh`) con **17 tests**; l10n (`languageGithubActions`/blurb +
  13 categorías en ambos `.arb`); assets en `pubspec.yaml` + ambos data
  sources; completeness/key-layout; `audit_lesson_order.py` (`githubActions`
  en `COURSE_ONLY_LANGUAGES`); drift test (1215→**1289** activos, 447→**476**
  beginner, 39 ids con `_` añadidos).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` + `CLAUDE.md`
  (espejo byte a byte), skill `content-curriculum` (SKILL.md, content-model,
  snippet-authoring con la receta de actionlint/action-validator/act).
- **Verificado**: `bash tool/check.sh` completo en verde — **731 tests**,
  format/analyze/arquitectura limpios (incluye las sesiones concurrentes de
  Linux y Docker del mismo working tree).

### 2026-09-12 — Linux: Essentials + Administración + Redes (lenguaje nuevo, 3 rutas, 85 snippets)

- **Pedido del usuario**: un curso/guía de introducción a Linux bilingüe
  (en/es, mismos estándares que las otras guías). Tras preguntarle eligió
  **tres rutas**, temario **autocontenido con enfoque de SO** (asumiendo un
  solape mínimo con Bash), **Arch Linux real** como base de verificación y
  el título **"Linux essentials" / "Linux esencial"**.
- **Contenido**: 85 snippets solo-curso, dificultad 37/36/11/1, en tres
  rutas — `linux-foundations-v1` (35: distro/kernel, FHS, navegación,
  archivos, permisos, usuarios, procesos, paquetes, servicios y logs),
  `linux-admin-v1` (30: cuentas y `sudo`, sticky/setgid/ACL, señales y
  prioridad, discos, unidades systemd, journald, pacman, timers y tar) y
  `linux-networking-v1` (20: `ip`, rutas, DNS, `ping`/`curl`, `ss`,
  nftables y systemd-resolved) — con **12 categorías propias**
  (`linuxBasics`, `linuxFiles`, `permissions`, `usersAndGroups`,
  `processes`, `packages`, `services`, `logs`, `storage`, `networking`,
  `scheduling`, `backupAndArchives`).
- **Verificación real, no por ojo**: harness propio
  (`/tmp/opencode/linux-course/verify.py`) que ejecuta **cada snippet con
  `archlinux:latest`** en contenedor desechable (plano, `--privileged`, o
  `--systemd=always --privileged` + `/sbin/init`), con setup por caso,
  `code` leído del asset final (verbatim) y aserciones de stdout/stderr/
  exit + estado resultante. **85/85 en verde**, re-corrido tras los
  arreglos del review. Casos de fallo incluidos a propósito:
  `systemctl is-enabled` deshabilitado, `pacman -Q` tras `-Rns`, `pgrep`
  sin coincidencia, `ip link` down.
- **Revisión adversarial fresca** (2 agentes sin contexto: código/ejecución
  y currícula/prosa) con hallazgos reales corregidos antes de cerrar:
  **blockers de reproducibilidad** (un `demo.service` que ningún snippet
  creaba, `chmod`/`chown` sobre `/tmp/demo/notes.txt` inexistente, `dev01`
  borrado y luego suplantado en la ruta de admin), `dev02` con `chpasswd`
  para que el lock no fuera no-op, `sudo` faltante en `passwd -S`,
  `ss -tulpn` y `nft list tables`, contradicción `pacman -Sy` vs `-Syu`
  (ahora una sola lección `pacman -Syu --needed`), `getent hosts` →
  `getent ahosts` (devuelve `::1` y `127.0.0.1`),
  `--timer-property=AccuracySec=100ms` tras descubrir que los timers
  pueden dispararse hasta 1 min tarde, tokenizer sin `cd`/`tail`/`tree`/
  `echo` y con `/dev/null` pintado como keyword (ahora las rutas tras `/`
  son identificadores), y ~20 precisiones de prosa (EN/ES) incluidos
  calcos, títulos largos y el `cache state` inexistente de `resolvectl`.
- **Wiring**: `ProgrammingLanguage.linux` + 12 `ContentCategory` nuevas,
  `LinuxSyntaxTokenizer` (comandos y verbos systemd/nft, flags como token,
  rutas como identificadores) con 17 tests; l10n (`languageLinux` +
  `languageLinuxBlurb` + 12 categorías en ambos `.arb`) + `gen-l10n`;
  assets en `pubspec.yaml` + ambos data sources; completeness/key-layout/
  drift (1215 activos / 447 beginner tras integrar la sesión concurrente
  de Docker, sets de `_`/`%` regenerados); `audit_lesson_order.py`
  (`linux` en `COURSE_ONLY_LANGUAGES`).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum` (SKILL.md,
  content-model y la receta de verificación de Linux en snippet-authoring).
- **Nota de concurrencia**: el mismo working tree traía una sesión activa
  de Docker (58 snippets, 3 rutas) que se fue integrando en paralelo; los
  conteos del drift test se recalcularon contra el catálogo asentado final
  y el gate se corrió con ambas sesiones verdes.
- **Verificado**: `bash tool/check.sh` completo en verde — **714 tests**,
  format/analyze/arquitectura limpios; `audit_lesson_order.py` verde para
  las 3 rutas y harness de ejecución 85/85.

### 2026-09-12 — Git: Fundamentos + Flujos + Internals (lenguaje nuevo, 3 rutas, 70 snippets)

- **Pedido del usuario**: un curso/guía de introducción a Git bilingüe
  (en/es, mismos estándares que las otras guías). Tras preguntarle eligió
  **tres rutas** (fundamentos + flujos + internals), **categorías propias
  dedicadas**, **comandos autocontenidos** (cada lección en su propio
  mini-repo, sin narrativa compartida) y el título **"Git from scratch" /
  "Git desde cero"** (tag `Fundamentals`/`Fundamentos`; blurb "Track every
  change and collaborate without fear." / "Registra cada cambio y colabora
  sin miedo.").
- **Contenido**: 70 snippets solo-curso, dificultad 19/28/19/4, en tres
  rutas — `git-foundations-v1` (33: config/init/status/staging/primer
  commit/`.gitignore`/diffs, deshacer y archivos; commits, mensajes y
  amend; ramas, merges ff y `--no-ff`, conflictos; clone/remote/fetch/
  pull/push) + `git-workflows-v1` (24: log graph/format/patch/pickaxe/
  blame/bisect; los tres `reset`, `restore`, `revert`, `clean`, `stash`;
  rebase, `pull --rebase`, `force-with-lease`, `cherry-pick`,
  `--fixup`/`--autosquash`, tags y hooks) + `git-internals-v1` (15:
  `cat-file`/`hash-object`/`ls-tree`, `HEAD`/refs/reflog/detached,
  índice, `count-objects`, `gc`, worktrees) — más 2 lecciones de `gitUndo`
  reutilizadas en fundamentos.
- **10 categorías propias** (`gitBasics`, `gitCommits`, `gitBranching`,
  `gitRemotes`, `gitHistory`, `gitUndo`, `gitCollaboration`, `gitObjects`,
  `gitRefs`, `gitMaintenance`): enum + `.arb` en/es + `gen-l10n` +
  `content_labels.dart`, con `content_category.dart` reescrito a doc
  comments de una línea (581→**414 líneas**, el límite duro es 500).
- **Verificación real, no por ojo**: harness propio
  (`/tmp/opencode/git-course/verify.py`) que corre **cada snippet con
  `git` 2.55** en un repo desechable (HOME aislado, `GIT_CONFIG_NOSYSTEM=1`,
  autor/committer y fechas fijos) con setup propio, salida asertada
  (stdout+stderr) y estado resultante (`status --short`, `log --format`,
  `rev-parse`, `test -f`); el `code` se lee del asset final (verbatim).
  Casos de fallo incluidos a propósito: merge en conflicto (exit 1 +
  `MERGE_HEAD`), `bisect run` hasta el veredicto, hook que imprime.
  **70/70 en verde**, re-corrido contra el asset del repo (md5 idéntico).
- **Revisión adversarial fresca** (2 agentes sin contexto, código/ejecución
  y currícula/prosa) + falsificación (no-ops inyectados). Hallazgos reales
  corregidos: `git clean -n` no previsualizaba los directorios que `-fd`
  borra (ahora `-nd`, explicando que el preview lleva los mismos flags),
  `git bisect` manual no llegaba a veredicto (se añadió `bad`/`good` del
  punto medio), `git-collab-009` no se podía replicar sin `git add foo.txt`
  (ahora va en el snippet) y explicaba mal `-i`/editores, `HEAD~n` se usaba
  en 8 lecciones sin enseñarse (se introdujo en `git-commit-005`),
  `rm --cached`/`mv` iban antes del primer commit (el primer commit pasó a
  `git-basic-006`, renumerando basics), `git gc` prometía podar objetos
  recientes y "un único pack" (matizado con `gc.pruneExpire` y cruft
  packs), más precisión de prosa (staging area = índice, `clone`→
  clonación, "en crudo"→formateado, salida de `bisect run` 1–127/125/128+,
  similitud en rename detection, borrados con `-a`/`add .`).
- **Wiring**: `ProgrammingLanguage.git` + `GitSyntaxTokenizer` nuevo
  (subcomandos con guion, flags como un token, `HEAD~1`/`HEAD^{tree}`/
  `stash@{0}`, comentarios `#`) con 17 tests; assets en `pubspec.yaml` +
  ambos data sources; completeness (catálogo + 3 rutas), key-layout,
  drift (1002→**1072** total, 372→**391** beginner; sets de `_` con
  `git-collab-009` y `%` con `git-log-002`) y `audit_lesson_order.py`
  (`git` en `COURSE_ONLY_LANGUAGES`, verde para las 3 rutas).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum` (SKILL.md,
  content-model y la receta de verificación de Git).
- **Verificado**: `bash tool/check.sh` completo en verde — **680 tests**,
  format/analyze/arquitectura limpios, con la tree compartida por las
  sesiones concurrentes del mismo día (PHP, teclado 3D) también en verde.

### 2026-09-12 — PHP: Fundamentos + Web/Backend + Algoritmos (lenguaje nuevo, 3 rutas, 48 snippets)

- **Pedido del usuario**: un curso/guía de introducción a PHP bilingüe
  (en/es, mismos estándares que las otras guías). Tras preguntarle el
  alcance eligió **tres cursos** y, a diferencia de los demás lenguajes,
  **todas las categorías propias estilo CSS**; aprobó el blurb técnico
  ("The web's server-side workhorse — pragmatic, dynamic, and
  everywhere." / "El motor del lado servidor de la web — pragmático,
  dinámico y en todas partes.").
- **Contenido**: 48 snippets solo-curso, dificultad 28/15/3/2, en tres rutas
  — `php-foundations-v1` (24: `phpBasics`, `phpStrings`,
  `phpConditionals`, `phpLoops`, `phpArrays`, `phpFunctions`,
  `phpClasses`, `phpEnums`, `phpErrorHandling`, `phpNamespaces`),
  `php-web-v1` (12: `phpSuperglobals`, `phpForms`, `phpSessions`,
  `phpDatabase` con PDO/SQLite, `phpJson`, `phpFiles`) y
  `php-algorithms-v1` (12: `phpSearching`, `phpSorting`, `phpGraphs`,
  secuencia canónica). Desviación mínima del plan aprobado: se añadió
  `php-vars-004` (null coalescing `??`/`??=`) dentro de `phpBasics` porque
  la ruta web usa `??` desde su primera lección y no existía introducción
  previa (sin categoría nueva).
- **Verificación real, no por ojo**: los 48 snippets se pasaron por
  `php -l` y se ejecutaron con **PHP 8.4.25 real**
  (`podman run docker.io/library/php:8.4-cli`, con `pdo_sqlite`). Los
  snippets web (superglobales, sesiones, cookies) se manejaron con drivers
  que pre-rellenan `$_GET`/`$_POST`/`$_COOKIE` y apuntan
  `session_save_path()` a un directorio temporal; los 12 algoritmos
  (definiciones puras) se corrieron con drivers y se fuzzearon contra
  referencias independientes: 500 arrays aleatorios × 6 sorts vs `sort()`,
  200–300 trials de búsquedas vs `array_search(..., true)`, BFS/DFS vs
  recorridos independientes, y Dijkstra vs Bellman-Ford (objetivos
  inalcanzables → `null`), con el `Graph` de la lección 9 antepuesto.
- **Prosa bilingüe** delegada a 3 agentes (uno por curso) con el código ya
  verificado leído del draft + validación independiente del orquestador
  (id-set, longitudes ≤80/≤950, 3 frases). **Revisión adversarial fresca**
  (3 agentes sin contexto: código, currícula y prosa) confirmó 0 blockers
  de código y cazó hallazgos reales corregidos antes de cerrar: la
  matemática de `area()` en `php-class-003` (decía `3.14159 * 2` al
  cuadrado), la contradicción de `php-web-006` (una cookie nueva no se lee
  en la misma petición), "digestos"/calcos en web-004/009, el tldr vago de
  web-008, "wrong type stops the call" (falso con strings numéricos), "`/`
  devuelve float" (solo puede), estabilidad/adaptabilidad sin definir en
  sorts, el título "CRUD" que prometía un delete inexistente, los
  docblocks del `Graph` (catálogo sin comentarios) y las 5 dificultades
  de algoritmos desalineadas del grid canónico (insertion→intermediate,
  merge/quicksort→advanced, graph repr→beginner, Dijkstra→expert).
- **Wiring**: `ProgrammingLanguage.php` + 19 categorías `php*` +
  `PhpSyntaxTokenizer` nuevo (tags `<?php`/`?>`, `$variables`/`${...}`,
  heredoc/nowdoc, `#` que no es comentario si es `#[`, `.`-números) con
  15 tests; l10n (`languagePhp`/`languagePhpBlurb` + 19 categorías en
  ambos `.arb`); assets en `pubspec.yaml` + ambos data sources;
  completeness/key-layout/drift tests; `audit_lesson_order.py` (`php` en
  `COURSE_ONLY_LANGUAGES`).
- **Drift test**: conteos 954→1002 totales y 344→372 beginner, con los 39
  ids de PHP que contienen `_` añadidos al set (ninguno contiene `%`).
- **Nota de concurrencia**: el mismo working tree traía sesiones activas
  terminando Dart/Kotlin/Swift/C# (el drift test se movió 953→954 a mitad
  de esta sesión y hubo que recalcular encima; una inserción inicial de
  ids de PHP cayó en el set de `%` por un ancla repetida y se movió al set
  de `_`). `content_category.dart` estaba en el límite exacto de 500
  líneas y hubo que compactar 75 doc comments a ≤2 líneas (466 finales).
  `AGENTS.md` y `CLAUDE.md` estaban divergentes al entrar; se re-espejó
  `CLAUDE.md` desde `AGENTS.md` (regla del repo).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum` (SKILL.md,
  content-model, snippet-authoring con la receta de PHP) y este archivo.
- **Verificado**: `bash tool/check.sh` completo en verde — **663 tests**,
  format/analyze/arquitectura limpios; `audit_lesson_order.py` verde para
  las 3 rutas (course-only, sin huérfanos).

### 2026-09-12 — Python/Django: Fundamentos + ORM + REST API (3 rutas nuevas, 55 snippets)

- **Pedido del usuario**: un curso/guía bajo Python pero para Django, de 0
  a una REST API completa, bilingüe (en/es, mismos estándares que las
  otras guías). Tras preguntarle eligió **tres rutas**, dificultad
  **mixta real** (beginner/intermediate/advanced honestos), proyecto
  compartido **API de Bookmarks** y stack **Django 5.2 LTS + DRF 3.16 +
  TokenAuthentication** (sin dependencias extra).
- **Contenido**: `python-django-foundations-v1` (21: proyecto/settings/
  `AppConfig`, primer modelo y migraciones, tipos de campo y `Meta`,
  vistas y URLs con converters, plantillas + herencia, `Form`/`ModelForm`
  y POST con CSRF, admin y `ModelAdmin`, `TestCase` + `Client`),
  `python-django-orm-v1` (17: FK/`related_name`/M2M/`CASCADE` vs
  `SET_NULL`, QuerySets, lookups, `get_or_create`, bulk, `Q`/`F`,
  `aggregate`/`annotate`, `select_related`/`prefetch_related`, manager
  propio, anatomía de migración, data migration `RunPython` y comandos) y
  `python-django-rest-v1` (17: instalación DRF, `ModelSerializer` +
  validación + campos anidados, `@api_view`/`APIView`/genéricas/
  `ModelViewSet` + router + `@action`, token, `owner` +
  `IsOwnerOrReadOnly` + `perform_create` + queryset por usuario,
  paginación + search/ordering, `APITestCase` y flujo e2e). Python suma
  **16 categorías propias** (`djangoProject`, `djangoModels`,
  `djangoViews`, `djangoTemplates`, `djangoForms`, `djangoAdmin`,
  `djangoTesting`, `djangoRelationships`, `djangoOrm`,
  `djangoMigrations`, `djangoRestSetup`, `djangoSerializers`,
  `djangoRestViews`, `djangoRestAuth`, `djangoRestFiltering`,
  `djangoRestTesting`).
- **Verificación real, no por ojo**: proyecto de referencia Django 5.2.17
  + DRF 3.16.1 (venv nuevo con Python 3.12 vía `uv`) construido por
  etapas; cada snippet es un slice verbatim de un archivo que corrió en su
  etapa, con `check`/`makemigrations --check`/`migrate`/`test` y scripts
  reales de `manage.py shell`; la data migration se probó forwards y
  backwards; el API se ejercitó con `rest_framework.test.APIClient`
  (201/400/401/403/404, token, paginación, search/ordering).
- **Prosa bilingüe delegada** (3 agentes en paralelo con guía de estilo y
  self-validation) y **fusión con validación independiente** (id-set
  exacto, 3 oraciones por explicación, límites de 80/950 caracteres).
- **Revisión adversarial fresca** (3 agentes sin contexto): reconstruyeron
  el proyecto en un venv desde cero (55/55 snippets coinciden **byte a
  byte** con lo ejecutado; 9 tests + smoke HTTP en verde), auditaron
  currícula y prosa. Hallazgos reales corregidos: **bloqueante** en
  `rest-005` (los campos declarados `collection_name`/`tags` no estaban en
  `Meta.fields` → `AssertionError` de DRF) y en `rest-017` (el test
  asertaba `owner` en la respuesta, que el serializer no expone; ahora lo
  verifica contra la DB), imports visibles en la primera lección de cada
  archivo (`rest-003`/`006`/`016`/`017`, `template-001`, `form-003`),
  `verbose_name` mal descrito, atomicidad de `get_or_create` matizada,
  `delete()` en lote corregido, "seis rutas" → manejadores/rutas estándar,
  recordatorios de `makemigrations`/`migrate` tras cambiar modelos, 19
  títulos es con acentos, `client`→`cliente`, `nullable`→`opcional`,
  `tags`→`etiquetas` y varios calques.
- **Wiring**: 16 valores en `ContentCategory` (los 24 previos se
  comprimieron para no romper el límite de 500 líneas, tarea de una sesión
  concurrente que ya los dejó en el límite) + labels en ambos `.arb`
  (`flutter gen-l10n`), `content_labels.dart`, assets en `pubspec.yaml` +
  `learning_path_repository_impl.dart`, completeness/drift tests (los
  conteos vigentes los fijó la sesión de PHP; sets de `_`/`%` recomputados
  con 48/3 ids de Django) y `audit_lesson_order.py` verde para las 5 rutas
  de Python.
- **Verificado**: `bash tool/check.sh` completo en verde — **648 tests**,
  format/analyze/arquitectura limpios, con la tree compartida por sesiones
  concurrentes del mismo día (Dart, PHP, C#, Go REST) también en verde.
  `SPEC.md` §3.1, `AGENTS.md` + `CLAUDE.md` (espejo byte a byte) y la
  skill `content-curriculum` (SKILL.md, content-model, snippet-authoring
  con la receta de verificación de Django) actualizados.

### 2026-09-12 — Kotlin: Fundamentos + Algoritmos + Avanzado (lenguaje nuevo, 3 rutas, 53 snippets)

- **Pedido del usuario**: un curso de introducción a Kotlin bilingüe
  (en/es, mismos estándares que las otras guías). Tras preguntarle el
  alcance eligió **tres cursos** y **categorías propias dedicadas**:
  `kotlin-foundations-v1` (22 lecciones: `val`/`var`, tipos y plantillas
  de texto, `if`/`when` como expresión, rangos y `while`, funciones con
  argumentos por defecto, null safety con `?.`/`?:`, colecciones (incluido
  `IntArray`), lambdas, `data class` + desestructuración, extensiones,
  clases e `init`, y `try`/`catch` como expresión),
  `kotlin-algorithms-v1` (12, secuencia canónica; Dijkstra con distancias
  `Long` y solo nodos alcanzables) y `kotlin-advanced-v1` (19: selladas +
  `when` exhaustivo, `object`/`companion`, métodos por defecto y
  delegación `by`, genéricos + varianza, `lateinit`/`as?`/guardas,
  extensiones, funciones de orden superior, funciones de alcance, lambdas
  con receptor, `runCatching`/`Result` y corrutinas con `flow`).
- **Cinco categorías propias** (`nullSafety`, `dataClasses`, `lambdas`,
  `extensions`, `coroutines`), con `collections` compartida con Crystal/C#;
  `nullSafety` se mantiene separada de `nilSafety` (Crystal/C#) porque el
  chip debe decir "Null safety", el término del propio lenguaje.
- **Verificación real, no por ojo**: los 53 snippets se compilaron con
  **kotlinc 2.4.20 / JRE 17** (`-Werror -include-runtime`) y se ejecutaron
  con salida esperada, cada uno dentro de un driver que contiene el código
  del catálogo como substring verbatim; los de corrutinas enlazan
  `kotlinx-coroutines-core-jvm` 1.11.0. Los 12 algoritmos se fuzzearon
  (25 684 casos con semillas fijas) contra `IntArray.sortedArray`, un scan
  independiente, flood fill/BFS-DFS y Bellman-Ford; la revisión adversarial
  inyectó 11 bugs deliberados y el fuzz los detectó todos.
- **Revisión adversarial fresca** (2 agentes sin contexto, uno de código y
  uno de currícula/prosa): 52/52 compilaban; hallazgos reales aplicados —
  la prosa de `kotlin-loop-001` afirmaba que `println()` insertaba líneas
  vacías (falso), faltaba presentar arrays (`IntArray`) en fundamentos
  (nuevo `kotlin-coll-003`), el objeto `Dot` y `apply` aparecían antes de
  sus lecciones (se intercambió el contenido de `oop-002`/`oop-003` y de
  `lambda-004`/`lambda-005` para que los ids sigan el orden pedagógico), y
  una decena de frases en español (calcos de "disparar y olvidar",
  "retardo", "ranura", "frentes", mezcla max heap/montículo, etc.).
- **Wiring**: `ProgrammingLanguage.kotlin` + 5 categorías nuevas,
  `KotlinSyntaxTokenizer` (comentarios `/* */` anidados, strings crudos
  `"""`, plantillas `$x`/`${...}`, identificadores con backticks, rangos
  `1..3` sin tragarse los números) con 14 tests, l10n
  (`languageKotlin`/`languageKotlinBlurb` + las 5 categorías en ambos
  `.arb`), assets en `pubspec.yaml` + ambos data sources,
  `snippet_catalog_completeness_test`/`key_layout_map_test`,
  `audit_lesson_order.py` (`kotlin` en `COURSE_ONLY_LANGUAGES`),
  `content_drift_integration_test` (conteos y sets de `_`/`%`).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum` (SKILL.md,
  content-model, snippet-authoring con la receta de Kotlin).
- **Verificado**: `audit_lesson_order.py` verde para las 3 rutas; tests
  enfocados de tokenizer/completeness/drift/key-layout/learning_paths en
  verde; `bash tool/check.sh` al cierre (ver arriba). Nota de
  concurrencia: Dart, C#, Swift, CSS, Java, Crystal y Django se estaban
  integrando en el mismo working tree; los conteos del drift test se
  recalcularon al final contra el catálogo sembrado real.

### 2026-09-12 — Dart: Fundamentos + Avanzado + Algoritmos (lenguaje nuevo, 3 rutas, 53 snippets)

- **Pedido del usuario**: un curso de introducción a Dart bilingüe (en/es,
  mismos estándares que las otras guías). Tras preguntarle el alcance eligió
  **tres cursos**: `dart-foundations-v1` (25, tour amplio: tipos, seguridad
  frente a nulos, control de flujo, colecciones, funciones, clases y
  herencia, registros y patrones, errores, `async`/`await` y módulos),
  `dart-advanced-v1` (16: `late` y promotion, streams (`async*`, `await
  for`, `StreamController`), futuros paralelos y `Completer`, isolates,
  patrones avanzados con sealed classes, mixins, métodos de extensión,
  genéricos con restricciones y excepciones propias) y
  `dart-algorithms-v1` (12, secuencia canónica con grafo como lista de
  adyacencia). Dart entra como lenguaje **solo-curso** con **una categoría
  propia** (`recordsAndPatterns`) y reutiliza las genéricas más
  `collections`, `nullSafety` y `asyncProgramming`.
- **Verificación real, no por ojo**: los 53 snippets se corrieron con el
  Dart SDK 3.13.3 del proyecto (`dart format --set-exit-if-changed`,
  `dart analyze`, `dart run` con salida aseverada); los 12 algoritmos
  (definiciones puras, sorts que devuelven lista nueva sin mutar la
  entrada) se fuzzearon contra referencias independientes (`List.sort`,
  scan lineal, flood-fill, Bellman-Ford) — la referencia DFS del fuzz
  atrapó y corrigió un bug propio antes de cerrar.
- **Revisión adversarial fresca** (2 agentes sin contexto, uno de
  código/ejecución y uno de currícula): hallazgos reales corregidos —
  `countEvens` usaba `List`/`for-in` antes de la lección de colecciones
  (el bloque `collections` se movió antes de `functions`), la lección
  "try/catch/finally" no contenía `try/catch/finally` en el código (ahora
  sí, y `errorHandling` va antes de `asyncProgramming`), los records
  avanzados enseñaban object patterns antes que `if-case` (reordenados
  003 → 002 → 001), `dart-oop-003` prometía `Rex says Woof` sin el `name`
  en `speak()`, prosa que exageraba el contrato de `late` (es
  `LateInitializationError` en runtime, no una garantía de compilación),
  "sealed" descrito como "solo Circle/Square" (es "solo la misma
  biblioteca"), calques ES (`seguridad nula`, `retrollamadas`, `cierre`),
  dificultades de los grafos alineadas con los catálogos hermanos y el
  `\n` final que solo tenían los 12 algoritmos.
- **Wiring**: `ProgrammingLanguage.dart` + `ContentCategory.recordsAndPatterns`
  (con docs de `nullSafety`/`asyncProgramming`/`concurrency` ampliados),
  `DartSyntaxTokenizer` nuevo (keywords, `r'...'` crudos, `'''`/`"""`,
  `//`/`///`/`/* */` sin anidar, interpolación dentro del string, números
  `0xFF_00`, `1.isEven` como acceso a miembro) + 12 tests; `languageDart`/
  `languageDartBlurb`/`categoryRecordsAndPatterns` en ambos `.arb` +
  gen-l10n; assets en `pubspec.yaml` + ambos data sources; completeness/
  drift (900→953 total, 325→343 beginner, sets `_`/`%` con los ids de
  Dart) + key-layout tests; `audit_lesson_order.py` (`dart` en
  `COURSE_ONLY_LANGUAGES`).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum` (SKILL.md,
  content-model y snippet-authoring con la receta de verificación Dart).
- **Verificado**: `bash tool/check.sh` **completo en verde** —
  **648 tests**, format/analyze/arquitectura limpios; `audit_lesson_order.py`
  verde para las tres rutas. Nota de concurrencia: el working tree compartía
  sesiones activas (Swift/C#/Kotlin/CSS); el helper `settledCatalog` del
  drift test quedó con un total stale al entrecruzarse con la sesión que
  añadió el snippet 954, y se sincronizó al estado final del catálogo
  (**954 activos / 344 beginner**).

### 2026-09-12 — Swift: Fundamentos + Algoritmos + Avanzado (lenguaje nuevo, 3 rutas, 47 snippets)

- **Pedido del usuario**: un curso de introducción a Swift bilingüe (en/es,
  mismos estándares que las otras guías). Tras preguntarle el alcance eligió
  **tres cursos**: `swift-foundations-v1` (20 lecciones, tour amplio:
  `let`/`var`, tipos, condicionales con `switch` de rangos/tuplas, ciclos,
  funciones con `inout`, opcionales, colecciones, closures, structs, clases,
  protocolos, enums, errores y un proyecto final de conteo de palabras),
  `swift-algorithms-v1` (12, misma secuencia canónica que Java/Crystal) y
  `swift-advanced-v1` (15: opcionales avanzados, pattern matching con
  `indirect`, ARC, closures de escape, genéricos, `some`/`any`, tipos
  asociados, conformidad condicional, `Codable`, property wrappers y
  concurrencia con `async`/`await`, actores y task groups). Swift entra como
  lenguaje **solo-curso** con **cinco categorías propias** — `optionals`,
  `closures`, `enumsAndPatternMatching`, `codable`, `propertyWrappers`.
- **Verificación real, no por ojo**: los 47 snippets se compilaron con
  **Swift 6.2.4** (`podman run docker.io/library/swift:6.2`,
  `swiftc -warnings-as-errors`; scripts y drivers viven en `main.swift`) y
  se ejecutaron con salida esperada exacta; los 12 algoritmos se fuzzearon
  contra referencias independientes (sorts vs `sorted()`, búsquedas vs
  `firstIndex(of:)`, BFS/DFS vs flood-fill, Dijkstra O(V²) vs Bellman-Ford,
  pesos cercanos a `Int.max` incluidos).
- **Revisión adversarial fresca** (2 agentes sin contexto) + **re-revisión
  post-fix** (un tercero): hallazgos reales corregidos — `retry(times: 0)`
  hacía trap con `1...0` (ahora `guard times > 0`), Dijkstra podía
  desbordar `Int` con pesos cercanos a `Int.max` (ahora
  `guard best <= Int.max - edge.weight`), el `@escaping` del ejemplo no
  escapaba (el closure ahora se guarda en `pending` y se invoca después),
  `enum Direction: CaseIterable` aparecía antes de la lección de protocolos
  (protocolos pasó antes de enums en la ruta), `try?` sobre una función
  `rethrows` con closure no-throwing no compila (se agregó el caso que sí
  lanza), `switch` sobre tupla literal dispara "will never be executed" con
  `-warnings-as-errors` (se usa una variable), y ~10 precisiones de prosa
  (inferencia de `Character`, `inout` como copy-in copy-out, DFS preorden,
  heap build O(n), `firstMatch` y `?? -1`).
- **Etiquetas de `length`**: regla única (short ≤8 líneas y ≤1 declaración,
  long ≥25, medium el resto) para corregir las inconsistencias que encontró
  la revisión.
- **Wiring**: enum `ProgrammingLanguage.swift` + 5 `ContentCategory` nuevas,
  `SwiftSyntaxTokenizer` (comentarios anidados, raw strings `#"..."#`,
  multiline `"""`, `$0`, directivas `#if` y `#available`) con 18 tests, l10n
  (`languageSwift`/`languageSwiftBlurb` + 5 categorías en ambos `.arb`),
  assets en `pubspec.yaml` + ambos data sources + completeness/key-layout,
  `audit_lesson_order.py` (`swift` en `COURSE_ONLY_LANGUAGES`).
- **Nota de concurrencia**: el mismo working tree tenía sesiones activas de
  Dart, C#, CSS y Go REST/HTTP tocando los mismos archivos compartidos
  (enum, l10n, data sources, el drift test). El conteo del
  `content_drift_integration_test` se regeneró al final desde los assets
  realmente sembrados (**953 activos / 343 beginner**, incluye Dart y C# de
  esas sesiones) y sus sets de `_`/`%` se reconstruyeron completos. El gate
  final (`bash tool/check.sh`) pasa formato y se detiene en analyze por un
  único info ajeno (`dart_syntax_tokenizer_test.dart:74`, WIP de la sesión
  de Dart), no por Swift.
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum` (SKILL.md,
  content-model, snippet-authoring con la receta de Swift).
- **Verificado**: `flutter test` completo **648/648 verdes** (incluye el
  tokenizer Swift 18/18, completeness, key-layout con `swift_v1.json`,
  learning_paths y el drift test regenerado); `audit_lesson_order.py` verde
  para las 3 rutas; `dart format` limpio; analyzer limpio salvo el info
  ajeno de Dart.

### 2026-09-12 — C#: Fundamentos + Algoritmos + Avanzado (lenguaje nuevo, 3 rutas, 52 snippets)

- **Pedido del usuario**: un curso de introducción a C# bilingüe (en/es,
  mismos estándares que las otras guías). Tras preguntarle el alcance
  eligió **tres cursos** (fundamentos + algoritmos + avanzado) y el
  título **"C# from scratch" / "C# desde cero"**.
- **Contenido**: `csharp-foundations-v1` (25 lecciones: sentencias de
  nivel superior, `namespace`/`Main` clásico, tipos, interpolación,
  `const`/`decimal`, `if`/`switch`, `for`/`foreach`/`while`, funciones
  locales, sobrecarga, clases/propiedades/`required`/`init`,
  herencia/`abstract`, interfaces, `List<T>`/`Dictionary`, excepciones
  propias), `csharp-algorithms-v1` (12, secuencia canónica; grafo como
  lista de adyacencia y Dijkstra O(V²)) y `csharp-advanced-v1` (15:
  nullable reference types, records, patrones/`switch` expressions,
  genéricos, delegados/eventos, métodos de extensión, iteradores con
  `yield return`, LINQ de métodos y de consulta, `async`/`await` y
  `Task.WhenAll`, `IDisposable`/`using`). C# entra como lenguaje
  **solo-curso** con **cuatro categorías propias** (`patternMatching`,
  `delegatesAndEvents`, `linq`, `asyncProgramming`) y reutiliza
  `collections`/`nilSafety` de Crystal (docs del enum actualizadas).
- **Verificación real, no por ojo**: los 52 snippets se compilaron y
  ejecutaron contra **.NET SDK 10.0.401** en
  `podman run mcr.microsoft.com/dotnet/sdk:10.0` con
  `Nullable=enable` + `TreatWarningsAsErrors=true` (analyzers de diseño
  apagados: CA1852 pide `sealed` en ejemplos de herencia a propósito;
  el baremo es el warning del compilador, como en los otros lenguajes).
  Los 12 algoritmos se fuzzearon contra `Array.Sort`/`Array.IndexOf`,
  flood-fill independiente (BFS/DFS) y Bellman-Ford (Dijkstra). Dos
  bugs reales atrapados por el compilador antes del catálogo: las
  **funciones locales de C# no se pueden sobrecargar** (la lección de
  overloading ahora usa una `static class Formatter`) y un `var ratio`
  sin usar (CS0219).
- **Revisión adversarial fresca** (2 agentes sin contexto): el de código
  recompiló los 52 desde el JSON final y re-fuzzeó los 12 con ~9.150
  casos diferenciales + 4 controles negativos (4/4 detectados), sin
  defectos de código. El de currícula encontró 7 problemas reales, todos
  corregidos: prosa que decía `List<T>` donde el código acabó usando
  arreglos (`csharp-oop-004`, `csharp-iface-002`), regla falsa del sufijo
  `L` (`csharp-vars-001`), contradicción de complejidad en insertion sort
  (`csharp-algo-005`), "in place" en el TLDR de merge sort
  (`csharp-algo-006`), `record`/nullable/ternario solo-avanzados en los
  algoritmos (se reescribieron `csharp-algo-006`/`009`/`012` y
  `csharp-func-004` con `class Edge`, `ContainsKey` y `if`/`else`), y
  prosa que decía "el mensaje" donde se imprime `ex.Level`
  (`csharp-err-002`). También se pulieron calcos ES (`namespace de
  archivo`, `antes del print`, `en locales`) y backticks en títulos ES.
- **Prosa bilingüe delegada** (3 agentes en paralelo con el código ya
  verificado) y **unión validada aparte** (`merge.py` con id-set exacto,
  longitudes, 3 oraciones, atribución por ruta, ASCII-only) más los
  parches del review aplicados con reemplazos exactos asertados.
- **Wiring**: `ProgrammingLanguage.csharp` + `CSharpSyntaxTokenizer`
  nuevo (verbatim `@"..."`, interpolados `$"..."`/`$@"..."`, raw
  `"""..."""`, `@`-identificadores, sufijos numéricos) con 19 tests;
  l10n (`languageCsharp`/`languageCsharpBlurb` + las 4 categorías en
  ambos `.arb`); assets en `pubspec.yaml` + ambos data sources;
  completeness/key-layout tests; `audit_lesson_order.py` (`csharp` en
  `COURSE_ONLY_LANGUAGES`).
- **`content_drift_integration_test`**: 694→**746** total y 249→**272**
  beginner (incluye los 77 snippets de CSS de la sesión concurrente),
  sets de `_` (+8 ids) y `%` (+3) ampliados.
- **Nota de concurrencia**: la sesión de CSS (mismo working tree) dejó el
  `switch` de `SyntaxTokenizers.forLanguage` sin su arm y sus tres rutas
  sin la clave `"language"`, lo que rompía analyze y el test de
  completeness compartidos; se completaron esos cuatro puntos mínimos
  (sin tocar su contenido) para poder verificar C#. `bash tool/format.sh`
  se corrió sobre el repo (formatea archivos ajenos también).
- **Verificado**: tests enfocados de contenido + key-layout + 
  learning_paths **247 verdes**, incluido drift con los conteos nuevos;
  `flutter analyze --fatal-infos --fatal-warnings` limpio. Cierre:
  `bash tool/check.sh` **verde de punta a punta — 648 tests**,
  format/analyze/arquitectura limpios (tras comprimir
  `content_category.dart` a 500 líneas exactas por las categorías de
  C#/CSS/Swift/Dart/Kotlin acumuladas, y arreglar el lint
  `use_raw_strings` de `dart_syntax_tokenizer_test.dart` de la sesión de
  Dart que bloqueaba analyze — cambio mecánico, mismo contenido del
  string).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum`
  (SKILL.md, content-model, snippet-authoring con la receta de .NET 10).

### 2026-09-12 — Go: REST & HTTP (ruta nueva, 33 lecciones, 32 snippets + 4 categorías)

- **Pedido del usuario**: guía bilingüe (en/es) "muy a lo backend":
  endpoints, CRUD, HTTP nativo, conexiones, REST API y lo nuevo de Go
  1.27. Tras preguntarle eligió **ruta nueva independiente**, **memoria +
  database/sql** ("ambas"), y **cliente HTTP + httptest**.
- **Contenido**: `go-rest-http-v1` (33 lecciones, 32 snippets nuevos
  `go-http-001..018` + `go-client-001..005` + `go-httptest-001..003` +
  `go-sqlite-001..006`, más `go-modern-005` reutilizado en la posición
  24): servidor mínimo → `Handler`/`ServeMux`/routing con método y
  `{id}` → request/JSON seguro → modelo+DTOs con **campos promovidos**
  (Go 1.27) → store en memoria con `RWMutex` e IDs `uuid.NewV7()`
  (Go 1.27) → paginación con `Page[T]` y **método genérico** (Go 1.27)
  → errores de dominio → status (400/404/422/500, con `errorMessage`
  ocultando detalles internos) → handlers CRUD → middleware (request ID,
  logging, recovery) → timeouts y shutdown con señales → router final;
  cliente GET/POST con contexto, errores, `Transport`/keep-alive,
  reintentos con backoff y perfil `goroutineleak` (Go 1.27); tests con
  `httptest` (recorder, server real, tabla de endpoints); y persistencia
  `database/sql` con SQLite (`modernc.org/sqlite` puro Go): pool,
  DDL/INSERT con placeholders, `ErrNoRows`, iteración de filas,
  transacción, y capstone `SQLStore` que implementa `TaskStore` sin tocar
  los handlers.
- **4 categorías nuevas** (`httpServers`, `httpClients`, `httpTesting`,
  `sqlPersistence`): enum + doc comments, `.arb` en/es + `gen-l10n`,
  `content_labels.dart`, set `_topicCategories` del test de completitud
  (renombrado desde `_algorithmTopicCategories`) y set espejo del
  `audit_lesson_order.py`.
- **Verificación real, no por ojo**: harness propio
  (`/tmp/opencode/jit-rest`) que envuelve cada lección con su soporte y
  la compila/ejecuta con **go1.27.0** (descargado por `GOTOOLCHAIN`):
  `gofmt` limpio + `go run`/`go build`/`go test` con salida aseverada
  para las 32. SQLite se ejecutó de verdad con `modernc.org/sqlite
  v1.58.0`. E2E adicional con servidores reales: `curl /health` +
  SIGTERM (el server mínimo responde y el de shutdown sale limpiamente).
- **Revisión adversarial fresca** (2 agentes sin contexto): bugs reales
  corregidos — `SQLStore.Update` descartaba `Done` (ahora
  `COALESCE(?, done)` + validación de título), `TaskStore.List` no
  devolvía error (ahora sí, y el handler responde 500 en vez de una
  página vacía), declaraciones compartidas (interface, store, centinelas
  `ErrNotFound`/`ErrInvalidInput`/`ErrMalformedInput`, `queryInt`,
  `errorMessage`, `decodeTask`) ahora **visibles en la primera lección
  que las usa**, `List` con clamp de negativos, `SetConnMaxLifetime`
  solo para bases con archivo (en `:memory:` borraba todo), 
  `fetchAllTasks` propaga errores de parse y ordena por `id DESC`
  (el texto RFC3339Nano no es cronológico con fracciones variables),
  el retry drena antes de cerrar y ya no duerme tras el último intento,
  claims falsos de Go 1.27 (inferencia de funciones en middleware)
  eliminados, recovery tras escritura parcial matizado, 400 vs 422
  separados (`ErrMalformedInput`), y ~20 calcos de español corregidos.
- **Wiring**: catálogo Go 183→215 activos; runtime
  `go_rest_http_v1.json` registrado en `pubspec.yaml`,
  `learning_path_repository_impl.dart` y el test de completitud;
  `content_drift_integration_test` sincronizado (793 activos / 287
  beginner, incluye las sesiones concurrentes); `audit_lesson_order.py`
  verde. Tests enfocados (drift + completeness + key-layout +
  learning_paths) **58 verdes**.
- **Nota de concurrencia**: el tree tenía sesiones activas de Kotlin,
  Swift, CSS, Java y Crystal. Esta sesión además arregló el campo
  `language` faltante en las 3 rutas CSS (rompía tests compartidos).
  `flutter analyze` sigue bloqueado por el wiring a medias de Kotlin
  (`languageKotlin`/`categoryNullSafety` sin casos en `content_labels`
  ni claves en `app_es.arb`).

### 2026-09-12 — CSS: Fundamentos + Layout & Responsive + Avanzado (lenguaje nuevo, 3 rutas, 45 snippets)

- **Pedido del usuario**: un curso de introducción a CSS bilingüe (en/es,
  mismos estándares que las otras guías). Tras preguntarle el alcance
  eligió **tres cursos** y las **7 categorías propias** propuestas;
  aprobó el blurb técnico ("La hoja de estilos de la web — cascada,
  especificidad y layout."). Como el curso avanzado incluye animaciones,
  se agregó una 8ª categoría (`cssTransitionsAndAnimations`) para que
  tuvieran dónde vivir — ninguna categoría de Go representa un concepto
  de CSS, así que las 8 son propias.
- **Contenido**: 45 snippets solo-curso, dificultad 23/19/3, en tres rutas
  — `css-foundations-v1` (16: selectores, modelo de caja, color y
  tipografía), `css-layout-v1` (16: flexbox, grid, posicionamiento,
  unidades/media queries/`clamp()`) y `css-advanced-v1` (13:
  especificidad/herencia/`@layer`, custom properties, transiciones,
  `@keyframes`, `prefers-reduced-motion` + capstone).
- **Verificación real, no por ojo**: CSS no tiene compilador, así que el
  estándar son **dos parsers independientes**: `csstree-validator`
  (valida cada propiedad/valor contra la data de la spec; se comprobó que
  atrapa errores sembrados a propósito) y `lightningcss` (motor Rust de
  Parcel/Vite). Los 45 snippets pasan ambos; `code` ASCII-only (pasa
  `key_layout_map_test`).
- **Autoría bilingüe delegada** (3 agentes, uno por ruta, con el código
  ya verificado leído del draft) y unión validada aparte (id-set,
  longitudes, 3 frases). **Revisión adversarial fresca** (2 agentes sin
  contexto, uno de código/orden y uno de prosa): ~20 hallazgos reales
  corregidos — el orden de `@layer` estaba al revés (la capa declarada
  *después* gana en declaraciones normales), `flex` decía que los ítems
  no se encogen solos (`flex-shrink` default 1), `gap` en un layout sin
  `display: flex/grid` no hacía nada, `width: 100%` + padding desbordaba
  sin `border-box`, `css-flex-003` usaba `flex:` sin contenedor padre,
  referencias adelantadas (`box-sizing`/`max-width`/`overflow`/selector
  universal), `2rem`/`60vh`/`0.02em` usadas en fundamentos antes de su
  lección de unidades (pasaron a `px`), tldr de `z-index` incompleto,
  imprecisiones (padding vertical inline, `text-decoration` no
  posiciona), calcos ES ("El root define X en Y", "la persona pide",
  "escala limpio") y la descripción de la ruta avanzada (frase sin verbo).
- **Wiring**: `ProgrammingLanguage.css` + `CssSyntaxTokenizer` nuevo
  (propiedades posicionales, `@`-rules, hex, unidades, funciones y
  pseudo-clases funcionales, custom properties `--x`) con 17 tests;
  l10n (`languageCss`/`languageCssBlurb` + 8 categorías en ambos `.arb`);
  assets en `pubspec.yaml` + ambos data sources; completeness/key-layout/
  drift tests; `audit_lesson_order.py` (`css` en `COURSE_ONLY_LANGUAGES`).
- **Bug real encontrado por el test de completeness**: los 3 JSON de
  rutas generados no traían la clave `language` (el test de orfandad la
  usa); corregido y regenerado.
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum` (SKILL.md,
  content-model, snippet-authoring con la receta de los dos parsers).
- **Verificado**: `flutter test` completo **600 verdes**; `flutter
  analyze --fatal-infos --fatal-warnings` limpio; `check_architecture`
  sin violaciones duras; `dart format` limpio en los archivos tocados;
  `audit_lesson_order.py` verde para las 3 rutas.
- **Nota de concurrencia**: el mismo working tree traía sesiones activas
  de C# y del teclado 3D; una de ellas ya había actualizado el drift test
  con los conteos/ids de CSS mientras corría esta sesión — se validaron
  contra el catálogo final (45 snippets, 23 principiantes, sets de `_`/`%`
  correctos) y la sesión de C# volvió a subir los totales combinados
  después (746/272), sin romper nada.

### 2026-09-12 — Teclado del perfil: look pseudo-3D estilo VIA (parallax, drag-to-orbit, hover/press, contraste)

- **Pedido del usuario**: el visual del teclado en Profile se veía plano;
  quería un efecto "2D que parece 3D" estilo UI de VIA. Decisiones
  acordadas por pregunta explícita: **híbrido** extrusión + gradiente sutil
  (sin blur), **hover/press por tecla**, **tilt isométrico solo en el
  hero**, y **más contraste de case**.
- **Arquitectura** (`lib/features/profile/presentation/widgets/keyboard/`):
  `keyboard_keycap_style.dart` nuevo (colores, radios y profundidades
  resueltos del `ColorScheme`); `KeyboardLayoutTransform` en
  `keyboard_layout_geometry.dart` (fit + rects + hit-test con rotación
  invertida, **compartido** por painter y puntero para que jamás diverjan);
  `KeyboardLayoutPainter` reescrito a slabs extruidos (labio inferior sólido
  + cara superior con gradiente vertical de 2 paradas); press hunde la cara
  y colapsa el labio. `KeyboardVisual` pasó a `ConsumerStatefulWidget`
  (`MouseRegion` + `Listener` + `AnimationController` con `AppMotion`) con
  `tiltDegrees` opcional (default 0 = **reposo centrado**); el preview de
  `EditProfileScreen` queda plano por defecto. En el hero la card **rastrea
  el puntero** sobre toda su superficie (`MouseRegion` + `GlobalKey`) y
  alimenta `pointerTilt` (±6° por eje) con `TweenAnimationBuilder` lento
  (`AppMotion.spatialDefault`), así el tablero gira siguiendo el mouse sin
  saltos y vuelve a centrado al salir (pedido explícito del usuario).
- **Drag-to-orbit** (misma sesión, pedido posterior): arrastrando con el
  mouse sobre la card se gira el 3D como visor de producto — horizontal =
  yaw (±60°), vertical = pitch (±30°) — y el ángulo **persiste** al soltar;
  umbral de 4 px para que un click normal siga siendo press de tecla (al
  cruzar el umbral se cancela el press vía `interactiveSuspended`). Cursor
  `grab`/`grabbing`, solo mouse (touch sigue scrolleando la lista). La
  perspectiva es **dinámica** (0.006 pleno hasta 8° y decreciente después):
  con factor fijo, un drag de 40°+ proyectaba el case fuera de la card al
  escalar el borde cercano.
- **Contraste medido, no adivinado**: `surfaceBright`/`surfaceDim` se
  invertían en gruvbox light y colapsaban a ~1.06 en varias dark; el style
  ancla el board al extremo oscuro (`inverseSurface` en light,
  `surfaceContainerLowest`+`shadow` en dark) y las teclas al claro, con
  test que exige contraste ≥2.5 en las **48 combinaciones**
  paleta×brightness.
- **Tests**: `keyboard_keycap_style_test.dart` (contraste + acentos),
  casos nuevos de `KeyboardLayoutTransform` (rects, rotación, stepped,
  `keyIndexAt`, espacio para la extrusión), de `keyboard_visual_test.dart`
  (hover, press/release, `interactive: false`, hit-test con tilt,
  `pointerTilt` vs. su ausencia, `rotation` de drag,
  `interactiveSuspended` libera el press) y
  `profile_keyboard_hero_card_test.dart` (el parallax responde al mouse y
  se resetea al salir; el drag orbita, respeta el umbral de click y
  persiste tras soltar).
- **Harness visual**: `test/_manual_visual_check.dart` captura light/dark,
  gruvbox, blackWhite, hover y pressed (`/tmp/hero_*.png`). Gotcha real:
  `RenderRepaintBoundary.toImage` en widget tests **debe** ir dentro de
  `tester.runAsync`; si no, el body termina pero el teardown cuelga para
  siempre (y `pump(60ms)` extra para el primer tick del `Ticker`).
- **Docs**: excepción al "flat, no gradients/shadows" documentada en
  `STACK.md` §2.5 y en la sección Design system de `AGENTS.md`/`CLAUDE.md`
  (mirror byte a byte re-hecho).
- **Gate**: `bash tool/check.sh` de hoy — el format-check global se detiene
  en archivos **ajenos en vuelo** de `content` (C#/CSS: `csharp_syntax_
  tokenizer.dart` sin formatear, `ProgrammingLanguage.css` sin cablear). Con
  esos archivos fuera del foco: analyze/arquitectura limpios para todo lo
  demás (341 archivos, 0 violaciones) y **todos los tests del teclado en
  verde** (32 en los 4 archivos del keycap/transform/visual/hero).

### 2026-09-12 — Crystal: Fundamentos + Algoritmos (lenguaje nuevo, 2 rutas, 28 snippets)

- **Pedido del usuario**: un curso de introducción a Crystal bilingüe
  (en/es, mismos estándares que las otras guías). Tras preguntarle el
  alcance eligió **dos cursos** y el **tour amplio** para fundamentos:
  `crystal-foundations-v1` (16 lecciones: variables e inferencia, strings,
  condicionales, `case/when`, ciclos, rangos, métodos, bloques/`yield`,
  arreglos, hashes, nil-safety, clases, structs, módulos y excepciones) +
  `crystal-algorithms-v1` (12, misma secuencia canónica de Go/Rust/Python/
  JS/TS/Haskell/C/C++/Java). Crystal entra como lenguaje **solo-curso** con
  **tres categorías propias** — `blocksAndProcs`, `collections`,
  `nilSafety` — porque `yield`/bloques, arreglos/hashes y los tipos unión
  con `nil` no encajan en las categorías existentes; el resto reutiliza
  `variablesAndTypes`, `conditionals`, `loops`, `functions`,
  `classesAndObjects`, `modules`, `errorHandling` y las 3 de algoritmos.
- **Wiring**: `ProgrammingLanguage.crystal` + labels/blurb
  (`languageCrystal`/`languageCrystalBlurb` + las 3 categorías en ambos
  `.arb`), `crystal_syntax_tokenizer.dart` nuevo (comentarios `#`, `//`
  como división entera —no comentario—, strings con interpolación, chars,
  `0x`/`0b`/`0o`, sufijos `_i64`, y el punto de `1..5`/`3.times`/`1..]`
  como puntuación), assets en `pubspec.yaml` + ambos data sources, y
  `crystal_syntax_tokenizer_test.dart` (18 casos).
- **Verificación real, no por ojo**: los 28 snippets se corrieron con
  **Crystal 1.21.0 real** (`podman run
  docker.io/crystallang/crystal:latest`): los 16 de fundamentos son
  programas ejecutables (output comparado contra lo que afirma la prosa) y
  los 12 de algoritmos se manejaron con drivers de casos borde (arreglo
  vacío, un elemento, duplicados, ya ordenado, invertido, objetivo
  ausente; BFS/DFS con el `Graph` de la lección 9 antepuesto; Dijkstra
  fuzzeado contra Bellman-Ford). Gotchas reales cazados antes de entrar al
  catálogo: `/` sobre enteros devuelve `Float64` (hay que usar `//`), no
  existe `block_given?` ni bloque nilable, `String#to_sym` no existe,
  `String#to_i` lanza en entrada inválida (`to_i?` da nil), `Box` colisiona
  con la clase `Box(T)` de la stdlib, y `struct` copia por valor.
- **Prosa bilingüe** delegada a 2 agentes (uno por curso) con el código ya
  verificado pegado en el prompt + validación independiente del
  orquestador (id-set, longitudes ≤80/≤950, conteo de frases 2-3) y
  spot-check de calidad.
- **Revisión adversarial fresca** (agente sin contexto que recompiló los
  28, fuzzeó los 12 algoritmos —16k asserts— y probó el tokenizer):
  0 blockers, 2 hallazgos reales y 9 nits, **todos corregidos** — la prosa
  de heap sort prometía O(1) de memoria (el `dup` es O(n)), el tokenizer se
  comía el primer punto tras un dígito (`1..5`, `3.times`), Dijkstra ahora
  itera `while visited.size < dist.size` (soporta `nodes` sin `start`), DFS
  usa acumulador mutable (O(V+E) real, sin `concat` que copiaba por
  nivel), claims de complejidad/memoria corregidos, `capitalize` documenta
  que también baja a minúsculas el resto, el ejemplo de arreglos/rangos de
  la lección de loops se movió a la lección de arreglos (menos referencias
  hacia adelante) y 4 pulidos de español.
- **Chequeos**: `bash tool/check.sh` completo en verde — **558 tests**,
  format/analyze/arquitectura limpios; `audit_lesson_order.py` verde para
  ambas rutas (course-only, sin huérfanos); catálogo total 589→617
  snippets, beginner 207→222.
- **Nota de concurrencia**: había otra sesión agregando C, C++ y Java en
  vivo al mismo árbol (mismos archivos compartidos). Se trabajó primero lo
  libre de colisiones (contenido/tokenizer/tests propios) y el wiring se
  hizo en una sola pasada vigilando cada archivo; Java se documentó
  también en `SPEC.md`/`AGENTS.md` porque la otra sesión lo dejó sin docs
  (el doc es la fuente de verdad y no debía quedar mintiendo). El set de
  `_` del `content_drift_integration_test` se movió de `crystal-loop-002`
  a `crystal-arr-001` tras el cambio de código.
- Docs actualizados: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` + `CLAUDE.md`
  (espejo byte a byte), la skill `content-curriculum` (SKILL.md,
  content-model, snippet-authoring) y este archivo.

### 2026-09-12 — C++: Fundamentos + Algoritmos + Avanzado (lenguaje nuevo, 3 rutas, 45 snippets)

- **Pedido del usuario**: un curso de introducción a C++ bilingüe (en/es,
  mismos estándares que las otras guías). Tras preguntarle el alcance
  eligió **tres cursos** (fundamentos + algoritmos + avanzado) y
  categorías propias: `cpp-foundations-v1` (18 lecciones: tipos, control
  de flujo, referencias y punteros, `std::vector`, structs y clases),
  `cpp-algorithms-v1` (12, secuencia canónica; grafo como lista de
  adyacencia en la 9 y Dijkstra con `WeightedGraph` en la 12) y
  `cpp-advanced-v1` (15: RAII/punteros inteligentes, semántica de
  movimiento, STL, plantillas y conceptos, excepciones, herencia y
  concurrencia). C++ entra como lenguaje **solo-curso** con **dos
  categorías propias** — `templates` y `stlContainers` — y reutiliza las
  genéricas ya existentes (incluidas `pointers`, `classesAndObjects`,
  `memoryManagement`, `errorHandling` y `concurrency`).
- **Verificación real, no por ojo**: los 45 snippets se compilaron con
  **g++ 16 y clang++ 22** (`-std=c++20 -Wall -Wextra -Werror -pthread`) y
  se ejecutaron contra salida esperada; los 12 algoritmos (definiciones
  puras) con drivers y fuzz contra referencias independientes.
- **Revisión adversarial fresca** (2 agentes sin contexto): recompilaron
  los 45 desde el JSON final (ASan+UBSan; TSan en la lección de hilos),
  fuzzearon los 12 algoritmos contra `std::sort`/`std::find`/Bellman-Ford
  y auditaron prosa y orden. Hallazgos reales corregidos: `Buffer` (RAII)
  ahora es no copiable (el doble-free latente que encontró ASan), la prosa
  de `join` dice `std::terminate` (no "el programa termina antes"),
  `find_if` se comprueba contra `end()` antes de desreferenciar, el bloque
  de referencias/punteros se movió antes de funciones (elimina el
  forward-reference de `const&`), el tldr de `.size()` dice bytes (no
  caracteres), y precisión de prosa en quicksort (`<=`), Dijkstra
  (no-negativo), `std::map` (sin "árbol balanceado") y `std::move` (sin
  "transferencia de punteros").
- **Wiring**: `ProgrammingLanguage.cpp` + `CppSyntaxTokenizer` nuevo
  (C++20: raw strings con delimitador `R"tag(...)tag"`, separadores de
  dígitos `1'000`, operadores alternativos `and`/`or`/`not`,
  `#include <...>` como string) con 20 tests; l10n (`languageCpp`/
  `languageCppBlurb` + `categoryTemplates`/`categoryStlContainers` en
  ambos `.arb`); assets en `pubspec.yaml` + ambos data sources;
  completeness/key-layout tests; `audit_lesson_order.py` (`cpp` en
  `COURSE_ONLY_LANGUAGES`).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo byte a byte), skill `content-curriculum` (SKILL.md,
  content-model, snippet-authoring con la receta de C++).
- **Verificado**: `tool/check.sh` corre entero — format/analyze/arquitectura
  limpios; `flutter test`: **557 de 558 verdes**, con el único fallo en
  `crystal-loop-002` (falta en el set de `_` del drift test, sesión de
  Crystal en vuelo — ajeno a C++). Los 4 tests de contenido + key layout en
  verde; `audit_lesson_order.py` verde para las 3 rutas; arquitectura sin
  violaciones duras. Se eliminó (con OK del usuario) el scratch ajeno
  `test/_scratch_colors_test.dart`, que era el único bloqueo de analyze.

### 2026-09-12 — Go: Interfaces & Types (ruta nueva, 24 lecciones, 23 snippets)

- **Pedido del usuario**: una guía bilingüe (en/es) enfocada 100% en
  interfaces de Go, "de inicio a fin": declaración, variaciones, method
  sets, valores de interfaz, `any`/type assertions/type switch, embedding
  (interfaz en interfaz), JSON (`MarshalJSON`/`UnmarshalJSON`), métodos
  exportados vs no exportados, la satisfacción implícita ("se conecta
  solito") y la diferencia entre `type`, `struct` e `interface`. Tras
  preguntarle: aceptó **ruta nueva independiente**, profundidad
  **~24-26 lecciones** y título **"Go: Interfaces & Types" / "Go:
  Interfaces y tipos"** (tag `Interfaces`).
- **Contenido**: `go-interfaces-v1` (24 lecciones) + 23 snippets nuevos
  (`go-iface-005`..`go-iface-027`, categorías `variablesAndTypes` (1),
  `structs` (1) e `interfaces` (21)) y 1 snippet reutilizado
  (`go-iface-002`, la implementación implícita mínima). Orden por
  dependencia de concepto: `type`/`struct`/`interface` → satisfacción
  implícita → method sets (puntero vs valor) → valor de interfaz
  (tipo dinámico, nil vs typed nil) → `any`, comma-ok, type switch →
  `Stringer`, `error` → composición (embedding) → `io.ReadWriter`,
  `sort.Interface` → JSON → sellado con método no exportado → embedding
  de structs que promueve métodos → interfaz `Clock` testeable →
  capstone con tipos, structs, interfaces y JSON. La revisión adversarial
  quitó del path dos snippets reutilizados que duplicaban el mismo
  concepto (`go-iface-001`/`go-iface-003`, ambos ya en
  `go-intermediate-syntax-v1`) — quedan accesibles en práctica libre.
- **Verificación real, no por ojo**: los 23 snippets se pasaron por
  `gofmt -l` (limpio) y `go run`/`go build` con la salida esperada
  aseverada (Go 1.26.5), incluidos los compile-only envueltos en un
  `main` vacío.
- **Autoría bilingüe delegada** (2 agentes en paralelo con el código ya
  verificado pegado literal) y **unión validada aparte** (id-set exacto,
  longitudes, 3 frases por explicación). **Revisión adversarial fresca**
  (2 agentes sin contexto, uno de currícula y uno de código/prosa): 7
  hallazgos reales aplicados — títulos de `go-iface-005` precisados
  (defined type ≠ alias), `go-iface-010` ya no nombra "typed nil" antes
  de su lección, `go-iface-018` aclara que las interfaces de restricción
  también admiten type terms desde Go 1.18, `go-iface-024` matiza el
  sellado (embeber un tipo que ya lleva el método igual lo promueve),
  `go-iface-026` explica `time.Date`/`After` y que imprime `false`, la
  descripción de la ruta ya no promete código de test, y ~10 correcciones
  de español natural (calcos de "informa", "impresor", "costura",
  "unmarshaling", "Capstone" → "Proyecto final").
- **Wiring**: `assets/content/learning_paths/go_interfaces_v1.json`
  nuevo, registrado en `pubspec.yaml`,
  `learning_path_repository_impl.dart` y
  `snippet_catalog_completeness_test.dart`; `audit_lesson_order.py` verde
  (24 lecciones, id/order sincronizados, categorías contiguas). El
  `content_drift_integration_test` quedó sincronizado con el catálogo
  sembrado real (**617 activos / 222 beginner**, incluye Java y Crystal
  de sesiones concurrentes) y los sets de `_`/`%` recomputados
  (177/76; nuevos ids `go-iface-010`/`027` y
  `go-iface-011`/`013`/`015`/`016`/`021`/`022` respectivamente).
- **Nota de concurrencia**: el mismo working tree tenía sesiones activas
  de C++, Java y Crystal tocando `programming_language.dart`,
  `content_labels.dart`, data sources y el mismo drift test; una de ellas
  pisó los conteos a mitad de sesión (los míos se recalcularon encima).
  Tests enfocados verificados: drift + completeness + key-layout +
  learning_paths = **58 verdes**.
- **Verificado**: `audit_lesson_order.py` verde; tests enfocados (drift +
  completeness + key-layout + learning_paths) **58 verdes**; `flutter
  test` completo **554 verdes**; `dart format` limpio en todos los
  archivos de esta sesión; `flutter analyze` limpio salvo 6 infos de
  `test/_scratch_colors_test.dart` (scratch de una sesión concurrente).
  `bash tool/check.sh` **se detiene en el format check** por 4 archivos
  ajenos a esta sesión: `keyboard_keycap_style.dart`,
  `keyboard_layout_painter.dart`, `test/_manual_visual_check.dart` y
  `test/features/content/crystal_syntax_tokenizer_test.dart`. Este
  trabajo no toca runtime: solo assets y tests.

### 2026-09-12 — Tecleo rápido/solapado (tests) + fix del dwell de la última tecla (practice)

- **Pedido del usuario**: revisar cómo se comporta la experiencia de
  velocidad al teclear (gente que teclea muy rápido o con muchas teclas a la
  vez) y si había soporte para esos escenarios. Se auditaron captura y
  métricas, y se agregaron tests de ráfaga y solape — que destaparon un hueco
  real: la sesión termina en el **keydown** de la última tecla, así que su
  keyup (y el de cualquier tecla aún sostenida) llegaba con
  `status == finished`, nunca parcheaba su `dwell`, y el snapshot persistido
  ya se había tomado.
- **Tests nuevos** (`test/features/practice/keystroke_capture_field_test.dart`):
  solape de 3 teclas con sueltes desordenados (cada `dwell` cae en su propio
  keystroke), ráfaga de ~66 CPS con 2 teclas solapadas (cero pérdidas, flight
  inter-onset), la tecla que completa la sesión conserva su dwell, y un keyup
  que nunca llega no cuelga la sesión.
- **Fix**: ventana de "settle" acotada al terminar (`_DwellSettle` en
  `practice_session_finish.dart`, tope 250ms) que el campo resuelve al
  instante vía `concludePendingDwell()` cuando se suelta la última tecla;
  keyups durante `finished` parchean su dwell (los keydowns se siguen
  ignorando para que Escape/atajos burbujeen) y `practice_session_screen.dart`
  ya no desmonta el campo hasta `result`. El reloj de sesión se congela antes
  del settle (no infla `duration`). Refactor por el límite de 500 líneas:
  `_elapsedSoFar`/`_persistFinishedSession` a part files y el auto-scroll a
  `keystroke_capture_autoscroll.dart`.
- **Hallazgo extra**: `ExternalSnippetPackSource` y
  `LearningPathRepositoryImpl._loadExternalInto` documentan "deliberately
  never throws" pero su `listSync()` quedaba fuera del try/catch (un pack dir
  que desaparece entre resolver y listar tumbaba el recompute). Ahora ambos
  degradan a "sin packs externos" con warning. El test de persistencia
  también se endureció (`_drainBackgroundWork`): `pumpEventQueue()` no drena
  el I/O real de fondo (carrera de teardown que el settle hizo aflorar).
- **Verificado**: `test/features/practice` 118/118 y packs/drift 28/28;
  analyzer y `check_architecture` limpios en lo tocado. La suite completa
  queda roja por el WIP concurrente de otra sesión (l10n de Crystal y
  `test/features/content/_tmp_cpp_wiring_review_test.dart`), no por esto.

### 2026-09-12 — Links del perfil: GitHub + página web (drift v16, url_launcher)

- **Pedido del usuario**: poder poner tu GitHub y tu página web personal en
  Profile, y que al tocar abran el navegador. Tras preguntarle la ubicación,
  eligió **tarjeta "Links" propia** en la pantalla de Profile (no chips
  dentro de "About me").
- **Datos + migración**: dos columnas nullable en `guest_profiles`
  (`github_username`, `website_url`), `schemaVersion` 15→16 con su bloque
  aditivo en `onUpgrade`; DTO, mapper (DTO/entidad/fila), DAO, puerto y
  adaptador del repositorio y `ActiveProfileController` extendidos en
  cadena — el editor sigue siendo una sola escritura atómica.
- **Normalización en `UpdateProfileCustomizationUseCase`** (nunca URLs
  crudas en la DB): GitHub acepta handle, `@handle`, `github.com/handle` o
  URL completa con query y guarda solo el handle (regex 1-39, alfanum +
  guiones simples, sin guion inicial/final/doble); la web acepta
  `ejemplo.com` y guarda `https://ejemplo.com` (solo http/https con host
  con punto). Inválidos → `ValidationFailure` antes de tocar el repo.
  `profileCustomizationInvalid` ahora dice "algún campo no es válido" en
  vez de "demasiado largo".
- **UI**: sección "Enlaces" con dos `TextField` en `EditProfileScreen`;
  `ProfileLinksCard` nueva en Profile (se auto-oculta sin links, mismo
  patrón que `ProfileDeviceCard`) con filas tappables, ícono Lucide de
  enlace externo (`gitBranch300`/`globe300`/`externalLink300`; Lucide no
  trae brand icon de GitHub) y apertura best-effort vía
  `launchUrl(..., LaunchMode.externalApplication)` en try/catch, con seam
  `onOpenUrl` para tests.
- **Avatar de GitHub** (ampliación pedida en la misma sesión):
  `ProfileAvatar` nuevo (extraído de `ProfileScreen`) usa
  `https://github.com/<handle>.png?size=200` como foto del círculo, con
  `loadingBuilder`/`errorBuilder` que caen a la inicial del username — el
  perfil offline nunca depende de la red para renderizar. Requirió
  declarar el permiso `INTERNET` en `AndroidManifest.xml` (Android no lo
  tenía; también lo necesitará Supabase) — anotado en `STACK.md` §3.4.
- **`url_launcher ^6.3.2`** nueva dependencia directa (ya resolvía en el
  lock como transitiva) — fila en la matriz `STACK.md` §3.1 + párrafo en
  §3.2; `SPEC.md` §7.3 menciona los enlaces; strings en ambos `.arb`.
- **Verificado**: 54 tests del feature profile verdes (usecase nuevo con
  tabla de normalización/rechazo, widget test de la tarjeta con el seam,
  avatar con su fallback, round-trip drift de los links vía stream
  reactivo), format y `check_architecture.dart` limpios. **`bash
  tool/check.sh` completo no se pudo cerrar en verde por una sesión
  concurrente** en el mismo working tree: sus archivos de `practice` sin
  commitear dejan `flutter analyze` en rojo y su test de persist-retry
  falla de forma intermitente — ajeno a este trabajo; el resto de la suite
  (539 tests verdes, incluidos los de profile) pasa.

### 2026-09-12 — C: Fundamentos + Algoritmos + Sistemas (lenguaje nuevo, 3 rutas, 45 snippets)

- **Pedido del usuario**: un curso de introducción a C bilingüe (en/es,
  mismos estándares que las otras guías). Tras preguntarle el alcance
  eligió **tres cursos**: `c-foundations-v1` (15 lecciones: tipos,
  control de flujo, arreglos/strings, punteros y funciones),
  `c-algorithms-v1` (12, secuencia canónica de búsqueda/ordenamiento/grafos)
  y `c-systems-v1` (18: structs, memoria dinámica, punteros de bajo nivel,
  preprocesador, errores y archivos). C entra como lenguaje **solo-curso**
  con **cuatro categorías propias** — `arraysAndStrings`,
  `memoryManagement`, `preprocessor`, `fileIO` — y reutiliza las genéricas
  (`variablesAndTypes`/`conditionals`/`loops`/`functions`) más `pointers`,
  `structs` y `errorHandling`.
- **Verificación real, no por ojo**: los 45 snippets se compilaron con
  **gcc 16 y clang 22** (`-std=c17 -Wall -Wextra -Werror -pedantic` +
  `-fsanitize=address,undefined`, `detect_leaks=1`) y se ejecutaron con
  chequeo de salida; los 12 algoritmos (definiciones puras) se corrieron con
  drivers y se fuzzearon contra referencias independientes: sorts vs `qsort`
  (tamaño 0/1, duplicados, ya ordenado, invertido), búsquedas entre sí,
  BFS/DFS vs flood-fill (grafos desconectados), Dijkstra vs Bellman-Ford
  (vértices inalcanzables).
- **Revisión adversarial fresca** (2 agentes sin contexto, uno de código y
  uno de currícula): 5 problemas reales corregidos antes de cerrar —
  overflow de `int` en Dijkstra (`distances[current] + weight` con pesos
  legales; UBSan lo confirmó → guarda `distances[current] <= INT_MAX -
  weight`), `malloc` sin check de `NULL` en el `merge` de merge sort (ahora
  retorna `-1` y `merge_sort` lo propaga), afirmación falsa "C no tiene
  `bool`" (C99 tiene `_Bool`/`<stdbool.h>`), afirmación imprecisa de que
  `errno` solo se asigna al fallar, y jerga ES (`array`→`arreglo`,
  `helper`→`auxiliar`, `castea`, `fugado`, `bufferizado`, `se hunde`).
  También se reordenó `c-foundations-v1` para enseñar punteros (lección 12)
  antes que funciones (13-15) y evitar el forward-reference en el capstone.
- **Decisión deliberada**: los snippets de C siguen la convención de
  fragmentos del resto del catálogo (Go/Rust/Python), con `#include` solo
  en la primera lección; no se repiten los headers en cada snippet porque
  ninguna otra guía incluye imports en sus fragmentos.
- **Wiring**: enum `ProgrammingLanguage.c`, `CSyntaxTokenizer` nuevo
  (directivas `#`, `#include <...>` como string, char literals, números con
  sufijos) + 16 tests, l10n (`languageC`/`languageCBlurb` + 4 categorías en
  ambos `.arb`), assets en `pubspec.yaml` + ambos data sources,
  completeness/key-layout tests, `audit_lesson_order.py` (`c` en
  `COURSE_ONLY_LANGUAGES`). `content_drift_integration_test` 440→485 total
  y 142→167 beginner, con los sets de `_`/`%` ampliados con los 20/26 ids
  de C que los contienen.
- **Nota de concurrencia**: el mismo working tree tenía una sesión activa
  agregando C++ (mismo día, mismos archivos: drift test, pubspec, data
  sources, SPEC/AGENTS) y otra tocando practice/profile. Los conteos
  finales del catálogo combinado quedan en 530/185; la sesión de C++ ya
  corrigió su conteo stale del drift test. Al cierre, `tool/check.sh` se
  detiene en el format check por el temporal
  `test/features/content/_tmp_cpp_wiring_review_test.dart` de esa sesión
  (analyze y arquitectura sí pasan; la sesión de practice ya bajó
  `practice_session_controller.dart` de 509 a 497 líneas).
- **Docs actualizados**: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo), skill `content-curriculum` (SKILL.md,
  content-model, snippet-authoring con la verificación de C).
- **Verificado**: `flutter test test/features/content/` +
  `test/features/practice/key_layout_map_test.dart` en verde (144 tests,
  incluye los de la sesión de C++) y `test/features/learning_paths/` (38);
  `flutter test` completo: 508 verdes con un único fallo de carga
  intermitente en `deep_link_providers_test.dart` que pasa al correrlo
  solo (flutter re-resolvió dependencias a mitad de corrida por la
  sesión concurrente); `flutter analyze` limpio; format y arquitectura
  sin violaciones en los archivos de C.

### 2026-09-12 — TypeScript: Fundamentos + Algoritmos (lenguaje nuevo, 2 rutas, 29 snippets)

- **Pedido del usuario**: un curso de introducción a TypeScript bilingüe
  (en/es, mismos estándares que las otras guías). Tras preguntarle el
  alcance eligió **dos cursos** y el **tour amplio**:
  `typescript-foundations-v1` (17 lecciones: anotaciones e inferencia,
  uniones y tipos literales, `interface`/`type`, `enum`, condicionales,
  `?.`/`??`, unión discriminada con `switch`, ciclos
  (`for`/`for...of`/`for...in`), clases con modificadores de acceso,
  funciones tipadas, flecha y genéricos, capstone `countEvens`, y
  módulos) + `typescript-algorithms-v1` (12, misma secuencia canónica de
  Go/Rust/Python/JS/Haskell). TS entra como lenguaje **solo-curso** con
  **dos categorías propias** — `classesAndObjects` y `modules` — porque
  el tour cubre clases y módulos que las categorías genéricas no
  representan; el resto reutiliza `variablesAndTypes`, `conditionals`,
  `loops` y `functions`.
- **Wiring**: `ProgrammingLanguage.typescript` + labels/blurb
  (`languageTypescript`/`languageTypescriptBlurb` + las 2 categorías en
  ambos `.arb`), `typescript_syntax_tokenizer.dart` nuevo (keywords de JS
  + modificadores/tipos primitivos/operadores de tipo; de paso reconoce el
  prefijo `0x`, que el tokenizer de JS no cubría), assets en `pubspec.yaml`
  + ambos data sources, y `typescript_syntax_tokenizer_test.dart`
  (13 casos).
- **Verificación real, no por ojo**: los 29 snippets se compilaron uno a
  uno con `tsc --strict` (TypeScript 7) y se ejecutaron con `node`; los 12
  de algoritmos (solo definiciones) con drivers descartables que los
  llaman con casos borde (arreglo vacío, un elemento, objetivo ausente).
  Dos colisiones con globales del DOM (`name`, `status`, `TS2451`)
  obligaron a renombrar bindings en `vars-001`/`vars-004`.
- **Revisión adversarial fresca** (agente sin contexto que recompiló los
  29 y fuzzeó los 12 algoritmos contra referencias, con Bellman-Ford
  independiente para Dijkstra): 3 hallazgos reales corregidos — el título
  de `oop-002` prometía un getter inexistente, 4 snippets mal etiquetados
  `short` (pasaron a `medium`) y 3 frases en español mejoradas. El uso de
  `Graph`/`WeightedGraph` definidos en la lección 9 se mantuvo a
  propósito: es el mismo patrón que `rust-algorithms-v1`
  (`fn bfs(graph: &Graph, ...)`).
- **Chequeos**: `bash tool/check.sh` en verde — **456 tests**,
  format/analyze/arquitectura limpios; `audit_lesson_order.py` verde para
  ambas rutas (course-only, sin huérfanos); catálogo total 411→440
  snippets. Docs actualizados: `SPEC.md` §3.1/§3.2/§18, `AGENTS.md` +
  `CLAUDE.md` (espejo), la skill `content-curriculum` (SKILL.md,
  content-model, snippet-authoring).

### 2026-09-12 — Haskell: Fundamentos + Algoritmos (lenguaje nuevo, 2 rutas, 24 snippets)

- **Pedido del usuario**: un curso de introducción a Haskell (bilingüe
  en/es, mismos estándares que las otras guías). Tras preguntarle el
  alcance eligió **dos cursos**: `haskell-foundations-v1` (12 lecciones
  solo-principiante) + `haskell-algorithms-v1` (12, misma secuencia
  canónica de Go/Rust/Python/JS). Haskell entra como lenguaje
  **solo-curso** (`haskell_v1.json`), sin categorías nuevas: los
  fundamentos reutilizan `variablesAndTypes`, `conditionals` y `functions`
  (sin bloque `loops`: la recursión se presenta como el sustituto
  funcional de la iteración), y Algoritmos reutiliza las 3 categorías de
  búsqueda/ordenamiento/grafos ya existentes. Copy aprobado por el
  usuario: "Haskell from scratch" / "Haskell desde cero", tag
  Beginner/Principiante, blurb "Purely functional — ..." /
  "Funcional y puro — ...".
- **Wiring**: `ProgrammingLanguage.haskell` + labels/blurb
  (`languageHaskell`/`languageHaskellBlurb` en ambos `.arb`),
  `haskell_syntax_tokenizer.dart` nuevo (comentarios `--` que no son
  comentario si siguen siendo operador (`-->`, `---`), `{- -}` anidados,
  char literal vs apóstrofe en identificadores `sum'`), assets en
  `pubspec.yaml` + ambos data sources, y
  `haskell_syntax_tokenizer_test.dart`.
- **Verificación real, no por ojo**: los 24 snippets se typechequearon con
  `ghc -fno-code` y los runnables (13, con `main` o harness) se
  ejecutaron con `runghc` en un contenedor descartable
  `haskell:9.8-slim` (GHC 9.8.4) — igual que el curso SQL usó
  postgres:16-alpine. Tres bugs reales atrapados antes de entrar al
  catálogo: heapify con `foldr` en vez de `foldl'` (heap inválido),
  heapsort devolvía descendente (faltaba `reverse`), y el harness de
  Dijkstra con indentación inválida. Prosa bilingüe (tldr + explicación
  3 frases) delegada a un agente de fondo y validada aparte (id-set,
  longitudes, conteo de frases).
- **Revisión adversarial fresca** (agente sin contexto, que además
  ejecutó GHC y fuzzeó los sorts/Dijkstra contra referencias): encontró 7
  problemas reales, todos corregidos — afirmación falsa sobre el scope de
  guards; complejidad engañosa de `binarySearch` (cada paso re-recorre la
  lista: O(n) real); claim de `O(n log n)` de heapsort con `//` (copia
  O(n) por update) + término "copy-on-write" incorrecto + `foldl` →
  `foldl'`; `factorial` parcial con negativos → guards `n <= 0`;
  `insert` del grafo prepend vs append (consistencia de recorridos con
  Rust/Python/JS); prosa de quicksort ("compara una vez"); tokenizer
  (`-->`/`---` ya no son comentario y faltaban builtins usados por el
  catálogo: `maybe`, `lookup`, `splitAt`, `minimum`, `id`, `foldl'`…).
  Nits aplicados: firmas `::` presentadas en las lecciones 3-4,
  terminología "helper", rango `[1 .. 5]` explicado en el capstone.
- **Tests/docs actualizados**: `content_drift_integration_test` (387→411
  snippets, beginner 117→133, ids con `_`), `snippet_catalog_completeness_test`
  (catálogo + 2 rutas), `key_layout_map_test`, `audit_lesson_order.py`
  (`haskell` en `COURSE_ONLY_LANGUAGES`); `SPEC.md` §3.1/§3.2/§18;
  `AGENTS.md`/`CLAUDE.md` (espejo byte a byte); skill
  `content-curriculum` (SKILL.md, content-model.md y la verificación de
  Haskell).
- **Verificado**: `bash tool/check.sh` completo en verde — **456 tests**,
  format/analyze/arquitectura limpios; `audit_lesson_order.py` verde para
  ambas rutas.

### 2026-09-12 — Fix: web no abría drift y los content packs tumbaban las guías

- **Síntoma reportado por el usuario**: en `flutter run -d chrome` la app
  arrancaba pero las guías (Learning Paths) no cargaban. Los warnings de
  consola (`webGLVersion is -1` → CPU-only rendering; `AudioContext was not
  allowed to start`) eran ruido ambiental, no la causa. Eran **dos bugs
  encadenados** de web.
- **Causa raíz 1 — drift nunca abría**: `AppDatabase` llamaba
  `driftDatabase(name: 'ridge.db')` **sin** `web:` — en `drift_flutter`
  0.3.1 la rama web lanza `ArgumentError` ("When compiling to the web, the
  web parameter needs to be set") antes de abrir nada, así que ninguna query
  corre. Cadena: el catálogo de snippets nunca se siembra (`catalogSeed`),
  `LearningPathsController` recibe catálogo vacío y devuelve `[]`, y todo lo
  drift-backed (guías, progreso de lecciones, práctica) queda vacío. Además,
  `web/` no traía `sqlite3.wasm` ni `drift_worker.js`.
  **Fix**: `web/sqlite3.wasm` (749 KB) + `web/drift_worker.js` (357 KB)
  versionados, bajados del release `drift-2.35.0` (mismo drift del
  `pubspec.lock`; los dos sha256 verificados contra la API de GitHub), y
  `AppDatabase` ahora pasa `web: DriftWebOptions(sqlite3Wasm: ...,
  driftWorker: ...)` — ignorado en builds nativos. El usuario final no
  descarga nada a mano: los dos archivos viajan en `build/web/` como
  cualquier asset.
- **Causa raíz 2 — content packs usaban `path_provider` en web** (detectada
  al re-probar con drift ya arreglado): `contentPacksSnippetsDir()` /
  `contentPacksLearningPathsDir()` llamaban a
  `getApplicationSupportDirectory()`, que en web lanza
  `MissingPluginException` (`path_provider` no tiene implementación web). En
  `LearningPathRepositoryImpl._loadExternalInto` esa llamada está fuera del
  try/catch por-archivo, así que el error escapaba y tumbaba `watchPaths()`;
  `ExternalSnippetPackSource` tomaba el mismo camino para el seed del
  catálogo. **Fix**: ambos resolvers devuelven `null` en web (guard `kIsWeb`,
  mismo patrón que `desktop_platform.dart`) y los dos callers tratan `null`
  como "no hay packs externos" — web no puede tenerlos (no hay directorio
  on-device donde un tercero deje JSON), así que el seam es desktop/mobile.
- **Verificado**: primer fix con `bash tool/check.sh` completo en verde —
  **430 tests**, format/analyze/arquitectura limpios; `flutter build web
  --release` copia ambos binarios a `build/web/` (confirmado con `ls`). El
  segundo fix pasó `dart format` + `dart analyze` limpios sobre los archivos
  tocados. **La suite completa no se pudo re-correr al cierre**: hay una
  sesión concurrente en el mismo working tree agregando soporte de Haskell,
  y su `pubspec.yaml` referencia `assets/.../haskell_*.json` que aún no
  existen → `flutter test` falla al construir el asset bundle (ajeno a este
  fix; correr el gate completo cuando esa sesión cree los JSON). En dev sin
  COOP/COEP drift cae a `sharedIndexedDb` (funciona igual, algo más lento);
  en producción `web/_headers` ya trae COOP/COEP para OPFS.

### 2026-09-11 — Sonido de tecleo migrado a flutter_soloud (fin del pool de audioplayers)

- **Contexto**: el fix anterior (pool reciclado + breaker, entrada siguiente)
  cerró la fuga de file descriptors de `audioplayers`, pero seguía siendo un
  pool de players que hay que pre-crear y reciclar a mano (y en lowLatency el
  pool no recicla solo). El usuario eligió migrar a **`flutter_soloud`** para
  que cada tecla sea una voz independiente y no exista nada que reciclar.
- **`pubspec.yaml`**: `+ flutter_soloud ^5.0.2`, `− audioplayers`, `− fake_async`
  (solo servía al test del pool). Bloque
  `hooks.user_defines.flutter_soloud.no_xiph_libs: true` — la app solo usa WAV,
  así que los builds nativos no clonan ni compilan Ogg/Vorbis/Opus/FLAC.
- **`lib/core/audio/sound_engine.dart`** (nuevo): `ensureSoundEngineInitialized()`
  cachea el `init` del motor (llamarlo dos veces lo reinicia y descarga todos
  los sonidos) con `devicePeriodFrames: 512` + `renderAheadFrames: 1536` — el
  render-ahead ring lleva la latencia tecla→sonido al periodo del dispositivo
  (~11 ms) sin bajar el buffer de mezcla (2048). Cualquier fallo de audio
  resuelve en silencio.
- **`keystroke_sound_player.dart`** reescrito: carga los 2 WAV del pack una
  vez con `loadAsset` y dispara `play()` por tecla (voces polifónicas);
  `dispose()` libera solo las sources (el motor vive a nivel app). Seam
  inyectable (`KeystrokeSoundLoader`/`Play`/`Dispose` + `KeystrokeSoundClip`)
  y `KeystrokeSoundPlayer.silent()` para tests de widgets sin audio nativo.
- **UI y plataforma**: preview del picker con `playSource` (se autolibera);
  `main.dart` arranca el motor en paralelo al startup; `web/index.html` carga
  `init_soloud.js`; CI instala `libasound2-dev` (el hook nativo compila
  también en `flutter test`, y el release Linux lo necesita).
- **Tests**: 6 casos nuevos del player (una voz por tecla, cola de carga,
  fallo parcial, dispose durante carga, errores tragados, variante silent); el
  test del campo de captura overridea el provider con `.silent()`.
- **Verificado**: `bash tool/check.sh` completo — **430 tests verdes**,
  format/analyze/arquitectura limpios. La prueba manual de escucha
  (`flutter run -d linux`, teclear rápido y cambiar de pack) queda para el
  usuario: este agente no puede oír el resultado.

### 2026-09-11 — Fix crítico: la app moría por fuga de file descriptors en los sonidos de tecleo

- **Síntoma**: tras ~15 min tecleando, `flutter run` perdía la conexión con
  la app; el log mostraba un `AudioPlayers Exception` por tecla y terminaba
  en `[ALSOFT] ... errno: 24` + assert de PulseAudio
  (`pa_threaded_mainloop_start`) que abortaba el proceso.
- **Causa raíz** (audioplayers 6.8.1 / audioplayers_linux 4.3.0): el
  `AudioPool` de `keystroke_sound_player.dart` corría en
  `PlayerMode.lowLatency` **sin `minPlayers`** (default 1) y descartaba el
  `StopFunction` que devuelve `AudioPool.start()`. En lowLatency el pool no
  recicla solo (no se suscribe a `onPlayerComplete`), así que cada tecla
  creaba un `AudioPlayer` nuevo — pipeline GStreamer + stream de audio +
  FDs — que nunca se liberaba (provider keepAlive). Con el backend de audio
  ya fallando, cada `start()` fallido tampoco quedaba trackeado por el pool:
  los FDs se agotaron y libpulse llamó `abort()`.
- **Fix** (`keystroke_sound_player.dart`): `minPlayers` real (4/8 click,
  2/4 reject), reciclado explícito a los 200 ms de cada `stop()` devuelto
  por el pool (clips de 28/90 ms), **circuit breaker** que apaga el audio de
  la instancia tras 3 fallos consecutivos, y carga por pool independiente
  (si uno falla, el otro se conserva y ninguno se filtra). Seam
  `SoundEffectPool`/`SoundEffectPoolFactory` para testear sin backend.
- **Tests**: `test/features/practice/keystroke_sound_player_test.dart`
  (5 casos: reciclado, breaker, reset de racha, carga parcial, dispose
  durante carga) con `fake_async` (nueva dev dependency).
- **Verificado**: `bash tool/check.sh` completo — **427 tests verdes**,
  format/analyze limpios, arquitectura sin violaciones duras.

### 2026-09-11 — Lenguaje activo estilo SoloLearn (catálogo + guía, sin candados)

- **Pedido del usuario**: el `SegmentedButton` de lenguajes (Practice y Free)
  recortaba "JavaScript" al existir 6 idiomas; pidió la experiencia SoloLearn
  — elegir un lenguaje al entrar a Practice, activarlo y caer en su guía,
  pudiendo volver a cambiarlo. Tras preguntarle el diseño, eligió: **unidad =
  lenguaje** (no curso/ruta), **sin candados** (todo abierto; gamificación
  solo visual con progreso) y **catálogo como estado inicial del tab
  Practice** (sin tocar onboarding, que SPEC.md §7 pide sin fricción).
- **Nuevo estado "lenguaje activo"** (SPEC.md §5.7): puerto
  `ActiveLanguageRepository` + `Get/SetActiveLanguageUseCase` + adapter
  `shared_preferences` (`learning_paths.active_language.v1`, nombre del enum;
  un nombre desconocido lee `null`) + `ActiveLanguageController` (keepAlive).
  `LanguageProgressCalculator` (domain puro) agrega lecciones
  completadas/total por lenguaje sobre todas sus rutas.
- **UI**: `LanguageCatalog` (tarjeta por lenguaje con nombre, blurb corto
  "para qué sirve" y barra de progreso; feedback del usuario: sin etiquetas
  Empezar/Continuar ni header "Choose your language") es el contenido del
  propio tab `/practice`: se muestra cuando no hay lenguaje activo y también
  al tocar "Cambiar lenguaje" en la guía (modo transitorio del mismo tab, sin
  ruta ni `AppBar` — feedback del usuario: la selección no debe abrir otra
  pantalla; el back de Android regresa a la guía vía `PopScope`).
  `FreePracticeScreen` pasó de `SegmentedButton` a `ActionChip` +
  `showLanguagePickerSheet` (bottom sheet en `content`, mismo patrón del mode
  picker) y por defecto sigue el lenguaje activo.
- **Sin candados** por decisión explícita del usuario: ningún lenguaje ni
  ruta se bloquea; la gamificación es el progreso visible por lenguaje.
- **Chequeos**: 5 tests nuevos (calculadora, repositorio con
  `InMemorySharedPreferencesAsync`, catálogo, `LearningPathsScreen`, picker de
  Free) y `bash tool/check.sh` completo en verde — **427 tests**, format/
  analyze/arquitectura limpios.

### 2026-09-11 — `AGENTS.md` (espejo) + `CODE_STANDARDS.md` + fix de formato del harness visual

- **`AGENTS.md` nuevo, espejo byte a byte de `CLAUDE.md`** (`diff` vacío,
  nota anti-drift al inicio de ambos). OpenCode ignora `CLAUDE.md` cuando
  existe `AGENTS.md`, así que el espejo evita que cualquier herramienta
  pierda la guía.
- **Reconciliación en la guía** (en ambos archivos): `daily_challenge`
  faltaba en la lista de features implementadas; se documentó
  `bash tool/format.sh`; CI fija Flutter 3.47.2; se anotó que `README.md`
  está desactualizado (describe un scaffold "Tasks" ya eliminado) y que la
  fuente viva es `lib/features/` + `Memory.md`.
- **`CODE_STANDARDS.md` creado** (español, como README/Memory/SPEC/STACK):
  era referenciado por `tool/check.sh`, `analysis_options.yaml`,
  `tool/check_architecture.dart` y `tool/git-hooks/pre-commit` pero no
  existía en el repo ni en el historial de git. Explica los 4 gates, el
  split pre-commit/pre-push (por qué cada commit es barato) y el contrato
  Conventional Commits → `version_bump.dart`/`release.sh` → tag.
- **Fix de formato encontrado por el gate**: el commit `32332db` agregó
  `test/_manual_visual_check.dart` sin pasar por el formatter (el harness
  visual desechable), y `tool/check.sh` fallaba en el primer gate. Se
  formateó (solo un rewrap del cast a `RenderRepaintBoundary`) y ahora el
  gate pasa completo. Sin cambios de comportamiento.
- **Chequeos**: `diff CLAUDE.md AGENTS.md` vacío; `bash tool/check.sh` en
  verde de punta a punta — **404 tests verdes**, format/analyze/arquitectura
  limpios.

### 2026-09-11 — Python y JavaScript como lenguajes nuevos (4 cursos: fundamentos + Algorithms)

- **Pedido del usuario**: tras la sesión de "Go: Algorithms"/"Rust: Algorithms", pidió un curso de "Python beginner" y otro de "Python algorithms", y luego lo mismo para JavaScript. A diferencia de la sesión anterior (que solo agregaba contenido a lenguajes ya soportados), esto significaba agregar **dos lenguajes enteramente nuevos** — algo que SPEC.md §18 listaba explícitamente como "fuera de alcance en v1" (aunque anticipado como roadmap futuro). Se procedió sin re-preguntar, siguiendo el mismo criterio que el usuario ya había dado la sesión anterior (cursos nuevos y acotados son su prerrogativa, no ambigüedad real), y se documentó el cambio de alcance en SPEC.md/CLAUDE.md en vez de bloquear el trabajo.
- **Wiring de lenguaje nuevo** (no solo contenido, esta vez): `ProgrammingLanguage.python`/`.javascript` nuevos en el enum; dos tokenizers de sintaxis nuevos desde cero (`python_syntax_tokenizer.dart`, `javascript_syntax_tokenizer.dart`, como `part of syntax_tokenizer.dart` igual que Rust/SQL) — Python maneja prefijos de string (`f`/`r`/`b` antes de una comilla) y strings triple-comilladas; JavaScript colorea template literals completos (backtick a backtick) como un solo string, sin resaltar el `${}` interno. l10n (`languagePython`/`languageJavascript`), y wiring en 3 lugares que costó encontrar todos: `pubspec.yaml`, `learning_path_repository_impl.dart` — y **`snippet_local_data_source.dart`**, que casi se queda desactualizado porque tiene su propia lista de rutas de assets separada de la que usa el test de completeness (causó que la primera corrida de tests fallara con conteos raros hasta encontrarlo).
- **Ambos cursos "Algorithms" (Python, JavaScript) reusan exactamente el mismo diseño de 12 lecciones** que ya se auditó la sesión pasada en Go/Rust (mismo orden: búsqueda → ordenamiento → grafos, mismas categorías `searchingAlgorithms`/`sortingAlgorithms`/`graphAlgorithms`, sin categorías nuevas esta vez). Los cursos "foundations" (beginner) son contenido original nuevo por lenguaje (12 lecciones cada uno: 4 `variablesAndTypes` + 3 `conditionals` + 2 `loops` + 3 `functions`, mismo reparto de categorías que ya usa `rust-foundations-v1`), reutilizando categorías genéricas — nada de categorías propias, igual que el resto de fundamentos.
- **Verificación real de código otra vez, no solo por ojo**: los 48 snippets nuevos (24 Python + 24 JavaScript) se corrieron de verdad (`python3` + `black --check`; `node` + `prettier --check`) antes de entrar al catálogo. Autoría bilingüe delegada a 4 forks en paralelo (uno por curso) con el código ya verificado pegado literal — igual patrón que la sesión anterior.
- **Revisión adversarial independiente** (2 agentes frescos en paralelo, uno por lenguaje, instruidos a cazar bugs activamente): esta vez **no encontraron ningún bug real** en código, tokenizers, orden de lecciones, ni calidad bilingüe — a diferencia de la sesión pasada (que sí encontró 2 problemas reales). Un hallazgo menor de estilo (una justificación de "overflow" un poco exagerada en la explicación de binary search) ya existía igual en el curso de Go, así que no es nuevo.
- **Documentación actualizada**: SPEC.md §3.1/§3.2/§18 (Python y JavaScript ya no están "fuera de alcance"; sus fundamentos reusan categorías genéricas igual que Rust; sus cursos de Algorithms comparten las mismas 3 categorías temáticas que Go/Rust), CLAUDE.md (lista de archivos de snippets y de rutas actualizada), `content-model.md` de la skill (tabla de tiers).
- **Chequeos**: `flutter test` completo, **403 tests verdes** (mismo número que la sesión anterior — no se agregaron categorías nuevas esta vez, así que la grilla de logros por categoría/dificultad no creció). `audit_lesson_order.py` verde para los 4 cursos nuevos (con un fix de paso: le faltaban `python`/`javascript` en `COURSE_ONLY_LANGUAGES`).
- **Bug real encontrado y arreglado durante esta misma sesión**: el usuario reportó que el auto-indentado (al presionar Enter, saltar directo a la indentación de la siguiente línea real) no se sentía aplicado en los lenguajes nuevos. Investigado con un agente de exploración: `ingestEnterKey` en
  `keystroke_stream_recorder.dart` traía un trabajo a medio terminar de una
  sesión anterior (ya en el working tree, sin commitear) — `ingestTabKey` ya
  se había generalizado para consumir una racha de `' '` *o* `'\t'`, pero el
  bloque nuevo de auto-indent post-Enter que se agregó junto a eso solo
  reconocía `'\t'`. Como Go es el único catálogo que indenta con tabs (todos
  los demás — Bash, SQL, Rust, y ahora Python/JavaScript — usan espacios),
  el auto-indent post-Enter simplemente nunca disparaba fuera de Go. Se
  completó el generalize (mismo patrón que `ingestTabKey`: detecta si el
  primer carácter esperado es `' '` o `'\t'` y consume la racha de ese
  mismo carácter) + un test nuevo para el caso de espacios, espejando el
  test existente de tabs. De paso quedaron limpios los 2 lints
  preexistentes en este mismo archivo/test que traían roto
  `flutter analyze --fatal-infos` — **`bash tool/check.sh` completo pasa
  en verde de punta a punta** al cerrar esta sesión.

### 2026-09-11 — Dos rutas nuevas "Algorithms" (Go y Rust): sorts, búsquedas y grafos

- **Pedido del usuario**: una guía "Go: Algorithms" con los algoritmos más
  famosos (burbuja, quicksort, Dijkstra, búsqueda, etc.) implementados de
  forma idiomática, con el campo de explicación sin lecturas de teoría
  CS; y la misma guía en Rust. Aclaración clave del usuario tras
  preguntarle: son **dos cursos nuevos e independientes** de las rutas
  base (`go-foundations-v1`, `rust-foundations-v1`), no una extensión de
  ellas — eso resuelve la tensión con la regla de SPEC.md de que Rust es
  "solo principiante, sin categorías propias" (esa regla sigue aplicando
  a `rust-foundations-v1`; el curso de Algorithms es otro curso aparte,
  documentado ahora en SPEC.md §3.1).
- **Contenido**: 12 lecciones por lenguaje (mismo orden en ambos):
  `searchingAlgorithms` (búsqueda lineal, binaria) →
  `sortingAlgorithms` (burbuja, selección, inserción, mezcla, quicksort,
  heapsort) → `graphAlgorithms` (grafo como lista de adyacencia, BFS,
  DFS, Dijkstra O(V²) sin cola de prioridad). Tres categorías
  (`ContentCategory`) nuevas, compartidas entre ambos lenguajes, con la
  misma barra de completitud relajada que las categorías de
  arquitectura DDD/TUI (`_algorithmTopicCategories` en
  `snippet_catalog_completeness_test.dart` — a diferencia de esas,
  aquí cada snippet sí tiene una dificultad real que refleja
  complejidad algorítmica, no de capa arquitectónica).
- **Verificación real de código, no solo por ojo**: cada uno de los 24
  snippets se compiló y corrió de verdad (`gofmt`/`go run`,
  `rustfmt --check`/`rustc`) antes de entrar al catálogo, siguiendo la
  skill `content-curriculum`. Autoría delegada a dos forks en paralelo
  (uno por lenguaje) con el código ya verificado pegado literal en el
  prompt — el fork solo escribió bilingüe (tldr/explicación) y armó el
  JSON, nunca tocó el código.
- **Revisión adversarial independiente** (agente fresco, sin mi contexto,
  instruido a buscar bugs activamente) encontró y se corrigieron 2
  problemas reales antes de cerrar: (1) el DFS de Go usaba un closure
  auto-referenciado (`var visit func(...); visit = func(...) {...}`) sin
  motivo — no aparece en ningún otro lado del curso — se reescribió como
  función recursiva plana (`visitDFS`, acumulador por puntero
  `*[]string`), igual que su gemelo en Rust; (2) 4 funciones de
  ordenamiento en Rust (bubble/selection/insertion/heap sort) recibían
  `&mut Vec<i32>` en vez de `&mut [i32]` (`clippy::ptr_arg` real, ya que
  ninguna necesita cambiar el tamaño) — corregido, recompilado y
  re-verificado.
- **Chequeos mecánicos**: `scripts/audit_lesson_order.py` (con un fix de
  paso: el script no traía `rust` en `COURSE_ONLY_LANGUAGES` ni las 3
  categorías nuevas en su set de "topic categories", desincronizado del
  test real de Dart — corregido) da verde para ambas rutas.
  `flutter test` completo: **403 tests verdes** (subió de ~366 al sumar
  las 24 entradas × combinaciones de logro por categoría/dificultad).
  `content_drift_integration_test.dart` actualizado (315→339 total,
  89→97 beginner, ids `go-algo-010/011/012` y los 12 `rust-algo-*`
  añadidos al set de `findContainingSymbols('_')` porque Go usa `_` de
  blank identifier en los recorridos con `range` y Rust usa snake_case
  en todos sus identificadores).
- **Pendiente/nota**: `flutter analyze --fatal-infos --fatal-warnings`
  (y por lo tanto `tool/check.sh` completo) sigue en rojo por 2 lints
  preexistentes en `keystroke_stream_recorder.dart`/su test — **no
  relacionado con esta sesión**, ya estaban modificados sin commitear
  antes de empezar; no se tocaron.

### 2026-09-11 — Build hardening de las 4 plataformas (compresión/ofuscación/firma/CI)

- **Pedido del usuario**: auditoría de "¿el sistema de buildear por
  plataforma se maneja bien — compresión, ofuscación, limpieza,
  seguridad, eficiencia, rendimiento?". Respuesta corta: no — Android
  seguía firmando `release` con la clave de debug y sin
  `isMinifyEnabled`/ProGuard (el template de Flutter sin tocar), y no
  existía ningún job de CI que compilara un artefacto por plataforma pese
  a que `STACK.md §12` ya especifica esa tabla. Confirmado con el usuario
  que quería las 4 plataformas (Web/Android/Windows/Linux)
  **preconfiguradas ya, sin ejecutar build/publicación real todavía**, y
  que sí corriera el scaffolding real de Windows/Web ahora (no solo
  documentado).
- **Scaffolding**: `flutter config --enable-windows-desktop` +
  `flutter create --platforms=windows,web .`. `android/` y `linux/`
  quedaron intactos. **Nota**: `flutter create` reescribió
  `.metadata`'s `migration.platforms` reemplazando las entradas
  `android`/`linux` por `web`/`windows` en vez de agregarlas — corregido a
  mano (las 4 platforms deben estar listadas para que `flutter migrate`
  seguido funcione bien).
- **Android** (`android/app/build.gradle.kts`): `signingConfig` ahora lee
  `android/key.properties` (gitignorado, patrón oficial de Flutter con
  `Properties()`/`FileInputStream`; `key.properties.example` versionado
  como plantilla) y cae a la clave de debug con `logger.warn(...)` si no
  existe. `isMinifyEnabled`/`isShrinkResources = true` +
  `android/app/proguard-rules.pro` (placeholder documentado — ninguna
  dependencia actual necesita keep-rules propias, todas traen *consumer
  rules* en su AAR).
- **Linux**: `linux/packaging/dev.omarcodes.ridge.desktop` (README ya
  señalaba que faltaba) + manifiesto Flatpak
  (`dev.omarcodes.ridge.yml`) con `--share=network` y
  `--talk-name=org.freedesktop.secrets` (`STACK.md §3.4`), empaquetando
  el bundle ya compilado (`flutter build linux --release`) en vez de
  compilar Dart dentro del sandbox sin red.
- **Windows**: `msix` dev_dependency + bloque `msix_config:` en
  `pubspec.yaml` (sin `certificate_path` — sin cert real cae a
  autofirmado de prueba; `msix_version` deliberadamente omitido para que
  se derive del `version:` de pubspec, un solo lugar de verdad,
  `STACK.md §10.1`).
- **Web**: `web/_headers` (COOP/COEP para que `drift`/OPFS rinda al
  máximo, `STACK.md §3.2`) + `web/_redirects` (fallback SPA) en formato
  Cloudflare Pages; `usePathUrlStrategy()` en `main.dart` tras `if
  (kIsWeb)`. Sin flag de renderer — este Flutter (`3.47.2`) ya no tiene
  `--web-renderer`/renderer HTML, compila a CanvasKit por defecto (cumple
  el requisito de ancho de carácter predecible de GeistMono sin nada
  adicional).
- **CI**: `.github/workflows/release-builds.yml` nuevo, separado de
  `ci.yml`, gatillado solo por tag `v*.*.*` — 4 jobs
  (android/windows/linux/web), cada uno compila con
  `--obfuscate --split-debug-info` (Web no soporta esa flag; dart2js ya
  minifica en release) y sube el artefacto empaquetado como *build
  artifact*, sin publicar a ninguna tienda/hosting real todavía (sin
  credenciales). Linux usa la action comunitaria
  `flatpak/flatpak-github-actions/flatpak-builder@v6` en vez de
  hand-rollear `flatpak-builder` + remoto Flathub.
- **Verificado en este sandbox**: `flutter analyze` limpio,
  `dart run tool/check_architecture.dart` sin violaciones nuevas,
  `flutter build web --release` y `flutter build linux --release
  --obfuscate --split-debug-info=...` compilan bien (confirmado que
  `_headers`/`_redirects` se copian a `build/web/` y que se genera
  `app.linux-x64.symbols`), suite completa (398 tests) verde tras
  `flutter clean` (un fallo intermitente de
  `practice_session_controller_persist_retry_test.dart` resultó ser
  caché de build viejo, no algo de esta sesión). **No verificado**:
  Android (sin SDK de Android en este sandbox, igual que ya advertía
  `README.md`) y Windows (requiere Visual Studio — solo se puede
  scaffoldear/configurar aquí, se compila de verdad en el runner
  `windows-latest` de CI).
- Docs actualizados: `CLAUDE.md`, `README.md`, `STACK.md §1`/`§12`.
  Pendientes reales (credenciales de firma, redimensionar el icono de
  Linux) movidos a la sección de abajo.

### 2026-09-11 — Deep link a una lección + compartir ejercicio

- **Pedido del usuario**: si llega una notificación de "avanzaste al
  ejercicio 4 de la guía 1", ¿un tap lleva justo ahí? ¿Se puede compartir
  un ejercicio con un link? Respuesta: no, nada de eso existía (sin
  `app_links`/`uni_links`, sin intent-filter más allá del launcher, sin
  `ios/`; notificaciones push explícitamente diferidas a v2 en
  `STACK.md:535`).
- **Alcance implementado** (deliberadamente sin tocar notificaciones
  push, que siguen fuera de alcance v1): ruta nueva
  `/practice/:pathId/lessons/:lessonId` (`lib/core/router/app_router.dart`)
  resuelta por `LessonDeepLinkScreen` (nuevo,
  `lib/features/learning_paths/presentation/screens/`), que reenvía a
  `/practice/session` vía `LessonNavigation.openLessonById` (nuevo método
  en `lesson_navigation.dart`, junto a `shareableLessonUri`). Enlace
  entrante manejado por `deepLinkListenerProvider`
  (`lib/core/router/deep_link_providers.dart`, `app_links ^7.2.1`),
  fireado igual que `catalogSeedProvider`/`deviceInfoSyncProvider` desde
  `RidgeApp.build`. Validación con lista blanca (`isSupportedDeepLinkPath`)
  antes de reenviar a `router.go` — necesario porque la mayoría de rutas
  leen un `extra` obligatorio que un link crudo nunca trae (hubiera hecho
  *null-assert crash* sin el filtro).
- Botón de compartir (`share_plus ^13.3.0`) — **tres rondas de ajuste de
  ubicación tras feedback del usuario en la misma sesión** antes de dar
  con el lugar correcto: 1) ícono en toda fila de `LessonTreeTile` con
  snippet cargado — "se ve muy feo", rechazado. 2) ícono solo cuando
  `status == LessonStatus.completed`, igual en `LessonTreeTile` —
  también rechazado ("quítalo también cuando está completed, no me
  sirve, siento que estorba visualmente"). 3) junto al botón "info" en
  `SessionResultFooter` — también rechazado ("no lo pongas al lado del
  What did you just type..."); el usuario pidió expresamente que fuera
  junto al título "Session complete". **Ubicación final**: ícono
  pequeño y silenciado en la esquina derecha del título propio de
  `SessionResultPanel` ("Sesión completa"/"Run over"), no en el footer
  ni en la lista. `onShare` sigue siendo el mismo callback opaco
  (mismo patrón que `onContinue`: `LessonNavigation` lo construye,
  `PracticeSessionScreen` solo lo reenvía sin saber qué hace), solo
  cuando la sesión pasa (`passed == true`). `LessonTreeTile` y
  `SessionResultFooter` quedaron sin ningún botón de compartir. Ver
  memoria `feedback_list_row_secondary_actions` (corregida para
  reflejar esta ubicación final).
- Esquema elegido: `ridge://app/...` (custom, no HTTPS App Links) — no
  hay dominio propio todavía para `assetlinks.json`; revisar cuando exista
  hosting web real (`STACK.md §3.4`). Solo Android (no hay `ios/`, ver
  `STACK.md §14`); Linux/Windows sin registro de protocolo (no vale la
  pena para un caso de uso mayormente teléfono-a-teléfono).
- Docs actualizados: `STACK.md §2.3` (detalle técnico) y `SPEC.md §5.7`
  (una línea, sin detalle técnico). `bash tool/check.sh` verde (397 tests).
  Intento de verificación visual (`flutter run -d linux`) bloqueado por
  este entorno WSL2: el driver Vulkan/Zink falla
  (`VK_ERROR_INCOMPATIBLE_DRIVER`) y la ventana nunca llega a mostrarse
  — verificado solo por análisis de código + suite de tests, no
  visualmente, en este sandbox.

### 2026-09-11 — Vista 2D fiel del teclado en Profile + banco de layouts curado

- **Pedido del usuario**: pulir el apartado visual del teclado en Profile
  (aislar el componente) y el "banco de datos" de layouts — un catálogo
  de JSON por teclado, sourced de GitHub/QMK, para un prototipo 2D fiel
  estilo VIA (no solo la silueta genérica que ya existía).
- **Hallazgo clave que reencuadró el alcance**: la mayoría de los ~150
  modelos de `kKeyboardModelSuggestions` (Corsair, Razer, Logitech,
  SteelSeries, ASUS ROG, MSI, marcas chinas económicas) son placas de
  firmware cerrado sin datos públicos de layout en ningún repo —
  inventar coordenadas para esos sería peor que la silueta genérica
  honesta que ya había. Solo los teclados hackeables QMK/VIA (split
  ergo y algunos boards custom) tienen datos verificables.
- **Arquitectura nueva** (`lib/features/profile/{domain,infrastructure,
  presentation}/`): `KeyboardKeySpec`/`KeyboardVisualLayout` (dominio,
  vocabulario KLE: x,y,w,h,x2,y2,w2,h2,rotación) + puerto
  `KeyboardVisualLayoutSource` + `KeyboardVisualLayoutLocalDataSource`
  (JSON empaquetado, sin drift — mismo patrón que Learning Paths) +
  `KeyboardLayoutPainter`/`keyboard_layout_geometry.dart` (un solo motor
  de render con soporte de rotación, reemplaza los dos paths bespoke
  `_paintRowBased`/`_paintSplitErgo` de `keyboard_shape_preview.dart`,
  eliminado) + `standard_family_key_specs.dart` (fallback genérico por
  familia, mismo grid visual de antes, re-expresado). `KeyboardVisual`
  es el único punto de integración — usado en `ProfileAboutCard` y ahora
  también en `EditProfileScreen` (preview en vivo mientras se escribe el
  modelo).
- **Banco curado** (`assets/content/keyboard_layouts/`): primera pasada,
  8 modelos reales confirmados vía `qmk/qmk_firmware` (ErgoDox EZ, ZSA
  Moonlander/Voyager, HHKB Professional Hybrid, Keychron Q1, Glorious
  GMMK Pro, Drop ALT/CTRL) — GPL-2.0, atribución en
  `THIRD_PARTY_SOURCES.md` + licencia vendorizada en
  `LICENSES/GPL-2.0.txt` (mismo precedente que `assets/fonts/LICENSE.txt`
  del Geist). Kinesis Advantage360 se descartó a propósito: corre ZMK,
  sin `info.json`/`keyboard.json` público en ningún lado — documentado
  para que no se re-investigue.
- **Ampliación del banco (misma sesión, a pedido del usuario — tiene un
  MCHOSE GX87 y quería "muchísimos más")**: **24 modelos** en total tras
  un barrido sistemático de toda `kKeyboardModelSuggestions` contra
  `the-via/keyboards` (~3500 defs, no aportó nada nuevo — son casi todas
  boards indie/maker, no las marcas de esta lista) y `qmk/qmk_firmware`
  (la fuente productiva: +15 modelos — Akko 5108B, Glorious GMMK
  Numpad/2, Monsgeek M1/M3, Royal Kludge RK61, Skyloong GK61, Kinesis
  Advantage2, Keychron Q2/Q3/Q10/V1/V3/V6/V10). **MCHOSE GX87** confirmado
  vía un fork GPL-2.0 de `qmk_firmware` (`jonylee1986/qmk_firmware_master`,
  rama `mchose_gx87`) al que el propio fabricante remite a los usuarios
  de VIA — no está mergeado upstream, documentado como tal en el
  `"source"` del JSON; se agregó como entrada nueva en
  `kKeyboardModelSuggestions`/`keyboard_shape_lookup.dart` (no existía
  antes). Confirmado por el mismo barrido: Corsair/Razer/Logitech/
  SteelSeries/ASUS ROG/MSI/Wooting/Varmilo/Leopold/Topre-Realforce/
  Vortex/Womier/Attack Shark/Epomaker/etc. **no tienen dato público en
  ningún lado** — listado exacto de qué se buscó y no se encontró en
  `THIRD_PARTY_SOURCES.md`, para no re-investigarlo después.
- **Verificado (ampliación del banco)**: `bash tool/check.sh` verde
  (**383 tests**, format/analyze/arquitectura limpios) — corrido dos
  veces tras la ampliación para descartar flakiness (una corrida tuvo un
  fallo aislado en `survival_controller_drift_integration_test.dart`, no
  relacionado con este trabajo — pasó limpio tanto solo como en dos
  corridas completas posteriores).
- **UX: brand → model ya no se repite dos veces** (a pedido del usuario,
  misma sesión): en `EditProfileScreen`, elegir una marca de teclado
  ahora prioriza (sin excluir nada — sigue siendo texto libre) los
  modelos de esa marca en el autocomplete del campo Modelo, en vez de
  obligar a re-escribir el nombre de la marca ahí también. Lógica
  extraída a `keyboard_model_brand_matching.dart` (`preferBrandMatches`/
  `brandTokens`, testeada aparte) — maneja marcas con alias entre
  paréntesis (`"ZSA (ErgoDox/Moonlander/Voyager)"` → también prioriza
  "ErgoDox EZ" aunque el nombre del producto no diga "ZSA"). Nota técnica
  real: `Autocomplete` de Flutter solo recalcula opciones cuando el
  *texto* del campo cambia, no en cada rebuild del padre — por eso esto
  actúa al escribir en el campo Modelo, no al sólo enfocarlo vacío tras
  elegir marca (se evaluó y se descartó por no ser alcanzable sin pelear
  contra el widget).
- **Pendiente natural (no bloqueante)**: el patrón ya está armado para
  seguir sumando modelos QMK/VIA al banco curado con el tiempo — es
  trabajo de curación de datos, no de arquitectura. La lista de "buscado
  y no encontrado" en `THIRD_PARTY_SOURCES.md` evita reabrir búsquedas ya
  agotadas.

### 2026-09-11 — Fix: el tamaño de ventana no persistía en Linux/WSLg

- **Reportado por el usuario**: "no persiste mi preferencia en linux (wsl)
  de como deje el tamaño de la ventana, se queda la default cada que
  levanto el sistema" — la persistencia (`WindowGeometryStore`,
  `WindowGeometryListener`, restauración en `main.dart`) ya existía desde
  el commit inicial; el bug estaba en la restauración, no en el guardado.
- **Causa real, verificada empíricamente** (`flutter run -d linux
  --release` bajo WSLg/Weston, con prints de depuración temporales
  leyendo `windowManager.getBounds()` en distintos puntos del arranque):
  pedir un tamaño (`WindowOptions.size` o `setBounds()`) **antes** de que
  la ventana esté mapeada (`show()`) pierde ~50px en ancho y alto de
  forma constante — el primer `configure` del compositor devuelve un
  tamaño menor al pedido. `WindowGeometryListener` guardaba ese tamaño ya
  encogido, y el siguiente arranque encogía ~50px más: la ventana se
  reducía en cada reinicio (982×482 → 930×430 → 878×378 → ... verificado
  con capturas repetidas del archivo `shared_preferences.json` en
  `~/.local/share/dev.omarcodes.ridge/`). Aplicar `setBounds()` en una
  ventana **ya mapeada** (después de `show()`/`focus()`) no pierde nada —
  confirmado reproduciendo el mismo arranque con el orden invertido y
  comparando el tamaño pedido contra `getBounds()` tras ~700ms.
- **Fix** en `lib/main.dart`: dentro del callback de
  `waitUntilReadyToShow`, `show()`/`focus()` ahora corren primero, y
  `setBounds()`/`maximize()` (la restauración de geometría guardada) se
  aplican después — `windowOptions.size` se mantiene igual (evita el
  flash al tamaño default 1280×800 antes de la corrección). Sin números
  mágicos ni delays artificiales: el fix es el reordenamiento en sí.
- **Limitación de plataforma, no bug nuestro**: la posición (x, y) nunca
  se restaura bajo este WSLg/Weston — Wayland no permite a un cliente
  consultar ni fijar su posición absoluta en pantalla (a diferencia de
  X11). El usuario solo reportó problema con el *tamaño*; se le explicó
  la limitación de posición aparte.
- **Verificado**: dos arranques consecutivos con geometría guardada
  1000×700 — el tamaño se mantuvo exacto en ambos, sin encogerse.
  `bash tool/check.sh` verde (**366 tests**, format/analyze/arquitectura
  limpios). Diff final: 12 líneas en `lib/main.dart` (reordenar +
  comentario explicando el porqué).

### 2026-09-10 — Exports PNG del mark + `MARKETING.md` ampliado (design system completo)

- **Pedido del usuario**: tener PNGs del mark a la mano en distintos
  tamaños, y ampliar `MARKETING.md` para dejar explícito el design
  system (tipografía, plataformas, íconos, layouts, botones, etc.).
- **`marketing/logo/r-mark-{16,32,48,64,128,192,256,512,1024}.png`**:
  generados con `rsvg-convert` desde `assets/icons/r_mark.svg` con
  `currentColor` sustituido por el Ember de marca (`#FF5A36`), fondo
  transparente real (verificado con Pillow/`identify`: `RGBA`, esquina
  `(0,0,0,0)`). Carpeta nueva `marketing/` en la raíz, hermana de
  `assets/` pero **no** referenciada en `pubspec.yaml` a propósito — son
  artefactos de referencia (tienda de apps, redes, docs), no assets de
  runtime; no hacía falta que viajaran en el bundle de la app.
- **`MARKETING.md` §5 reescrita** de un resumen de 6 bullets a 8
  subsecciones con valores concretos, todas trazadas a código real (no
  inventadas): 5.1 Tipografía (Geist/Geist Mono, pesos), 5.2 Plataformas
  (tabla de `STACK.md` §1: Android/Linux vigentes, Windows/Web
  planeados sin scaffoldear, iOS/macOS fuera de alcance), 5.3 Color y
  paletas (semilla Ember + las 25 paletas reales de
  `app_palette_catalog.dart`), 5.4 Forma (escala de 8 radios × 4 estilos
  de esquina, valores exactos de `app_shapes.dart`), 5.5 Iconografía
  (convención de sufijo `300`/`600` de Lucide, confirmada leyendo
  `app_shell.dart`), 5.6 Layout y navegación (breakpoints 640/360 de
  `AppShell`, los 5 destinos en su orden real), 5.7 Componentes (tabla:
  botones, cards, chips, inputs —sin borde nunca—, diálogos, sheets,
  snackbar, switches, transiciones — todo leído de `app_theme.dart`),
  5.8 Movimiento (los valores exactos de `AppMotion`).
- **§6 (el mark) ampliada** con el comando exacto de regeneración de los
  PNG nuevos, para que la próxima iteración del mark no tenga que
  re-derivar el procedimiento.
- **Disciplina seguida**: cero valores inventados — todo lo que entró a
  §5 se leyó primero de `STACK.md`/`app_theme.dart`/`app_shapes.dart`/
  `app_typography.dart`/`app_shell.dart`/`app_palette_catalog.dart`
  (conteo de paletas verificado contra los `.arb`, no adivinado).
- **CLAUDE.md**: ya referenciaba `MARKETING.md` desde la sesión
  anterior, sin cambios adicionales esta vez.

### 2026-09-10 — Eslogan definitivo + `MARKETING.md`

- **Brainstorm de eslogans**: el usuario pidió alternativas al eslogan
  original ("Real code. Real speed.", que no le convenció del todo),
  mencionando "aprende haciendo, algo elegante, rápido, minimal" como
  guía de tono. Se propusieron ~9 opciones agrupadas por ángulo (aprender
  haciendo, código real, velocidad/precisión, metáfora de montaña/Ridge)
  antes de tocar nada. **Eligió**: "Type better, not just faster."
- **Eslogan actualizado en el código**: `splashSlogan` en `app_en.arb`
  ("Type better, not just faster.") y `app_es.arb` ("Escribe mejor, no
  solo más rápido."), regenerado con `flutter gen-l10n`. Único lugar del
  código que usa el eslogan hoy es `AppStartupSplash` (§7 de
  `MARKETING.md`) — no hizo falta tocar nada más.
- **`MARKETING.md` nuevo** (repo root, mismo estilo/idioma que
  `SPEC.md`/`STACK.md`): documenta el posicionamiento ("unir a
  programadores y aficionados al teclado", pedido explícito del
  usuario), con evidencia real ya implementada de ese puente (campos de
  teclado en el perfil, sound packs `Mechanical`/`Typewriter`/etc., el
  mark mismo), el eslogan y su porqué (conecta con SPEC.md principio #2),
  voz/tono, un resumen del design system (`STACK.md` §2.5) orientado a
  marketing, y las reglas aprendidas sobre el mark en esta misma sesión
  (nunca bisel/dish falso-3D). Referenciado desde `CLAUDE.md` igual que
  `SPEC.md`/`STACK.md`.
- **Nota de entorno**: a mitad de esta sesión, `bash tool/check.sh` falló
  en el paso de `dart format` por archivos de una sesión concurrente
  (`practice_mode_picker_sheet.dart`, `lock_screen.dart`,
  `onboarding_*_page.dart`, etc., no tocados por esta sesión) y
  `flutter analyze` marcó un error de sintaxis transitorio en
  `rename_profile_sheet.dart` (edición en curso de esa otra sesión). No
  se tocaron esos archivos — no son responsabilidad de esta sesión. El
  cambio de esta sesión (dos `.arb` + `MARKETING.md`, sin Dart nuevo más
  allá de lo ya regenerado) no lo requiere: los `.arb` no pasan por
  `dart format`/`flutter analyze`, y los `.dart` generados de `l10n/gen`
  están exentos de todas las reglas manuales (`CLAUDE.md`).

### 2026-09-10 — Tercera vuelta del mark: keycap plano de vuelta (sin bisel)

- **El usuario vio la R sola y preguntó**: "me gusta pero y el keycap de
  logo?" — releyendo la sesión anterior, lo que quería sacar no era el
  **cuadrado** en sí (su pedido original siempre fue "un keycap 2D... con
  la R"), sino específicamente el **bisel/dish falso-3D** que tenía el
  primer intento. Se confirmó con `AskUserQuestion` (mostrando de nuevo
  las dos opciones ya generadas) antes de tocar el archivo: eligió
  recuperar el cuadrado plano.
- **`assets/icons/r_mark.svg`** (mismo archivo, sin renombrar de nuevo —
  el nombre no compromete a ninguna forma en particular): mismos 2
  subpaths de la R sin cambios, con el path de cuadrado redondeado
  reincorporado (radio 60, mucho más chico que el radio 160 original —
  ese radio grande era justo lo que hacía leer "tecla física"; con radio
  60 lee como ícono de app genérico) y `viewBox` de vuelta a `-465 -465
  930 930` (el que corresponde al cuadrado, no al de la R sola).
- **Verificado visualmente** (`rsvg-convert`, 16px/72px reales, tinte
  `#FF5A36`): se ve bien en ambos tamaños de uso real.
- **Verificado en el proyecto**: `bash tool/check.sh` verde (**366
  tests**, format/analyze/arquitectura limpios).
- **Lección de esta sesión completa**: cuando el feedback de diseño es
  ambiguo ("quítale el efecto 3D" podía leerse como "quita la forma
  entera" o "quita solo el bisel"), generar 2-3 variantes rasterizadas
  reales y preguntar con `AskUserQuestion` antes de tocar código evitó ir
  y viniendo a ciegas — aun así hizo falta una ronda extra porque la
  primera lectura de la ambigüedad fue la equivocada.

### 2026-09-10 — Fix: flash del tema por defecto al arrancar (`AppSettings.initial`)

- **Pregunta del usuario**: "mientras carga el splash screen el window bar
  se ve sin el theme aplicado, por?" — la causa real no era el
  `WindowBar` en sí, sino que **toda la app** (el splash incluido, que
  está garantizado visible durante exactamente esa ventana) brevemente
  renderiza con `AppSettings.initial` (paleta Ember, tema `system`) en
  vez de la paleta/tema real del usuario, hasta que el `Stream<AppSettings>`
  de `SettingsController` resuelve su primer valor real desde
  `shared_preferences` (async, se resuelve unos frames después).
- **Fix**: `main.dart` ahora pre-calienta un `ProviderContainer` ANTES de
  `runApp` — lee `settingsRepositoryProvider`, y si es la implementación
  concreta (`SettingsRepositoryImpl`), espera su nuevo getter `hydrated`
  (un `Future<AppSettings>` separado del stream de `watch()`, que resuelve
  una sola vez con el valor real persistido) — y pasa ese MISMO container
  ya "tibio" a `UncontrolledProviderScope` en vez de dejar que un
  `ProviderScope` normal cree uno nuevo perezosamente. Así, el primer
  frame que Flutter pinta ya tiene los ajustes reales.
- **Intento fallido, revertido**: la primera versión intentó lograr esto
  cambiando el `onListen` de `SettingsRepositoryImpl` para NO repetir
  `_current` a un suscriptor que llega antes de hidratar — rompió
  determinísticamente `data_management_drift_integration_test.dart`
  ("wipeAllData... disarms the app lock"), un test sin relación alguna
  con el splash. Diagnosticado con `print` temporales: la secuencia de
  emisiones (`update(true)`, `update(false)`) llegaba en el orden
  correcto al `StreamController`, pero el estado de
  `SettingsController` (via `AsyncNotifier`) no llegaba a reflejar la
  última emisión sincrónicamente al leerlo justo después de un
  `await` — una sensibilidad de timing de microtasks de Riverpod de la
  que otro código (este test) dependía implícitamente sin saberlo.
  **Lección**: no toques la semántica de re-emisión de un stream
  compartido para resolver un problema de "valor inicial" — usa un
  mecanismo separado (`hydrated`) y deja `watch()`/`onListen` exactamente
  como estaban.
- **Verificado**: `bash tool/check.sh` verde — **366 tests**, format/
  analyze limpios, arquitectura sin violaciones nuevas. En la app real
  (`flutter run -d linux`), capturas en ráfaga (cada 100ms) del arranque
  confirman que la paleta/acento correctos (no Ember) se ven desde el
  primer frame del splash.
- **Seguimiento — sí era un bug real** (el usuario lo confirmó en su
  propia máquina, con GPU real: "aun sigue pasando, el window bar se
  pinta blanco"): la franja clara/blanca no era ruido de la sandbox — la
  causaba el fix anterior de esta misma sesión (ver "Fix: `WindowBar`
  crasheaba sin `Overlay` ancestro"), que envolvía el `WindowBar` de
  `AppStartupSplash` en un `Overlay(initialEntries: [...])` local para
  darle al `Tooltip` de `_WindowButton` un ancestro. `Overlay` no
  garantiza pintar su contenido en el mismo frame en que se inserta —
  deja una franja en blanco/sin componer durante uno o dos frames antes
  de que el `OverlayEntry` realmente pinte, visible como blanco porque
  `WindowOptions(backgroundColor: Colors.transparent)` deja ver lo que
  sea que haya detrás mientras tanto.
- **Fix real** (reemplaza el de la entrada anterior por completo, ya no
  hay `Overlay` en `window_bar.dart` en absoluto): en vez de darle a
  `WindowBar` un `Overlay` propio para que su `Tooltip` funcione en
  cualquier contexto, se le agregó un parámetro `showTooltips` (default
  `true`) que `_WindowButton` usa para saltarse el `Tooltip` por
  completo cuando es `false` — sin `Tooltip`, nunca hace falta un
  `Overlay`. `AppStartupSplash` pasa `WindowBar(showTooltips: false)`:
  esa instancia es no-interactiva y dura ~1.4s, perder el tooltip de
  hover ahí es irrelevante. `AppShell`/`LockScreen` (con `Overlay` real
  del `Navigator`) siguen con `showTooltips: true` por defecto, sin
  cambios de comportamiento.
- **Lección para la próxima**: cuando un widget necesita una capacidad
  (`Overlay`, `Navigator`, etc.) que solo UN caller no tiene, primero
  preguntar si esa capacidad es realmente necesaria para ESE caller —
  quitar la característica que la exige (aquí, el tooltip) es más
  simple y más robusto que fabricarle el ancestro que le falta.
- **Verificado en la app real** (`flutter run -d linux`, capturas en
  ráfaga cada 100ms cubriendo cold start + fade completo del splash):
  el `WindowBar` se ve oscuro y consistente con el resto de la app en
  TODOS los frames capturados, sin ninguna franja blanca/clara.
- **Verificado**: `bash tool/check.sh` verde — **366 tests**, format/
  analyze limpios, arquitectura sin violaciones nuevas.

### 2026-09-10 — Segunda vuelta del mark: fuera el marco de keycap, solo la R

- **Feedback del usuario** sobre el mark con keycap de la entrada
  anterior: "no se ve mal, [pero quítale] ese efecto falso 3D de tecla
  como logo" — el problema no era la R en sí, era el cuadrado/bezel
  detrás leyendo como una tecla física (skeuomorfismo), no un mark plano.
- **Se generaron 3 variantes** (rasterizadas con `rsvg-convert`, tinte
  ember real `#FF5A36`, mostradas al usuario antes de tocar código): (a)
  R sola sin fondo, (b) R recortada sobre cuadrado de radio chico, (c) R
  recortada sobre círculo. **El usuario eligió (a)** vía
  `AskUserQuestion`.
- **Archivo renombrado** `assets/icons/keycap_mark.svg` →
  `assets/icons/r_mark.svg` (con `git mv`, ya no es una keycap, el
  nombre viejo habría quedado engañoso) y actualizadas las 3 referencias
  (`pubspec.yaml`, `window_bar.dart`, `app_startup_splash.dart`).
  Contenido: mismos 2 subpaths de la R (contorno + counter de la panza,
  evenodd) que ya se habían extraído de Geist Mono Bold en la sesión
  anterior, **sin** el path del cuadrado exterior. `viewBox` recalculado
  ajustado al bounding box real de la R (`-230 -320 460 640`, antes
  `-465 -465 930 930` pensado para el cuadrado) para que la letra llene
  el ícono en vez de quedar con márgenes pensados para un fondo que ya
  no existe.
- **Verificado visualmente** (`rsvg-convert`, 16px/32px/72px reales, tinte
  de marca): la R se ve nítida y bien proporcionada en los dos tamaños de
  uso real (`WindowBar` 16px, splash 72px), sin el padding sobrante que
  hubiera quedado de reusar el `viewBox` viejo.
- **Verificado en el proyecto**: `bash tool/check.sh` verde (**366
  tests**, format/analyze/arquitectura limpios) y `flutter build linux
  --debug` compila con el asset renombrado.

### 2026-09-10 — Rediseño del mark: keycap con "R" (Geist Mono) en negativo

- **Feedback del usuario** sobre el mark del splash: "el logo no me
  encanta" — el mark viejo (bezel + "dish" hueco, sin letra) se veía
  como un blob vacío. Pedido: keycap 2D con la R en Geist Mono, minimal.
- **`assets/icons/keycap_mark.svg` reescrito por completo** (mismo
  archivo, mismo `viewBox`, cero cambios de código en
  `window_bar.dart`/`app_startup_splash.dart` — siguen apuntando a la
  misma ruta): ahora es un cuadrado redondeado **sólido** (mismo contorno
  exterior que el mark viejo, radio 160) con la **R recortada como
  hueco** (negative space, `fill-rule="evenodd"`), no una letra pintada
  encima. Bajo el tinte monocromo `ColorFilter.mode(color,
  BlendMode.srcIn)` que ya aplican ambos usos, solo importa la silueta
  alfa — el hueco de la R deja ver el fondo detrás (superficie/toolbar),
  igual que una tecla física con la letra grabada.
- **La R es el contorno real de Geist Mono Bold**, no dibujada a mano:
  extraída con `fontTools` (`SVGPathPen`) desde
  `assets/fonts/GeistMono/GeistMono-Bold.ttf` (upm 1000, bounds del
  glifo `R` x:[62,546] y:[0,710]), escalada ×0.8 y centrada en el
  cuadrado de -400..400 con una transformación afín simple (sin rotar:
  los comandos V/H/Q/L conservan su tipo, solo cambian los números). El
  hueco propio de la panza de la R (el "counter") sale gratis del mismo
  evenodd apilando los 3 subpaths (cuadrado, contorno de R, counter de
  R) — no hizo falta lógica extra.
- **Verificado visualmente** (este entorno no tiene servidor gráfico para
  Flutter, pero sí `rsvg-convert`): rasterizado a 512px, 32px y **16px
  real** (tamaño exacto de `WindowBar`) y con el color de marca real
  (`0xFFFF5A36`) sobre superficie clara — la R se mantiene legible incluso
  a 16px. Herramientas efímeras: venv de Python en `/tmp/logo_venv`
  (`fonttools`), todo borrado al terminar.
- **Verificado en el proyecto**: `bash tool/check.sh` verde (**366
  tests**, format/analyze/arquitectura limpios) y `flutter build linux
  --debug` compila con el asset nuevo (mismo path, sin tocar
  `pubspec.yaml`).

### 2026-09-10 — Fix: `WindowBar` crasheaba sin `Overlay` ancestro (splash)

- **Reportado por el usuario**: pegó un log de `flutter run` con
  `No Overlay widget found` (sobre un `RawTooltip` de `WindowButton`,
  `window_bar.dart:164`) y un `RenderFlex overflowed by 298673 pixels`,
  repetidos en ráfaga tanto al arranque en frío como tras un hot
  restart. No tenía relación con la sesión de "Progress JSON" en curso
  — pertenece al trabajo (de otra sesión concurrente) del splash de
  arranque de más abajo.
- **Causa real**: `AppStartupSplash` monta su propia copia de
  `WindowBar()` dentro del slot `builder` de `MaterialApp.router`
  (`app.dart`), que queda **por encima** del `Router`/`Navigator` — o
  sea, fuera de cualquier `Overlay` que ese `Navigator` provea.
  `_WindowButton` envuelve su ícono en un `Tooltip` (ahora `RawTooltip`
  internamente), que exige un `Overlay` ancestro incluso solo para
  construirse (no solo al mostrarse por hover) — así que esto no era una
  carrera de arranque transitoria, crasheaba en cada frame mientras el
  splash estuvo visible. `LockScreen` tiene su propio `WindowBar()`
  también, pero **sí** funciona porque `/lock` es una `GoRoute` normal —
  vive dentro del `Navigator` de go_router, con `Overlay` real.
- **Fix** en `window_bar.dart` (no en el splash — `WindowBar` promete en
  su propio doc "safe to mount unconditionally anywhere", así que se
  corrigió ahí para que la promesa sea cierta para cualquier caller
  futuro): el widget final se envuelve en un `Overlay` local
  (`Overlay(initialEntries: [OverlayEntry(builder: ...)])`). Como
  `Overlay` no se autodimensiona (a diferencia del `Container(height:
  ...)` que reemplazó, que sí ignora las constraints entrantes), hubo
  que envolverlo además en `SizedBox(height: WindowBar.height, ...)` —
  si no, revienta con "Overlay was given infinite constraints" en
  cuanto un padre (como el `Column` de `AppShell`) le da altura no
  acotada.
- **Regresión propia detectada por el usuario tras el fix de arriba**:
  "el appbar (windowbar) tiene un color super fuera de todo del theme
  original... no se adapta según el que elija en tiempo real". Causa:
  `Overlay.initialEntries` **solo se consulta una vez**, al crear su
  `OverlayState` — envolver todo en un `Overlay(initialEntries: [...])`
  nuevo en cada `build()` (como quedó arriba) hace que Flutter descarte
  el `OverlayEntry` nuevo y seguía usando el original congelado en el
  primer frame, así que ningún cambio de tema/paleta/paleta en vivo
  volvía a llegar a pantalla — quedaba pegado al color del primer
  build. **Fix del fix**: solo envolver en un `Overlay` local cuando
  `Overlay.maybeOf(context) == null` (el caso real del splash); cuando
  ya hay uno ambiente (`AppShell`, `LockScreen` — el caso normal y el
  único visible casi todo el tiempo), se retorna `content` directo,
  igual que antes de tocar nada — cero riesgo de regresión ahí, y
  reactivo al 100% otra vez.
- **Verificado en la app real** (`flutter run -d linux`, dos veces):
  arranque en frío limpio, cero exceptions en todo el log; y luego,
  tras el fix del fix, cambiando la paleta en Ajustes en vivo
  (Nord → Synthwave) con la app corriendo — el `WindowBar` (ícono,
  botones minimizar/maximizar/cerrar, tooltip al hover) se re-pinta
  instantáneamente con la paleta nueva, confirmado con capturas de
  pantalla reales. No se probó un hot restart real (no hay tty
  interactivo para mandar `R` a un proceso backgrounded en este
  entorno), pero la causa del crash original es estructural (no
  depende de cold-start vs. restart), así que el arranque limpio ya
  cubre ese caso.
- **Verificado**: `bash tool/check.sh` verde — **366 tests** (una
  corrida marcó 1 test de `survival_controller_drift_integration_test.dart`
  como fallido, pero pasó solo al re-correrlo aislado y de nuevo la
  suite completa — flaky preexistente, no relacionado: ese archivo no
  se tocó en esta sesión), format/analyze limpios, arquitectura sin
  violaciones nuevas.

### 2026-09-10 — Splash de arranque (marketing/branding)

- **Pedido del usuario**: pantalla de carga al abrir la app con logo,
  nombre "Ridge" y un eslogan, más una revisión de que el proyecto está
  listo para arrancar.
- **`AppStartupSplash`** (`lib/core/splash/app_startup_splash.dart`,
  presentación pura, sin dominio/aplicación — mismo tipo de carpeta plana
  que `lib/core/window/`): vive en el slot `builder` de `MaterialApp.router`
  (`app.dart`), envuelto por `AppWindowFrame` cuando aplica. Muestra un
  `Stack` con el `child` real (el árbol enrutado) construyéndose debajo
  desde el primer frame y el splash como capa opaca encima
  (`colorScheme.surface`) con el ícono `assets/icons/keycap_mark.svg`
  (mismo mark que `window_bar.dart`, teñido con `colorScheme.primary`), el
  wordmark `l10n.appName` y el eslogan `l10n.splashSlogan`, animados con
  `flutter_animate` + los tokens de `AppMotion` (fade/slide de entrada,
  nada de rebote — la única animación "loud" del proyecto sigue siendo el
  shake del PIN). Tras 1400 ms hace fundido de salida
  (`AppMotion.effectsSlow`) y luego se retira del árbol (deja de construir
  el `Stack`, ya no hay overlay). Incluye su propio `WindowBar()` (igual
  que hace `LockScreen` en su propio `Scaffold`) para que la ventana en
  Linux siga siendo arrastrable/cerrable durante el splash.
- **Efecto colateral deliberado**: como el `child` real ya se está
  construyendo debajo del overlay opaco, cualquier redirect de
  `app_router.dart` (onboarding/lock/practice) ya se resolvió para cuando
  el splash se levanta — no hace falta acoplar el splash a
  `hasGuestProfileProvider`/`settingsControllerProvider` ni tocar la
  lógica de redirect existente.
- **l10n**: clave nueva `splashSlogan` en `app_en.arb`/`app_es.arb`
  ("Real code. Real speed." / "Código real. Velocidad real.", tono
  consistente con `onboardingWelcomeTitle`: "Real code, not filler").
  Regenerado con `flutter gen-l10n`.
- **Verificado**: `bash tool/check.sh` verde (format, analyze
  `--fatal-infos --fatal-warnings`, arquitectura sin violaciones nuevas,
  **366 tests**) y `flutter build linux --debug` compila. No se pudo
  verificar visualmente (WSL2 sin servidor gráfico, misma limitación de
  siempre en este entorno).
- **Pendiente opcional, no pedido explícitamente**: splash nativo (SO) vía
  `flutter_native_splash` para tapar el hueco blanco antes de que Flutter
  pinte el primer frame — hoy solo existe el splash in-app descrito arriba.

### 2026-09-10 — Debug: ver/exportar stats de Progress como JSON

- **Motivación**: SPEC.md §15 ("el usuario puede consultar y exportar su
  propio historial y reporte de progreso en cualquier momento") no tenía
  todavía una vía concreta en la app — se pidió para poder debugear datos
  reales del perfil activo.
- `progress_stats_json_codec.dart` (`presentation/`, Dart puro, sin
  Flutter): serializa el `ProgressSnapshot` completo (xp, racha,
  mastery, weakness report, activity report) + el
  `PersonalHistoryComparison` de la categoría top (si ya resolvió) a un
  `Map<String, Object?>` — enums/ids en crudo (`.name`/`.value`), no
  labels localizados, porque es para depurar el dato, no para mostrarlo.
- `StatsJsonScreen` (nueva ruta `/progress/stats-json`): JSON con formato
  bonito, seleccionable, botón **Copiar** (`Clipboard`, sin dependencia
  nueva) y botón **Exportar** (archivo `.json` con timestamp bajo
  `getApplicationSupportDirectory()/exports/`, mismo patrón que
  `content_packs_directory.dart`). Punto de entrada: botón "View raw
  JSON" al final de la pestaña **History** de `ProgressScreen` (ya es
  "tu historial/tus datos") — el primer intento lo puso como ícono `{}`
  junto al `TabBar` en el app bar, pero el usuario lo rechazó por verse
  mal ahí; se movió dentro de la pestaña.
- `KeyboardScrollShortcuts` debe envolver **todo el body** (botones +
  scroll), no solo el `SingleChildScrollView` — los botones son hermanos
  del scrollable, y si quedan fuera, Home/End/PageUp/PageDown dejan de
  funcionar en cuanto el foco pasa a un botón (el evento de teclado nunca
  llega a ese `CallbackShortcuts` porque no es ancestro del foco actual).
- **Verificado en la app real** (`flutter run -d linux`, conectado por
  DTD/VM service), en ambas iteraciones (ícono en el app bar y luego el
  botón dentro de History): navegación Progress → History → "View raw
  JSON", JSON con datos reales del perfil, Copiar (confirmado leyendo el
  clipboard del sistema) y Exportar (confirmado leyendo el archivo
  `.json` resultante) funcionan. Nota de entorno: este contenedor corre
  bajo WSLg/Weston sin `_NET_ACTIVE_WINDOW` — `xdotool` no logra dar foco
  de teclado real a la ventana, así que el fix de
  `KeyboardScrollShortcuts` se validó por lectura del código/semántica de
  `Focus`, no visualmente.
- Test nuevo: `progress_stats_json_codec_test.dart` (forma de cada
  subsección + round-trip real por `jsonEncode`/`jsonDecode`).
- **Verificado**: `bash tool/check.sh` verde — **366 tests**, format/
  analyze (`--fatal-infos --fatal-warnings`) limpios, arquitectura sin
  violaciones nuevas.

### 2026-09-10 — Reto Diario (Fase 0, 100% offline)

- **Decisión con el usuario** (ver plan `el-reto-diario-me-frolicking-turing.md`):
  el Reto Diario de SPEC.md §5.4 tal cual está especificado depende de todo
  el backend online (Supabase Auth, Postgres+RLS, cron) que STACK.md §5–6
  describe pero que **aún no existe**. Se construyó primero una **Fase 0
  offline-only**: mismo snippet para todo el mundo calculado
  **determinísticamente por fecha UTC** (hash FNV-1a de 32 bits escrito a
  mano sobre `ChallengeDate.isoKey`, nunca `String.hashCode` — no
  garantizado estable entre plataformas/versiones de Dart), sin ningún
  round-trip a servidor. Banda de dificultad fija **Go
  Principiante/Intermedio** (decisión explícita del usuario: nada de rotar
  por todas las dificultades, para que el hábito diario no se rompa con un
  día "Experto" al azar). El puerto `DailyChallengeRepository` queda
  diseñado para que una Fase 1 futura le agregue un data source remoto
  detrás del mismo puerto (patrón adaptador dual, STACK.md §4.2) sin tocar
  dominio/aplicación de esta fase.
- **Nuevo feature `lib/features/daily_challenge/`** (hexagonal completo):
  `ChallengeDate` (value object, UTC date-only), `DailyChallenge`/
  `DailyChallengeCompletion` (entidades), `DailyChallengeSelector`
  (servicio puro del hash determinístico), `DailyChallengeStreakCalculator`
  (racha propia de este feature — **no** la racha general de actividad de
  `progression`, son conceptos distintos: esta solo cuenta días en que se
  jugó específicamente el Reto Diario), 4 usecases, tabla drift
  `daily_challenge_completions` (clave primaria compuesta `(profileId,
  challengeDate)` — un intento por día garantizado a nivel de esquema),
  `schemaVersion` 13→14.
- **`PracticeMode` ganó una variante nueva** `dailyChallenge({required
  DateTime challengeDate})` — se auditaron y actualizaron todos los call
  sites exhaustivos (`practice_mapper.dart` ×2,
  `finish_practice_session_usecase.dart`'s cálculo de `passed`, que
  reutiliza `PrecisionScoreCalculator` igual que Precisión/lección de
  ruta). Certificación de dominio (mastery) sigue siendo solo-Precisión a
  propósito: el Reto Diario no alimenta mastery en esta fase.
- **Integración con la sesión de práctica existente**: la tarjeta vive en
  `FreePracticeScreen` (`/free-practice`), arriba de los `QuickModeTile`;
  al tocarla empuja `/practice/session` reusando la rama de record tipado
  del router que ya usaba `learning_paths` (cero cambios de router). Al
  terminar una sesión, `PracticeSessionController` graba la finalización
  vía un usecase nuevo — la llamada es *fire-and-forget* e incondicional
  (no gateada por modo en el controller, igual que las otras tres
  llamadas ya existentes ahí); el usecase mismo decide que es un no-op si
  el modo no era `dailyChallenge`.
- **Refactor incidental**: mover las 4 llamadas fire-and-forget de
  `_persistFinishedSession` a una función top-level nueva en
  `practice_session_downstream_effects.dart` (part file) — no puede ser un
  método de extensión porque `ref` es un miembro `@protected` del notifier
  generado, solo accesible dentro del propio cuerpo de la clase; se
  resolvió pasando `ref` como parámetro explícito. Esto fue necesario
  porque agregar la 4ª llamada directamente dejaba
  `practice_session_controller.dart` en 505 líneas (límite duro: 500).
- **`data_reset_dao.dart`**: `wipeEverything()` ahora también borra
  `daily_challenge_completions` — si no, un reset completo de perfil deja
  huérfano el historial del Reto Diario.
- **Verificado**: `bash tool/check.sh` verde — **356 tests** (315 + 41
  nuevos: `ChallengeDate`, el selector con valores FNV-1a fijados a mano
  como regresión, el streak calculator, los 4 usecases, integración drift
  real, widget test de la tarjeta, extensión de
  `finish_practice_session_usecase_test.dart`, y cobertura del reset en
  `data_management_drift_integration_test.dart`), format/analyze
  (`--fatal-infos --fatal-warnings`) limpios, arquitectura sin violaciones
  nuevas.
- **Pendiente explícito** (no se hizo en esta sesión, a propósito): el
  leaderboard global y la racha a prueba de reinstalación (requieren
  Supabase/Auth, ver "Pendientes" abajo).

### 2026-09-10 — Fix: comentarios colándose en el tipeo de `go-tui-notes-v1`

- Reporte de usuario: la ruta `go-tui-notes-v1` (agregada hoy mismo, commit
  `7481669`) obligaba a tipear líneas de comentario Go (`// NoteID is...`)
  como parte del snippet — nunca debe pasar, el tipeo debe ser código puro.
- Causa: los 29 snippets se extrajeron **verbatim** de una app Go de
  referencia real (ver `snippet-authoring.md`), y el código idiomático
  incluye doc-comments de símbolos exportados. No hay ninguna lógica en
  `lib/` que filtre comentarios antes de usar `Snippet.code` como
  `expectedSnippet` — nunca la hubo ni la debe haber (afectaría offsets de
  resaltado de sintaxis y métricas por carácter en todos los modos).
- Fix: se limpiaron las 27 de 29 entradas de `go-tui-*` en
  `assets/content/snippets/go_v1.json` que tenían líneas `//`, quitando
  solo esas líneas (sin tocar el resto del código). Verificado: JSON
  válido, `gofmt -l` limpio en cada snippet modificado (envuelto en
  `package main`), sin líneas en blanco dobles resultantes, cero snippets
  de ninguna lección de `go-tui-notes-v1` con prosa (`titleEn/Es`,
  `explanationEn/Es`) que dependa del comentario para tener sentido.
  Editado en sitio (sin bump de `revision`): no había ninguna
  `typing_session`/`lesson_progress_cache` con progreso real sobre estos
  ids en `~/Documents/ridge.db.sqlite` — la ruta se agregó hoy y nadie
  la había completado.
- `snippet_catalog_completeness_test.dart`, `content_drift_integration_test.dart`
  y `scripts/audit_lesson_order.py` (contra `go_v1.json` +
  `go_tui_notes_v1.json`) pasan tras el cambio.
- `sql-basics-006` (`sql-foundations-v1`) tenía una línea
  `-- Arithmetic in the SELECT list` intencional — el título/explicación de
  esa lección eran literalmente sobre qué es un comentario SQL, a
  diferencia del caso de arriba que fue un efecto secundario accidental de
  la extracción verbatim. Usuario confirmó que quiere la regla "código
  puro, cero comentarios" sin excepciones: se quitó la línea de comentario
  y se reescribió la lección (título/tldr/explicación EN/ES en
  `sql_v1.json` + título del step en `sql_foundations_v1.json`) para que
  gire solo en torno a la división entera (`SELECT 10 / 2 AS half;`),
  `length` short → coherente con el resto de `sqlBasics`.
- Confirmado (script de auditoría): ningún snippet referenciado por
  `go-tui-notes-v1` ni `sql-foundations-v1` conserva líneas `//`/`--`/`#`.

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
- **Reto Diario en fases**: Fase 0 (hoy) es 100% offline — "mismo snippet
  para todo el mundo" se logra con un hash determinístico por fecha UTC,
  sin servidor. La racha del Reto Diario (`DailyChallengeStreakCalculator`)
  es deliberadamente distinta de la racha general de actividad de
  `progression` (`StreakCalculator`) — no reusar una para la otra. Fase 1
  (leaderboard global, racha a prueba de reinstalación) requiere el
  backend online completo (`auth` + Supabase) y se agrega como un data
  source remoto detrás del mismo `DailyChallengeRepository`, sin tocar
  dominio/aplicación de la Fase 0.
- **Audio de tecleo con presupuesto de recursos**: los pools de
  `KeystrokeSoundPlayer` en `PlayerMode.lowLatency` **deben** reciclar sus
  players (invocar el `stop()` que devuelve el pool, agendado ~200 ms) y
  llevar un circuit breaker. En lowLatency `AudioPool` no recicla solo, y
  cualquier path que cree jugadores nativos por tecla agota los file
  descriptors del proceso y termina en `abort()` de libpulse — no es
  catchable desde Dart (ver sesión del fix de sonido de tecleo).

## Pendientes / próximos pasos

- Todo lo online de `SPEC.md` §5/§9 y `STACK.md` §5–6 (Supabase, sync,
  duelos, escuadrones, leaderboards, y la Fase 1 del Reto Diario descrita
  arriba).
- Generar keystore/certificado de firma/cuentas reales de distribución
  (Play Console, certificado de firma de código Windows, Cloudflare Pages)
  antes del primer tag `v*.*.*` real — hoy `release-builds.yml` compila y
  empaqueta pero cae a firma debug/certificado de prueba sin esos
  secrets (ver sesión 2026-09-11 de build hardening).
- ~~Redimensionar `assets/icons/ridge_launcher_master.png` a los tamaños
  `hicolor` estándar~~ — hecho (sesión 2026-09-21, ver arriba: 64/128/256/512
  ya generados e instalados por el manifiesto Flatpak).
- **Auto-actualización Linux/Flathub + AUR (sesión 2026-09-21)**: el
  usuario decidió hacer público el repo existente (`sazardev/Ridge`) en
  vez de un repo separado solo para binarios — **bloqueado**: el intento
  de `gh repo edit --visibility public` fue denegado por el clasificador
  de seguridad de auto mode ("Create Public Surface"); el usuario debe
  hacerlo él mismo (web o su propia terminal). Hasta que eso pase, los
  jobs `linux` y `aur` de `release-builds.yml` fallarán al intentar
  descargar/verificar el *release asset* recién publicado (esperado, no
  silencioso). Antes de pedir el cambio se escaneó todo `git log --all`
  buscando secretos reales — no se encontró ninguno (ver sesión de arriba).
  Además, antes de abrir el PR de submission a Flathub falta: (a) una
  captura de pantalla real de la app para `<screenshots>` del metainfo,
  (b) un dominio real para `<url type="homepage">` (hoy apunta al repo
  como placeholder) y su verificación de dominio para el app-id
  `dev.omarcodes.*`. Para AUR falta que el usuario cree una cuenta en
  aur.archlinux.org, registre una llave SSH, y guarde la privada como el
  secret `AUR_SSH_PRIVATE_KEY` — hecho eso, el próximo tag publica el
  paquete `ridge` automáticamente (no hay paso manual de "crear" el
  paquete, ver `STACK.md §12`). Windows (auto-actualización vía
  MSIX/`.appinstaller` o Microsoft Store) quedó fuera de alcance de esta
  sesión a pedido del usuario.
- **Open source + protección de rama (sesión 2026-09-21)**: Ridge se
  relicenció a AGPL-3.0-or-later (`LICENSE`, ver arriba). Falta que el
  usuario haga público el repo (mismo bloqueo de arriba) — sin eso,
  también falla `gh api .../branches/main/protection` (probado: 403
  "Upgrade to GitHub Pro or make this repository public"). Una vez
  público, reintentar ese mismo comando (requerir el check `quality-gate`
  de `ci.yml`, bloquear force-push/delete, exigir resolución de
  conversaciones). Pendiente también, decisión del usuario, no del código:
  revisar si el modelo de negocio de `SPEC.md`/`MARKETING.md`
  (monetización, competencia) sigue siendo coherente con un cliente 100%
  abierto bajo AGPL. Opcional/no bloqueante: agregar cabeceras SPDX
  (`// SPDX-License-Identifier: AGPL-3.0-or-later`) por archivo fuente —
  no se hizo en esta sesión (tocaría cientos de archivos), el `LICENSE` en
  la raíz ya cubre el repo legalmente sin eso.
- Evaluar si `symbolFocus` merece valores SQL (hoy `[]`, como Bash) si se
  le da uso real en recomendaciones.
- Considerar versionar el harness de verificación de contenido SQL dentro
  de `tool/` (hoy efímero en `/tmp`).
- Ampliar `assets/content/keyboard_layouts/` con más modelos QMK/VIA con
  el tiempo (ver sesión 2026-09-11) — el patrón/arquitectura ya está
  armado, es trabajo de curación de datos, no de código.
- `AppNavigationShortcuts`/`EscapeToPop` no disparan sin foco de teclado
  previo (ver sesión 2026-09-12 de verificación en Android) — no
  bloqueante, pero si se retoca esa zona, replicar el patrón
  `Focus(autofocus: true)` que ya usan `snippet_info_screen.dart`/
  `practice_session_screen.dart`.
- Probar biometría end-to-end en un AVD con huella enrolada (ver sesión
  2026-09-12) — hoy solo verificado por código/lectura, no en vivo.

## Comandos clave

```sh
bash tool/check.sh                         # gate completo
flutter test                               # suite (768 tests)
python3 .claude/skills/content-curriculum/scripts/audit_lesson_order.py \
  assets/content/snippets/sql_v1.json \
  assets/content/learning_paths/sql_foundations_v1.json
# Postgres para verificar snippets SQL:
podman run -d --rm --name ridge-sql-pg -e POSTGRES_PASSWORD=postgres \
  docker.io/library/postgres:16-alpine
```
