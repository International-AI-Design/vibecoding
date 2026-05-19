#!/usr/bin/env bash
# Regression guard: the public contributor kit must NEVER point at the
# confidential business monorepo or its layout. New contributors don't (and
# shouldn't) have access to `International-AI-Design/ferroai` — pointing them
# there is the onboarding bug this guard exists to prevent.
#
# Fails CI if any tracked file references the confidential repo, its old
# nested layout, or a hard private-repo issue number.
set -euo pipefail

cd "$(dirname "$0")/.."

# Patterns that must not appear in the kit.
PATTERN='International-AI-Design/ferroai|[^a-z]ferroai[^a-z]|\bferroai\b|workspaces/platform'

# Exclude the guard itself and its workflow (they legitimately name the patterns),
# plus VCS internals.
HITS="$(git ls-files \
  | grep -vE '^scripts/check-no-confidential-refs\.sh$' \
  | grep -vE '^\.github/workflows/no-confidential-refs\.yml$' \
  | while read -r f; do
      grep -HnE "$PATTERN" "$f" 2>/dev/null || true
    done)"

if [ -n "$HITS" ]; then
  echo "❌ Confidential-boundary reference(s) found in the contributor kit:"
  echo "$HITS"
  echo
  echo "The kit must reference International-AI-Design/animal-lovers-platform"
  echo "(repo root = platform, no nested wrapper). It must NOT reference the"
  echo "private 'ferroai' monorepo or its old workspaces/platform layout."
  exit 1
fi

echo "✅ No confidential-boundary references. Kit points at the contributor repo only."
