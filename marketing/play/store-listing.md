# Ridge — Ficha de Google Play

Material de partida para la ficha de Play Store. Todo el copy sigue
`MARKETING.md` §3–§4 (frases cortas, sin superlativos, sin signos de
exclamación, beneficio antes que feature). No editar un texto aquí sin
comprobarlo contra ese documento.

## Metadatos

| Campo | Valor |
|---|---|
| Título (máx 30) | `Ridge: Code Typing Practice` |
| Idioma predeterminado | `en-US` (traducción `es-ES` añadida) |
| Categoría | `Education` |
| Tipo | Aplicación · Gratis |
| Anuncios | No |
| Compras integradas | No (por ahora) |
| Email de contacto | `omar.desarrollo@gmtransporterp.com` |
| Política de privacidad | `https://sazardev.github.io/Ridge/privacy/` |
| Sitio web | `https://sazardev.github.io/Ridge/` |

## Descripción corta (máx 80)

- **EN (77/80):** `Typing practice with real code. Track accuracy, speed, and every key you miss.`
- **ES (74/80):** `Practica mecanografía con código real. Mide precisión, velocidad y errores.`

## Descripción completa

### EN

```text
Ridge is a typing practice game for programmers and keyboard enthusiasts.

REAL CODE, NOT FILLER
Practice with actual snippets from Go, Python, JavaScript, TypeScript, Rust, SQL, Bash, Kotlin, Swift, C, C++, Java, C#, Dart, PHP, CSS, Git, Docker, Linux, GitHub Actions, Haskell, Crystal, and Zig. The symbols you really type every day: :=, {, &, =>, snake_case.

KNOW EXACTLY WHAT SLOWS YOU DOWN
Accuracy, speed, and per-key breakdowns show which characters and fingers trip you up. The final WPM is just the tip of the iceberg; the quality of your typing is the goal.

WAYS TO PRACTICE
- Learning paths: guided lessons that grow from first steps to complete projects.
- Free practice: Zen (no pressure), Sprint (against the clock), Precision (accuracy first), Survival (one mistake costs a life), and a Daily Challenge shared by everyone.
- A catalog of real code to explore by language and category.

MADE FOR KEYBOARD PEOPLE
- A full 3D view of your keyboard.
- Customize keycap shapes and colors, case color, and eleven RGB effects, with per-key lights.
- Add extra keys, legends, and functional remaps.
- Keystroke sound packs: mechanical, soft, typewriter, arcade, pop.
- Physical and Bluetooth keyboards welcome. Touch input is supported too.

WORKS OFFLINE
No account, no ads, no tracking. Your progress stays on your device. Available in English and Spanish.

Type better, not just faster.
```

### ES

```text
Ridge es un juego de práctica de mecanografía para programadores y aficionados al teclado.

CÓDIGO REAL, NO RELLENO
Practica con fragmentos reales de Go, Python, JavaScript, TypeScript, Rust, SQL, Bash, Kotlin, Swift, C, C++, Java, C#, Dart, PHP, CSS, Git, Docker, Linux, GitHub Actions, Haskell, Crystal y Zig. Los símbolos que escribes a diario: :=, {, &, =>, snake_case.

SABES EXACTAMENTE QUÉ TE FRENA
Precisión, velocidad y desglose por tecla: descubre qué caracteres y qué dedos te cuestan. El PPM final es solo la punta del iceberg; la calidad de tu tecleo es el objetivo.

FORMAS DE PRACTICAR
- Rutas guiadas: lecciones que avanzan desde lo básico hasta proyectos completos.
- Práctica libre: Zen (sin presión), Sprint (contra el reloj), Precisión (exactitud ante todo), Survival (un error cuesta una vida) y un Reto Diario compartido por todos.
- Catálogo de código real para explorar por lenguaje y categoría.

HECHA PARA GENTE DEL TECLADO
- Vista 3D completa de tu teclado.
- Personaliza formas y colores de keycaps, color de carcasa y once efectos RGB, con luz por tecla.
- Añade teclas extra, leyendas y remapeos funcionales.
- Packs de sonido: mecánico, suave, máquina de escribir, arcade, pop.
- Teclados físicos y Bluetooth bienvenidos. Entrada táctil también soportada.

FUNCIONA SIN CONEXIÓN
Sin cuenta, sin anuncios, sin rastreo. Tu progreso se queda en tu dispositivo. Disponible en inglés y español.

Escribe mejor, no solo más rápido.
```

## Notas de la versión (release notes, máx 500)

- **EN:** `First public release. 20+ real-code languages, guided learning paths, five practice modes, a 3D customizable keyboard, keystroke sound packs, and English/Spanish UI.`
- **ES:** `Primera versión pública. Más de 20 lenguajes con código real, rutas guiadas, cinco modos de práctica, teclado 3D personalizable, packs de sonido e interfaz en inglés y español.`

## Gráficos (en `marketing/play/`)

| Asset | Requisito Play | Archivo |
|---|---|---|
| Ícono de la app | 512×512 PNG 32-bit, ≤1 MB | `icon-512.png` (fuente: `icon-master-1024.png`) |
| Gráfico destacado | 1024×500 PNG/JPEG | `feature-graphic-1024x500.png` |
| Capturas de teléfono | 2–8, 320–3840 px, max 2:1 | `screenshots/phone-*.png` (generadas del emulador) |
| Capturas de teléfono (sin borde del emulador) | ídem | `screenshots/clean/phone-*.png` (1080×2160) |
| Gráfico de promoción in-app | 1024×500 PNG/JPEG | `../assets/play/promo-graphic-{en,es}.png` |

Las capturas con el borde verde del emulador se sustituyen por las de
`screenshots/clean/`; ambas se regeneran con
`bash tool/generate_marketing_assets.sh`.

> **Pendiente (2026-10-03):** en la ficha *Default – English (United
> States)* de la consola hay un **borrador guardado sin las 8 capturas de
> teléfono** (se borraron pero la subida falló: el navegador del agente
> cierra la pestaña al abrir el diálogo de archivos). La ficha publicada
> sigue intacta. **No enviar ese borrador**: descartarlo o subir las 8 de
> `screenshots/clean/` más el gráfico destacado nuevo
> `../assets/play/promo-graphic-en.png`.

## Promoción in-app (gratis, sin Google Ads)

Play permite dos promociones gratuitas por app: un **anuncio dentro de la
app** (in-app promo) y un **mensaje en la ficha** (store listing promo). No
requieren cuenta publicitaria ni presupuesto, solo el gráfico 1024×500.

| Campo | EN | ES |
|---|---|---|
| Tipo | In-app promo (gratuita) | In-app promo (gratuita) |
| Gráfico | `../assets/play/promo-graphic-en.png` | `../assets/play/promo-graphic-es.png` |
| Mensaje (≤80) | `Type real code. Twenty-plus languages, free.` | `Escribe código real. Más de veinte lenguajes, gratis.` |
| Bots | EN (Global, excepto swimsuit) | ES (Global, excepto swimsuit) |
| Condiciones | Solo Android; Play decide la audiencia y el periodo | ídem |

El **video promocional** (21,6 s, `../video/promo-horizontal-{en,es}.mp4`)
requiere una URL de YouTube (pública o no listada): Play no aloja vídeo. Subir
el MP4 a YouTube, marcarlo como público y pegar el enlace en el campo de
vídeo; el texto de la promoción puede ser el mismo que el del gráfico.

## Formularios de Play Console (respuestas)

- **Data safety:** la app no recopila ni comparte datos. Todo es local. La
  única red es la descarga del avatar público de GitHub (elección del
  usuario).
- **Content rating:** cuestionario OARS; sin contenido sensible → apta para
  todos.
- **Target audience:** 13+ (no dirigida a menores).
- **App access:** totalmente accesible sin cuenta (sin credenciales
  especiales).
- **Ads:** no contiene anuncios.
- **Government apps / financial / health / news:** no.

## Registro de la clave de firma

- Keystore: `~/keystores/ridge-release.jks` (alias `ridge`).
- Credenciales: `~/.config/ridge/signing-credentials.txt` (chmod 600).
- `android/key.properties` (gitignored) apunta al keystore.
- Al publicar, aceptar **Play App Signing** (Google guarda la clave de
  firma de la app; la del keystore local es la *upload key*).
- Respaldar el `.jks` y las credenciales fuera de esta máquina.
