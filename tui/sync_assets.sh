#!/usr/bin/env bash
# Copies the Flutter app's bundled content into the embed directory so the TUI
# ships the exact same snippets and learning paths. Run before `go build`.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$here/internal/content/assets"
rm -rf "$dest" && mkdir -p "$dest"
cp -r "$here/../assets/content/snippets" "$dest/snippets"
cp -r "$here/../assets/content/learning_paths" "$dest/learning_paths"
echo "synced $(ls "$dest/snippets" | wc -l) snippet files, $(ls "$dest/learning_paths" | wc -l) paths"
