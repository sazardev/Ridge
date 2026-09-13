# STACK.md — Ridge
### Arquitectura técnica y stack tecnológico

> Este documento declara **cómo se construye** el producto descrito en `SPEC.md`. Toda decisión aquí debe trazarse a una necesidad de negocio de `SPEC.md`; si una sección de este documento no sirve a ninguna regla de negocio, sobra. Donde sea relevante se referencia la sección de `SPEC.md` que justifica la decisión técnica.
>
> Este documento describe el estado actual del repositorio (ya implementado) **y** las extensiones necesarias para cubrir el alcance completo de `SPEC.md` (Supabase, sincronización, competencia online, multiplataforma). Las decisiones ya vigentes en el código se marcan como **[Vigente]**; las nuevas, como **[Nuevo]**.

---

## Índice

0. [Principios técnicos rectores](#0-principios-técnicos-rectores)
1. [Plataformas objetivo y matriz de soporte](#1-plataformas-objetivo-y-matriz-de-soporte)
2. [Frontend — Flutter](#2-frontend--flutter)
3. [Compatibilidad de paquetes y requisitos por sistema operativo](#3-compatibilidad-de-paquetes-y-requisitos-por-sistema-operativo)
4. [Arquitectura de software — Hexagonal (Ports & Adapters)](#4-arquitectura-de-software--hexagonal-ports--adapters)
5. [Backend — Supabase](#5-backend--supabase)
6. [Sincronización offline/online](#6-sincronización-offlineonline)
7. [Patrones de diseño transversales](#7-patrones-de-diseño-transversales)
8. [Coherencia — reglas no negociables](#8-coherencia--reglas-no-negociables)
9. [Seguridad](#9-seguridad)
10. [Versionamiento](#10-versionamiento)
11. [Testing y calidad](#11-testing-y-calidad)
12. [Despliegue (CI/CD por plataforma)](#12-despliegue-cicd-por-plataforma)
13. [Entornos y configuración](#13-entornos-y-configuración)
14. [Fuera de alcance técnico / roadmap](#14-fuera-de-alcance-técnico--roadmap)

---

## 0. Principios técnicos rectores

Estos principios traducen los principios de negocio de `SPEC.md §1` a decisiones de ingeniería:

1. **Un solo código fuente, cinco plataformas.** Flutter es la única capa de UI/lógica de cliente. Nada de forks nativos por plataforma salvo lo estrictamente necesario a nivel de empaquetado/distribución.
2. **Un solo backend, sin servidor propio.** Supabase cubre auth, base de datos, tiempo real y cómputo (Edge Functions). No se mantiene infraestructura propia (ni VM, ni contenedor propio, ni servidor Node/Go separado) — esto es lo que hace viable el principio de "bajo costo" de `SPEC.md §1.6`.
3. **Local-first.** El cliente nunca bloquea una funcionalidad individual por falta de red (`SPEC.md §8`). La base de datos local es la fuente de verdad inmediata; Supabase es la fuente de verdad eventual/compartida.
4. **Arquitectura hexagonal estricta.** Cada feature separa dominio, aplicación, infraestructura y presentación. Esto ya es la convención establecida en el repositorio (`lib/features/*`) y se extiende sin excepción a todo lo nuevo (Supabase incluido: Supabase es un detalle de infraestructura, nunca se referencia desde `domain` o `application`).
5. **Los errores son valores, no excepciones.** Todo puerto (`Repository`, `DataSource`) retorna `Result<S, AppFailure>`; nada de `try/catch` fugándose hacia la capa de presentación.
6. **Nada se calcula dos veces con dos criterios distintos.** Los agregados (nivel, XP, rating, leaderboards) siempre se recalculan desde el histórico de eventos (`SPEC.md §8.3`); el cliente nunca es la fuente de verdad de un agregado competitivo.
7. **Costo y latencia se diseñan, no se optimizan después.** Cada elección de Supabase (Realtime vs. polling, JSONB agregado vs. fila por evento, funciones event-driven vs. cron) se hace pensando en minimizar filas, invocaciones y bytes transferidos desde el día uno.
8. **Ninguna plataforma es de segunda clase.** Si un paquete no soporta igual de bien las cinco plataformas objetivo, se documenta la diferencia explícitamente (§3) y se diseña una mitigación — nunca se descubre en producción.

---

## 1. Plataformas objetivo y matriz de soporte

| Plataforma | Estado actual | Mecanismo de entrada de tecleo | Notas |
|---|---|---|---|
| **Android** | **[Vigente]** (`android/` ya existe) | Teclado físico/Bluetooth (preferido) o táctil en pantalla | Ver `SPEC.md §13.2`: sesiones sin teclado físico se registran en categoría "Modo táctil", separada de leaderboards de teclado físico. |
| **Linux (desktop)** | **[Vigente]** (`linux/` ya existe) | Teclado físico | Plataforma de desarrollo principal del equipo. |
| **Windows (desktop)** | **[Vigente]** (`windows/` ya existe) | Teclado físico | |
| **Web** | **[Vigente]** (`web/` ya existe) | Teclado físico | Ver nota de precisión de timestamps en §2.8 y consideraciones de runtime en §3.4. |
| iOS / macOS | Fuera de alcance v1 | — | No solicitado en `SPEC.md`; el código hexagonal no impide agregarlo después (`flutter create --platforms=ios,macos .`), pero no se prioriza. |

**Regla de paridad** (`SPEC.md §13.1`): toda plataforma soportada implementa el 100% de los módulos de negocio. No hay "modo lite" por plataforma — la única diferenciación permitida es la ya definida por negocio (teclado físico vs. táctil).

---

## 2. Frontend — Flutter

### 2.1 SDK y lenguaje **[Vigente]**
- **Flutter** con **Dart ^3.13.2** (ver `environment.sdk` en `pubspec.yaml`), null-safety estricto, `analysis_options.yaml` sobre `package:very_good_analysis/analysis_options.yaml` (~190 reglas, superset estricto de `flutter_lints`) con `strict-casts`/`strict-inference`/`strict-raw-types` y reglas adicionales (`unawaited_futures`, `avoid_dynamic_calls`) — se mantienen y se amplían para el código nuevo (ver §8, §11). Toda regla desactivada puntualmente lleva un comentario `// Disabled: <motivo>` en `analysis_options.yaml` — nunca una excepción muda.

### 2.2 Gestión de estado — Riverpod **[Vigente]**
- `flutter_riverpod ^3.4.3` + `riverpod_annotation` + `riverpod_generator` (codegen con `@riverpod`).
- Convención ya establecida: un provider generado por caso de uso/estado en `presentation/providers/*_providers.dart`, con su `.g.dart` generado — **nunca** `StateNotifier` manual ni `Provider` sin codegen para estado nuevo.
- Providers `keepAlive: true` reservados para singletons transversales (router, cliente de Supabase, servicio de sincronización) — ya es el patrón usado en `appRouter` (`lib/core/router/app_router.dart`).

### 2.3 Navegación — go_router **[Vigente]**
- `go_router ^18.0.1`, rutas declarativas (`GoRoute`, sin codegen de rutas), `StatefulShellRoute.indexedStack` para la navegación principal con pestañas persistentes — patrón ya usado para `/tasks`, `/settings`.
- Redirecciones centralizadas en un único `redirect` del router raíz, reactivas a providers vía `refreshListenable` (patrón `_RouterRefreshNotifier` ya existente) — así se integran los nuevos guards (p. ej. redirigir a `/auth` si una ruta requiere Cuenta Registrada y el usuario es Invitado, por `SPEC.md §7.1`).
- En Web, `go_router` requiere una decisión explícita de estrategia de URL — ver §3.4.
- **Deep link a una lección concreta** — `/practice/:pathId/lessons/:lessonId` (`LessonDeepLinkScreen`) resuelve y reenvía a `/practice/session`; es la única ruta pensada para llegar desde fuera de la app. Un enlace entrante (`app_links ^7.2.1`, esquema propio `ridge://app/...` — sin dominio propio todavía, así que no se usan App Links HTTPS/`assetlinks.json`; revisar esa opción cuando exista un dominio real de hosting web, §3.4) se valida contra una lista blanca de rutas (`isSupportedDeepLinkPath`, `lib/core/router/deep_link_providers.dart`) antes de reenviarse a `router.go` — la mayoría de las demás rutas leen un `extra` obligatorio que un enlace crudo nunca trae, así que reenviar una ruta arbitraria sin filtrar produciría un *null-assert crash* en vez de fallar de forma segura. Solo Android por ahora (no hay `ios/` en el repo, §1/§14).
- **Compartir el enlace de una lección** (`share_plus ^13.3.0`) — un `onShare` opaco (mismo patrón ya establecido por `onContinue`: `learning_paths` lo construye vía `LessonNavigation`, `practice` solo lo invoca sin saber qué hace) que `PracticeSessionScreen` solo expone una vez la sesión pasa. Vive como ícono pequeño y silenciado en la esquina derecha del título propio de `SessionResultPanel` ("Sesión completa") — no en `SessionResultFooter` (junto a Retry/Continue/info) ni, mucho menos, en la lista de lecciones (un ícono por fila ahí se sintió intrusivo en revisión de diseño, incluso limitado a lecciones completadas).

### 2.4 Modelado de datos — freezed / json_serializable **[Vigente]**
- Entidades de dominio inmutables con `freezed_annotation ^3.1.0` + `freezed`.
- DTOs de infraestructura (forma de persistencia/red) separados de las entidades de dominio, con su propio `json_serializable` y un `*_mapper.dart` explícito (`toDomain()` / `toDto()`) — **nunca** se serializa una entidad de dominio directamente; siempre pasa por un DTO. Ya es el patrón de `tasks` y `settings`.
- Identificadores de dominio como *value objects* dedicados (`TaskId` hoy; `UserId`, `SnippetId`, `MatchId`, `SquadId`, `SessionId` nuevos) generados con `uuid ^4.6.0`.

### 2.5 Sistema de diseño y coherencia visual **[Vigente + extendido]**
- Design tokens centralizados en `lib/core/theme/`: `app_colors.dart`, `app_shapes.dart`, `app_typography.dart`, `app_motion.dart`, ensamblados en `app_theme.dart`. Toda pantalla/widget nuevo consume estos tokens; **prohibido** hardcodear color, radio, duración o curva de animación fuera de `core/theme`.
- Tipografía: **Geist** (UI general) y **GeistMono** (autohospedadas, `assets/fonts/`). `GeistMono` es de uso **obligatorio** para: el snippet a teclear, el cursor de progreso, cualquier vista de métricas por carácter y los reportes de velocidad — una fuente monoespaciada no es un detalle estético aquí, es lo que garantiza que el ancho de cada carácter sea predecible para el usuario mientras teclea.
- Animación: `flutter_animate ^4.5.2` para microinteracciones (transiciones de estado, feedback de acierto/error carácter por carácter), siempre con curvas/duraciones tomadas de `app_motion.dart`.
- El teclado es el input principal de toda la app: el manejo de foco (`FocusNode`, `Shortcuts`/`Actions` de Flutter) es un requisito de primera clase, no un accesorio — cualquier pantalla de escritura debe capturar foco de forma predecible y nunca perderlo por una animación o rebuild.
- **Teclado del perfil en 3D real (excepción sancionada al "flat")**: el teclado del perfil (`KeyboardVisual` + `keyboard_layout_painter.dart` + `keyboard_geometry_3d.dart` + `keyboard_scene_3d.dart` + `keyboard_scene_faces.dart` + `keyboard_scene_shading.dart` + `keyboard_keycap_style.dart`) es el **único** lugar permitido para gradientes —la cara superior de cada keycap (dos paradas de luminosidad sutiles) y el halo suave de la retroiluminación RGB cuando el usuario la enciende (ver abajo)— y es un renderer 3D por software, sin paquetes nuevos: geometría real (case extruido con paredes, plate hundido, keycaps como frustums con esquinas redondeadas y bisel), cámara con perspectiva fija al espectador (`yaw`/`pitch`), proyección y **auto-fit al bounding proyectado** (el tablero se encoge para no cortarse a ángulos grandes, nunca crece más allá de su tamaño en reposo), culling de caras traseras, orden pintado por profundidad e iluminación direccional por cara (las caras superiores también se sombrean). Hover/press por tecla y drag-to-orbit siguen vivos: el hit-testing des-proyecta el puntero sobre el plano de las tapas con la misma cámara que dibuja, así que pintado y clickeable nunca divergen. Sigue prohibido cualquier blur o sombra difusa en toda la app. Cada keycap lleva además su **leyenda impresa** (Geist Mono, el mismo font del motor de tecleo): el painter la dibuja con la matriz de cámara (`KeyboardCamera.canvasMatrix`), así que el texto se apoya en el plano de la tapa con perspectiva real, y se auto-ajusta al ancho del cap cuando el nombre es largo; las etiquetas salen de los keymaps default reales de QMK (ver `assets/content/keyboard_layouts/THIRD_PARTY_SOURCES.md`) y las familias genéricas usan leyendas QWERTY canónicas en Dart. La razón es de producto: el teclado es el objeto que este usuario configura y reconoce, y el render plano no vendía las teclas. El contraste tecla↔board está fijado por test para las 24 paletas × 2 brightness (`keyboard_keycap_style_test.dart`).
- **Personalización total del teclado (editor `/profile/keyboard/customize`)**: sobre el mismo renderer, el usuario elige la silueta de los keycaps (redondeada/cuadrada/redonda — el radio de esquina efectivo lo resuelve `keyboard_scene_shading.dart` según la forma), la **transmisión de luz** de las teclas (`KeycapTransparency`: opacas con leyenda oscura, shine-through con leyenda iluminada, pudding con laterales brillantes, translúcidas — los factores viven en `KeyboardKeycapStyle`), colores propios de keycaps y carcasa (ARGB; sin override salen del `ColorScheme`), y **RGB**: once efectos de firmware (fijo, respiración, arcoíris, ciclo de color, onda, aurora, estrellas, lluvia, degradado, reactivo y **onda expansiva/ripple**) en una rejilla visual de tiles (`keyboard_effect_grid.dart`). Los efectos animados se resuelven por tecla con `keyboard_scene_effects.dart` (`effectIntensity`/`rgbTint` por posición, onda gaussiana que recorre, destellos con hash por tecla, gotas que caen, bandas de aurora) y el *splash* del ripple se calcula por distancia al origen de cada pulsación (`rippleBoost`, radio a 7 u/s, vida 1.4 s). Con RGB encendido, la escena antepone un **halo de luz** (gradiente radial de color→transparente proyectado bajo la caja) y tiñe tapas, laterales y plate; `KeyboardVisual` mantiene vivo un `AnimationController` (respiración ~4 s, arcoíris ~8 s) solo mientras el efecto es animado, y el campo `rgbPhase` del painter alimenta el color por fotograma (el arcoíris varía el tono por columna). Las leyendas por tecla (`keyOverrides`, direccionadas por posición física `keyboardKeyIdFor`, nunca por índice), las **teclas extra** (colocadas por `keyboard_customization_geometry.dart` en columnas a la derecha del tablero) y los **remapeos funcionales** (ver `SPEC.md §7.3`) viven en `KeyboardCustomization`, persistida como un blob JSON en la columna `guest_profiles.keyboard_customization_json` (schema drift v17) — nunca se consulta a nivel SQL, solo se lee entera para dibujar. El editor guarda con un caso de uso propio (`UpdateKeyboardSetupUseCase`, columnas disjuntas del formulario de perfil) y muestra una ficha de especificaciones completa en el inspector (`keyboard_specs.dart` alimenta la tarjeta y el viewer).
- **Luces por tecla y libertad geométrica total (misma sesión)**: cada tecla puede tener su propio color de retroiluminación (`KeyboardKeyLight`, indexado por `keyboardKeyIdFor` o por el id de una tecla extra). Con RGB encendido, cada tecla con luz propia recibe un **charco radial sobre el plate** (`_plateGlowFaces`) y un **glow aditivo a través de la tapa** (campo `glowColor` de `KeyboardFace`, pintado con `BlendMode.plus` por el painter, nunca una sombra), y su leyenda se tiñe hacia el color de luz; el hit-testing y el resto del render no cambian. La geometría es libre: elegir un formato **reemplaza** la geometría del modelo (aunque sea curado), incluida `KeyboardShapeFamily.custom`, el lienzo en blanco que se construye solo con teclas extra (bloque tipo macro-pad que empieza en el origen). El preview del editor es un producto-shot en vivo (pitch de 20°, órbita por arrastre de mouse, tap directo a la edición de la tecla y botón de pantalla completa que abre el inspector con el estado **sin guardar**); los remapeos funcionales se reflejan en las tapas (el carácter nuevo como leyenda primaria y el viejo arriba, vía `_legendToPhysicalKeyName`) para que "el reordenamiento de las letras" se vea en el propio tablero. Las familias genéricas 60/65/75/TKL llevan también las leyendas canónicas de su clúster de navegación (Ins/Home/PgUp, Del/End/PgDn, flechas). El visor y el preview del editor **reaccionan al teclado físico real**: un `Focus` observa los keydown/keyup, los traduce a `PhysicalKeyId` por posición física (`physicalKeyIdFor`, de `practice`), reproduce el click de tecleo (`keystrokeSoundPlayer`, el mismo del motor de práctica) y `KeyboardKeyEffects` hunde, destella y lanza la onda expansiva de la tapa correspondiente con un ticker propio que se detiene solo cuando no queda nada en movimiento (los clicks del puntero hacen lo mismo). El editor es ahora un configurador, no un formulario: cada sección es una card con ícono, hay una tira de navegación rápida que salta a cada sección (`keyboard_section_nav.dart`) y una acción de reset total en el AppBar.
- En Web, la fidelidad de esta tipografía monoespaciada depende del *renderer* elegido — ver §3.4.
- **Widgets globales (diseño atómico).** Un widget vive en `features/<feature>/presentation/widgets/` mientras lo use un solo feature. En cuanto un segundo feature necesita el mismo widget, se promueve a `lib/design_system/{atoms,molecules,organisms}/` (átomo: no compone otros widgets del design system, p. ej. un botón o un chip; molécula: compone átomos, p. ej. un campo con su label y su error; organismo: compone moléculas/átomos en una sección completa reutilizable) y se exporta desde `lib/design_system/design_system.dart`. Checklist de promoción: (1) usado por 2+ features, (2) no importa nada de `application/` ni `domain/` de un feature específico, (3) solo consume tokens de `core/theme/`. Nunca se duplica el mismo widget en dos features para evitar el import cruzado — eso es exactamente lo que el design system existe para prevenir.

### 2.6 Internacionalización **[Vigente]**
- `flutter_localizations` + `intl`, archivos `lib/l10n/app_en.arb` / `app_es.arb`, generación vía `flutter gen-l10n` (`l10n.yaml`, `generate: true` en `pubspec.yaml`). Todo string nuevo de UI pasa por ARB — nunca string literal en widgets.

### 2.7 Persistencia local **[Vigente + extendido]**

| Dato | Mecanismo | Razón |
|---|---|---|
| Preferencias simples, `AppSettings` (tema, idioma) | `shared_preferences ^2.5.5` (`SharedPreferencesAsync`) | **[Vigente]** — ya usado en `settings` y `tasks`. Adecuado para valores pequeños y de baja cardinalidad. |
| PIN de bloqueo / tokens de sesión Supabase | `flutter_secure_storage ^11.0.0` | **[Vigente/extendido]** — ya usado en `core/security/secure_storage_provider.dart`. Se reutiliza como backend de almacenamiento de sesión del SDK de Supabase (ver §5.2), en vez del almacenamiento por defecto del SDK. Mecanismo nativo y salvedades por plataforma: ver §3.2. |
| Metadata detallada de tecleo, historial de sesiones, cola de sincronización | **`drift`** (SQLite tipado) — **[Nuevo]** | `shared_preferences` no escala a un histórico creciente de sesiones con desgloses por carácter/dedo/n-grama que se necesita **consultar** (top-10 debilidades, promedios por ventana de tiempo), no solo leer entero. `drift` da consultas SQL tipadas, streams reactivos (coherente con el patrón `Stream<List<Task>>` ya usado) y soporta **todas las plataformas objetivo**, incluida Web (vía `sqlite3.wasm` + OPFS). Detalle de salvedades por plataforma: ver §3.2. |

Paquetes nuevos para persistencia local estructurada: `drift`, `drift_flutter` (apertura de base de datos multiplataforma), `sqlite3_flutter_libs` (nativo: Android/Windows/Linux), `sqlite3` (asset WASM para Web). Versión exacta a resolver con `flutter pub add` al momento de integrar (tomar siempre la última estable compatible con el Dart SDK del proyecto).

**Paquetes de contenido de terceros** ("content packs" — ver `CLAUDE.md` §Content sourcing): un directorio plano de JSON bajo `getApplicationSupportDirectory()`, fuera de `drift`, leído por `ExternalSnippetPackSource`/`LearningPathRepositoryImpl`. Regla de protección: cada archivo se descarta (con log, sin abortar el resto del pack) si supera **5 MiB** antes de decodificarse — un pack legítimo pesa órdenes de magnitud menos; el límite evita cargar a memoria un archivo arbitrariamente grande solo para descubrir después que es inválido. Implementado en `content_packs_directory.dart` (`maxContentPackFileBytes` / `readContentPackFile`).

### 2.8 Captura de input de bajo nivel (motor de métricas) **[Nuevo]**
- Se captura con los eventos de teclado físico de Flutter (`HardwareKeyboard` / `KeyDownEvent` / `KeyUpEvent` de `package:flutter/services.dart`), no con `TextField.onChanged` — un `TextField` normal no expone ni el *keydown* real, ni tiempos de permanencia, ni tecla física, que son la base de toda la metadata de `SPEC.md §4.1`.
- Cada evento se timestampea con el reloj monotónico del motor (no `DateTime.now()`, que no es monotónico y es vulnerable a ajustes de reloj del sistema).
- **Nota técnica de riesgo conocido**: en **Web**, los navegadores limitan deliberadamente la resolución de `performance.now()`/timestamps de eventos por razones de privacidad (mitigación de *timing attacks*), por lo que la precisión de tiempo de vuelo entre teclas puede ser menor que en nativo. Se documenta como limitación conocida de la plataforma Web, a monitorear; no se resuelve inventando una nueva categoría de negocio — si en el futuro se vuelve significativo, es una decisión de `SPEC.md`, no de este documento.

### 2.9 Paquetes de terceros — resumen de roles

| Paquete | Estado | Propósito |
|---|---|---|
| `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator` | Vigente | Estado y DI |
| `go_router` | Vigente | Navegación declarativa |
| `freezed_annotation`, `freezed`, `json_annotation`, `json_serializable` | Vigente | Modelos inmutables + serialización |
| `uuid` | Vigente | Identificadores de dominio |
| `flutter_secure_storage` | Vigente/extendido | Secretos (PIN, sesión Supabase) |
| `shared_preferences` | Vigente | Preferencias simples |
| `flutter_animate` | Vigente | Motion |
| `flutter_soloud` | Vigente | SFX de tecleo: voces polifónicas de baja latencia (motor SoLoud; reemplazó a `audioplayers`, §3.2) |
| `crypto` | Vigente/extendido | Hash de PIN local; hoy también candidato para verificación local de integridad de datos sincronizados |
| `intl`, `flutter_localizations` | Vigente | i18n |
| `build_runner`, `flutter_lints` | Vigente (dev) | Codegen y lint |
| `supabase_flutter` | **Nuevo** | Cliente Supabase: Auth, Postgres (PostgREST), Realtime, Edge Functions |
| `drift`, `drift_flutter`, `sqlite3_flutter_libs`, `sqlite3` | **Nuevo** | Persistencia local estructurada (metadata de tecleo, outbox de sincronización) |
| `connectivity_plus` | **Nuevo** | Detección de estado de red para disparar sincronización (§6) |
| `msix` | **Nuevo (dev)** | Empaquetado Windows para distribución (§12) |
| `integration_test` | **Nuevo (dev)** | Pruebas end-to-end multiplataforma (§11) |

Esta tabla es de **referencia rápida**. La matriz completa de compatibilidad por sistema operativo, mecanismos nativos por plataforma, requisitos de compilación y salvedades de runtime de cada uno de estos paquetes está en **§3**.

---

## 3. Compatibilidad de paquetes y requisitos por sistema operativo

> "Funciona en las cinco plataformas" no significa "funciona igual" en las cinco plataformas. Cada paquete resuelve la misma necesidad con un mecanismo nativo distinto según el sistema operativo, y algunos tienen requisitos de compilación, permisos o límites de tiempo de ejecución que hay que conocer **antes** de escribir código sobre ellos, no después de que algo falle en producción (principio §0.8). Esta sección es la referencia exhaustiva de tolerancia por plataforma de todo el stack.

### 3.1 Matriz maestra de compatibilidad

Leyenda: ✅ soportado nativamente sin salvedades · ⚠️ soportado con una salvedad relevante (ver §3.2) · ❌ no aplica a esa plataforma.

| Paquete | Android | Linux desktop | Windows | Web | Mecanismo nativo por plataforma |
|---|:---:|:---:|:---:|:---:|---|
| `flutter_riverpod` / `riverpod_annotation` / `riverpod_generator` | ✅ | ✅ | ✅ | ✅ | 100% Dart. El codegen corre en build-time (`build_runner`); no queda rastro nativo en el binario final. |
| `go_router` | ✅ | ✅ | ✅ | ⚠️ | Dart puro sobre `Navigator`. En Web requiere elegir estrategia de URL (§3.4). |
| `freezed` / `json_serializable` (+ `*_annotation`) | ✅ | ✅ | ✅ | ✅ | Solo codegen en build-time; cero huella en runtime en cualquier plataforma. |
| `uuid` | ✅ | ✅ | ✅ | ✅ | Dart puro. En Web usa `window.crypto.getRandomValues` para entropía criptográfica (disponible en todo navegador moderno). |
| `crypto` | ✅ | ✅ | ✅ | ✅ | Dart puro, sin bindings nativos. |
| `intl` / `flutter_localizations` | ✅ | ✅ | ✅ | ✅ | Dart puro; datos de locale empaquetados como assets. |
| `flutter_animate` | ✅ | ✅ | ✅ | ✅ | Se apoya en el motor de renderizado de Flutter, sin plugins nativos. |
| `cupertino_icons` | ✅ | ✅ | ✅ | ✅ | Fuente de glifos vectoriales; pese al nombre, no implica UI de iOS. |
| `shared_preferences` | ✅ | ✅ | ✅ | ✅ | Backend de almacenamiento distinto por plataforma (§3.2), API idéntica. |
| `flutter_secure_storage` | ✅ | ⚠️ | ✅ | ⚠️ | Keystore/Credential Locker nativos en Android/Windows; `libsecret` en Linux (requiere keyring); `localStorage` cifrado en Web (§3.2). |
| `local_auth` | ✅ | ❌ | ✅ | ❌ | `BiometricPrompt` en Android, Windows Hello en Windows. Sin implementación de Linux ni Web — el feature `lock` (§4.5) lo trata como una mejora opcional, nunca como requisito (§3.2). |
| `connectivity_plus` | ✅ | ✅ | ✅ | ⚠️ | Estado real de red del SO en nativo; heurística de navegador en Web (§3.2). |
| `supabase_flutter` | ✅ | ✅ | ✅ | ⚠️ | HTTP + WebSocket puro. En Web, Realtime puede degradarse por proxies/ad-blockers (§3.2). |
| `url_launcher` | ✅ | ✅ | ✅ | ✅ | Intents nativos del SO (Android `ACTION_VIEW`, `xdg-open` en Linux, `ShellExecute` en Windows); pestaña nueva en Web. Sin permisos ni configuración adicional (§3.2). |
| `drift` + `drift_flutter` + `sqlite3_flutter_libs` + `sqlite3` | ✅ | ✅ | ✅ | ⚠️ | Binario nativo de SQLite en Android/Linux/Windows; `sqlite3.wasm` + OPFS (con salvedad de cabeceras) en Web (§3.2). |
| `flutter_soloud` | ✅ | ✅ | ✅ | ⚠️ | Motor SoLoud + miniaudio nativo (AAudio en Android, ALSA en Linux, WASAPI en Windows), compilado con Dart build hooks; WASM + `init_soloud.js` en Web (§3.2). |
| `msix` | ❌ | ❌ | ✅ | ❌ | Empaquetador exclusivo de Windows, solo `dev_dependency`. |
| `integration_test` | ✅ | ✅ | ✅ | ⚠️ | En Web se ejecuta vía `flutter drive` + ChromeDriver, mecanismo distinto al de nativo (§3.3). |
| `build_runner`, `flutter_lints` | — | — | — | — | Herramientas de build-time/dev-time; no producen artefacto de runtime, no aplica matriz. |

### 3.2 Detalle y salvedades por paquete

**`shared_preferences`** — misma API, backend distinto: Android usa `SharedPreferences` nativo (XML); Linux y Windows usan un archivo de datos de la app en el directorio de configuración estándar del sistema (`~/.local/share/<app>/` en Linux, `%APPDATA%\<app>\` en Windows); Web usa `window.localStorage` (persistente pero borrable por el usuario o el navegador, con un límite compartido por dominio de unos 5–10 MB). Ninguna salvedad bloqueante — es exactamente lo que se necesita para preferencias pequeñas.

**`flutter_secure_storage`** — el paquete con mayor divergencia de *garantías* de seguridad entre plataformas, no solo de mecanismo:
- **Android**: Android Keystore + `EncryptedSharedPreferences`. Fuerte, sin dependencias externas, sin configuración adicional.
- **Windows**: Windows Credential Locker (API de WinRT). Fuerte, sin instalación adicional.
- **Linux**: **libsecret**, vía el Secret Service de D-Bus. Esto **requiere**:
  - En tiempo de compilación: la librería de desarrollo `libsecret-1-dev` instalada en la máquina que compila (ver §3.3).
  - En tiempo de ejecución: un *keyring* corriendo (GNOME Keyring, KWallet u otro proveedor del Secret Service). **Riesgo concreto**: en un servidor headless, un contenedor de CI, o una sesión Linux sin entorno de escritorio, no hay Secret Service disponible y las llamadas de lectura/escritura fallan. **Mitigación**: en pipelines de CI que corran en Linux, envolver la ejecución con `dbus-run-session -- gnome-keyring-daemon --unlock` para simular un keyring, o directamente sustituir el repositorio de almacenamiento seguro por un doble de prueba en los tests automatizados que corren en Linux headless — nunca depender de libsecret real en CI.
  - Empaquetado como **Flatpak**: el sandbox de Flatpak no da acceso a D-Bus Secret Service salvo que el manifiesto lo declare explícitamente (`--talk-name=org.freedesktop.secrets`, o el portal `org.freedesktop.portal.Secret`). Sin ese permiso en el manifiesto, el guardado seguro falla silenciosamente dentro del sandbox — se declara como requisito obligatorio del manifiesto Flatpak (§12).
- **Web**: usa `window.localStorage` con una capa de cifrado adicional de la librería, pero la clave de cifrado también reside en el navegador — **no** ofrece la misma garantía que un Keystore/Credential Locker nativo. Se acepta como limitación conocida para guardar la sesión JWT en Web (mismo nivel de garantía que cualquier SPA que guarda un token en el navegador); no se compensa con criptografía adicional porque el enemigo de ese modelo de amenaza (acceso físico/malware al navegador del propio usuario) no cambia con más cifrado del lado del cliente.

**`local_auth`** — desbloqueo biométrico opcional para el PIN de `lock` (§4.5), nunca su reemplazo:
- **Android**: `BiometricPrompt` nativo — requiere `minSdkVersion 23`+ (ya cubierto por el `flutter.minSdkVersion` por defecto del proyecto) y que `MainActivity` extienda `FlutterFragmentActivity` en vez de `FlutterActivity` (`android/app/src/main/kotlin/.../MainActivity.kt`), más el permiso `USE_BIOMETRIC` en el manifiesto.
- **iOS**: Face ID/Touch ID vía `local_auth_darwin` — sin salvedad propia más allá de que iOS está **fuera de alcance v1** (§1); de agregarse la plataforma, requiere declarar `NSFaceIDUsageDescription` en `Info.plist`.
- **Windows**: Windows Hello vía `local_auth_windows` — sin configuración adicional.
- **Linux y Web**: **sin implementación** — el paquete no registra ningún plugin ahí. Una llamada sin protección lanzaría una excepción de plugin faltante. **Mitigación** (ya implementada en `LocalAuthBiometricRepository`): toda llamada está envuelta en `try/catch` y `isAvailable()` degrada a `false` ante cualquier excepción, así que en Linux/Web el toggle de biometría de Ajustes simplemente nunca se muestra — el PIN sigue siendo 100% funcional en las cinco plataformas, la biometría es un atajo adicional, no un requisito (principio §0.8).

**`connectivity_plus`** — en Android/Windows/Linux consulta el estado real de la interfaz de red del sistema operativo. En **Web** no existe una forma fiable de saber "hay internet real": el evento `navigator.onLine` del navegador solo indica que hay una interfaz de red activa (un WiFi conectado a un router sin salida a internet igual reporta `online`). **Mitigación**: el `SyncService` (§6) en Web no se queda esperando pasivamente la señal de `connectivity_plus`; además reintenta con *backoff* ante fallos reales de las peticiones HTTP a Supabase, tratando la señal de conectividad como una pista, no como la verdad.

**`supabase_flutter`** — cliente 100% HTTP + WebSocket, sin plugins nativos, por lo que corre igual en las cuatro plataformas. La única salvedad es en **Web**: el WebSocket usado por Realtime puede ser bloqueado por bloqueadores de anuncios agresivos, extensiones de privacidad, o proxies corporativos que no permiten `wss://`. Cuando esto ocurre, la app se degrada a "sin actualizaciones en vivo" (sin Realtime) pero el resto de la funcionalidad (lecturas/escrituras vía PostgREST, Auth) sigue funcionando con normalidad — la UI debe tolerar la ausencia de eventos Realtime sin bloquear ninguna pantalla.

**`drift` + `drift_flutter` + `sqlite3_flutter_libs` + `sqlite3`** — el paquete con más matices:
- **Android**: `sqlite3_flutter_libs` empaqueta binarios `.so` para `armeabi-v7a`, `arm64-v8a` y `x86_64`. Sin configuración manual; el Android App Bundle sirve a cada dispositivo solo el `.so` de su propia arquitectura, así que el tamaño final descargado por el usuario no crece por soportar múltiples arquitecturas.
- **Windows**: empaqueta `sqlite3.dll`, incluida automáticamente por `flutter build windows` junto al ejecutable.
- **Linux**: empaqueta `libsqlite3.so`; en el empaquetado Flatpak, la biblioteca vive dentro del sandbox de la propia app y no depende de la versión de SQLite instalada en el sistema anfitrión.
- **Web**: `sqlite3_flutter_libs` **no aplica** (es un plugin de plataforma nativa). En su lugar, `drift` sobre Web carga `sqlite3.wasm` como asset y lo ejecuta en un Web Worker, persistiendo preferentemente en **OPFS** (Origin Private File System) por rendimiento. **OPFS de alto rendimiento requiere que el sitio se sirva con las cabeceras `Cross-Origin-Opener-Policy: same-origin` y `Cross-Origin-Embedder-Policy: require-corp`** (COOP/COEP) — deben configurarse explícitamente en el hosting elegido (§12). Si el hosting no puede fijar esas cabeceras, `drift` cae automáticamente a un VFS respaldado por IndexedDB: funcional, pero notablemente más lento en cargas de datos grandes — aceptable como *fallback* documentado, no como plan A.

**`go_router` en Web** — ver estrategia de URL en §3.4.

**`flutter_soloud`** — motor de audio (SoLoud + miniaudio) para los SFX de tecleo, elegido sobre `audioplayers` porque reproduce cada tecla como una **voz independiente y polifónica** (sin pool de players que reciclar ni handles nativos que liberar a mano) y, con el *render-ahead ring* nativo, la latencia tecla→sonido baja al periodo del dispositivo (~11 ms) en vez de esperar al bloque de mezcla (~46 ms). Salvedades: en **Linux** la máquina de build necesita `libasound2-dev` (§3.3); en **Web** requiere el script `assets/packages/flutter_soloud/web/init_soloud.js` en `web/index.html` y el *render-ahead ring* no existe (la latencia queda cuantizada al buffer); los builds nativos no compilan los códecs Xiph porque `pubspec.yaml` fija `hooks.user_defines.flutter_soloud.no_xiph_libs: true` (solo se usan WAV). El audio es **decorativo**: toda la ruta de carga/reproducción va en `try/catch` y un backend ausente nunca interrumpe el tecleo.

**`url_launcher`** — abre los enlaces externos del perfil (GitHub, página web) en el navegador del sistema, nunca dentro de la app. Cada plataforma usa el mecanismo estándar del SO (Intent `ACTION_VIEW` en Android, `xdg-open`/portal en Linux, `ShellExecute` en Windows) y en Web abre una pestaña nueva. La apertura es *best-effort*: `ProfileLinksCard` envuelve la llamada en `try/catch`, así que un fallo (sin navegador asociado, plataforma sin handler) simplemente no hace nada — nunca bloquea la pantalla. Sin permisos, dependencias de compilación ni configuración adicionales en ninguna plataforma.

**`msix`** — `dev_dependency` exclusiva de Windows; no se instala ni afecta el árbol de dependencias de ninguna otra plataforma. Requiere un certificado de firma de código: autofirmado para desarrollo/pruebas internas, o firmado por una CA reconocida (o por el propio proceso de certificación de Microsoft Store) para distribución pública — sin certificado válido, Windows SmartScreen advierte al usuario al instalar.

**`integration_test`** — en Android/Windows/Linux corre contra el binario real de la plataforma vía `flutter test integration_test/` o `flutter drive`. En **Web** requiere Chrome/Chromium y ChromeDriver instalados en la máquina que ejecuta las pruebas, y se invoca como `flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d web-server` — un mecanismo de ejecución distinto que debe declararse como su propio job de CI (§3.3, §11).

### 3.3 Toolchain de compilación requerido por plataforma

Lo que necesita **la máquina que compila** (local o CI) — no confundir con lo que necesita el dispositivo del usuario final, que solo recibe el binario ya compilado.

| Plataforma | Requisitos de la máquina de build | Runner de CI sugerido (GitHub Actions) |
|---|---|---|
| **Android** | JDK 17, Android SDK (`cmdline-tools`, `platform-tools`, la *platform* correspondiente al `compileSdkVersion` que use la versión de Flutter del proyecto), Android NDK (versión fijada en `android/app/build.gradle` para reproducibilidad — la exige `sqlite3_flutter_libs`), Gradle (gestionado por el wrapper del propio proyecto, no se instala aparte) | `ubuntu-latest` (trae JDK y Android SDK preinstalados; NDK se instala/fija con `sdkmanager` en el propio workflow) |
| **Windows** | Visual Studio 2022 o superior, con el *workload* **"Desarrollo para el escritorio con C++"** (incluye el Windows SDK) — requisito no opcional del *embedder* de Flutter Windows | `windows-latest` (ya trae Visual Studio con ese *workload* preinstalado) |
| **Linux** | Toolchain de compilación C/C++: `clang`, `cmake`, `ninja-build`, `pkg-config`; bibliotecas de desarrollo `libgtk-3-dev` (el *embedder* de Flutter Linux está construido sobre GTK3), `liblzma-dev`, **`libsecret-1-dev`** (requerido por `flutter_secure_storage`, ver §3.2) y **`libasound2-dev`** (requerido por `flutter_soloud`, ver §3.2) | `ubuntu-latest`, instalando el toolchain vía `apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libsecret-1-dev libasound2-dev` como paso previo al build |
| **Web** | Ninguno adicional al SDK de Flutter/Dart. Para **pruebas** de integración en Web sí se necesita Chrome/Chromium + ChromeDriver (§3.2) | `ubuntu-latest` (Chrome viene preinstalado en los runners estándar de GitHub Actions) |

### 3.4 Consideraciones de runtime por plataforma

Configuraciones que no son de compilación sino de **comportamiento correcto una vez la app está corriendo**:

- **Web — estrategia de URL de `go_router`**: usar `usePathUrlStrategy()` (de `package:flutter_web_plugins`) para URLs limpias (`/tasks` en vez de `/#/tasks`). Esto exige que el hosting (§12) sirva `index.html` como *fallback* para cualquier ruta (reescritura `/*` → `/index.html`); sin esa regla, recargar la página en una ruta profunda (p. ej. `/squads/123`) devuelve un 404 del servidor de hosting, no de la app.
- **Web — renderer**: usar **CanvasKit** (o su sucesor **Skwasm**, basado en WebAssembly con soporte multihilo, cuando esté disponible como estable) en vez del renderer HTML plano. El renderer HTML delega el layout de texto al motor del propio navegador, lo que puede introducir variaciones sutiles de *kerning*/ancho de carácter entre navegadores. Como `SPEC.md §4` depende de que el ancho de cada carácter en `GeistMono` sea perfectamente predecible para el feedback visual de tecleo, esto se declara como **requisito**, no como optimización opcional.
- **Web — cabeceras COOP/COEP** para que `drift`/OPFS rinda al máximo (§3.2) — deben configurarse en el hosting estático elegido (§12).
- **Android — permisos** declarados en `AndroidManifest.xml`: `INTERNET` (hoy lo requiere el avatar de GitHub del perfil — `ProfileAvatar` carga `github.com/<handle>.png` — y lo requiere Supabase al llegar las funciones online). `ACCESS_NETWORK_STATE` (requerido por `connectivity_plus`, §6) aún no se declara porque el paquete no es dependencia todavía. Ninguno es un permiso "peligroso" que dispare un diálogo de confirmación al usuario; el avatar falla en silencio y cae a la inicial del username si no hay conexión.
- **Android — `minSdkVersion`**: se fija al mínimo que soporten en conjunto la versión de Flutter estable en uso y `sqlite3_flutter_libs` (a revisar puntualmente al integrar; hoy no representa una restricción práctica, ambos cubren versiones muy antiguas de Android).
- **Linux empaquetado como Flatpak — permisos del manifiesto**: acceso de red (`--share=network`) y `--talk-name=org.freedesktop.secrets` para que `flutter_secure_storage` funcione dentro del sandbox (§3.2) — sin este último permiso, el guardado seguro de sesión falla de forma silenciosa dentro de la app empaquetada.
- **Windows — versión mínima soportada** por el *embedder* de Flutter Desktop: Windows 10 (build reciente) o superior; Windows 7/8 no están soportados por Flutter y no se prueban.

---

## 4. Arquitectura de software — Hexagonal (Ports & Adapters)

### 4.1 Capas y reglas de dependencia **[Vigente, se mantiene sin excepción]**

```
presentation  →  application  →  domain  ←  infrastructure
```

- **`domain/`**: entidades (`freezed`), value objects, e **interfaces** de repositorio (`abstract interface class`). Cero dependencias de Flutter, Supabase, `drift` o cualquier paquete de infraestructura. Es Dart puro.
- **`application/`**: casos de uso (una clase por acción de negocio, `XxxUseCase` con un método `call`/`execute`). Orquesta repositorios del dominio; no sabe si el repositorio es local, remoto o híbrido.
- **`infrastructure/`**: implementaciones concretas de los puertos del dominio (`XxxRepositoryImpl`), `DataSource`s (uno por origen de datos: `XxxLocalDataSource` sobre `drift`, `XxxRemoteDataSource` sobre `supabase_flutter`), DTOs y `mapper`s. **Aquí, y solo aquí, se importa Supabase o Drift.**
- **`presentation/`**: providers de Riverpod, pantallas, widgets. Consume casos de uso, nunca repositorios ni data sources directamente.

Esta regla ya se cumple en `features/tasks` y `features/settings` y es de cumplimiento obligatorio para todo feature nuevo (tecleo, duelos, escuadrones, leaderboard, cuentas).

### 4.2 Estructura de carpetas por feature **[Vigente, patrón a replicar]**

```
lib/features/<feature>/
  domain/
    entities/
    value_objects/
    repositories/          # interfaces (puertos)
  application/
    usecases/
  infrastructure/
    <feature>_dto.dart
    <feature>_mapper.dart
    <feature>_local_data_source.dart      # drift
    <feature>_remote_data_source.dart     # supabase_flutter (nuevo)
    <feature>_repository_impl.dart        # implementa el puerto combinando ambas fuentes
  presentation/
    providers/
    screens/
    widgets/
```

### 4.3 Manejo de errores — `Result` / `AppFailure` **[Vigente, se extiende]**

`lib/core/utils/result.dart` y `lib/core/error/app_failure.dart` son compartidos por toda la app. Todo puerto nuevo retorna `Future<Result<T, AppFailure>>` o `Stream<T>` (para *watch*, siguiendo el patrón de `TaskRepository.watchAll()`). Subtipos de `AppFailure` nuevos que se agregan, respetando la jerarquía sellada existente:

- `ConflictFailure` — para el caso, poco común pero posible, de un `username` ya tomado al registrarse.
- `RateLimitFailure` — respuestas de Edge Functions que aplican límites (p. ej. reintentos de matchmaking).
- `OfflineFailure` — una operación que requiere red (`SPEC.md §8.2`) se invoca sin conectividad; la capa de presentación la usa para mostrar el estado "esto requiere conexión" en vez de un error genérico.

### 4.4 Value Objects e identidad **[Vigente, se extiende]**

Siguiendo el patrón de `TaskId`, cada entidad de negocio nueva tiene su propio value object envolviendo un `uuid`: `UserId`, `SnippetId`, `SessionId`, `MatchId`, `SquadId`. Esto evita pasar un `String` crudo entre capas y hace imposible, a nivel de tipos, confundir un `SnippetId` con un `MatchId`.

### 4.5 Mapeo de los módulos de negocio (`SPEC.md`) a features técnicos

| Feature técnico (`lib/features/…`) | Cubre de `SPEC.md` |
|---|---|
| `auth` **(nuevo)** | §7 Cuentas y perfiles (Invitado / Registrada, migración, recuperación) |
| `typing` **(nuevo)** | §3 Contenido, §4 Motor de métricas, §5.1–5.3, 5.7 Modos individuales, §6 Progresión |
| `daily_challenge` **(nuevo)** | §5.4 Reto Diario |
| `duels` **(nuevo)** | §9 Duelos 1 vs 1 |
| `squads` **(nuevo)** | §10 Escuadrones |
| `leaderboard` **(nuevo)** | §11 Leaderboards |
| `achievements` **(nuevo)** | §12 Logros e insignias |
| `settings` **[Vigente]** | Preferencias de la app (tema, idioma) |
| `lock` **[Vigente, se extiende]** | Bloqueo local por PIN + desbloqueo biométrico opcional (Android/iOS/Windows, ver §3.1–3.2) — sin relación directa con `SPEC.md`, se mantiene como feature independiente |
| `sync` **(nuevo, transversal)** | §8 Sincronización — no es una pantalla, es un servicio de aplicación (§6 de este documento) |

---

## 5. Backend — Supabase

### 5.1 Por qué Supabase
Cubre, con una sola pieza de infraestructura administrada y de bajo costo, los cuatro requisitos técnicos que `SPEC.md` exige del "plano online" (§0, §8.2): **identidad** (Auth), **persistencia relacional con reglas de acceso** (Postgres + RLS), **comunicación instantánea** (Realtime) y **lógica de servidor confiable** (Edge Functions) — sin operar un servidor propio, alineado con el principio rector §0.2.

### 5.2 Auth **[Nuevo]**

Requisito de negocio (`SPEC.md §7`): dos identidades, ninguna con correo electrónico.

- **Perfil de Invitado**: **no usa Supabase Auth**. Es un UUID generado en el dispositivo (`uuid` package) más un `username` local. Vive enteramente en `drift`. Nunca toca la red (`SPEC.md §7.1`, §8.1).
- **Cuenta Registrada**: Supabase Auth exige internamente un correo o teléfono como identificador; para no exponer ese requisito al usuario, se usa un **correo sintético interno**, derivado determinísticamente del username (p. ej. `"<username-normalizado>@users.ridge.internal"`), nunca mostrado en la UI y nunca usado para enviar nada:
  - **Registro**: el cliente llama a una Edge Function `register` con `{username, password}`. La función valida formato/unicidad de `username`, crea el usuario en Supabase Auth (Admin API) con el correo sintético, crea la fila en `profiles`, genera un **código de recuperación** de un solo uso (`SPEC.md §7.2`), guarda solo su hash (nunca el valor en claro) en `recovery_codes`, y devuelve el código en claro **una única vez** para que el cliente lo muestre y el usuario lo guarde.
  - **Login**: el cliente deriva el mismo correo sintético a partir del `username` ingresado y llama directamente a `supabase.auth.signInWithPassword` — no necesita ida y vuelta a una función para iniciar sesión, lo que mantiene el login rápido y disponible incluso con conectividad intermitente.
  - **Recuperación**: Edge Function `recoverAccount` con `{username, recoveryCode, newPassword}`; verifica el hash, usa la Admin API para fijar la nueva contraseña, e invalida/reemite un nuevo código de recuperación de un solo uso.
  - **Migración Invitado → Registrada** (`SPEC.md §7.2`): al registrar, el cliente adjunta su historial local (`drift`) a la nueva cuenta subiéndolo por la vía normal de sincronización (§6) inmediatamente después de la creación de la cuenta — no requiere lógica de "fusión" especial en el backend, porque el historial es un conjunto de eventos que simplemente se suben por primera vez.
- **Persistencia de sesión del SDK**: `supabase_flutter` acepta una implementación de almacenamiento local personalizada; se conecta al `flutter_secure_storage` ya existente en `core/security/secure_storage_provider.dart`, en vez de usar el almacenamiento por defecto del SDK, para mantener un único punto de verdad de "qué se guarda de forma segura en este dispositivo" (salvedades de esa librería por plataforma: §3.2).
- La **contraseña de la Cuenta Registrada nunca se transmite ni se guarda en texto plano** fuera del flujo estándar de Supabase Auth (TLS + hashing del lado del servidor de Supabase); el proyecto no reimplementa hashing de contraseñas.

### 5.3 Base de datos (Postgres) — modelo conceptual de tablas **[Nuevo]**

No es el DDL final (eso vive en las migraciones de Supabase, ver §10.2), es el mapeo conceptual de qué tabla resuelve qué necesidad de `SPEC.md`:

| Tabla | Propósito | `SPEC.md` |
|---|---|---|
| `profiles` | Identidad pública de una Cuenta Registrada: `username`, avatar/cosméticos, nivel, XP | §7.2, §7.3 |
| `recovery_codes` | Hash del código de recuperación vigente por perfil | §7.2 |
| `seasons` | Ventanas de temporada competitiva | §9.4 |
| `skill_ratings` | Rating de habilidad vigente por perfil y temporada, liga actual | §6.5, §9.2, §9.4 |
| `snippets` | Catálogo de contenido: lenguaje, dificultad, categoría, foco de símbolo, longitud, **revisión** (inmutable una vez publicada) | §3.1–3.2 |
| `typing_sessions` | Una fila por sesión completada y sincronizada: modo, snippet+revisión, duración, velocidad neta/bruta, precisión, consistencia, y un **`breakdown` JSONB** con el desglose agregado por carácter/dedo/n-grama de esa sesión | §4.2, §4.3 |
| `daily_challenges` | Snippet del día, por fecha | §5.4 |
| `daily_challenge_results` | Resultado de un perfil para el reto de una fecha dada | §5.4, §11.2 |
| `matchmaking_queue` | Cola efímera de jugadores esperando duelo (se borra al emparejar) | §9.1 |
| `matches` | Duelo: jugadores, snippet, ganador, delta de rating aplicado, estado | §9.1–9.3 |
| `squads`, `squad_members` | Escuadrón y su membresía/roles | §10.1–10.2 |
| `squad_challenges`, `squad_challenge_results` | Retos de escuadrón (semanales) y contribución por miembro | §10.3 |
| `leaderboard_snapshots` (vistas materializadas) | Resultados pre-agregados por dimensión (alcance × modo × categoría × ventana), refrescados periódicamente en vez de calculados en cada lectura | §11.1–11.2 |
| `achievements`, `profile_achievements` | Catálogo de logros/insignias y cuáles tiene cada perfil | §12 |

**Decisión de costo clave**: no existe una tabla de "evento por tecla" en Supabase. El detalle carácter-por-carácter (`SPEC.md §4.1`) vive **completo solo en el dispositivo** (`drift`); a la nube solo se sincronizan **agregados por sesión** (JSONB compacto en `typing_sessions.breakdown`). Esto reduce en órdenes de magnitud el volumen de filas/escrituras en Postgres, manteniendo el principio de bajo costo (§0.7) sin sacrificar el diagnóstico personal detallado, que de todas formas es un dato primariamente local (`SPEC.md §15`).

### 5.4 Row Level Security (RLS) **[Nuevo]**

RLS es el único mecanismo de autorización — no hay una capa de autorización adicional en un servidor propio.

Reglas base (ejemplo ilustrativo, no exhaustivo):

```sql
-- Un perfil solo puede leer/escribir su propia fila de perfil.
create policy "profiles_self_rw" on profiles
  for all using (auth.uid() = id) with check (auth.uid() = id);

-- Las sesiones de tecleo son de solo-inserción por el dueño; nunca editables
-- (son eventos inmutables, SPEC.md §8.3) ni borrables por el cliente.
create policy "typing_sessions_insert_own" on typing_sessions
  for insert with check (auth.uid() = profile_id);
create policy "typing_sessions_select_own" on typing_sessions
  for select using (auth.uid() = profile_id);

-- Los snapshots de leaderboard son públicos de solo lectura para cualquier
-- usuario autenticado; solo Edge Functions (con service role) escriben ahí.
create policy "leaderboard_read_all" on leaderboard_snapshots
  for select using (auth.role() = 'authenticated');
```

Regla general: **ninguna tabla permite `update`/`delete` de filas históricas por parte del cliente**; el cliente solo inserta eventos nuevos. Cualquier corrección de agregados sucede recalculando desde el histórico en una Edge Function/función SQL con `service_role`, nunca editando una fila existente desde el cliente — esto materializa técnicamente el principio de `SPEC.md §8.3` y a la vez es la primera línea de defensa de integridad (§14 de `SPEC.md`).

### 5.5 Realtime **[Nuevo]**

Tres mecanismos de Supabase Realtime, cada uno para un caso de uso distinto (elegidos por costo/latencia, no por defecto):

- **Broadcast** (`match:{matchId}`): progreso en vivo de un duelo (posición dentro del snippet). Es efímero por diseño — **no se persiste tick a tick**, solo el resultado final se escribe en `matches`. Esto es lo que mantiene un duelo "instantáneo" (`SPEC.md §9.1`) sin generar escrituras a disco por cada carácter tecleado por el rival.
- **Postgres Changes**: suscripción del cliente a `matches` filtrada por `player_a=eq.<id> or player_b=eq.<id>` para notificación instantánea de "match encontrado" (ver matchmaking en §5.6), y a `squad_members`/`squads` para actualizaciones de membresía en vivo.
- **Presence**: quién está activamente en cola de matchmaking o conectado dentro de un escuadrón — usado solo para señales de UI (p. ej. "3 miembros de tu escuadrón están jugando ahora"), nunca como fuente de verdad de negocio.

### 5.6 Edge Functions **[Nuevo]**

Cómputo de servidor confiable (Deno), invocado por el cliente o por triggers de base de datos — nunca lógica de negocio sensible replicada en el cliente:

| Función | Dispara | Hace |
|---|---|---|
| `register` | Llamada directa del cliente | Crea Auth user + `profiles` + código de recuperación (§5.2) |
| `recoverAccount` | Llamada directa del cliente | Verifica código, resetea contraseña (§5.2) |
| `attemptMatch` | **Database Webhook** en `insert` sobre `matchmaking_queue` | Busca otro jugador en rango de rating; si hay match, borra ambas filas de cola e inserta en `matches` — el cliente se entera vía Realtime (§5.5), **sin polling** (`SPEC.md §9.1`) |
| `widenMatchmakingRange` | Cron (§5.7) | Amplía progresivamente el rango de búsqueda de filas en cola con espera larga (`SPEC.md §9.1`) |
| `settleMatch` | Llamada del cliente al finalizar un duelo, o forzado por timeout | Valida plausibilidad del resultado (§5.9/`SPEC.md §14`), calcula el nuevo rating (ELO) de ambos jugadores, cierra el `match` |
| `refreshLeaderboards` | Cron (§5.7) | Recalcula las vistas materializadas de `leaderboard_snapshots` por dimensión |
| `rotateDailyChallenge` | Cron diario | Publica el snippet del Reto Diario del día (`SPEC.md §5.4`) |
| `rolloverSeason` | Cron por temporada | Aplica el *soft reset* de rating y cierra la temporada (`SPEC.md §9.4`) |
| `settleSquadChallenge` | Cron al cierre de la ventana de un reto de escuadrón | Agrega resultados de miembros, determina ganador/MVP (`SPEC.md §10.3`) |

Principio: **toda función que decide un resultado competitivo (rating, ganador de un reto, leaderboard) corre en una Edge Function con `service_role`, nunca se confía en un valor calculado por el cliente** — coherente con `SPEC.md §14`.

### 5.7 Cron / tareas programadas **[Nuevo]**
Cron nativo de Supabase (`pg_cron` / *scheduled Edge Functions*) para: rotación del Reto Diario, refresco de leaderboards, cierre de temporada, liquidación de retos de escuadrón, y ampliación de rango de matchmaking. No se introduce un *scheduler* externo.

### 5.8 Storage — explícitamente no usado en v1 **[Decisión]**
`SPEC.md` no requiere subida de archivos (no hay avatares personalizados por imagen, ni adjuntos). Supabase Storage queda deliberadamente fuera del stack v1 para no sumar superficie ni costo sin una necesidad de negocio que lo justifique. Si en el futuro se agregan avatares subidos por el usuario, este documento se actualiza.

### 5.9 Estrategia de costo y retención de datos **[Nuevo]**
- Detalle carácter-por-carácter: **local únicamente** (§5.3).
- Nube: solo agregados por sesión + eventos de resultado de competencia — volumen bajo y acotado por usuario activo, no por carácter tecleado.
- Leaderboards: **vistas materializadas refrescadas periódicamente** (§5.6), nunca `count`/`avg` en vivo sobre toda la tabla histórica en cada apertura de pantalla.
- Duelos: progreso en vivo por Broadcast **efímero**, no persistido (§5.5).
- Validación de plausibilidad (`SPEC.md §14`) ocurre sobre los agregados de la sesión (velocidad, precisión), no requiere reproducir el detalle de cada tecla en el servidor.

---

## 6. Sincronización offline/online **[Nuevo]**

Implementa `SPEC.md §8` con un patrón *outbox*:

1. Toda acción que en el futuro deba viajar a Supabase (sesión completada, resultado de duelo, evento de escuadrón) se escribe primero, de forma síncrona y local, en una tabla `drift` de **outbox** (`sync_outbox`: payload, tipo, estado `pending|synced|failed`, intentos).
2. Un `SyncService` (caso de uso de aplicación, expuesto como provider `keepAlive`) escucha:
   - Cambios de conectividad (`connectivity_plus`, con la salvedad de precisión en Web descrita en §3.2).
   - Reanudación de la app en primer plano.
   - Un *fallback* periódico de baja frecuencia (por si el evento de conectividad se pierde).
3. Al disparar, procesa la cola en orden, enviando cada evento pendiente a su repositorio remoto correspondiente; marca `synced` en éxito o incrementa intentos con *backoff* en fallo.
4. Como cada fila de `sync_outbox` es un evento cerrado e inmutable, **no hay resolución de conflictos que programar**: nunca dos dispositivos editan el mismo registro, solo agregan nuevos (`SPEC.md §8.3`). El único estado compartido mutable (rating, nivel) se recalcula siempre del lado de Supabase a partir de eventos, nunca se sobrescribe con un valor traído del cliente.
5. Resultados atados a una ventana de tiempo (Reto Diario, Duelo, reto de Escuadrón) que sincronizan **después** de que su ventana cerró se guardan igual en el histórico personal, pero una Edge Function los excluye de afectar un ranking ya cerrado (`SPEC.md §8.3`, último punto).

El Perfil de Invitado **nunca** tiene un `SyncService` activo: su `sync_outbox` local, si existe, no tiene destino remoto hasta que el usuario migra a Cuenta Registrada (§5.2).

---

## 7. Patrones de diseño transversales

| Patrón | Dónde se usa | Por qué |
|---|---|---|
| **Repository (puerto/adaptador)** | Todo acceso a datos | Ya vigente; aísla dominio de Supabase/drift |
| **Result/Either** | Todo puerto | Errores como valores (§4.3) |
| **Value Object** | Identificadores de dominio | Seguridad de tipos (§4.4) |
| **Use Case (Command)** | `application/usecases` | Una acción de negocio = una clase, testeable de forma aislada |
| **DTO + Mapper explícito** | `infrastructure` | Domain nunca conoce la forma de Postgres/SQLite |
| **Outbox** | Sincronización (§6) | Persistencia local garantizada antes de intentar red |
| **Adapter dual (local + remoto) detrás de un mismo puerto** | `XxxRepositoryImpl` que combina `XxxLocalDataSource` + `XxxRemoteDataSource` | El `application` layer no sabe ni le importa si un dato vino de `drift` o de Supabase |
| **Event-driven sobre polling** | Matchmaking, notificación de resultados (§5.5–5.6) | Menor costo, menor latencia — coherente con el principio rector §0.7 |
| **Vistas materializadas sobre cómputo en caliente** | Leaderboards (§5.3, §5.9) | Costo predecible independientemente de cuánta gente mire el ranking |

---

## 8. Coherencia — reglas no negociables

Checklist que aplica a **todo** feature nuevo, sin excepción, para que el código no diverja del patrón ya establecido:

- [ ] Sigue exactamente la estructura de carpetas de §4.2.
- [ ] `domain/` no importa Flutter, Supabase ni Drift.
- [ ] Todo puerto retorna `Result<T, AppFailure>` o `Stream<T>`.
- [ ] Toda entidad/DTO usa `freezed`/`json_serializable`; ningún modelo mutable a mano.
- [ ] Todo identificador de negocio es un value object, no un `String` suelto.
- [ ] Ningún color, radio, tipografía o curva de animación fuera de `lib/core/theme/`.
- [ ] Texto de UI siempre vía ARB (`lib/l10n`), nunca string literal.
- [ ] Todo provider de estado usa `@riverpod` con codegen; nada de `ChangeNotifier`/`StateNotifier` manual salvo los ya existentes por razones puntuales (p. ej. `_RouterRefreshNotifier`, que no es estado de negocio sino un puente técnico hacia `go_router`).
- [ ] Cualquier tabla nueva en Supabase nace con su política RLS en el mismo cambio — nunca se despliega una tabla sin RLS "para agregarla después".
- [ ] Cualquier resultado competitivo (rating, ranking, ganador) se calcula en Edge Function/SQL con `service_role`, nunca se acepta un valor agregado calculado por el cliente como definitivo.
- [ ] Si un paquete nuevo no soporta igual las cuatro plataformas objetivo, la diferencia se documenta en §3 en el mismo cambio que lo introduce — nunca se descubre en un build de release.
- [ ] Ningún archivo de `lib/` (no generado) supera 500 líneas — verificado automáticamente por `dart run tool/check_architecture.dart` (bloqueante en pre-commit/pre-push/CI, §11).
- [ ] Un archivo declara un único tipo público top-level (una responsabilidad por archivo), salvo jerarquías `sealed` que Dart obliga a mantener en el mismo archivo (p. ej. `Result`/`Ok`/`Err`, `AppFailure` y sus subtipos) — el mismo script las señala como advertencia no bloqueante para revisión manual, nunca las prohíbe.
- [ ] Todo miembro público lleva doc-comment (`///`) — exigido por `public_member_api_docs` en `analysis_options.yaml`; el doc-comment describe el contrato (qué garantiza, no cómo está implementado).
- [ ] `domain/` y `application/` no importan Flutter ni rutas de `infrastructure/`/`presentation/` — verificado automáticamente por `tool/check_architecture.dart`, además de la revisión manual de §4.1.

---

## 9. Seguridad

- **RLS como límite de autorización primario** (§5.4) — no existe una capa de permisos adicional que la reemplace o la duplique.
- **`service_role` key**: solo vive como variable de entorno de las Edge Functions; nunca se empaqueta en el cliente ni se versiona en el repositorio.
- **`anon` key**: es pública por diseño del modelo de Supabase (protegida por RLS), se inyecta por configuración de build (§13), no se hardcodea en el código fuente.
- **Sesión/JWT del cliente**: persistida en `flutter_secure_storage` (§5.2), nunca en `shared_preferences` ni en almacenamiento no cifrado — con la salvedad de garantías por plataforma descrita en §3.2.
- **Sin PII**: ninguna tabla contiene correo real, teléfono o nombre real (`SPEC.md §15`) — el correo sintético de Auth (§5.2) no es información personal, es un artefacto técnico interno del proveedor de identidad.
- **Principio de mínima escritura del cliente**: el cliente inserta eventos, casi nunca actualiza filas existentes; esto reduce drásticamente la superficie de ataque de manipulación de datos históricos.

---

## 10. Versionamiento

### 10.1 Versionado de la app
- `pubspec.yaml` usa SemVer + build number: `MAJOR.MINOR.PATCH+BUILD` (hoy `1.0.0+1`).
  - **MAJOR**: cambios de negocio que alteran datos o expectativas del usuario de forma incompatible (p. ej. cambio en cómo se calcula el rating).
  - **MINOR**: features nuevas (un modo de juego, escuadrones).
  - **PATCH**: correcciones sin cambio de comportamiento visible de negocio.
  - **BUILD**: contador entero monotónico creciente, **compartido entre todas las plataformas** en un mismo release (satisface el requisito de Android de que `versionCode` sea siempre creciente, y evita tener esquemas de numeración de build divergentes entre Windows/Linux/Web/Android).
- El *build number* lo asigna el pipeline de CI (no a mano), a partir del número de tag/release, nunca incrementado manualmente en `pubspec.yaml` en cada commit.

### 10.2 Versionado de esquema (Supabase)
- Migraciones SQL versionadas con **Supabase CLI** (`supabase/migrations/*.sql`, nombradas por timestamp), aplicadas en orden idéntico en local → staging → producción (§13).
- **Solo aditivas por defecto**: agregar tabla/columna, nunca renombrar o eliminar en la misma migración que un release de cliente. Si algo debe eliminarse, primero se deja de usar desde el cliente, se libera al menos un release, y solo entonces se elimina en una migración posterior — así un cliente offline que sincronice tarde (`SPEC.md §8.3`) nunca choca contra un esquema que ya no reconoce.
- Ninguna migración fusionada se edita después: una corrección es siempre una migración nueva.

### 10.3 Versionado de contenido (snippets)
- Cada snippet tiene `id` estable + `revision`. Publicar una corrección crea una nueva `revision`; la anterior queda marcada inactiva pero no se borra (`SPEC.md §3.2`) — necesario porque sesiones históricas y duelos ya jugados referencian una `snippet_id + revision` específica y deben seguir siendo interpretables.

### 10.4 Control de versiones / Git
- Rama principal única (`main`), *trunk-based*, ramas de feature de vida corta.
- **Conventional Commits** (`feat:`, `fix:`, `refactor:`, `chore:`, `test:`) para permitir generación automática de `CHANGELOG.md` y decidir el próximo número de versión (`fix` → PATCH, `feat` → MINOR, `!`/`BREAKING CHANGE` → MAJOR).
- Un tag `vX.Y.Z` en `main` es lo único que dispara un release multiplataforma (§12).
- **Hooks locales versionados** en `tool/git-hooks/` (no en el `.git/hooks/` por defecto, que no se versiona), activados una vez por clon con `bash tool/install_hooks.sh` (fija `core.hooksPath`). `pre-commit` auto-formatea y re-stagea los `.dart` staged, corre `tool/check_architecture.dart` y escanea el diff staged en busca de secretos (llaves privadas, credenciales tipo AWS, `password=`/`token=` con valores largos) — bloquea el commit si encuentra algo, sin bypass. `pre-push` corre `tool/check.sh` completo (el mismo script que ejecuta CI en §12, para que ambos nunca diverjan).

---

## 11. Testing y calidad

- **Formatter**: `dart format`, sin configuración adicional — `tool/format.sh` para reescribir todo el repo, `dart format --set-exit-if-changed .` (dentro de `tool/check.sh`) para verificar sin reescribir.
- **Lint/Analyzer**: `very_good_analysis` + reglas del proyecto (`analysis_options.yaml`, ver §2.1); se evalúa sumar reglas adicionales de seguridad de tipos a medida que se introduzca `drift`/Supabase (p. ej. evitar `dynamic` en el borde de deserialización JSON, ya cubierto por `avoid_dynamic_calls`).
- **Arquitectura**: `dart run tool/check_architecture.dart` — script sin dependencias (`dart:io` puro) que aplica lo que el analyzer no puede expresar de forma nativa: límite de 500 líneas por archivo y dirección de dependencias `domain`/`application` (§4.1, §8) como reglas bloqueantes, y un tipo público por archivo como advertencia no bloqueante (§8).
- **Unitarias (`test/`)**: dominio y casos de uso, sin I/O real — patrón ya existente (`create_task_usecase_test.dart`). Requisito **no negociable** para el motor de métricas (§2.8): cálculos de velocidad, precisión, n-gramas y consistencia deben tener cobertura unitaria exhaustiva con relojes inyectados de forma determinística, porque son el corazón del producto (`SPEC.md §4`).
- **Widget tests**: pantallas y widgets de `presentation/`, siguiendo el `widget_test.dart` ya existente.
- **Integración (`integration_test`, nuevo)**: flujos completos críticos — sesión de tecleo de principio a fin, sincronización tras reconexión, flujo de duelo simulando dos clientes contra un Supabase local. Un job de CI por plataforma, dado que Web se ejecuta con un mecanismo distinto al nativo (§3.2, §3.3).
- **Contra Supabase real, no mocks**: las pruebas de integración de repositorios remotos corren contra el **stack local de Supabase CLI** (Postgres + Auth + Realtime reales vía Docker) en CI, no contra dobles/mocks del cliente — evita que una prueba "verde" contra un mock oculte una política RLS mal escrita o una migración rota.
- **Golden tests** para el sistema de diseño (§2.5): al menos los componentes que muestran el snippet/feedback de tecleo, para detectar regresiones visuales en la fuente monoespaciada y el layout de progreso.

---

## 12. Despliegue (CI/CD por plataforma)

**Pipeline**: GitHub Actions (`.github/workflows/ci.yml`).
- Job `quality-gate` (en cada PR y push a `main`): `bash tool/check.sh` (formato, `flutter analyze --fatal-infos --fatal-warnings`, `tool/check_architecture.dart`, `flutter test` — mismo script que corre `pre-push` en local, §10.4) más una verificación de que el código generado (`*.g.dart`/`*.freezed.dart`) sigue actualizado tras `build_runner`. Pendiente de sumar a este job: pruebas de integración contra Supabase CLI local (§11) una vez exista ese backend.
- Jobs de build por plataforma, gatillados solo por tag `v*.*.*` (§10.4), cada uno con el toolchain de §3.3 ya resuelto por el runner correspondiente. **Implementado** en `.github/workflows/release-builds.yml` (dormido hasta el primer tag): cada job compila con ofuscación Dart (`--obfuscate --split-debug-info`, salvo Web, que no soporta esa flag — dart2js ya minifica/renombra en release) y sube el artefacto empaquetado como *artifact* de Actions; ninguno publica todavía a una tienda/hosting real (columna "Distribución" de la tabla de abajo — pendiente de credenciales reales, ver Memory.md):

| Plataforma | Build | Empaquetado | Distribución | Auto-actualización |
|---|---|---|---|---|
| Android | `flutter build appbundle` | Android App Bundle | Google Play Console (Play App Signing) | Gestionada por Play Store |
| Windows | `flutter build windows` | MSIX (paquete `msix`) | Microsoft Store (preferido) o instalador firmado de descarga directa | Microsoft Store, o mecanismo propio si es descarga directa |
| Linux | `flutter build linux` | Flatpak (manifiesto con `--share=network` y `--talk-name=org.freedesktop.secrets`, ver §3.4) | Flathub | Gestionada por Flatpak |
| Web | `flutter build web` | Estático (HTML/JS/Wasm, renderer CanvasKit/Skwasm — §3.4) | Hosting estático de bajo costo con CDN (p. ej. Cloudflare Pages), con reglas de SPA fallback y cabeceras COOP/COEP (§3.4) | Instantánea (siguiente carga de página); se sirve con cabeceras de caché apropiadas y manifest PWA para instalación |

- Credenciales de firma/publicación (cuenta de servicio de Play Console, certificado de firma de Windows, token de despliegue del hosting web) viven como *secrets* de GitHub Actions — nunca en el repositorio.
- Los releases de escritorio/móvil se acompañan de notas de versión derivadas del `CHANGELOG.md` generado por Conventional Commits (§10.4).
- El backend (migraciones + Edge Functions de Supabase) se despliega en su **propio job**, disparado también por el mismo tag, vía Supabase CLI (`supabase db push`, `supabase functions deploy`) — el backend y el cliente versionan juntos, pero el esquema es aditivo (§10.2) para que clientes de una versión anterior sigan funcionando durante el *rollout* escalonado de cada tienda.

---

## 13. Entornos y configuración

Tres entornos, cada uno con su propio proyecto de Supabase (o el stack local vía Docker):

| Entorno | Supabase | Uso |
|---|---|---|
| `dev` | Stack local (Supabase CLI + Docker) | Desarrollo diario y pruebas de integración en CI |
| `staging` | Proyecto Supabase real, separado | QA pre-release, datos sintéticos, pruebas de migraciones antes de aplicarlas a producción |
| `prod` | Proyecto Supabase real | Usuarios reales |

- La URL y la `anon key` de cada entorno se inyectan en tiempo de build vía `--dart-define-from-file=env/<entorno>.json` (archivos **no versionados**, listados en `.gitignore`), leídos en el cliente mediante `String.fromEnvironment` desde un único punto (`lib/core/config/`).
- Nunca se hardcodea una URL/llave de Supabase en el código fuente ni en un archivo versionado.

---

## 14. Fuera de alcance técnico / roadmap

Coherente con `SPEC.md §18`, y agregando exclusiones puramente técnicas:

- Servidor propio fuera de Supabase (VM, contenedor a medida) — mientras Supabase cubra la necesidad, no se introduce infraestructura adicional.
- Notificaciones push nativas en v1 (p. ej. avisar "match encontrado" con la app en segundo plano) — candidato natural para v2 una vez validado el uso de Duelos. Esto es independiente de que una lección ya sea *direccionable* por URL (§2.3): cuando llegue la notificación push de v2, su payload solo necesita llevar esa misma ruta — no hace falta trabajo de enrutamiento adicional entonces.
- Multi-región en Supabase — una sola región es suficiente para el alcance y costo de v1.
- iOS/macOS (§1) — la arquitectura no lo impide, simplemente no está priorizado; de agregarse, requeriría extender la matriz de §3 con sus propias salvedades (p. ej. Keychain de iOS/macOS para `flutter_secure_storage`, sin las salvedades de Linux).
- Cualquier almacenamiento de archivos binarios (Supabase Storage) — sin necesidad de negocio que lo justifique hoy (§5.8).
