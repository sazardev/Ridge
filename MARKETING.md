# MARKETING.md — Ridge

### Posicionamiento, voz de marca e identidad visual

## Índice

0. [Qué es y qué no es este documento](#0-qué-es-y-qué-no-es-este-documento)
1. [Motivación y posicionamiento](#1-motivación-y-posicionamiento)
2. [Público objetivo (la doble comunidad)](#2-público-objetivo-la-doble-comunidad)
3. [Eslogan y mensajes clave](#3-eslogan-y-mensajes-clave)
4. [Voz y tono](#4-voz-y-tono)
5. [Identidad visual y design system](#5-identidad-visual-y-design-system)
   - [5.1 Tipografía](#51-tipografía) · [5.2 Plataformas](#52-plataformas) ·
     [5.3 Color y paletas](#53-color-y-paletas) · [5.4 Forma](#54-forma) ·
     [5.5 Iconografía](#55-iconografía) ·
     [5.6 Layout y navegación](#56-layout-y-navegación) ·
     [5.7 Componentes](#57-componentes) · [5.8 Movimiento](#58-movimiento)
6. [El mark (logo)](#6-el-mark-logo)
7. [Superficies de marketing ya implementadas](#7-superficies-de-marketing-ya-implementadas)
8. [Pendiente / fuera de alcance](#8-pendiente--fuera-de-alcance)

---

## 0. Qué es y qué no es este documento

Este documento estandariza cómo Ridge se presenta hacia afuera: eslogan,
tono de voz, y qué partes del design system (definido en detalle en
`STACK.md` §2.5) son parte de la identidad de marca y no deben variar
libremente entre features. **No** redefine el producto (eso es `SPEC.md`)
ni la arquitectura técnica (`STACK.md`). Cualquier copy nuevo orientado a
usuario (onboarding, splash, tienda de apps, redes) debería poder
justificarse desde este documento igual que una decisión de código se
justifica desde `SPEC.md`/`STACK.md`.

---

## 1. Motivación y posicionamiento

Ridge no es "otra app de mecanografía" ni "otra app para programadores" —
la apuesta es unir dos comunidades que casi nunca se dirigen al mismo
producto:

- **Programadores** que quieren practicar deliberadamente (velocidad,
  precisión, símbolos que realmente escriben — `:=`, `{`, `&`, snake_case)
  con el mismo rigor con el que entrenan cualquier otra habilidad técnica.
- **Aficionados al teclado** (la cultura de MonkeyType/TypeRacer, teclados
  mecánicos, switches, keycaps, PPM como deporte) para quienes tipear es
  un *craft* en sí mismo, con o sin relación directa a programar
  profesionalmente.

La mayoría de apps de mecanografía le hablan a la segunda comunidad con
texto genérico (citas, literatura, lorem ipsum) que a un programador le
resulta irrelevante; la mayoría de herramientas "para programadores"
ignoran por completo la cultura de teclado. Ridge ya tiene, implementado,
el puente entre ambas — no es solo un ángulo de copy:

- El **catálogo es código real** (Go/Bash/SQL), no prosa — le habla al
  programador (SPEC.md §3, principio rector #1).
- El **perfil** tiene campos dedicados a `Keyboard layout`/`brand`/`model`
  con vista previa de la forma del teclado
  (`lib/features/profile/presentation/widgets/keyboard_shape_preview.dart`)
  — le habla directo al aficionado al teclado, sin que tenga que ser
  programador para disfrutarlo.
- Los **sound packs** de tecleo (`Mechanical`, `Soft`, `Typewriter`,
  `Arcade`, `Pop`, en Ajustes) son un guiño explícito a la cultura de
  switches/sonido de teclado mecánico.
- El **mark** (§6) es literalmente una tecla (keycap) con una letra en la
  tipografía monoespaciada del producto — las dos comunidades en un mismo
  símbolo.

Cualquier decisión de marketing futura debería reforzar este puente, no
elegir un solo lado.

---

## 2. Público objetivo (la doble comunidad)

Complementa (no reemplaza) el público objetivo de `SPEC.md` §2 — ese
documento define el público *primario* del producto (programadores, foco
en Go); esta sección agrega el ángulo de *comunidad* para efectos de
mensaje/canal:

| Comunidad | Qué valora | Mensaje que le resuena |
|---|---|---|
| Programadores (junior→senior) | Sintaxis real, métricas por carácter/dedo, progresión medible | "Escribe mejor, no solo más rápido" — la calidad del tecleo, no solo el WPM bruto |
| Aficionados al teclado / typing enthusiasts | PPM, precisión, feel, sonido, competir | Contenido que no sea genérico + soporte real a su hobby (perfil de teclado, sound packs) |
| Intersección (la más valiosa) | Ambas cosas a la vez | "Por fin una app de mecanografía que entiende mi teclado *y* mi código" |

Canales naturales por comunidad (no implementado hoy, ver §8): comunidades
de Go/programación para la primera, comunidades de mechanical keyboards
y typing (r/MechanicalKeyboards, Discords de teclado, comunidad
MonkeyType) para la segunda.

---

## 3. Eslogan y mensajes clave

**Eslogan oficial** (`l10n.splashSlogan`, `lib/l10n/app_en.arb` /
`app_es.arb`):

> **"Type better, not just faster."**
> **"Escribe mejor, no solo más rápido."**

Por qué este y no otro: no vende velocidad bruta (PPM) como el objetivo
final — vende *calidad* de tecleo, que es exactamente el principio rector
#2 de `SPEC.md` ("la métrica es el producto": precisión, por dedo, por
carácter — el WPM final es "solo la punta del iceberg"). El eslogan y el
producto dicen lo mismo. Elegido tras iterar sobre varias alternativas más
genéricas ("Real code. Real speed.", "Aprende haciendo") tanto en tono
como en fondo — ver `Memory.md`, sesión "para el tema del marketing".

**Mensajes de apoyo** (ya viven como copy real en el onboarding,
`onboardingWelcomeTitle` etc. en los `.arb` — reusar este tono para
cualquier copy nuevo, no inventar uno nuevo):

- "Real code, not filler" — el contenido nunca es genérico.
- "Know exactly what slows you down" — el desglose de métricas es el
  valor, no la cifra final.
- "Progress at your own pace" — currícula guiada, sin presión.
- "No friction, ever" — solo un username, cero fricción de cuenta.
- "Make it yours" — personalización (paleta, forma, sonido) real, no
  cosmética superficial.

---

## 4. Voz y tono

- **Directo y corto.** Frases de 3-8 palabras en título/eslogan; nada de
  signos de exclamación ni superlativos vacíos ("¡La mejor app de
  mecanografía del mundo!"). El tono es el de una dev-tool (Vercel/shadcn,
  de donde viene Geist), no el de una app de consumo masivo.
- **Beneficio, no feature.** "Sabes exactamente qué te frena" en vez de
  "reporte de métricas por dedo y carácter" — el copy de cara al usuario
  vende el resultado, la UI ya explica el mecanismo.
- **Sin relleno, ni en el copy.** El principio "contenido real, no
  relleno" (SPEC.md #1) aplica también al texto de marketing: cero lorem
  ipsum, cero frases de agencia genéricas.
- **Restraint en todo, incluida la animación.** La única animación
  "ruidosa" de todo el producto es el shake de PIN incorrecto
  (`CLAUDE.md`) — el resto (incluido el splash, `AppMotion`) es fade/slide
  contenido. El tono visual no compite con el tono de copy: los dos son
  discretos.

---

## 5. Identidad visual y design system

Fuente completa y autoritativa: `STACK.md` §2.5 (regla general: **prohibido
hardcodear** color/radio/duración/curva fuera de `lib/core/theme/` — todo
widget nuevo consume estos tokens) y el propio código en
`lib/core/theme/`. Esta sección lo resume para efectos de marca/marketing,
con los valores concretos a mano.

### 5.1 Tipografía

- **Geist** (UI general) y **Geist Mono** (SIL OFL, autohospedadas en
  `assets/fonts/`, nunca Google Fonts en runtime).
- **Geist Mono es la tipografía de *todo* el type scale de la app**, no
  solo del código (`buildAppTextTheme`, `app_typography.dart`) — decisión
  deliberada: consistencia de ancho de carácter es funcional (el
  snippet a teclear, el cursor, los reportes de velocidad, `STACK.md`
  §2.5 lo marca como **obligatorio** para esas vistas), y estéticamente
  es la identidad "dev-tool" del producto. Cualquier material externo
  (splash, capturas, redes) debe usar Geist/Geist Mono, nunca una fuente
  del sistema por defecto.
- Pesos disponibles (ambas familias): Thin(100)…UltraBlack(900). Escala
  de peso ya asignada por `buildAppTextTheme`: `display*`/`headline*`
  en 600–700, `title*` en 500–600, `labelLarge` en 600 con
  `letterSpacing 0.2` (botones), cuerpo de texto sin negrita.

### 5.2 Plataformas

De `STACK.md` §1 — regla de paridad: toda plataforma soportada implementa
el 100% de los módulos de negocio, sin "modo lite".

| Plataforma | Estado | Notas |
|---|---|---|
| **Android** | Vigente | Teclado físico/Bluetooth preferido; táctil soportado pero registrado aparte ("Modo táctil", SPEC.md §13.2). |
| **Linux (desktop)** | Vigente | Plataforma principal de desarrollo del equipo. |
| **Windows (desktop)** | Planeado, no scaffoldeado | `flutter create --platforms=windows .` pendiente. |
| **Web** | Planeado, no scaffoldeado | Precisión de timestamps limitada por el navegador (mitigación de timing attacks) — limitación conocida, no un bug. |
| iOS / macOS | Fuera de alcance v1 | No solicitado en `SPEC.md`; no bloqueado técnicamente, no priorizado. |

### 5.3 Color y paletas

- Semilla de marca: **Ember** `#FF5A36` (`AppColors.seed`) — el default
  de fábrica y el color a usar en cualquier material externo (tienda de
  apps, redes, este documento) salvo que se diga lo contrario.
  Material 3 `ColorScheme.fromSeed`, variante *expressive* (más vívida)
  con opción de apagarla a una más conservadora (ajuste "Color
  expresivo").
- **25 paletas** seleccionables en vivo por el usuario
  (`app_palette_catalog.dart`, Ajustes > Paleta de color) — Ember, Ocean,
  Forest, Grape, Rose, Sunflower, Teal, Crimson, Mono, Nord, Gruvbox,
  Dracula, Solarized, Catppuccin, Tokyo Night, Terminal, Matrix, Fallout,
  Black & White, Monokai, One Dark, Cyberpunk, Synthwave, GitHub, VS
  Code. Varias son guiños directos a temas de editor/terminal conocidos
  — otro punto de contacto con la comunidad dev además de la de teclado.
- Cualquier asset de marca (el mark, el splash) debe tintarse
  externamente (`ColorFilter`/`currentColor`), **nunca** un color fijo
  quemado en el asset — así se ve bien sin importar qué paleta tenga
  activa el usuario (ver §6).

### 5.4 Forma

- **Squircle real** (`RoundedSuperellipseBorder`, no `RoundedRectangleBorder`)
  en absolutamente todo — `AppShapes`/`app_shapes.dart`.
- Escala de 8 radios con nombre (`extraSmall` 4 → `full` 999/pill),
  reescalada completa por 4 **estilos de esquina** seleccionables por el
  usuario (Ajustes > Estilo de bordes), que también cambian el marco de
  ventana en desktop en vivo:

  | Estilo | extraSmall→full (px) |
  |---|---|
  | Sharp | 0 en todos — ángulos rectos reales |
  | **Soft (default)** | 4 / 8 / 12 / 16 / 20 / 28 / 32 / 999 |
  | Round | 8 / 14 / 20 / 26 / 30 / 36 / 40 / 999 |
  | Pill | 999 en todos |

- Cero sombras, cero gradientes, `elevation: 0` en todo — la
  profundidad viene solo de roles tonales de superficie
  (`surfaceContainer*`). Esta regla es la razón concreta por la que el
  mark **no** puede llevar un bisel/"dish" falso-3D (§6): sería la única
  superficie con esa ilusión de profundidad en toda la app.

### 5.5 Iconografía

- **Lucide** (`lucide_icons_flutter`), trazo geométrico — elegido por
  combinar con Geist (misma familia visual que Vercel/shadcn/dev tools
  modernas). **Nunca** Material `Icons.*` (`cupertino_icons` tampoco se
  usa).
- Convención de grosor de trazo por sufijo numérico del mismo ícono:
  **`300`** = trazo por defecto/no-seleccionado (p. ej. `keyboard300` en
  la barra de navegación, o los íconos de la barra de ventana); **`600`**
  = trazo grueso, reservado para el estado seleccionado/con énfasis
  (`keyboard600` cuando esa pestaña está activa). Ver `app_shell.dart`.

### 5.6 Layout y navegación

- **Shell adaptativo** (`AppShell`, `lib/core/router/app_shell.dart`):
  ancho ≥ 640px → `NavigationRail` lateral con labels siempre visibles;
  < 640px → `NavigationBar` inferior; por debajo de 360px (equivalente a
  `sw360dp` de Android, "compacto") el `NavigationBar` oculta las
  etiquetas y queda solo-ícono. Mismo breakpoint y mismos 5 destinos en
  ambos layouts — nunca contenido distinto por tamaño de pantalla, solo
  disposición distinta.
- **5 destinos fijos, en este orden** (coincide 1:1 con el orden de
  branches del router — nunca reordenar uno sin el otro): Práctica
  (rutas guiadas, entrada por defecto), Progreso, Libre (Zen/Sprint/
  Precisión + catálogo), Perfil, Ajustes.
- **Barra de ventana propia** (`WindowBar`, 34px, solo desktop): sin
  decoración nativa del SO (`TitleBarStyle.hidden`), arrastre/maximizar/
  cerrar implementados a mano, coloreada con el tema activo — nunca la
  barra de título gris por defecto del sistema operativo.
- **Marco de ventana** (`AppWindowFrame`, solo desktop): reemplaza los
  bordes de resize nativos con un borde propio cuyo radio sigue el
  estilo de esquina activo (§5.4) y cuyo grosor es configurable.

### 5.7 Componentes

| Componente | Tratamiento |
|---|---|
| Botones (Filled/Outlined/Text/Elevated) | Forma "full" (pill) por defecto — cuadrados solo bajo el estilo "Sharp" (§5.4). Padding 24h/16v, texto `labelLarge` (w600, +0.2 tracking), cero elevación siempre. |
| Cards | Planas, `surfaceContainerLow`, radio "large" (16 default), sin margen propio. |
| Chips | `surfaceContainerHigh` (o `secondaryContainer` seleccionado), radio "small" (8 default), sin borde. |
| Inputs de texto | Siempre rellenos (`filled: true`), **nunca con borde** — el estado (foco/error/disabled) se comunica solo tiñendo el color de relleno. Radio "medium" (12 default). |
| Diálogos / date-time pickers | `surfaceContainerHigh`, radio "extraLarge" (28 default). |
| Bottom sheets | `surfaceContainerHigh`, solo esquinas superiores redondeadas a "extraLarge". |
| Snackbar | `inverseSurface` (contraste invertido a propósito), flotante, radio "medium". |
| Switches | Sin contorno de pista — el estado se lee del color de relleno, no de un borde. |
| Transiciones de página | Android: *predictive back* nativo. Linux: fundido M3 ("fade forwards"). |

### 5.8 Movimiento

Tokens `AppMotion` — nunca una `Duration`/`Curve` literal fuera de este
archivo:

- **Espacial** (posición/tamaño/forma): rápido 260ms, default 380ms,
  lento 520ms — curva `easeInOutCubicEmphasized`.
- **Efectos** (opacidad/color): rápido 120ms, default 200ms, lento
  300ms — curva `easeOut`.
- `enter`/`exit`: `easeOutCubic`/`easeInCubic`.
- `emphasizedBounce` (un rebote real): **reservado exclusivamente** para
  el shake de PIN incorrecto — es la única animación "ruidosa" de todo
  el producto a propósito (§4). No reusar este curve en nada nuevo sin
  repensar si de verdad amerita romper esa regla.

---

## 6. El mark (logo)

Archivo: `assets/icons/r_mark.svg`. Usado hoy en `WindowBar` (16px) y
`AppStartupSplash` (72px, `lib/core/splash/`), siempre vía
`ColorFilter.mode(color, BlendMode.srcIn)` — es decir, el SVG en sí es
monocromo (`fill="currentColor"`) y el color final lo decide quien lo
consume (normalmente `colorScheme.primary`, así que sigue la paleta
activa del usuario, nunca un color de marca fijo).

**Qué es**: un keycap 2D plano — un solo cuadrado redondeado sólido
(radio 60, sin segunda forma tipo "dish"/bisel) — con una **R** recortada
como espacio negativo (no pintada encima). La R es el contorno real del
glifo de **Geist Mono Bold** (`assets/fonts/GeistMono/GeistMono-Bold.ttf`),
extraído con `fontTools`, no dibujado a mano ni puesto como `<text>` SVG
(`flutter_svg` no lo renderiza de forma confiable).

**Reglas** (aprendidas iterando con el usuario en la misma sesión, ver
`Memory.md`):

- ✅ Plano, un solo relleno, un solo color vía tinte externo.
- ✅ Keycap reconocible (esquinas redondeadas, proporción de tecla) —
  esto es intencional, es el nexo visual con la comunidad de teclado (§1).
- ❌ **Nunca** un bisel/"dish" (segunda forma anidada que sugiera
  profundidad) — se probó primero y se descartó explícitamente por leer
  como skeuomorfismo falso-3D, inconsistente con el resto de la UI
  (100% plana, §5).
- ❌ Nunca depender de que la fuente esté instalada en el dispositivo que
  renderiza (por eso el trazo va embebido como path, no como texto vivo).

**Verificación mínima antes de aceptar cualquier cambio futuro al mark**:
debe seguir siendo legible a 16px real (tamaño de `WindowBar`) — se
verificó rasterizando con `rsvg-convert` a 16/32/72px con el color de
marca real antes de aceptar cada iteración.

**Exports PNG a mano** (`marketing/logo/r-mark-{size}.png`, fondo
transparente, color Ember `#FF5A36` quemado — el SVG fuente sigue siendo
`assets/icons/r_mark.svg` con `currentColor`, estos PNG son solo para uso
externo donde no se puede tintar en vivo: capturas, tienda de apps,
redes). Tamaños generados: 16, 32, 48, 64, 128, 192, 256, 512, 1024px.
**No** están listados en `pubspec.yaml` — no se empaquetan en la app,
son material de referencia, no un asset de runtime. Regenerar tras
cualquier cambio al mark:

```sh
sed 's/currentColor/#FF5A36/' assets/icons/r_mark.svg > /tmp/r_mark_ember.svg
for size in 16 32 48 64 128 192 256 512 1024; do
  rsvg-convert -w "$size" -h "$size" /tmp/r_mark_ember.svg \
    -o "marketing/logo/r-mark-${size}.png"
done
rm /tmp/r_mark_ember.svg
```

---

## 7. Superficies de marketing ya implementadas

- **Splash de arranque** (`lib/core/splash/app_startup_splash.dart`):
  mark + wordmark ("Ridge") + eslogan, ~1.4s al arrancar en frío, se
  funde hacia la app real. Es hoy la única superficie que muestra el
  eslogan.
- **Onboarding** (`lib/features/onboarding/`): los mensajes de apoyo de
  §3, ya en el tono correcto — no requieren cambio, son la referencia de
  voz para copy nuevo.
- **Ícono de launcher Android** (`assets/icons/ridge_launcher_master.png`):
  mark **distinto** al de §6 (una marca de "dos picos" aludiendo al
  nombre "Ridge" en el naranja ember) — no se generó a partir de
  `r_mark.svg` y no se tocó en esta ronda de iteración del mark; evaluar
  en el futuro si conviene unificar ambos marks en uno solo.

---

## 8. Pendiente / fuera de alcance

No implementado ni decidido todavía — anotado para no perderlo, no para
implicar compromiso de fecha:

- Unificar el ícono de launcher (§7) con el mark nuevo de §6.
- Materiales para tiendas de apps (capturas, descripción larga/corta,
  copy de ASO) — el eslogan de §3 es el punto de partida obvio.
- Presencia en comunidades específicas (§2): ninguna cuenta/canal
  creado todavía.
- Landing page / sitio — no existe hoy, la app es offline-only y sin
  presencia web (`STACK.md` — Windows/Web ni siquiera están scaffoldeados
  aún).
