#!/usr/bin/env bash
# Run once per clone: points git at the versioned hooks in tool/git-hooks/
# instead of the default (untracked) .git/hooks/.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

chmod +x tool/git-hooks/pre-commit tool/git-hooks/pre-push tool/format.sh tool/check.sh
git config core.hooksPath tool/git-hooks

echo "Git hooks installed (core.hooksPath = tool/git-hooks)."
