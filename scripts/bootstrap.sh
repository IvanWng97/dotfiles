#!/usr/bin/env zsh
#
# Bootstrap a fresh macOS install:
#   1. Verify Xcode Command Line Tools
#   2. Install Homebrew (if missing) and ensure it's on PATH
#   3. Install GNU stow
#   4. Move any conflicting $HOME files aside into a timestamped backup
#   5. Stow every package into its mapped target
#   6. Run scripts/install.sh to install brew/npm/pip/cargo/fish/tpm packages
#      (skip with SKIP_INSTALL=1)
#
# Usage:
#   cd ~/dotfiles && make bootstrap
#   # or directly:
#   scripts/bootstrap.sh
#
# Idempotent — safe to re-run.

set -euo pipefail

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
NC=$'\033[0m'

info() { print -r -- "${BLUE}==>${NC} $*"; }
ok()   { print -r -- "${GREEN}✓${NC} $*"; }
warn() { print -r -- "${YELLOW}!${NC} $*"; }
err()  { print -r -- "${RED}✗${NC} $*" >&2; }

SCRIPT_DIR="${0:A:h}"
REPO_DIR="${SCRIPT_DIR:h}"

typeset -A PKG_TARGET=(
	aria2   "$HOME/.aria2"
	bash    "$HOME"
	claude  "$HOME/.claude"
	config  "$HOME/.config"
	czrc    "$HOME"
	vim     "$HOME"
	zsh     "$HOME"
)
STOW_PACKAGES=("${(@k)PKG_TARGET}")

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
if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi
ok "Homebrew ready ($(brew --version | head -1))"

# 3. GNU stow
if ! command -v stow >/dev/null 2>&1; then
	info "Installing GNU stow..."
	brew install stow
fi
ok "stow ready ($(stow --version | head -1))"

# 4. Move any conflicting files aside
BACKUP_DIR="$HOME/.dotfiles-pre-stow-$(date +%Y%m%d-%H%M%S)"
conflicts=()
conflict_rels=()
cd "$REPO_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
	[[ -d $pkg ]] || continue
	target_base="${PKG_TARGET[$pkg]}"
	while IFS= read -r -d $'\0' file; do
		rel="${file#$pkg/}"
		target="$target_base/$rel"
		if [[ -e $target && ! -L $target ]]; then
			conflicts+=("$target")
			conflict_rels+=("${target#$HOME/}")
		fi
	done < <(find "$pkg" -type f -not -name '.DS_Store' -print0)
done

if (( ${#conflicts} > 0 )); then
	warn "${#conflicts} pre-existing file(s) conflict with stow targets"
	info "Backing them up to $BACKUP_DIR"
	mkdir -p "$BACKUP_DIR"
	for i in {1..${#conflicts}}; do
		dst="$BACKUP_DIR/${conflict_rels[$i]}"
		mkdir -p "${dst:h}"
		mv "${conflicts[$i]}" "$dst"
	done
	ok "Backed up ${#conflicts} file(s) to $BACKUP_DIR"
else
	ok "No conflicting files in target locations"
fi

# 5. Stow each package to its mapped target
info "Stowing packages"
mkdir -p "$HOME/.aria2" "$HOME/.claude" "$HOME/.config"
cd "$REPO_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
	[[ -d $pkg ]] || continue
	stow -v -t "${PKG_TARGET[$pkg]}" "$pkg"
done
ok "Symlinks created"

# 6. Install packages (skippable)
if [[ ${SKIP_INSTALL:-0} == 1 ]]; then
	warn "SKIP_INSTALL=1 — skipping scripts/install.sh"
else
	info "Running scripts/install.sh (brew/npm/pip/cargo/fish/tpm)"
	"$SCRIPT_DIR/install.sh"
fi

print
ok "Bootstrap complete. Open a new terminal to pick up the new shell config."
