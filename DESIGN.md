# DESIGN.md: Modern TUI (Charm-style)

The modern terminal look popularized by Charm (Glow, Gum, Soft Serve): rounded borders, soft adaptive colors that suit light
and dark terminals, generous padding, gentle spinners and markdown rendered with care. Friendly, polished, still fast.

## Principles

- **Friendly, not loud**: soft colors, rounded corners, breathing room.
- **Adaptive**: every color has a light and a dark variant chosen from the terminal background.
- **Guided**: inline help, clear prompts and forms that tell you what to do next.
- **Polish in motion**: spinners and small transitions show life without slowing anything.
- **Readable docs**: markdown is rendered (headings, code, lists), not dumped.
- **The terminal decides**: the app looks native in every theme the user already chose (Gruvbox, Catppuccin, Solarized…), light or dark, because it never paints its own background.

## Color

| Token | Light terminal | Dark terminal | ANSI 16 fallback | Use |
| --- | --- | --- | --- | --- |
| `fg` | `#1A1A1A` | `#DDDDDD` | default | Text |
| `muted` | `#8A8A8A` | `#6C6C6C` | default fg, dimmed (SGR 2) | Hints, help |
| `primary` | `#7D56F4` | `#9B7CFF` (approx.) | 5 | Titles, focus, selection |
| `secondary` | `#EE6FF8` | `#F78CFF` (approx.) | 13 | Highlights, badges |
| `success` | `#02BA84` | `#04D99A` (approx.) | 2 | Done |
| `warning` | `#C99700` (approx.) | `#F2C94C` (approx.) | 3 | Attention |
| `danger` | `#E0245E` (approx.) | `#FF5F87` | 1 | Errors |
| `surface` | `#F2F0FA` (approx.) | `#2A2438` (approx.) | none | Badges and selected items background |

- Adaptive colors via `lipgloss.AdaptiveColor{Light, Dark}`; background detected once at start.
- Colors are **ANSI roles, not hex**: default foreground/background for text, the default foreground with SGR 2 (dim) for muted — never bright black, which is near-white on several light themes — `1` red for danger, `2` green for success, `3` yellow for warning, `4` blue for accent, `5` magenta for highlights, `6` cyan for links/info. High contrast keeps the full foreground instead of dimming.
- Never set a background on the whole screen; selections use reverse video (`SGR 7`) or the accent as background with the default background as text.
- Truecolor (`COLORTERM=truecolor`) only for gradients and charts, always with an ANSI 16 fallback; 256-color in between.
- `NO_COLOR` set or `TERM=dumb` → no colors at all, hierarchy by bold, dim, underline and spacing alone; not a TTY → plain text.
- Gradients interpolate in OKLCH between 2-3 stops per character cell (foreground color per cell); 256-color fallback picks the nearest index, ANSI 16 falls back to one solid accent.
- Glow: text gets a soft halo of its own color (GUI `text-shadow: 0 0 2px currentColor, 0 0 8px color-mix(in oklch, currentColor 40%, transparent)`); TUI keeps the palette's brightest step for focus to imitate it.
- Gradients and images are reduced to the palette with ordered dithering (Bayer 4×4 or 8×8); error diffusion (Floyd-Steinberg) only for photos.
- Neon accents: magenta `#FF2BD6`, cyan `#00F0FF`, violet `#9D4EDD` on near-black `#0B0612`.
- Success/danger pairs never rely on red vs green alone: add icons (`✓`, `✕`), labels or patterns; charts use a color-blind safe set (e.g. Okabe-Ito: `#E69F00`, `#56B4E9`, `#009E73`, `#F0E442`, `#0072B2`, `#D55E00`, `#CC79A7`).

## Typography

| Role | Style | Use |
| --- | --- | --- |
| Title | bold `primary`, often in a `surface` badge with 1-cell padding | Screen titles |
| Body | default | Text |
| Hint | `muted` | Inline help, placeholders |
| Key | bold | Shortcuts in the help view (`↑/k up • q quit`) |
| Markdown | Glamour `dark`/`light`/`auto` style | Docs, READMEs, long text |
| Icons | `✓ ✗ • → ●` (Unicode), Nerd Font icons optional | Status |

- Density ramps map brightness to characters, darkest to brightest: short ` .:-=+*#%@` (10 levels), block ` ░▒▓█`, half blocks `▀▄` (double vertical resolution), and the long 70-level ramp:

```
 .'`^",:;Il!i><~+_-?][}{1)(|\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$
```
- Banners in figlet/toilet fonts (`ANSI Shadow`, `Big`, `Slant`, `Small`), at most one per screen, never wider than the terminal (fall back to a smaller font, then to plain bold text).
- Borders with box drawing: light `┌─┐│└┘`, rounded `╭─╮│╰╯`, heavy `┏━┓┃┗┛` for focus, double `╔═╗║╚╝` for dialogs.
- Bars and meters with block elements `▁▂▃▄▅▆▇█` (vertical) and `▏▎▍▌▋▊▉█` (horizontal); sparklines with the vertical set.
- Charts and fine graphics with braille (U+2800-U+28FF): 2×4 dots per cell, 8× the resolution of plain cells.

## Spacing and layout

- Unit = one cell; padding 1×2 (rows×cols) inside boxes; margins of 1 row between blocks.
- Minimum 80×24; centered content column of ≤ 100 cells on wide terminals; lists fill height.
- Help view at the bottom, one line short help, `?` toggles the full help.
- Usable from 40×20 cells: a single column, no side-by-side panes below 60 columns.
- Labels shorten before content does (`Downloads` → `DL`); tables drop low-priority columns first, by a declared priority.
- Designed for 80×24 cells and usable down to it; above 120 columns a second pane may appear.
- Redraw on every resize (`SIGWINCH`); nothing is cut silently: truncate with `…` and keep the key column readable.
- Runs the same over SSH, in tmux/screen and in the alternate screen; restores the terminal on exit, crash or `Ctrl+C`.
- GUI: 4 px base unit, rows 28-32 px, controls 28 px high, body text 13-14 px; TUI: no blank line between list rows, 1-cell padding inside borders.
- Information density over whitespace; group with alignment and subtle dividers instead of space.

## Shape and elevation

| Token | Glyphs | Use |
| --- | --- | --- |
| border-rounded | `╭─╮│╰╯` | Cards, panes, dialogs |
| border-thick-left | `▌` or `┃` in `primary` | Selected list item marker |
| badge | text on `surface` with 1-cell padding | Titles, tags |

- Elevation: focused pane gets a `primary` border; others `muted`. Dialogs are rounded boxes placed in the center (`lipgloss.Place`).
- GUI scanlines: a fixed overlay `repeating-linear-gradient(to bottom, rgb(0 0 0 / 0.15) 0 1px, transparent 1px 3px)`, pointer-events none; optional vignette and 1-2% barrel curvature via a shader or SVG filter.
- TUI: no overlays; the effect comes from the phosphor palette, a dim surface one step above the background and generous blank lines.
- Shadows and fills use dither patterns instead of opacity; GUI renders at integer scale with `image-rendering: pixelated`.
- TUI: dithering with block/shade characters `░▒▓` or braille dots for sub-cell detail.
- GUI glow: `box-shadow: 0 0 6px var(--accent), 0 0 18px color-mix(in oklch, var(--accent) 50%, transparent)` on focus and primary elements only.
- TUI: bright ANSI colors (`13`, `14`) and bold for the glowing elements; everything else stays dim.

## Motion

| Token | Value | Use |
| --- | --- | --- |
| spinner | `spinner.Dot` / `spinner.MiniDot` (~10–12 fps) | Activity |
| progress | animated bar with spring easing (`bubbles/progress`), gradient `primary` → `secondary` | Determinate work |
| frame-budget | 60 fps | Animated components |
| transitions | none between screens | Instant |

- Reduced motion: progress bars jump to the value; spinners static.
- Spinner frames: braille `⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏` at 80 ms/frame (dots), or `◐ ◓ ◑ ◒`; ASCII fallback `| / - \`.
- Progress bars with sub-cell precision (`▏▎▍▌▋▊▉█`), percentage and ETA; indeterminate work uses a spinner, never a fake bar.
- Typewriter or fade-in reveals only for short headings (≤ 40 chars, ≤ 400 ms total).
- Redraw budget 60 fps for idle animation and interactions; only changed cells are redrawn.

## Components

- **Lists**: `bubbles/list` with title, filter (`/`), pagination dots, selected item with a `▌` marker and `primary` text.
- **Tables**: `bubbles/table`, header bold with bottom border, selected row in `surface`.
- **Forms**: `huh` forms: one question at a time or grouped, validation inline in `danger`.
- **Text input / text area**: placeholder in `muted`, focused prompt in `primary`.
- **Viewport**: scrollable markdown rendered by Glamour.
- **Status bar**: segments as colored badges (mode, file, position).
- **Help**: `bubbles/help` short and full views.
- **Empty/loading/error**: friendly sentence + icon (`• Nothing yet — press n to create one`), spinner + verb, `✗` + cause + next step.
- Every key binding has a single-key or `Ctrl` alternative (soft keyboards lack `Alt`/function keys); touch scrolling works where the terminal sends mouse events.
- Keyboard first: arrows and `hjkl`, `Enter` select, `Esc` back, `q` quit, `/` search, `?` help; the mouse is an optional extra: clicking a row selects and runs it and the wheel scrolls, but every action is reachable from the keyboard.
- `F1` (and Home → Guide & shortcuts, and the `:` palette) opens the in-app guide: navigation, commands, mouse, typing keys, theme and accessibility.
- A status/help line shows the keys that matter on the current screen.
- Art is data: banners and images live in asset files or are generated at startup, never hand-typed into view code.
- GUI: open with Cmd/Ctrl+K (and "/" when no input is focused); centered overlay 600 px wide, 15% from the top, search input 48 px with the placeholder "Search or run a command...", results list max 8 rows visible, 40 px each, scrollable.
- GUI: one list mixes navigation, objects and actions in labelled groups (Recent, Pages, Records, Actions); with an empty query show Recent and common actions; ranking favors prefix matches, then recency, then frequency; fuzzy matching tolerates typos.
- GUI: each row: icon, label with the matched characters emphasized, secondary text (location or type) muted, and the shortcut right-aligned as keycaps (`Ctrl` `Shift` `P`); show the platform's symbols (Cmd on macOS, Ctrl elsewhere).
- GUI: Up/Down move the highlight, Enter runs, Cmd/Ctrl+Enter opens in a new tab or alternate target, Esc closes, Backspace on an empty query leaves a scoped mode; scoped prefixes (`>` actions, `@` people, `#` pages) are listed in the footer hints.
- GUI: actions that need input continue inside the palette as a second step with a breadcrumb chip ("Move to..."), never a new dialog; destructive actions ask for confirmation before running.
- GUI: no results shows "No matches for 'x'" with the nearest alternative or "Search all records" as the action; slow sources show a spinner row while local results are already visible.
- GUI: show results in under 100 ms for local items; remote results append without moving the highlighted row.
- TUI: `:` or Ctrl+P opens a prompt at the bottom with a list above it, same ranking, `Tab` completes, Enter runs, Esc cancels; the key binding appears at the right of each row.

## Accessibility

- Adaptive colors keep contrast on light and dark terminals; check `muted` stays ≥ 4.5:1 for anything important (approx.).
- `NO_COLOR`/`TERM=dumb`: Lip Gloss drops colors; borders and markers still show focus.
- Non-TTY: print plain output (Gum-style: results to stdout, UI to stderr).
- Keyboard: arrows and vi keys, `/` filter, `?` help, `esc` back, `q`/`ctrl+c` quit.
- No animation when stdout is not a TTY, in `CI`, with `NO_COLOR`/`TERM=dumb`, or with the app's reduced-motion flag: print a single status line instead.
- Screen readers and `NO_COLOR` get the plain text the art spells, never the art itself.
- Scanlines and glow are off with reduced motion/transparency preferences or high contrast; body text never sits under the overlay at less than 7:1.
- Glow never carries meaning on its own; it is off in high contrast and reduced-transparency modes.
- Every screen is checked with a color-blindness simulator (deuteranopia, protanopia, tritanopia) before it is done.
- With `prefers-reduced-motion: reduce` (or the OS/app setting), movement is replaced by ≤ 150 ms opacity fades; parallax, auto-playing animation and spinners that move across the screen are removed.
- GUI: semantic HTML/native controls first, landmarks, headings in order, every control named, live regions for async updates; tested with VoiceOver and NVDA/TalkBack.
- TUI: an accessible mode (flag or env var) prints linear text without box art, spinners or cursor tricks, one line per state change, readable by screen readers.
- Text contrast at least 7:1 (4.5:1 for large text), targets at least 44×44 px, no timing that cannot be extended, no flashing at all.
- Line height ≥ 1.5, paragraph spacing ≥ 2× font size, measure ≤ 80 characters, text resizable to 200% without loss.
- Context help for every non-obvious input; error messages say how to fix the problem.
- Implement as a combobox with `aria-activedescendant`, announce the results count, keep focus in the input, and make every command also reachable without the palette.

## Rules for agents

- Use Bubble Tea + Bubbles + Lip Gloss + Huh + Glamour; Ratatui equivalent: rounded `BorderType::Rounded`, `tui-input`, `tui-markdown` (approx.).
- Styles only in `styles.go` with `AdaptiveColor`; never a raw color in a view.
- Every screen has a short help line; every action is in the full help.
- Respect the terminal background: no full-screen background painting.
- Test with light and dark terminal themes, `NO_COLOR=1` and at 80×24.
- Test at 40×20 and at 60×24 as well as 80×24.
- Test at 80×24, at 200×60 and while resizing; test inside tmux and over SSH.
- Never assume a font, a color depth or mouse support: detect and degrade.
- Read colors through one theme module that maps roles to ANSI indexes; never write an escape sequence or a hex value in a view.
- Test every screen with a light and a dark terminal theme and with `NO_COLOR=1`.
- Animations run on a ticker owned by the UI loop and stop when nothing is pending; never sleep in the render path.
- Dither at build time or once at load, never per frame.
- Every glyph has an ASCII fallback (`+-|`, `#`, `*`) selected when the locale is not UTF-8.
- Every animation is behind the motion preference check; test with it on.
- Never convey state only visually; every icon-only control has an accessible name.
- Every action in the palette shows its shortcut when it has one; every shortcut appears in the palette.
- Never make the palette the only way to reach a feature.
- Read every color and style from `styles.go`; a view only calls styles and `lipgloss.Join*` / `Place`.
- Never pad with hand-counted spaces: widths come from `lipgloss.Width` and `.Width(n)`.

## Toolkit

| Design | Lip Gloss / Bubble Tea |
| Color token | one `lipgloss.AdaptiveColor{Light, Dark}` (or an ANSI index string `"4"` when the theme inherits the terminal) per token, in `styles.go` |
| Text style | one named `lipgloss.Style` per role (`Title`, `Muted`, `Key`, `Error`…), built once, never inline in a view |
| Frame | `.Border(lipgloss.RoundedBorder())` (or `NormalBorder`, `ThickBorder`, `DoubleBorder`, `BlockBorder`, `HiddenBorder`) + `.BorderForeground(token)` |
| Spacing | `.Padding(v, h)` inside frames, `.Margin(v, h)` between blocks; one cell is the unit |
| Layout | `lipgloss.JoinVertical` / `JoinHorizontal` compose blocks; `lipgloss.Place(width, height, lipgloss.Center, lipgloss.Center, view)` centers the whole screen |
| Width | `lipgloss.Width(s)` / `lipgloss.Height(s)` measure rendered blocks (display width, ANSI ignored); never `len(s)` |
| Size | the last `tea.WindowSizeMsg` is kept in the model; every view is laid out from it, never from a constant |
| Grid / keypad | a row of fixed-width cells (`.Width(n).Align(lipgloss.Center)`) joined horizontally; the focused cell gets the `Focus` style |
| Tables / lists | `lipgloss/table` for static tables, `bubbles/table` and `bubbles/list` for interactive ones |
| Help bar | `bubbles/help` + `bubbles/key` bindings; `help.Width = width` so it truncates with `…` instead of overflowing |
| Motion | `tea.Tick` for frames; `github.com/charmbracelet/harmonica` springs for eased values (position, flash fade) |

- The root view ends with `lipgloss.Place(...)` over the full window, so the composition is centered and never touches the edges by accident.
- Compose top-down: header, body, help bar as three blocks joined vertically; each block renders to exactly the width it was given.
- A block that does not fit swaps to its compact variant (smaller banner, fewer columns); test the 80×24 minimum with `teatest` golden files.
- Golden tests force a color profile (`lipgloss.SetColorProfile(termenv.Ascii)` or the `teatest` option) so snapshots do not depend on the terminal.
