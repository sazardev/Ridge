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

## Estado actual (2026-09-11)

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
  | Go | 160 snippets | `go-foundations-v1` (~51 lecciones) + `go-intermediate-syntax-v1` (25, con bloque Go 1.27) + notas DDD + `go-tui-notes-v1` (29, TUI Bubble Tea) + `go-algorithms-v1` (12, ver sesión de hoy) | práctica libre (grid denso) |
  | Bash (Arch) | 95 snippets | `bash-foundations-v1` + `bash-toolkit-v1` | solo-curso |
  | SQL (PostgreSQL) | 60 snippets | `sql-foundations-v1` (60) | solo-curso |
  | Rust | 24 snippets | `rust-foundations-v1` (12, solo principiante) + `rust-algorithms-v1` (12) | solo-curso |
  | Python | 24 snippets | `python-foundations-v1` (12, solo principiante) + `python-algorithms-v1` (12) — ambos nuevos, ver sesión de hoy | solo-curso |
  | JavaScript | 24 snippets | `javascript-foundations-v1` (12, solo principiante) + `javascript-algorithms-v1` (12) — ambos nuevos, ver sesión de hoy | solo-curso |

- Curso SQL: base de datos de ejemplo compartida tipo biblioteca
  (`authors`, `books`, `members`, `loans`), 8 categorías contiguas:
  `sqlBasics` (6), `sqlSchema` (13), `sqlQueries` (7), `sqlFiltering` (9),
  `sqlAggregation` (7), `sqlJoins` (7), `sqlModifications` (5),
  `sqlAdvancedQueries` (6). Dificultad 30/22/7/1.
- Gate de calidad: `bash tool/check.sh` (format + analyze + arquitectura +
  tests). Última corrida (2026-09-11, cierre de la migración del sonido de
  tecleo a flutter_soloud): **430 tests verdes**, format/analyze limpios, sin
  violaciones duras de arquitectura (solo warnings informativos de "varios
  tipos por archivo").
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
- Último release: **v1.11.0** (`5cf284a`). El siguiente push a `main`
  genera release automático desde los Conventional Commits.
- **Deep link a una lección** (`/practice/:pathId/lessons/:lessonId`,
  `LessonDeepLinkScreen`) + compartir enlace de una lección
  (`share_plus`) — ver sesión de hoy. Esquema propio `ridge://app/...`
  (`app_links`), solo Android por ahora. Notificaciones push siguen sin
  implementar (v2, `STACK.md §14`); esto solo deja una lección
  *direccionable* por URL para cuando lleguen.

---

## Historial de sesiones

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
- Redimensionar `assets/icons/ridge_launcher_master.png` a los tamaños
  `hicolor` estándar (128/256/512) antes de un submit real a Flathub —
  hoy el manifiesto Flatpak instala un único tamaño sin escalar.
- Evaluar si `symbolFocus` merece valores SQL (hoy `[]`, como Bash) si se
  le da uso real en recomendaciones.
- Considerar versionar el harness de verificación de contenido SQL dentro
  de `tool/` (hoy efímero en `/tmp`).
- Ampliar `assets/content/keyboard_layouts/` con más modelos QMK/VIA con
  el tiempo (ver sesión 2026-09-11) — el patrón/arquitectura ya está
  armado, es trabajo de curación de datos, no de código.

## Comandos clave

```sh
bash tool/check.sh                         # gate completo
flutter test                               # suite (404 tests)
python3 .claude/skills/content-curriculum/scripts/audit_lesson_order.py \
  assets/content/snippets/sql_v1.json \
  assets/content/learning_paths/sql_foundations_v1.json
# Postgres para verificar snippets SQL:
podman run -d --rm --name ridge-sql-pg -e POSTGRES_PASSWORD=postgres \
  docker.io/library/postgres:16-alpine
```
