#!/usr/bin/env bash
# Regenera los assets de marketing de Ridge desde las capturas reales.
# Uso: bash tool/generate_marketing_assets.sh [en|es|both]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SHOTS="$ROOT/marketing/play/screenshots/clean"
OUT="$ROOT/marketing/assets"
BRAND="$ROOT/marketing/brand"
F_GEIST="$ROOT/assets/fonts/Geist"
F_MONO="$ROOT/assets/fonts/GeistMono/GeistMono-Medium.ttf"

EMBER="#FF5A36"
INK="#241913"
MUTED="#8A7B72"
CREAM="#FEF1EB"
SURFACE="#FFF8F6"
EMBER_TINT="#FFE3DA"
BORDER="#EAD9D0"

B=2

log() { printf '  %s\n' "$1"; }

copy() {
  local lang=$1 key=$2
  if [ "$lang" = "en" ]; then
    case $key in
      eyebrow) printf 'TYPING PRACTICE FOR PROGRAMMERS' ;;
      h_slogan) printf 'Type better,\nnot just faster.' ;;
      h_real) printf 'Real code.\nNot filler.' ;;
      h_lang) printf 'Twenty-plus languages.\nOne habit.' ;;
      h_keys) printf 'Your keyboard,\nin three dimensions.' ;;
      sub_slogan) printf 'Practice with the code you actually write all day.' ;;
      sub_real) printf 'Real snippets from Go, Python, Rust, SQL and twenty more languages.' ;;
      sub_lang) printf 'Guided paths from your first variable to a full project.' ;;
      sub_keys) printf 'Keycap shapes, case colors, RGB effects and remaps you can feel.' ;;
      cta) printf 'Free  ·  Works offline  ·  No ads' ;;
      promo) printf 'Typing practice for programmers and keyboard people.' ;;
    esac
  else
    case $key in
      eyebrow) printf 'MECANOGRAFÍA PARA PROGRAMADORES' ;;
      h_slogan) printf 'Escribe mejor,\nno solo más rápido.' ;;
      h_real) printf 'Código real.\nNo relleno.' ;;
      h_lang) printf 'Más de veinte lenguajes.\nUn solo hábito.' ;;
      h_keys) printf 'Tu teclado,\nen tres dimensiones.' ;;
      sub_slogan) printf 'Practica con el código que de verdad escribes cada día.' ;;
      sub_real) printf 'Fragmentos reales de Go, Python, Rust, SQL y otros veinte lenguajes.' ;;
      sub_lang) printf 'Rutas guiadas desde tu primera variable hasta un proyecto completo.' ;;
      sub_keys) printf 'Formas de keycap, color de carcasa, efectos RGB y remapeos que se sienten.' ;;
      cta) printf 'Gratis  ·  Sin conexión  ·  Sin anuncios' ;;
      promo) printf 'Mecanografía para programadores y aficionados al teclado.' ;;
    esac
  fi
}

mark_svg() {
  local color=$1 out=$2 src=${3:-$ROOT/assets/icons/r_mark.svg}
  sed "s/currentColor/$color/" "$src" > "$out.svg"
  rsvg-convert -w 1024 -h 1024 "$out.svg" -o "$out"
  rm -f "$out.svg"
}

frame_shot() {
  local shot=$1 out=$2 w=$3 h=$4 r=$5 bc=$6 fill=${7:-$SURFACE}
  local iw=$((w - 2 * B)) ih=$((h - 2 * B))
  local sw sh nw nh
  sw=$(magick identify -format %w "$shot")
  sh=$(magick identify -format %h "$shot")
  if [ $(( sw * ih )) -gt $(( sh * iw )) ]; then
    nw=$iw
    nh=$(( iw * sh / sw ))
  else
    nh=$ih
    nw=$(( ih * sw / sh ))
  fi
  magick -size "${iw}x${ih}" xc:"$fill" \
    \( "$shot" -resize "${nw}x${nh}" \) -gravity center -composite "$out.photo.png"
  magick -size "${iw}x${ih}" xc:none -fill white \
    -draw "roundrectangle 0,0,$((iw - 1)),$((ih - 1)),$r,$r" "$out.mask.png"
  magick "$out.photo.png" "$out.mask.png" -alpha off -compose CopyOpacity -composite "$out.frame.png"
  magick "$out.frame.png" -background none -bordercolor "$bc" -border "$B" "$out"
  rm -f "$out.photo.png" "$out.mask.png" "$out.frame.png"
}

label_layer() {
  local out=$1 font=$2 size=$3 color=$4 text=$5
  magick -background none -font "$font" -pointsize "$size" -fill "$color" \
    -gravity northwest label:"$text" "$out"
}

cta_pill() {
  local out=$1 w=$2 h=$3 text=$4 bg=$5 fg=$6
  magick -size "${w}x${h}" xc:none -fill "$bg" -draw "roundrectangle 0,0,$((w - 1)),$((h - 1)),$((h / 2)),$((h / 2))" "$out.base.png"
  local tw tw2
  tw=$(magick -background none -font "$F_GEIST/Geist-Medium.ttf" -pointsize $((h * 38 / 100)) -fill "$fg" label:"$text" -format %w info:)
  local tx=$(( (w - tw) / 2 )) ty=$(( h * 31 / 100 ))
  magick "$out.base.png" \( -background none -font "$F_GEIST/Geist-Medium.ttf" -pointsize $((h * 38 / 100)) \
    -fill "$fg" -gravity northwest label:"$text" \) -geometry +"$tx"+"$ty" -compose over -composite "$out"
  rm -f "$out.base.png"
}


fit_dims() {
  local shot=$1 maxw=$2 maxh=$3
  local sw sh nw nh
  sw=$(magick identify -format %w "$shot")
  sh=$(magick identify -format %h "$shot")
  if [ $(( sw * maxh )) -gt $(( sh * maxw )) ]; then
    printf '%s %s' "$maxw" "$(( maxw * sh / sw ))"
  else
    printf '%s %s' "$(( maxh * sw / sh ))" "$maxh"
  fi
}

label_fit() {
  local out=$1 font=$2 size=$3 color=$4 maxw=$5 text=$6
  local w
  w=$(magick -background none -font "$font" -pointsize "$size" -fill "$color" -gravity northwest label:"$text" -format %w info:)
  if [ "$w" -gt "$maxw" ]; then
    size=$(( size * maxw / w ))
  fi
  magick -background none -font "$font" -pointsize "$size" -fill "$color" -gravity northwest label:"$text" "$out"
}

frame_hug() {
  local shot=$1 out=$2 maxw=$3 maxh=$4 r=$5 bc=$6 fill=${7:-$SURFACE}
  read -r nw nh <<<"$(fit_dims "$shot" "$maxw" "$maxh")"
  frame_shot "$shot" "$out" "$nw" "$nh" "$r" "$bc" "$fill"
  printf '%s %s' "$nw" "$nh"
}

logo_for() {
  local out=$1 kind=$2 color=$3 size=$4
  local src slug
  if [ "$kind" = "glyph" ]; then
    case "$color" in
      "#FFFFFF") slug=white ;; *) slug=ink ;;
    esac
    src="$BRAND/r-only-$slug.png"
    [ -f "$src" ] || mark_svg "$color" "$src" "$BRAND/r-only.svg"
  else
    case "$color" in
      "#FFFFFF") slug=white ;; "#241913") slug=ink ;; *) slug=ember ;;
    esac
    src="$BRAND/r-mark-$slug.png"
    [ -f "$src" ] || mark_svg "$color" "$src"
  fi
  local ps=$(( size * 72 / 100 ))
  local mark_w mark_h
  mark_w=$(magick identify -format %w "$src")
  mark_h=$(magick identify -format %h "$src")
  local wm_h word_w
  wm_h=$(magick -background none -font "$F_GEIST/Geist-Bold.ttf" -pointsize "$ps" -fill "$color" -gravity northwest label:"Ridge" -format %h info:)
  word_w=$(magick -background none -font "$F_GEIST/Geist-Bold.ttf" -pointsize "$ps" -fill "$color" -gravity northwest label:"Ridge" -format %w info:)
  if [ "$kind" = "glyph" ]; then
    mark_w=$(( size * mark_w / mark_h ))
    mark_h=$size
  else
    mark_w=$size
    mark_h=$size
  fi
  gap=$(( mark_w * 26 / 100 ))
  total_w=$(( mark_w + gap + word_w ))
  total_h=$(( mark_h > wm_h ? mark_h : wm_h ))
  magick -size "${total_w}x${total_h}" xc:none \
    \( "$src" -resize ${mark_w}x${mark_h} \) -geometry +0+0 -composite \
    \( -background none -font "$F_GEIST/Geist-Bold.ttf" -pointsize "$ps" -fill "$color" -gravity northwest label:"Ridge" \) \
    -geometry +$(( mark_w + gap ))+0 -composite "$out"
}

logo_lockup() {
  local out=$1 color=$2 size=$3
  local slug mark
  case "$color" in
    "#FFFFFF") slug=white ;;
    "#241913") slug=ink ;;
    *) slug=ember ;;
  esac
  mark="$BRAND/r-mark-$slug.png"
  [ -f "$mark" ] || { mark_svg "$color" "$mark"; log "$(basename "$mark")"; }
  local word wm_h word_w gap total_w total_h
  wm_h=$(magick -background none -font "$F_GEIST/Geist-Bold.ttf" -pointsize $((size * 72 / 100)) \
    -fill "$color" -gravity northwest label:"Ridge" -format %h info:)
  word_w=$(magick -background none -font "$F_GEIST/Geist-Bold.ttf" -pointsize $((size * 72 / 100)) \
    -fill "$color" -gravity northwest label:"Ridge" -format %w info:)
  gap=$((size * 22 / 100))
  total_w=$(( size + gap + word_w ))
  total_h=$(( size > wm_h ? size : wm_h ))
  magick -size "${total_w}x${total_h}" xc:none "$mark" -resize "${size}x${size}" -geometry +0+0 -composite \
    \( -background none -font "$F_GEIST/Geist-Bold.ttf" -pointsize $((size * 72 / 100)) -fill "$color" \
       -gravity northwest label:"Ridge" \) -geometry +$((size + gap))+0 -composite "$out"
  rm -f "$mark"
}

scene_light() {
  local lang=$1 dir=$2 name=$3 w=$4 h=$5 hkey=$6 skey=$7 shot=$8
  local out="$dir/${name}-${lang}.png"
  local pad=$(( w * 9 / 100 ))
  local eyebrow_size=$(( w / 34 ))
  local head_size=$(( w / 13 ))
  local sub_size=$(( w / 42 ))
  local inner=$(( w - pad * 2 ))
  local avail_h=$(( h - pad * 2 ))
  local shot_max_h=$(( avail_h - head_size * 6 ))
  label_layer "$out.eb.png" "$F_MONO" "$eyebrow_size" "$EMBER" "$(copy "$lang" eyebrow)"
  label_fit "$out.hd.png" "$F_GEIST/Geist-Bold.ttf" "$head_size" "$INK" "$inner" "$(copy "$lang" "$hkey")"
  label_fit "$out.sb.png" "$F_GEIST/Geist-Regular.ttf" "$sub_size" "$MUTED" "$inner" "$(copy "$lang" "$skey")"
  local eb_h hd_h sb_h nw nh
  eb_h=$(magick "$out.eb.png" -format %h info:)
  hd_h=$(magick "$out.hd.png" -format %h info:)
  sb_h=$(magick "$out.sb.png" -format %h info:)
  read -r nw nh <<<"$(frame_hug "$shot" "$out.fr.png" "$inner" "$shot_max_h" $(( w / 26 )) "$BORDER")"
  cta_pill "$out.cta.png" $(( w * 62 / 100 )) $(( w / 16 )) "$(copy "$lang" cta)" "$EMBER" "#FFFFFF"
  local cta_h=$(( w / 16 ))
  local fr_x=$(( pad + ( inner - nw ) / 2 ))
  local y=$pad
  magick -size "${w}x${h}" xc:"$CREAM" \
    "$out.eb.png" -geometry +"${pad}"+"$y" -composite "$out"
  y=$(( y + eb_h + head_size * 2 / 5 ))
  magick "$out" "$out.hd.png" -geometry +"${pad}"+"$y" -composite "$out"
  y=$(( y + hd_h + head_size * 3 / 10 ))
  magick "$out" "$out.sb.png" -geometry +"${pad}"+"$y" -composite "$out"
  y=$(( y + sb_h + head_size * 3 / 10 ))
  magick "$out" "$out.fr.png" -geometry +"${fr_x}"+"$y" -composite "$out"
  y=$(( y + nh + head_size * 3 / 10 ))
  magick "$out" "$out.cta.png" -geometry +"${pad}"+"$y" -composite "$out"
  rm -f "$out.eb.png" "$out.hd.png" "$out.sb.png" "$out.fr.png" "$out.cta.png"
  log "$(basename "$out")"
}

scene_split() {
  local lang=$1 dir=$2 name=$3 w=$4 h=$5 hkey=$6 skey=$7 shot=$8
  local out="$dir/${name}-${lang}.png"
  local pad=$(( h * 8 / 100 ))
  local eyebrow_size=$(( w / 60 ))
  local head_size=$(( w / 20 ))
  local sub_size=$(( w / 46 ))
  local col_w=$(( w * 47 / 100 ))
  local gapw=$(( w * 3 / 100 ))
  local shot_maxw=$(( w - pad * 2 - col_w - gapw ))
  local shot_maxh=$(( h - pad * 2 ))
  label_layer "$out.eb.png" "$F_MONO" "$eyebrow_size" "$EMBER" "$(copy "$lang" eyebrow)"
  label_fit "$out.hd.png" "$F_GEIST/Geist-Bold.ttf" "$head_size" "$INK" "$col_w" "$(copy "$lang" "$hkey")"
  label_fit "$out.sb.png" "$F_GEIST/Geist-Regular.ttf" "$sub_size" "$MUTED" "$col_w" "$(copy "$lang" "$skey")"
  local eb_h hd_h sb_h nw nh
  eb_h=$(magick "$out.eb.png" -format %h info:)
  hd_h=$(magick "$out.hd.png" -format %h info:)
  sb_h=$(magick "$out.sb.png" -format %h info:)
  read -r nw nh <<<"$(frame_hug "$shot" "$out.fr.png" "$shot_maxw" "$shot_maxh" $(( w / 44 )) "$BORDER")"
  cta_pill "$out.cta.png" $(( col_w * 94 / 100 )) $(( h / 10 )) "$(copy "$lang" cta)" "$EMBER" "#FFFFFF"
  local cta_h=$(( h / 10 ))
  local y=$(( (h - (eb_h + hd_h + sb_h + cta_h + h / 12)) / 2 ))
  magick -size "${w}x${h}" xc:"$CREAM" \
    "$out.eb.png" -geometry +"${pad}"+"$y" -composite "$out"
  y=$(( y + eb_h + h / 40 ))
  magick "$out" "$out.hd.png" -geometry +"${pad}"+"$y" -composite "$out"
  y=$(( y + hd_h + h / 30 ))
  magick "$out" "$out.sb.png" -geometry +"${pad}"+"$y" -composite "$out"
  y=$(( y + sb_h + h / 22 ))
  magick "$out" "$out.cta.png" -geometry +"${pad}"+"$y" -composite "$out"
  local fr_x=$(( pad + col_w + gapw + ( shot_maxw - nw ) / 2 ))
  magick "$out" "$out.fr.png" -geometry +"${fr_x}"+"${pad}" -composite "$out"
  rm -f "$out.eb.png" "$out.hd.png" "$out.sb.png" "$out.fr.png" "$out.cta.png"
  log "$(basename "$out")"
}

scene_ember() {
  local lang=$1 dir=$2 name=$3 w=$4 h=$5 hkey=$6 skey=$7 shot=$8
  local out="$dir/${name}-${lang}.png"
  local pad=$(( h * 9 / 100 ))
  local eyebrow_size=$(( w / 58 ))
  local head_size=$(( w / 17 ))
  local sub_size=$(( w / 42 ))
  local col_w=$(( w * 49 / 100 ))
  local gapw=$(( w * 3 / 100 ))
  local shot_maxw=$(( w - pad * 2 - col_w - gapw ))
  local shot_maxh=$(( h - pad * 2 - h / 12 ))
  label_layer "$out.eb.png" "$F_MONO" "$eyebrow_size" "$EMBER_TINT" "$(copy "$lang" eyebrow)"
  label_fit "$out.hd.png" "$F_GEIST/Geist-Bold.ttf" "$head_size" "#FFFFFF" "$col_w" "$(copy "$lang" "$hkey")"
  label_fit "$out.sb.png" "$F_GEIST/Geist-Regular.ttf" "$sub_size" "$EMBER_TINT" "$col_w" "$(copy "$lang" "$skey")"
  local eb_h hd_h sb_h nw nh
  eb_h=$(magick "$out.eb.png" -format %h info:)
  hd_h=$(magick "$out.hd.png" -format %h info:)
  sb_h=$(magick "$out.sb.png" -format %h info:)
  read -r nw nh <<<"$(frame_hug "$shot" "$out.fr.png" "$shot_maxw" "$shot_maxh" $(( w / 44 )) "#FFFFFF" "$CREAM")"
  local y=$(( (h - (eb_h + hd_h + sb_h + h / 8)) / 2 ))
  magick -size "${w}x${h}" xc:"$EMBER" \
    "$out.eb.png" -geometry +"${pad}"+"$y" -composite "$out"
  y=$(( y + eb_h + h / 40 ))
  magick "$out" "$out.hd.png" -geometry +"${pad}"+"$y" -composite "$out"
  y=$(( y + hd_h + h / 28 ))
  magick "$out" "$out.sb.png" -geometry +"${pad}"+"$y" -composite "$out"
  local fr_x=$(( pad + col_w + gapw + ( shot_maxw - nw ) / 2 ))
  magick "$out" "$out.fr.png" -geometry +"${fr_x}"+"${pad}" -composite "$out"
  logo_for "$out.lock.png" glyph "#FFFFFF" $(( w / 15 ))
  magick "$out" "$out.lock.png" -geometry +"${pad}"+$(( h - pad - w / 15 )) -composite "$out"
  rm -f "$out.eb.png" "$out.hd.png" "$out.sb.png" "$out.fr.png" "$out.lock.png"
  log "$(basename "$out")"
}

scene_banner() {
  local lang=$1 dir=$2 name=$3 w=$4 h=$5
  local out="$dir/${name}-${lang}.png"
  local mark_size=$(( h * 30 / 100 ))
  logo_for "$out.lock.png" glyph "#FFFFFF" "$mark_size"
  local lock_w lock_h
  lock_w=$(magick "$out.lock.png" -format %w info:)
  lock_h=$(magick "$out.lock.png" -format %h info:)
  label_fit "$out.sb.png" "$F_GEIST/Geist-Medium.ttf" $(( h / 10 )) "#FFFFFF" $(( w * 46 / 100 )) "$(copy "$lang" promo)"
  local sb_w sb_h
  sb_w=$(magick "$out.sb.png" -format %w info:)
  sb_h=$(magick "$out.sb.png" -format %h info:)
  local y=$(( (h - (lock_h + h / 14 + sb_h)) / 2 ))
  magick -size "${w}x${h}" xc:"$EMBER" \
    "$out.lock.png" -geometry +$(( (w - lock_w) / 2 ))+"${y}" -composite "$out"
  y=$(( y + lock_h + h / 14 ))
  magick "$out" "$out.sb.png" -geometry +$(( (w - sb_w) / 2 ))+"${y}" -composite "$out"
  rm -f "$out.lock.png" "$out.sb.png"
  log "$(basename "$out")"
}

brand_sheet() {
  local out="$BRAND/brand-sheet.png"
  local w=1600 h=1000 pad=80
  magick -size "${w}x${h}" xc:"$SURFACE" "$out"
  local x=$pad y=$pad
  magick "$out" \( -background none -font "$F_MONO" -pointsize 26 -fill "$MUTED" label:"MARKETING/BRAND" \) -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + 60 ))
  magick "$out" \( -background none -font "$F_GEIST/Geist-Bold.ttf" -pointsize 76 -fill "$INK" label:"Ridge" \) -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + 120 ))
  magick "$out" \( -background none -font "$F_GEIST/Geist-Medium.ttf" -pointsize 34 -fill "$EMBER" label:"Type better, not just faster." \) -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + 90 ))
  local label
  label=$(magick -background none -font "$F_MONO" -pointsize 24 -fill "$MUTED" label:"PALETTE" -format %w info:)
  magick "$out" \( -background none -font "$F_MONO" -pointsize 24 -fill "$MUTED" label:"PALETTE" \) -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + 46 ))
  local sw_w=200 sw_h=200 gap2=24
  local i=0
  for c in "$EMBER" "$INK" "$CREAM" "$MUTED" "$SURFACE" "$EMBER_TINT"; do
    local name_w
    name_w=$(magick -background none -font "$F_MONO" -pointsize 18 -fill "$MUTED" label:"$c" -format %w info:)
    magick -size "${sw_w}x${sw_h}" xc:"$c" -bordercolor "#D9C9C0" -border 2 "$out.sw.png"
    magick "$out" "$out.sw.png" -geometry +$(( x + i * (sw_w + gap2) ))+"${y}" -composite "$out"
    magick "$out" \( -background none -font "$F_MONO" -pointsize 18 -fill "$MUTED" label:"$c" \) \
      -geometry +$(( x + i * (sw_w + gap2) + (sw_w - name_w) / 2 ))+"$(( y + sw_h + 14 ))" -composite "$out"
    i=$(( i + 1 ))
  done
  rm -f "$out.sw.png"
  y=$(( y + sw_h + 80 ))
  magick "$out" \( -background none -font "$F_MONO" -pointsize 24 -fill "$MUTED" label:"TYPE" \) -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + 50 ))
  magick "$out" \( -background none -font "$F_GEIST/Geist-Bold.ttf" -pointsize 56 -fill "$INK" label:"Geist — headings, UI" \) -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + 84 ))
  magick "$out" \( -background none -font "$F_GEIST/Geist-Regular.ttf" -pointsize 40 -fill "$MUTED" label:"Geist — body copy, straight from the product" \) -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + 70 ))
  magick "$out" \( -background none -font "$F_MONO" -pointsize 40 -fill "$INK" label:"Geist Mono — code, labels, metrics" \) -geometry +"${x}"+"${y}" -composite "$out"
  logo_for "$out.lock.png" keycap "$INK" 120
  magick "$out" "$out.lock.png" -geometry +$(( w - pad - 400 ))+$(( h - pad - 160 )) -composite "$out"
  rm -f "$out.lock.png"
  log "brand/brand-sheet.png"
}

brand_marks() {
  mark_svg "$EMBER" "$BRAND/r-mark-ember.png"
  mark_svg "#FFFFFF" "$BRAND/r-mark-white.png"
  mark_svg "$INK" "$BRAND/r-mark-ink.png"
  for g in white ink; do
    local gc=$EMBER
    [ "$g" = "white" ] && gc="#FFFFFF"
    mark_svg "$gc" "$BRAND/r-only-$g.png" "$BRAND/r-only.svg"
    magick "$BRAND/r-only-$g.png" -trim +repage "$BRAND/r-only-$g.png"
  done
  for v in ember white ink; do
    local bg
    case $v in ember) bg=$EMBER ;; white) bg=$SURFACE ;; ink) bg=$INK ;; esac
    local fg
    case $v in ember) fg="#FFFFFF" ;; white) fg=$EMBER ;; ink) fg=$SURFACE ;; esac
    magick -size 1200x420 xc:"$bg" \
      \( "$BRAND/r-mark-$v.png" -resize 260x260 \) -geometry +120+80 -composite \
      \( -background none -font "$F_GEIST/Geist-Bold.ttf" -pointsize 190 -fill "$fg" -gravity northwest label:"Ridge" \) \
      -geometry +420+120 -composite \
      \( -background none -font "$F_GEIST/Geist-Medium.ttf" -pointsize 46 -fill "$fg" -gravity northwest label:"Type better, not just faster." \) \
      -geometry +424+330 -composite "$BRAND/logo-on-$v.png"
    log "brand/logo-on-$v.png"
  done
}

prepare_shots() {
  local src="$ROOT/marketing/play/screenshots"
  mkdir -p "$SHOTS"
  local f b
  for f in "$src"/phone-*.png; do
    b=$(basename "$f")
    if [ -f "$SHOTS/$b" ] && [ "$SHOTS/$b" -nt "$f" ]; then
      continue
    fi
    magick "$f" -crop 1074x2154+3+3 +repage -resize 1080x2160! "$SHOTS/$b"
  done
}

main() {
  local langs=${1:-both}
  mkdir -p "$BRAND" "$OUT/social" "$OUT/play" "$OUT/web" "$OUT/press" "$OUT/yt"
  [ -f "$BRAND/r-mark.svg" ] || cp "$ROOT/assets/icons/r_mark.svg" "$BRAND/r-mark.svg"
  prepare_shots

  local langs_list=("en" "es")
  [ "$langs" = "en" ] && langs_list=("en")
  [ "$langs" = "es" ] && langs_list=("es")

  for lang in "${langs_list[@]}"; do
    local s_cat="$SHOTS/phone-01-practice-catalog.png"
    local s_paths="$SHOTS/phone-02-go-paths.png"
    local s_free="$SHOTS/phone-06-free-practice.png"
    local s_keys="$SHOTS/phone-07-profile-keyboard.png"
    local s_edit="$SHOTS/phone-08-keyboard-editor.png"
    local s_set="$SHOTS/phone-09-settings.png"

    scene_light "$lang" "$OUT/social" "ig-square" 1080 1080 h_real sub_real "$s_cat"
    scene_light "$lang" "$OUT/social" "ig-story" 1080 1920 h_slogan sub_slogan "$s_free"
    scene_split "$lang" "$OUT/social" "fb-link" 1200 630 h_real sub_real "$s_cat"
    scene_split "$lang" "$OUT/social" "x-post" 1600 900 h_slogan sub_slogan "$s_free"
    scene_split "$lang" "$OUT/social" "linkedin" 1200 627 h_lang sub_lang "$s_paths"
    scene_ember "$lang" "$OUT/yt" "yt-thumbnail" 1280 720 h_real sub_real "$s_edit"
    scene_banner "$lang" "$OUT/yt" "yt-banner" 2560 1440
    scene_ember "$lang" "$OUT/web" "og-image" 1200 630 h_slogan sub_slogan "$s_keys"
    scene_ember "$lang" "$OUT/web" "gh-social" 1280 640 h_keys sub_keys "$s_keys"
    scene_ember "$lang" "$OUT/play" "promo-graphic" 1024 500 h_slogan sub_slogan "$s_free"
    scene_ember "$lang" "$OUT/press" "press-hero" 1600 900 h_real sub_real "$s_cat"
    scene_light "$lang" "$OUT/press" "press-onepager" 1200 1500 h_lang sub_lang "$s_paths"
    cp "$OUT/press/press-hero-${lang}.png" "$OUT/press/press-hero-${lang}-tmp.png" 2>/dev/null || true
  done

  cp "$OUT/social/ig-square-en.png" "$OUT/social/ig-square-en-feed.png" 2>/dev/null || true
  rm -f "$OUT/press/press-hero-"*-tmp.png

  brand_marks
  brand_sheet
  log "assets en $OUT"
}

main "$@"
