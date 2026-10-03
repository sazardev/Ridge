# Ridge press kit

Everything in this folder is generated. Do not edit the PNGs by hand; run the
scripts and re-commit the output.

| What | Script |
| --- | --- |
| Still images (social, YouTube, web, Play promo, press, brand) | `bash tool/generate_marketing_assets.sh both` |
| Promo videos (vertical + horizontal, EN/ES) | `bash tool/generate_marketing_video.sh both` |
| Web press page + downloadable ZIP | `bash tool/build_press_kit.sh` |

`generate_marketing_video.sh` writes intermediate frames to
`marketing/video/frames/` and deletes them when it finishes; nothing to commit.

## Inventory

- `assets/social/` — Instagram square (1080×1080), story/Reels/TikTok
  (1080×1920), Facebook/Mastodon (1200×630), X (1600×900), LinkedIn
  (1200×627). Each in `en` and `es`.
- `assets/yt/` — thumbnail (1280×720) and channel banner (2560×1440).
- `assets/web/` — Open Graph card (1200×630) and GitHub social preview
  (1280×640).
- `assets/play/` — Play in-app promo graphic (1024×500), `en` and `es`.
- `assets/press/` — press hero (1600×900) and one-pager (1200×1500).
- `brand/` — logo lockups on ember/ink/white, the R mark (SVG + PNG), and a
  brand sheet with the palette and type.
- `video/` — `promo-{vertical,horizontal}-{en,es}.mp4`, 21.6 s, silent.
- `play/screenshots/clean/` — store screenshots with the emulator focus ring
  cropped out, 1080×2160.

## Rules the assets follow

Flat surfaces only: no gradients, no shadows, no blur. Ember `#FF5A36` on ink
`#241913`, cream `#FEF1EB` for surfaces, Geist and Geist Mono. Every image
carries the R mark, never a stretched or recolored one. Both languages ship
together; neither is a machine translation of the other.