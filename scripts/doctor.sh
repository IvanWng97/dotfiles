#!/usr/bin/env zsh
#
# Repo health check — runs all the checks you'd want before/after a refactor.
#
#   1. zsh -n on every script (syntax)
#   2. symlinks-check (every package file has a healthy $HOME symlink)
#   3. Brewfile parses (brew bundle list)
#   4. git working tree clean
#
# Exit 0 if everything's healthy, 1 otherwise.

set -euo pipefail

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
NC=$'\033[0m'

info() { print -r -- "${BLUE}==>${NC} $*"; }
ok()   { print -r -- "${GREEN}✓${NC} $*"; }
bad()  { print -r -- "${RED}✗${NC} $*"; }
warn() { print -r -- "${YELLOW}!${NC} $*"; }

SCRIPT_DIR="${0:A:h}"
REPO_DIR="${SCRIPT_DIR:h}"

typeset -i failures=0

info "1/4 zsh -n on scripts/*.sh"
cd "$REPO_DIR"
for f in scripts/*.sh; do
	if zsh -n "$f" 2>/dev/null; then
		ok "  $f"
	else
		bad "  $f"
		(( ++failures ))
	fi
done

info "2/4 symlinks-check"
if "$SCRIPT_DIR/check-links.sh" >/dev/null 2>&1; then
	ok "  all symlinks resolve"
else
	bad "  symlinks-check failed — run 'make symlinks-check' for details"
	(( ++failures ))
fi

info "3/4 Brewfile parses"
if command -v brew >/dev/null 2>&1; then
	if brew bundle list --file=Backup/Brewfile >/dev/null 2>&1; then
		count=$(brew bundle list --file=Backup/Brewfile 2>/dev/null | wc -l | tr -d ' ')
		ok "  Brewfile lists $count entries"
	else
		bad "  brew bundle list failed"
		(( ++failures ))
	fi
else
	warn "  skip: brew not installed"
fi

info "4/4 git working tree clean"
if [[ -z "$(git status --porcelain)" ]]; then
	ok "  no uncommitted changes"
else
	dirty_count=$(git status --porcelain | wc -l | tr -d ' ')
	warn "  $dirty_count uncommitted change(s) — not a failure, just FYI"
fi

print
if (( failures == 0 )); then
	ok "Doctor: healthy"
	exit 0
else
	bad "Doctor: $failures check(s) failed"
	exit 1
fi
