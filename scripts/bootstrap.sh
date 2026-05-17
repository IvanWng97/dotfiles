#!/usr/bin/env bash
#
# Bootstrap a fresh macOS install:
#   1. Verify Xcode Command Line Tools
#   2. Install Homebrew (if missing) and ensure it's on PATH
#   3. Install GNU stow
#   4. Move any conflicting $HOME files aside into a timestamped backup
#   5. Stow all dotfile packages into $HOME
#   6. Run scripts/install.sh to install brew/npm/pip/cargo/fish/tpm packages
#      (skip with SKIP_INSTALL=1)
#
# Usage:
#   cd ~/dotfiles && make bootstrap
#   # or directly:
#   bash scripts/bootstrap.sh
#
# Idempotent — safe to re-run.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { printf "${BLUE}==>${NC} %s\n" "$*"; }
ok()   { printf "${GREEN}✓${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}!${NC} %s\n" "$*"; }
err()  { printf "${RED}✗${NC} %s\n" "$*" >&2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STOW_PACKAGES=(aria2 bash claude config czrc vim zsh)

# 1. Xcode Command Line Tools
if xcode-select -p >/dev/null 2>&1; then
	ok "Xcode Command Line Tools installed"
else
	err "Xcode Command Line Tools are required"
	info "Run this in another terminal, then re-run bootstrap:"
	info "    xcode-select --install"
	exit 1
fi

# 2. Homebrew
if ! command -v brew >/dev/null 2>&1; then
	info "Installing Homebrew..."
	NONINTERACTIVE=1 /bin/bash -c \
		"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi
ok "Homebrew ready ($(brew --version | head -1))"

# 3. GNU stow
if ! command -v stow >/dev/null 2>&1; then
	info "Installing GNU stow..."
	brew install stow
fi
ok "stow ready ($(stow --version | head -1))"

# 4. Move any conflicting $HOME files aside
BACKUP_DIR="$HOME/.dotfiles-pre-stow-$(date +%Y%m%d-%H%M%S)"
conflicts=()
cd "$REPO_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
	[ -d "$pkg" ] || continue
	while IFS= read -r -d '' file; do
		rel="${file#"$pkg"/}"
		target="$HOME/$rel"
		if [ -e "$target" ] && [ ! -L "$target" ]; then
			conflicts+=("$rel")
		fi
	done < <(find "$pkg" -type f -not -name '.DS_Store' -print0)
done

if [ "${#conflicts[@]}" -gt 0 ]; then
	warn "${#conflicts[@]} pre-existing file(s) in \$HOME conflict with stow targets"
	info "Backing them up to $BACKUP_DIR"
	mkdir -p "$BACKUP_DIR"
	for c in "${conflicts[@]}"; do
		mkdir -p "$BACKUP_DIR/$(dirname "$c")"
		mv "$HOME/$c" "$BACKUP_DIR/$c"
	done
	ok "Backed up ${#conflicts[@]} file(s) to $BACKUP_DIR"
else
	ok "No conflicting files in \$HOME"
fi

# 5. Stow packages
info "Stowing packages into \$HOME"
cd "$REPO_DIR"
stow -v -t "$HOME" "${STOW_PACKAGES[@]}"
ok "Symlinks created"

# 6. Install packages (skippable)
if [ "${SKIP_INSTALL:-0}" = "1" ]; then
	warn "SKIP_INSTALL=1 — skipping scripts/install.sh"
else
	info "Running scripts/install.sh (brew/npm/pip/cargo/fish/tpm)"
	bash "$SCRIPT_DIR/install.sh"
fi

echo
ok "Bootstrap complete. Open a new terminal to pick up the new shell config."
