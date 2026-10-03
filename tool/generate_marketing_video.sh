#!/usr/bin/env bash
# Genera el video promocional de Ridge desde las capturas reales.
# Uso: bash tool/generate_marketing_video.sh [en|es|both]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SHOTS="$ROOT/marketing/play/screenshots/clean"
BRAND="$ROOT/marketing/brand"
FRAMES="$ROOT/marketing/video/frames"
OUT="$ROOT/marketing/video"
F_GEIST="$ROOT/assets/fonts/Geist"
F_MONO="$ROOT/assets/fonts/GeistMono/GeistMono-Medium.ttf"

EMBER="#FF5A36"
INK="#241913"
MUTED="#8A7B72"
CREAM="#FEF1EB"
SURFACE="#FFF8F6"
EMBER_TINT="#FFE3DA"
BEAT=3.6

log() { printf '  %s\n' "$1"; }

copy() {
  local lang=$1 key=$2
  if [ "$lang" = "en" ]; then
    case $key in
      eyebrow) printf 'TYPING PRACTICE FOR PROGRAMMERS' ;;
      h1) printf 'Type better,\nnot just faster.' ;;
      h2) printf 'Real code.\nNot filler.' ;;
      h3) printf 'Twenty-plus languages.\nOne habit.' ;;
      h4) printf 'Your keyboard,\nin three dimensions.' ;;
      h5) printf 'Offline, by design.' ;;
      s1) printf 'Practice with the code you actually write all day.' ;;
      s2) printf 'Snippets from Go, Python, Rust, SQL and twenty more.' ;;
      s3) printf 'Guided paths from your first variable to a full project.' ;;
      s4) printf 'Keycap shapes, case colors, RGB effects and remaps.' ;;
      s5) printf 'No account, no ads, no tracking. Your progress stays on your device.' ;;
      cta) printf 'Ridge' ;;
      store) printf 'Available on Google Play' ;;
    esac
  else
    case $key in
      eyebrow) printf 'MECANOGRAFÍA PARA PROGRAMADORES' ;;
      h1) printf 'Escribe mejor,\nno solo más rápido.' ;;
      h2) printf 'Código real.\nNo relleno.' ;;
      h3) printf 'Más de veinte lenguajes.\nUn solo hábito.' ;;
      h4) printf 'Tu teclado,\nen tres dimensiones.' ;;
      h5) printf 'Sin conexión, por diseño.' ;;
      s1) printf 'Practica con el código que de verdad escribes cada día.' ;;
      s2) printf 'Fragmentos de Go, Python, Rust, SQL y otros veinte lenguajes.' ;;
      s3) printf 'Rutas guiadas desde tu primera variable hasta un proyecto completo.' ;;
      s4) printf 'Formas de keycap, color de carcasa, efectos RGB y remapeos.' ;;
      s5) printf 'Sin cuenta, sin anuncios, sin rastreo. Tu progreso queda en tu dispositivo.' ;;
      cta) printf 'Ridge' ;;
      store) printf 'Disponible en Google Play' ;;
    esac
  fi
}

text_fit() {
  local out=$1 size=$2 color=$3 maxw=$4 weight=$5 text=$6
  local font="$F_GEIST/Geist-$weight.ttf"
  local w
  w=$(magick -background none -font "$font" -pointsize "$size" -fill "$color" -gravity northwest label:"$text" -format %w info:)
  [ "$w" -gt "$maxw" ] && size=$(( size * maxw / w ))
  magick -background none -font "$font" -pointsize "$size" -fill "$color" -gravity northwest label:"$text" png:"$out"
}

height_of() { magick "$1" -format %h info:; }
width_of() { magick "$1" -format %w info:; }

shot_fit() {
  local shot=$1 maxw=$2 maxh=$3
  local sw sh
  sw=$(magick identify -format %w "$shot")
  sh=$(magick identify -format %h "$shot")
  if [ $(( sw * maxh )) -gt $(( sh * maxw )) ]; then
    printf '%s %s\n' "$maxw" "$(( maxw * sh / sw ))"
  else
    printf '%s %s\n' "$(( maxh * sw / sh ))" "$maxh"
  fi
}

shot_frame() {
  local shot=$1 out=$2 nw=$3 nh=$4 bc=$5 fill=$6 r=$7
  local iw=$(( nw - 4 )) ih=$(( nh - 4 ))
  magick -size "${iw}x${ih}" xc:"$fill" \
    \( "$shot" -resize "${iw}x${ih}" \) -gravity center -composite "$out.p.png"
  magick -size "${iw}x${ih}" xc:none -fill white \
    -draw "roundrectangle 0,0,$((iw - 1)),$((ih - 1)),$r,$r" "$out.m.png"
  magick "$out.p.png" "$out.m.png" -alpha off -compose CopyOpacity -composite "$out.c.png"
  magick "$out.c.png" -background none -bordercolor "$bc" -border 2 "$out"
  rm -f "$out.p.png" "$out.m.png" "$out.c.png"
}

beat_card() {
  local lang=$1 out=$2 w=$3 h=$4 hkey=$5 skey=$6
  local pad=$(( h * 8 / 100 ))
  local inner=$(( w - pad * 2 ))
  local head_size=$(( w / 11 ))
  local sub_size=$(( w / 38 ))
  local eb_size=$(( w / 52 ))
  text_fit "$out.eb" "$eb_size" "$EMBER_TINT" "$inner" "SemiBold" "$(copy "$lang" eyebrow)"
  text_fit "$out.hd" "$head_size" "#FFFFFF" "$inner" "Bold" "$(copy "$lang" "$hkey")"
  text_fit "$out.sb" "$sub_size" "$EMBER_TINT" "$inner" "Regular" "$(copy "$lang" "$skey")"
  local eb_h hd_h sb_h
  eb_h=$(height_of "$out.eb")
  hd_h=$(height_of "$out.hd")
  sb_h=$(height_of "$out.sb")
  local gap=$(( h * 3 / 100 ))
  local mark
  mark="$BRAND/r-only-white.png"
  local mw mh
  mw=$(( h * 12 / 100 ))
  mh=$(magick "$mark" -resize "x${mw}" -format %h info:)
  local total=$(( mw + gap + eb_h + gap + hd_h + gap + sb_h ))
  local y=$(( (h - total) / 2 ))
  local x=$(( pad + ( inner - mw ) / 2 ))
  magick -size "${w}x${h}" xc:"$EMBER" \
    \( "$mark" -resize "x${mw}" \) -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + mw + gap ))
  x=$(( (w - $(width_of "$out.eb") ) / 2 ))
  magick "$out" "$out.eb" -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + eb_h + gap ))
  x=$(( pad + ( inner - $(width_of "$out.hd") ) / 2 ))
  magick "$out" "$out.hd" -geometry +"${x}"+"${y}" -composite "$out"
  y=$(( y + hd_h + gap ))
  x=$(( pad + ( inner - $(width_of "$out.sb") ) / 2 ))
  magick "$out" "$out.sb" -geometry +"${x}"+"${y}" -composite "$out"
  rm -f "$out.eb" "$out.hd" "$out.sb"
}

beat_shot() {
  local lang=$1 out=$2 w=$3 h=$4 hkey=$5 skey=$6 shot=$7 layout=${8:-stack}
  local pad=$(( h * 7 / 100 ))
  local inner=$(( w - pad * 2 ))
  local eb_size=$(( w / 52 ))
  local head_size=$(( w / 16 ))
  local sub_size=$(( w / 40 ))
  local mw=$(( h * 7 / 100 ))
  local gap=$(( h * 2 / 100 ))
  local mark="$BRAND/r-only-white.png"
  local frame_maxw frame_maxh nw nh fx text_x text_w

  if [ "$layout" = "side" ]; then
    frame_maxw=$(( w * 30 / 100 ))
    frame_maxh=$(( h - pad * 2 ))
    read -r nw nh <<< "$(shot_fit "$shot" "$frame_maxw" "$frame_maxh")"
    fx=$(( w * 6 / 100 ))
    text_x=$(( fx + nw + w * 6 / 100 ))
    text_w=$(( w - pad - text_x ))
  else
    text_x=$pad
    text_w=$inner
  fi

  text_fit "$out.eb" "$eb_size" "$EMBER_TINT" "$text_w" "SemiBold" "$(copy "$lang" eyebrow)"
  text_fit "$out.hd" "$head_size" "#FFFFFF" "$text_w" "Bold" "$(copy "$lang" "$hkey")"
  text_fit "$out.sb" "$sub_size" "$EMBER_TINT" "$text_w" "Regular" "$(copy "$lang" "$skey")"
  local eb_h hd_h sb_h
  eb_h=$(height_of "$out.eb")
  hd_h=$(height_of "$out.hd")
  sb_h=$(height_of "$out.sb")

  local below
  if [ "$layout" = "stack" ]; then
    below=$(( pad + eb_h + gap + hd_h + h * 1 / 100 + sb_h + gap ))
    frame_maxw=$inner
    frame_maxh=$(( h - pad - mw - gap - below ))
    [ "$frame_maxh" -lt $(( h / 8 )) ] && frame_maxh=$(( h / 8 ))
    read -r nw nh <<< "$(shot_fit "$shot" "$frame_maxw" "$frame_maxh")"
    fx=$(( (w - nw) / 2 ))
  fi

  shot_frame "$shot" "$out.fr" "$nw" "$nh" "#FFFFFF" "$CREAM" $(( w / 44 ))
  local fy
  if [ "$layout" = "side" ]; then
    fy=$(( (h - nh) / 2 ))
  else
    fy=$below
  fi
  magick -size "${w}x${h}" xc:"$EMBER" "$out"
  magick "$out" "$out.fr" -geometry +"${fx}"+"${fy}" -composite "$out"
  magick "$out" \( "$mark" -resize "x${mw}" \) \
    -geometry +"$(( text_x + ( text_w - mw ) / 2 ))"+"$(( h - pad - mw ))" -composite "$out"

  local ty block
  block=$(( eb_h + gap + hd_h + h * 1 / 100 + sb_h + gap + mw ))
  if [ "$layout" = "side" ]; then
    ty=$(( (h - block) / 2 ))
  else
    ty=$pad
  fi
  magick "$out" "$out.eb" -geometry +"$(( text_x + ( text_w - $(width_of "$out.eb") ) / 2 ))"+"${ty}" -composite "$out"
  ty=$(( ty + eb_h + gap ))
  magick "$out" "$out.hd" -geometry +"$(( text_x + ( text_w - $(width_of "$out.hd") ) / 2 ))"+"${ty}" -composite "$out"
  ty=$(( ty + hd_h + h * 1 / 100 ))
  magick "$out" "$out.sb" -geometry +"$(( text_x + ( text_w - $(width_of "$out.sb") ) / 2 ))"+"${ty}" -composite "$out"
  rm -f "$out.eb" "$out.hd" "$out.sb" "$out.fr"
}

render_beat() {
  local lang=$1 kind=$2 idx=$3 w=$4 h=$5 hkey=$6 skey=$7 shot=${8:-} layout=${9:-stack}
  local out="$FRAMES/${lang}-${orientation}-${idx}.png"
  if [ "$kind" = "card" ]; then
    beat_card "$lang" "$out" "$w" "$h" "$hkey" "$skey"
  else
    beat_shot "$lang" "$out" "$w" "$h" "$hkey" "$skey" "$shot" "$layout"
  fi
  log "$(basename "$out")"
}

build_video() {
  local lang=$1 orientation=$2 w=$3 h=$4
  local list="$FRAMES/${lang}-${orientation}.txt"
  : > "$list"
  local f
  for f in "$FRAMES/${lang}-${orientation}"-*.png; do
    local clip="$FRAMES/${lang}-${orientation}-$(basename "$f" .png).mp4"
    local fin=0.5
    local fade_out
    fade_out=$(awk "BEGIN{print $BEAT-$fin}")
    ffmpeg -y -loglevel error -loop 1 -framerate 30 -t "$BEAT" -i "$f" \
      -vf "scale=iw*1.08:ih*1.08,zoompan=z='min(zoom+0.00045,1.05)':d=1:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=${w}x${h}:fps=30,fade=t=in:st=0:d=0.45:color=${EMBER},fade=t=out:st=${fade_out}:d=${fin}:color=${EMBER},format=yuv420p" \
      -c:v libx264 -preset medium -crf 21 -r 30 "$clip"
    printf "file '%s'\n" "$clip" >> "$list"
    log "$(basename "$clip")"
  done
  local raw="$FRAMES/${lang}-${orientation}-raw.mp4"
  ffmpeg -y -loglevel error -f concat -safe 0 -i "$list" -c copy "$raw"
  ffmpeg -y -loglevel error -i "$raw" -f lavfi -i anullsrc=r=44100:cl=stereo -shortest \
    -c:v copy -c:a aac -b:a 128k -movflags +faststart "$OUT/promo-${orientation}-${lang}.mp4"
  rm -f "$raw" "$list"
  log "video/promo-${orientation}-${lang}.mp4"
}

main() {
  local langs=${1:-both}
  mkdir -p "$FRAMES"
  local langs_list=("en" "es")
  [ "$langs" = "en" ] && langs_list=("en")
  [ "$langs" = "es" ] && langs_list=("es")

  local s_cat="$SHOTS/phone-01-practice-catalog.png"
  local s_paths="$SHOTS/phone-02-go-paths.png"
  local s_keys="$SHOTS/phone-07-profile-keyboard.png"
  local s_edit="$SHOTS/phone-08-keyboard-editor.png"
  local s_free="$SHOTS/phone-06-free-practice.png"

  for lang in "${langs_list[@]}"; do
    orientation=vertical
    rm -f "$FRAMES/${lang}-vertical"-*.png
    render_beat "$lang" card 1 1080 1920 h1 s1
    render_beat "$lang" shot 2 1080 1920 h2 s2 "$s_cat"
    render_beat "$lang" shot 3 1080 1920 h3 s3 "$s_paths"
    render_beat "$lang" shot 4 1080 1920 h4 s4 "$s_keys"
    render_beat "$lang" shot 5 1080 1920 h5 s5 "$s_free"
    render_beat "$lang" card 6 1080 1920 store cta
    build_video "$lang" vertical 1080 1920

    orientation=horizontal
    rm -f "$FRAMES/${lang}-horizontal"-*.png
    render_beat "$lang" card 1 1920 1080 h1 s1
    render_beat "$lang" shot 2 1920 1080 h2 s2 "$s_cat" side
    render_beat "$lang" shot 3 1920 1080 h3 s3 "$s_paths" side
    render_beat "$lang" shot 4 1920 1080 h4 s4 "$s_edit" side
    render_beat "$lang" shot 5 1920 1080 h5 s5 "$s_free" side
    render_beat "$lang" card 6 1920 1080 store cta
    build_video "$lang" horizontal 1920 1080
  done
  log "videos en $OUT"
}

main "$@"