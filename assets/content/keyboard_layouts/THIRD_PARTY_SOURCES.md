# Third-party sources — keyboard layout data bank

The files in this directory (except this one and `manifest.json`)
contain **factual physical key-position data** (x/y/width/height per
key, in key-units) extracted from the `keyboards/**/info.json` /
`keyboards/**/keyboard.json` layout definitions of the open-source
[QMK Firmware](https://github.com/qmk/qmk_firmware) repository, so
Ridge can render a faithful 2D silhouette of these specific keyboard
models instead of the generic size-family approximation used for
every other model. This is a factual-data extraction, not a copy of
QMK's firmware source code — no C sources, build scripts, or QMK
branding are included. This note is not a substitute for legal review;
if Ridge's distribution terms change, re-verify this before relying on
it.

QMK Firmware is licensed **GPL-2.0-or-later** (per the repository's
root `LICENSE` file, mirrored at `LICENSES/GPL-2.0.txt`). Every entry
below was extracted under that license.

| Model | Source path | Layout | Retrieved | Link |
|---|---|---|---|---|
| ErgoDox EZ | `keyboards/ergodox_ez/info.json` | `LAYOUT_ergodox_pretty` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/ergodox_ez/info.json) |
| ZSA Moonlander Mark I | `keyboards/zsa/moonlander/keyboard.json` | `LAYOUT` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/zsa/moonlander/keyboard.json) |
| ZSA Voyager | `keyboards/zsa/voyager/keyboard.json` | `LAYOUT` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/zsa/voyager/keyboard.json) |
| HHKB Professional Hybrid | `keyboards/hhkb/ansi/info.json` | `LAYOUT` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/hhkb/ansi/info.json) |
| Keychron Q1 | `keyboards/keychron/q1v1/ansi/keyboard.json` | `LAYOUT_ansi_82` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/keychron/q1v1/ansi/keyboard.json) |
| Glorious GMMK Pro | `keyboards/gmmk/pro/rev1/ansi/keyboard.json` | `LAYOUT` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/gmmk/pro/rev1/ansi/keyboard.json) |
| Drop ALT | `keyboards/drop/alt/v2/keyboard.json` | `LAYOUT_65_ansi_blocker` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/drop/alt/v2/keyboard.json) |
| Drop CTRL | `keyboards/drop/ctrl/v2/keyboard.json` | `LAYOUT_tkl_ansi` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/drop/ctrl/v2/keyboard.json) |
| Akko 5108B | `keyboards/akko/5108/keyboard.json` | `LAYOUT` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/akko/5108/keyboard.json) |
| Glorious GMMK Numpad | `keyboards/gmmk/numpad/keyboard.json` | `LAYOUT` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/gmmk/numpad/keyboard.json) |
| Glorious GMMK 2 | `keyboards/gmmk/gmmk2/p96/ansi/keyboard.json` | `LAYOUT` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/gmmk/gmmk2/p96/ansi/keyboard.json) |
| Monsgeek M1 | `keyboards/monsgeek/m1/keyboard.json` | `LAYOUT_ansi` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/monsgeek/m1/keyboard.json) |
| Monsgeek M3 | `keyboards/monsgeek/m3/keyboard.json` | `LAYOUT_tkl_ansi` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/monsgeek/m3/keyboard.json) |
| Royal Kludge RK61 | `keyboards/royal_kludge/rk61/keyboard.json` | `LAYOUT_60_ansi` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/royal_kludge/rk61/keyboard.json) |
| Skyloong GK61 | `keyboards/skyloong/gk61/v1/keyboard.json` | `LAYOUT_60_ansi` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/skyloong/gk61/v1/keyboard.json) |
| Kinesis Advantage2 | `keyboards/kinesis/kint2pp/keyboard.json` | `LAYOUT` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/kinesis/kint2pp/keyboard.json) |
| Keychron Q2 | `keyboards/keychron/q2/ansi/keyboard.json` | `LAYOUT_ansi_67` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/keychron/q2/ansi/keyboard.json) |
| Keychron Q3 | `keyboards/keychron/q3/ansi/keyboard.json` | `LAYOUT_tkl_ansi` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/keychron/q3/ansi/keyboard.json) |
| Keychron Q10 | `keyboards/keychron/q10/ansi_encoder/keyboard.json` | `LAYOUT_ansi_89` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/keychron/q10/ansi_encoder/keyboard.json) |
| Keychron V1 | `keyboards/keychron/v1/ansi/keyboard.json` | `LAYOUT_ansi_82` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/keychron/v1/ansi/keyboard.json) |
| Keychron V3 | `keyboards/keychron/v3/ansi/keyboard.json` | `LAYOUT_tkl_ansi` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/keychron/v3/ansi/keyboard.json) |
| Keychron V6 | `keyboards/keychron/v6/ansi/keyboard.json` | `LAYOUT_ansi_108` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/keychron/v6/ansi/keyboard.json) |
| Keychron V10 | `keyboards/keychron/v10/ansi_encoder/keyboard.json` | `LAYOUT_ansi_89` | 2026-09-11 | [link](https://github.com/qmk/qmk_firmware/blob/master/keyboards/keychron/v10/ansi_encoder/keyboard.json) |
| MCHOSE GX87 | `keyboards/mchose/gx87/keyboard.json` (unmerged fork, see note) | `LAYOUT_ansi` | 2026-09-11 | [link](https://github.com/jonylee1986/qmk_firmware_master/blob/mchose_gx87/keyboards/mchose/gx87/keyboard.json) |

## Note on `MCHOSE GX87`

Not yet merged into upstream `qmk/qmk_firmware`. Sourced from
`jonylee1986/qmk_firmware_master`'s `mchose_gx87` branch — a public
fork of `qmk/qmk_firmware` (inherits its GPL-2.0 license, confirmed via
the GitHub API's license detection on that fork) contributed by the
person MCHOSE points GX87 VIA users to for QMK/VIA firmware/config
(also distributed as a standalone VIA JSON at
`github.com/Ericbai0808/GX87-VIA-JSON-file`, referenced from MCHOSE's
own support blog). The `keyboard.json`'s physical layout
(`LAYOUT_ansi`, 88 keys) is what's curated here; firmware source itself
was not touched.

## Note on `Glorious GMMK 2`

GMMK2 ships in 65%/75%/96% trims under one product name (`keyboard_
shape_lookup.dart` already commits to the `fullSize` family for this
model) — curated from the 96% ANSI trim (`gmmk2/p96/ansi`) to match.

## Note on `Kinesis Advantage2`

No `info.json`/`keyboard.json` exists under the literal "Advantage2"
name. Curated from `kinesis/kint2pp` — QMK's own community
controller-replacement project for the classic Kinesis
Advantage/Contoured case ("Kinesis Classic/Advantage/Contoured" per its
`keyboard_name`), maintained under the `QMK` org itself. The
Advantage2 kept the same physical case/keywell shape as the original
Advantage line (only the internals changed), so this is the closest
verifiable public source for its real geometry — a genuine
key-position match, not a guess, but noted here in case that
assumption ever needs re-checking against an actual Advantage2 teardown.

## Searched but not found (don't re-check without new information)

Beyond `qmk/qmk_firmware`, `the-via/keyboards` (VIA's own definitions
repo) was swept for every remaining brand in `kKeyboardModelSuggestions`
— it adds no coverage beyond what's listed above (mostly indie/maker
boards under community usernames, not these consumer brands). No
public QMK/VIA/KLE layout data was found for: Corsair, Razer,
Logitech(/G), SteelSeries, ASUS ROG, MSI, Das Keyboard, Redragon
(one unrelated `k667` board exists, not a suggested model), Wooting
(own proprietary firmware), Varmilo, Leopold, Topre/Realforce, Vortex,
Womier, Attack Shark, Epomaker (one unrelated `tide65` board exists),
Apple, Dell, HP, Lenovo, Alienware, Microsoft, IBM Model F/M (the
vintage originals — only unrelated hobbyist projects exist), WASD
Keyboards (only an unrelated community clone exists, not the real
product), Keychron's non-Q/V-numbered lines (C1/C2 non-Pro, K-series,
K Pro), and Akko's "ACR Pro 75" specifically (a different Akko model,
`akko/acr87`, exists in QMK but is a TKL, not a 75%, so it wasn't
force-matched).

## Note on `HHKB Professional Hybrid`

QMK's `keyboards/hhkb/ansi` folder targets community-made
HHKB-compatible replacement controller boards, not Happy Hacking
Keyboard's own (closed) firmware — but those replacement boards are
built to the real HHKB case/plate dimensions, so the physical key
layout is an accurate match for the Professional Hybrid's actual
footprint (same 60-key blank layout, split backspace/backslash, no
arrow cluster) shared across the Classic/Hybrid/Type-S generations.

## Dropped: Kinesis Advantage360

Not included. The Advantage360 runs Kinesis's own ZMK-based firmware,
not QMK, and no `info.json`/`keyboard.json`-style physical layout file
for it was found in `qmk/qmk_firmware` or `the-via/keyboards`. Rather
than approximate its physical layout without a verifiable public
source, this model falls back to the app's generic `splitErgo` family
silhouette like any other uncurated model.
