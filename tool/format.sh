#!/usr/bin/env bash
# Auto-formats the whole codebase. Dev convenience — not used by hooks/CI,
# which check formatting instead of rewriting it (see tool/check.sh).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

dart format .
