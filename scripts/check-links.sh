#!/usr/bin/env bash
#
# Verify every file in every stow package has a matching symlink in $HOME
# that resolves to the expected target, and report any dangling dotfiles
# symlinks left over from removed files.
#
# Exit 0 if everything is healthy, 1 otherwise.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { printf "${BLUE}==>${NC} %s\n" "$*"; }
ok()   { printf "${GREEN}✓${NC} %s\n" "$*"; }
bad()  { printf "${RED}✗${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}!${NC} %s\n" "$*"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STOW_PACKAGES=(aria2 bash claude config czrc vim zsh)

ok_count=0
missing=()
not_symlink=()
wrong_target=()
broken=()

info "Checking package files have matching \$HOME symlinks"
cd "$REPO_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
	[ -d "$pkg" ] || { warn "package dir missing: $pkg"; continue; }
	while IFS= read -r -d '' file; do
		rel="${file#"$pkg"/}"
		target="$HOME/$rel"
		expected="$REPO_DIR/$file"

		if [ ! -L "$target" ]; then
			if [ -e "$target" ]; then
				not_symlink+=("$target")
			else
				missing+=("$target")
			fi
			continue
		fi

		resolved="$(cd "$(dirname "$target")" && cd -P "$(dirname "$(readlink "$target")")" 2>/dev/null && pwd)/$(basename "$(readlink "$target")")"
		if [ "$resolved" != "$expected" ]; then
			wrong_target+=("$target -> $resolved (expected $expected)")
		elif [ ! -e "$target" ]; then
			broken+=("$target -> $(readlink "$target")")
		else
			ok_count=$((ok_count + 1))
		fi
	done < <(find "$pkg" -type f -not -name '.DS_Store' -print0)
done

info "Looking for orphan symlinks under \$HOME (point into dotfiles/, target gone)"
orphans=()
while IFS= read -r -d '' link; do
	[ -e "$link" ] || orphans+=("$link -> $(readlink "$link")")
done < <(find "$HOME" -maxdepth 5 -type l -lname '*dotfiles/*' -print0 2>/dev/null)

echo
total_bad=$((${#missing[@]} + ${#not_symlink[@]} + ${#wrong_target[@]} + ${#broken[@]} + ${#orphans[@]}))

if [ "${#missing[@]}" -gt 0 ]; then
	bad "MISSING (${#missing[@]}): symlink not created — run 'make install-links'"
	printf '    %s\n' "${missing[@]}"
fi
if [ "${#not_symlink[@]}" -gt 0 ]; then
	bad "NOT SYMLINK (${#not_symlink[@]}): a real file/dir is shadowing the target"
	printf '    %s\n' "${not_symlink[@]}"
fi
if [ "${#wrong_target[@]}" -gt 0 ]; then
	bad "WRONG TARGET (${#wrong_target[@]}): symlink points to the wrong place"
	printf '    %s\n' "${wrong_target[@]}"
fi
if [ "${#broken[@]}" -gt 0 ]; then
	bad "BROKEN (${#broken[@]}): symlink target is missing"
	printf '    %s\n' "${broken[@]}"
fi
if [ "${#orphans[@]}" -gt 0 ]; then
	bad "ORPHAN (${#orphans[@]}): \$HOME symlink whose dotfiles/ target was removed"
	printf '    %s\n' "${orphans[@]}"
fi

if [ "$total_bad" -eq 0 ]; then
	ok "All $ok_count symlinks healthy"
	exit 0
else
	echo
	bad "$total_bad issue(s) found; $ok_count healthy"
	exit 1
fi
