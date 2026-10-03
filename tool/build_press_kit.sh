#!/usr/bin/env bash
# Prepara el press kit: copia/reescala assets para la web y empaqueta el ZIP
# descargable. Uso: bash tool/build_press_kit.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
M="$ROOT/marketing"
WEB="$ROOT/docs/press"
ASSETS="$WEB/assets"
CLEAN="$M/play/screenshots/clean"
KIT="$M/press/ridge-press-kit"

log() { printf '  %s\n' "$1"; }

rm -rf "$ASSETS" "$KIT"
mkdir -p "$ASSETS/screenshots" "$KIT/screenshots"

magick "$M/assets/press/press-hero-en.png" -resize 1200x "$ASSETS/press-hero-en.png"
magick "$M/assets/press/press-hero-es.png" -resize 1200x "$ASSETS/press-hero-es.png"
magick "$M/assets/press/press-onepager-en.png" -resize x1400 "$ASSETS/press-onepager-en.png"
magick "$M/assets/press/press-onepager-es.png" -resize x1400 "$ASSETS/press-onepager-es.png"
magick "$M/assets/play/promo-graphic-en.png" "$ASSETS/promo-graphic-en.png"
magick "$M/assets/play/promo-graphic-es.png" "$ASSETS/promo-graphic-es.png"
magick "$M/brand/logo-on-ember.png" -resize x200 "$ASSETS/logo-on-ember.png"
magick "$M/brand/logo-on-ink.png" -resize x200 "$ASSETS/logo-on-ink.png"
magick "$M/brand/logo-on-white.png" -resize x200 "$ASSETS/logo-on-white.png"
cp "$M/brand/r-mark.svg" "$ASSETS/r-mark.svg"
cp "$M/brand/r-mark-ember.png" "$ASSETS/r-mark-ember.png"

for f in "$CLEAN"/*.png; do
  b=$(basename "$f")
  magick "$f" -resize x1440 "$ASSETS/screenshots/$b"
  magick "$f" -resize x1440 "$KIT/screenshots/$b"
done

cp "$M/assets/press"/*.png "$KIT/"
cp "$M/assets/play"/*.png "$KIT/"
mkdir -p "$KIT/social" "$KIT/youtube"
cp "$M/assets/social"/*.png "$KIT/social/"
cp "$M/assets/yt"/*.png "$KIT/youtube/"
cp "$M/brand/r-mark.svg" "$KIT/r-mark.svg"
cp "$M/brand/logo-on-ember.png" "$KIT/logo-on-ember.png"
cp "$M/brand/logo-on-ink.png" "$KIT/logo-on-ink.png"
cp "$M/brand/logo-on-white.png" "$KIT/logo-on-white.png"
cp "$M/brand/brand-sheet.png" "$KIT/brand-sheet.png"
cp "$M/README.md" "$KIT/README.md"
cp "$M/press/facts.md" "$KIT/FACTS.md"
cp "$M/press/social-captions.md" "$KIT/SOCIAL-CAPTIONS.md"

rm -f "$M/press/ridge-press-kit.zip"
(cd "$KIT" && zip -qr "$M/press/ridge-press-kit.zip" .)
log "docs/press/assets/ + marketing/press/ridge-press-kit.zip"