#!/usr/bin/env bash
# Runs tool/version_bump.dart and, if it found release-worthy Conventional
# Commits, commits the pubspec.yaml + CHANGELOG.md bump and tags it. This is
# the only path that should ever move the version forward (STACK.md §10.4) —
# never bump pubspec.yaml by hand. Safe to run locally or in CI; does not
# push, so the caller decides when the tag becomes visible to others.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

set +e
output="$(dart run tool/version_bump.dart)"
status=$?
set -e

echo "$output"

if [ "$status" -eq 3 ]; then
  exit 0
elif [ "$status" -ne 0 ]; then
  exit "$status"
fi

new_version_full="$(echo "$output" | grep '^NEW_VERSION=' | cut -d= -f2)"
version_name="${new_version_full%%+*}"

git add pubspec.yaml CHANGELOG.md
git commit -m "chore(release): v${version_name} [skip ci]"
git tag -a "v${version_name}" -m "v${version_name}"

echo "release: tagged v${version_name} (not pushed)."
