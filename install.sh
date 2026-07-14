#!/usr/bin/env bash
# AI Design System — installer
#
# SAFE BY DEFAULT. This script will never silently replace an existing config.
#
# What it does:
#   1. Installs the method docs + templates to ~/.claude/ads/   (always safe — own namespace)
#   2. Installs ~/.claude/CLAUDE.md and ~/.claude/MEMORY.md ONLY if they don't exist.
#      If they DO exist, it writes a .suggested file next to them and tells you.
#   3. Never touches ~/.claude/settings.json. Prints guidance instead.
#
# Re-running is safe. Docs are refreshed; your configs are never clobbered.
#
# Flags:
#   --force    Overwrite existing CLAUDE.md / MEMORY.md (timestamped backup first)
#   --dry-run  Show what would happen, change nothing

set -euo pipefail

KIT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
ADS_DIR="$CLAUDE_DIR/ads"

FORCE=0
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --force)   FORCE=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown flag: $arg (try --help)" >&2; exit 1 ;;
  esac
done

BOLD='\033[1m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; DIM='\033[2m'; NC='\033[0m'
say()  { echo -e "${GREEN}[ads]${NC} $1"; }
warn() { echo -e "${YELLOW}[ads]${NC} $1"; }
err()  { echo -e "${RED}[ads]${NC} $1"; }
skip() { echo -e "${DIM}[ads] $1${NC}"; }

echo ""
echo -e "${BOLD}AI Design System${NC} — installing"
echo -e "${DIM}kit:    $KIT_DIR${NC}"
echo -e "${DIM}target: $CLAUDE_DIR${NC}"
[ "$DRY_RUN" -eq 1 ] && warn "DRY RUN — nothing will be written"
echo ""

# ─── Prerequisites ────────────────────────────────────────────────
# Only `claude` is genuinely required. git/gh are strongly recommended but the
# method works without them — don't hard-fail someone out of the method
# because they haven't installed the GitHub CLI.

MISSING_REQUIRED=0

if command -v claude >/dev/null 2>&1; then
  say "✓ claude  $(command -v claude)"
else
  err "✗ claude — Claude Code CLI not found. This kit is for Claude Code."
  err "  Install: https://docs.claude.com/claude-code"
  MISSING_REQUIRED=1
fi

for cmd in git gh; do
  if command -v "$cmd" >/dev/null 2>&1; then
    say "✓ $cmd  $(command -v "$cmd")"
  else
    warn "○ $cmd not found (recommended, not required) — brew install $cmd"
  fi
done

if [ "$MISSING_REQUIRED" -ne 0 ]; then
  echo ""
  err "Install Claude Code, then re-run."
  exit 1
fi
echo ""

# ─── Helpers ──────────────────────────────────────────────────────

run() { [ "$DRY_RUN" -eq 1 ] && echo -e "${DIM}    would run: $*${NC}" || "$@"; }

# Install a file only if the destination doesn't exist.
# If it exists: leave it alone, drop a .suggested alongside, and report.
install_safe() {
  local src="$1" dest="$2" label="$3"

  if [ ! -f "$src" ]; then
    warn "missing source: $src — skipping $label"
    return
  fi

  if [ ! -f "$dest" ]; then
    run cp "$src" "$dest"
    say "✓ installed $dest ${DIM}($label)${NC}"
    return
  fi

  if [ "$FORCE" -eq 1 ]; then
    local backup="${dest}.backup-$(date +%Y%m%d-%H%M%S)"
    run cp "$dest" "$backup"
    run cp "$src" "$dest"
    warn "↻ replaced $dest ${DIM}(backup: $(basename "$backup"))${NC}"
    return
  fi

  # The safe path: don't touch it.
  run cp "$src" "${dest}.suggested"
  warn "⊙ $dest already exists — NOT modified."
  echo -e "     ${DIM}Our version is at ${dest}.suggested${NC}"
  echo -e "     ${DIM}Compare: diff ${dest} ${dest}.suggested${NC}"
  PREEXISTING+=("$dest")
}

PREEXISTING=()

# ─── 1. Method docs + templates (own namespace — always safe) ──────

run mkdir -p "$ADS_DIR" "$ADS_DIR/templates"

for f in THE-METHOD SESSION-PLAYBOOK DEVELOPMENT-PROTOCOL MEMORY-ARCHITECTURE LESSONS_LEARNED CROSS-FEEDBACK; do
  if [ -f "$KIT_DIR/docs/$f.md" ]; then
    run cp "$KIT_DIR/docs/$f.md" "$ADS_DIR/$f.md"
  fi
done
say "✓ method docs → $ADS_DIR/"

run cp "$KIT_DIR/templates/project-CLAUDE.md" "$ADS_DIR/templates/project-CLAUDE.md"
run cp "$KIT_DIR/templates/spec.md"           "$ADS_DIR/templates/spec.md"
say "✓ templates   → $ADS_DIR/templates/"
echo ""

# ─── 2. Base config (never silently clobbered) ────────────────────

install_safe "$KIT_DIR/claude-files/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" "base harness"
install_safe "$KIT_DIR/claude-files/MEMORY.md" "$CLAUDE_DIR/MEMORY.md" "memory index"
echo ""

# ─── 3. settings.json — never auto-written ────────────────────────
# Permissions are personal and security-relevant. Overwriting someone's
# settings.json could silently widen what runs without confirmation.

if [ -f "$CLAUDE_DIR/settings.json" ]; then
  skip "○ settings.json exists — left alone (permissions are yours to own)."
  run cp "$KIT_DIR/settings/settings.json" "$ADS_DIR/settings.example.json"
  echo -e "     ${DIM}Reference copy: $ADS_DIR/settings.example.json${NC}"
else
  run cp "$KIT_DIR/settings/settings.json" "$CLAUDE_DIR/settings.json"
  say "✓ installed $CLAUDE_DIR/settings.json"
fi
echo ""

# ─── Done ─────────────────────────────────────────────────────────

echo -e "${BOLD}Install complete.${NC}"
echo ""

if [ ${#PREEXISTING[@]} -gt 0 ]; then
  warn "You already had these — we did NOT overwrite them:"
  for f in "${PREEXISTING[@]}"; do echo "     • $f"; done
  echo ""
  echo "  Merge what you want from the .suggested files, or re-run with --force"
  echo "  to replace them (a timestamped backup is made first)."
  echo ""
fi

echo "Next:"
echo ""
echo -e "  ${BOLD}1.${NC} Read the method — it's the whole point:"
echo "       $ADS_DIR/THE-METHOD.md"
echo ""
echo -e "  ${BOLD}2.${NC} Then the session ritual:"
echo "       $ADS_DIR/SESSION-PLAYBOOK.md"
echo ""
echo -e "  ${BOLD}3.${NC} Starting a project? Copy the template into it:"
echo "       cp $ADS_DIR/templates/project-CLAUDE.md <your-repo>/CLAUDE.md"
echo ""
echo -e "  ${BOLD}4.${NC} Open Claude Code in a real project and try the spec prompt"
echo "     from THE-METHOD Layer 1. Don't start by building — start by"
echo "     making it interview you."
echo ""
echo -e "${DIM}The kit only gets good through use. When something here is wrong,${NC}"
echo -e "${DIM}file it: bash $KIT_DIR/scripts/file-feedback.sh${NC}"
echo ""
