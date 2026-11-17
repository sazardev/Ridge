#!/usr/bin/env bash
# Terminal matrix smoke test: start the TUI under the environments the app is
# expected to survive — light/dark, truecolor/256/ANSI, NO_COLOR, dumb, tiny and
# huge windows, and a non-UTF-8 locale — then check the first frame is alive.
#
# Uses `script` to allocate a PTY, so it runs in CI without a desktop terminal.
# This is a smoke test: the detailed color/width assertions live in the Go suite
# (theme_test.go, app_test.go, ascii.go).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
bin="${1:-$here/../bin/ridge}"
[ -x "$bin" ] || { echo "missing $bin — run: make build" >&2; exit 1; }

tmp="$(mktemp -d "${TMPDIR:-/tmp}/ridge-matrix.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT
fail=0

# run <name> <env assignments> <cols> <rows>
run() {
  local name="$1" envs="$2" cols="$3" rows="$4"
  local out="$tmp/$name.out"
  local data="$tmp/$name.db"
  mkdir -p "$data"
  local code=0
  # stty runs inside the PTY script allocates; screen/tmux terms skip OSC 11.
  timeout 2 script -qec "stty rows $rows cols $cols; exec env RIDGE_DATA='$data' $envs" /dev/null >"$out" 2>&1 || code=$?
  # 124 = still running when the timer fired, which is what a TUI does.
  if [ "$code" != 0 ] && [ "$code" != 124 ]; then
    echo "FAIL $name (exit $code)"; sed -n '1,20p' "$out"; fail=1; return
  fi
  if ! grep -qi "ridge" "$out"; then
    echo "FAIL $name (no frame)"; fail=1; return
  fi
  case "$name" in
    no-color)
      if grep -q $'\x1b\[[0-9;]*m' "$out"; then
        echo "FAIL $name (SGR escapes with NO_COLOR)"; fail=1; return
      fi ;;
    utf8-c-locale)
      if LC_ALL=C grep -qP '[\x80-\xFF]' "$out"; then
        echo "FAIL $name (non-ASCII bytes in C locale)"; fail=1; return
      fi ;;
  esac
  echo "ok   $name"
}

# TERM=screen keeps termenv from blocking on an OSC 11 query (the PTY has no
# real terminal behind it); COLORFGBG still selects the light/dark variant.
run dark-truecolor  "TERM=screen-256color COLORTERM=truecolor COLORFGBG='15;0' '$bin'"     100 30
run light-truecolor "TERM=screen-256color COLORTERM=truecolor COLORFGBG='0;15' '$bin'"      100 30
run ansi16-dark     "TERM=screen COLORTERM= COLORFGBG='15;0' '$bin'"                          100 30
run ansi256-light   "TERM=screen-256color COLORTERM= COLORFGBG='0;15' '$bin'"                 100 30
run no-color        "TERM=screen-256color COLORTERM=truecolor NO_COLOR=1 '$bin'"               100 30
run dumb            "TERM=dumb '$bin'"                                                        100 30
run utf8-c-locale   "TERM=screen-256color COLORFGBG='15;0' LANG=C LC_ALL=C '$bin'"             100 30
run 40x20           "TERM=screen-256color COLORFGBG='15;0' '$bin'"                             40 20
run 80x24           "TERM=screen-256color COLORFGBG='15;0' '$bin'"                             80 24
run 200x60          "TERM=screen-256color COLORFGBG='15;0' '$bin'"                            200 60
run 60x50-square    "TERM=screen-256color COLORFGBG='15;0' '$bin'"                             60 50
run 60x80-portrait  "TERM=screen-256color COLORFGBG='15;0' '$bin'"                             60 80
run 160x40-landscape "TERM=screen-256color COLORFGBG='15;0' '$bin'"                           160 40
run 100x26-short    "TERM=screen-256color COLORFGBG='15;0' '$bin'"                            100 26

if [ "$fail" != 0 ]; then
  echo "terminal matrix failed" >&2
  exit 1
fi
echo "terminal matrix passed"
