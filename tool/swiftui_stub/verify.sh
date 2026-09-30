#!/usr/bin/env bash
# Typecheck a SwiftUI snippet with the real Swift compiler, on Linux.
#
# WHY THIS EXISTS
#   Apple's SwiftUI does not exist on the Linux Swift toolchain: inside
#   `docker.io/library/swift:6.2`, `import SwiftUI` fails with
#   "error: no such module 'SwiftUI'". The alternative considered and
#   rejected was building OpenSwiftUI (github.com/OpenSwiftUIProject), which
#   does compile on Linux but needs an 8-10 minute build, ~1.2 GB, and is
#   missing 66 of the APIs this catalog uses -- including `Button("tap") { }`,
#   the single most idiomatic line in a SwiftUI calculator, plus `List`,
#   `TextField`, `ScrollView` and `.buttonStyle`.
#
#   So the catalog's SwiftUI snippets are typechecked against a hand-written
#   stub module (the files next to this script) that declares the API surface
#   with real Swift signatures. That still runs the real swiftc 6.2 front end
#   over every snippet, so it catches Swift syntax errors, wrong argument
#   labels, wrong generic constraints, result-builder misuse and
#   property-wrapper misuse -- including the "use wrapper instead" diagnostic
#   that the @Binding lesson turns on. What it cannot check is whether a real
#   Apple API exists under exactly the name and signature used here; the
#   surface was transcribed from Apple's documentation by hand.
#
# USAGE
#   tool/swiftui_stub/verify.sh <file.swift> [more.swift ...]
#
#   `import SwiftUI` is prepended automatically when a snippet does not already
#   contain it, because only the first lesson of the route carries the import
#   (every other snippet in the catalog follows that convention).
#
#   If `<file>.support.swift` sits next to the snippet, it is compiled together
#   with it in the same module. That is how a snippet which refers to a type
#   taught in an earlier lesson is verified: the support file holds that type,
#   the snippet stays the fragment the catalog ships.
#
# FLAG NOTES
#   -parse-as-library      a lone file is otherwise treated as main.swift, and
#                          `@main` is then rejected ("module that contains
#                          top-level code")
#   -swift-version 5       matches what an Xcode 16+ app template uses; the
#                          stub is deliberately not @MainActor-isolated, so
#                          Swift 6 language mode is not claimed
#   -warnings-as-errors    the same bar the rest of swift_v1.json is held to
#   -I <dir>               where SwiftUI.swiftmodule was emitted
set -uo pipefail

readonly IMAGE="docker.io/library/swift:6.2"
readonly HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -eq 0 ]; then
  echo "usage: verify.sh <file.swift> [...]" >&2
  exit 64
fi

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

# Flat basenames, because the container only sees $workdir and several lessons
# reuse the same file name in different directories.
i=0
for file in "$@"; do
  {
    if ! grep -q '^import SwiftUI$' "$file"; then
      echo 'import SwiftUI'
      echo
    fi
    cat "$file"
  } >"$workdir/snippet$i.swift"
  # A support file is a separate file, and Swift imports are per-file, so it
  # needs its own `import SwiftUI` even when the snippet already has one.
  if [ -f "$file.support.swift" ]; then
    {
      if ! grep -q '^import SwiftUI$' "$file.support.swift"; then
        echo 'import SwiftUI'
        echo
      fi
      cat "$file.support.swift"
    } >"$workdir/support$i.swift"
  fi
  i=$((i + 1))
done

docker run --rm -v "$HERE:/stub:ro" -v "$workdir:/work" -w /work "$IMAGE" \
  bash -c '
    set -uo pipefail
    swiftc -emit-module -module-name SwiftUI -swift-version 5 \
      /stub/SwiftUIStub.swift \
      /stub/SwiftUIStubViews.swift \
      /stub/SwiftUIStubModifiers.swift \
      -emit-module-path /work/SwiftUI.swiftmodule || exit 70
    status=0
    for snippet in /work/snippet*.swift; do
      n="${snippet#/work/snippet}"
      n="${n%.swift}"
      extra=()
      if [ -f "/work/support$n.swift" ]; then
        extra=("/work/support$n.swift")
      fi
      echo "typechecking $(basename "$snippet")"
      if ! swiftc -typecheck -parse-as-library -swift-version 5 \
        -warnings-as-errors -I /work "$snippet" "${extra[@]}"; then
        status=1
      fi
    done
    exit "$status"
  ' || {
    rc=$?
    if [ "$rc" = 70 ]; then
      echo "verify.sh: the stub module itself failed to build" >&2
    fi
    exit "$rc"
  }
