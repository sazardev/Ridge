#!/usr/bin/env bash
# The single source of truth for "is this codebase good?" — run by
# tool/git-hooks/pre-push and by CI (.github/workflows/ci.yml), so the two
# never drift apart. See CODE_STANDARDS.md for what each gate runs and why.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

echo "==> dart format --set-exit-if-changed"
dart format --output=none --set-exit-if-changed .

echo "==> flutter analyze --fatal-infos --fatal-warnings"
flutter analyze --fatal-infos --fatal-warnings

echo "==> tool/check_architecture.dart"
dart run tool/check_architecture.dart

echo "==> flutter test"
flutter test

echo "==> all checks passed"
