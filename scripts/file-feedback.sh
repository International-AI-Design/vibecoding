#!/usr/bin/env bash
# vibecoding — file a cross-feedback issue
# Walks the contributor through type + title, then opens gh issue create with
# the right template pre-selected.

set -euo pipefail

REPO="International-AI-Design/vibecoding"

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

say() { echo -e "${GREEN}[feedback]${NC} $1"; }
warn() { echo -e "${YELLOW}[feedback]${NC} $1"; }

if ! command -v gh >/dev/null 2>&1; then
  warn "GitHub CLI (gh) not installed. Install: brew install gh"
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  warn "gh not authenticated. Run: gh auth login"
  exit 1
fi

cat <<'EOF'
What kind of feedback?

  1. Correction — the kit said X, but actually Y
  2. Win — a pattern worked unusually well
  3. Gap — I needed context the kit didn't have
  4. Feature — idea for an addition

EOF

read -rp "Choose (1-4): " choice
echo ""

case "$choice" in
  1) TEMPLATE="feedback-correction.md" ;;
  2) TEMPLATE="feedback-win.md" ;;
  3) TEMPLATE="feedback-gap.md" ;;
  4) TEMPLATE="feature-request.md" ;;
  *) warn "Invalid choice. Exiting."; exit 1 ;;
esac

say "Opening $REPO issue with template $TEMPLATE in your browser…"
gh issue create --repo "$REPO" --template "$TEMPLATE" --web
