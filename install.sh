#!/usr/bin/env bash
# VibeCoding — IAID contributor kit installer
# Idempotent. Safe to re-run. Only touches ~/.claude/.
#
# What it does:
#   1. Verifies prerequisites (node, pnpm, git, gh, claude)
#   2. Installs Claude Code CLI via brew if missing
#   3. Installs ~/.claude/CLAUDE.md (with timestamped backup)
#   4. Installs ~/.claude/MEMORY.md (with timestamped backup)
#   5. Installs ~/.claude/settings.json (with timestamped backup)
#   6. Verifies gh auth
#   7. Prints next steps

set -euo pipefail

KIT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLAUDE_DIR="$HOME/.claude"

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

say() { echo -e "${GREEN}[vibecoding]${NC} $1"; }
warn() { echo -e "${YELLOW}[vibecoding]${NC} $1"; }
err() { echo -e "${RED}[vibecoding]${NC} $1"; }

say "IAID VibeCoding contributor kit — installing"
say "Kit dir: $KIT_DIR"
say "Target ~/.claude: $CLAUDE_DIR"
echo ""

# ─── Prereq checks ─────────────────────────────────────────────────
check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    say "✓ $1 found ($(which "$1"))"
  else
    warn "✗ $1 NOT found"
    if [ -n "${2:-}" ]; then
      warn "  Install with: $2"
    fi
    return 1
  fi
}

say "Checking prerequisites…"
MISSING=0
check_cmd node "brew install node" || MISSING=1
check_cmd pnpm "npm i -g pnpm" || MISSING=1
check_cmd git "brew install git" || MISSING=1
check_cmd gh "brew install gh" || MISSING=1
echo ""

if [ "$MISSING" -ne 0 ]; then
  err "One or more prerequisites are missing. Install them and re-run."
  exit 1
fi

# ─── Claude Code CLI ──────────────────────────────────────────────
if ! command -v claude >/dev/null 2>&1; then
  say "Installing Claude Code CLI via brew…"
  if command -v brew >/dev/null 2>&1; then
    brew install claude 2>&1 | tail -3 || true
  fi
  if ! command -v claude >/dev/null 2>&1; then
    warn "Claude Code CLI not installed automatically. Install manually:"
    warn "  https://docs.claude.com/claude-code"
  fi
else
  say "✓ Claude Code CLI already installed ($(which claude))"
fi

# ─── ~/.claude dir ────────────────────────────────────────────────
if [ ! -d "$CLAUDE_DIR" ]; then
  say "Creating $CLAUDE_DIR…"
  mkdir -p "$CLAUDE_DIR"
fi

# ─── Helper: install file with timestamped backup ─────────────────
install_file() {
  local src="$1"
  local dest="$2"
  local label="$3"

  if [ ! -f "$src" ]; then
    warn "Missing source $src — skipping $label"
    return
  fi

  if [ -f "$dest" ]; then
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    local backup="${dest}.backup-${ts}"
    warn "Existing $dest — backing up to $backup"
    cp "$dest" "$backup"
  fi

  cp "$src" "$dest"
  say "✓ Installed $dest ($label)"
}

install_file "$KIT_DIR/claude-files/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" "contributor CLAUDE.md"
install_file "$KIT_DIR/claude-files/MEMORY.md" "$CLAUDE_DIR/MEMORY.md" "starter memory index"
install_file "$KIT_DIR/settings/settings.json" "$CLAUDE_DIR/settings.json" "permissions + model template"

# ─── GitHub auth check ────────────────────────────────────────────
echo ""
if gh auth status >/dev/null 2>&1; then
  say "✓ GitHub CLI authenticated as $(gh api user --jq .login 2>/dev/null || echo 'unknown')"
else
  warn "GitHub CLI not authenticated. Run: gh auth login"
fi

# ─── Done ─────────────────────────────────────────────────────────
echo ""
say "Install complete."
echo ""
echo "Next steps:"
echo "  1. Read $KIT_DIR/CONTRIBUTOR_QUICKSTART.md"
echo "  2. Ask Johnny (@Fermin-Robbins) to add you as a collaborator on"
echo "     International-AI-Design/ferroai (the actual platform repo)"
echo "  3. Once added, clone it:"
echo "       gh repo clone International-AI-Design/ferroai ~/code/ferroai"
echo "  4. cd ~/code/ferroai/workspaces/platform && claude"
echo ""
say "Welcome to VibeCoding 🐾"
