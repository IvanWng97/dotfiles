#!/usr/bin/env zsh
#
# Verify every file in every stow package has a matching symlink at the
# package's stow target, and report any dangling dotfiles symlinks left
# over from removed files.
#
# Exit 0 if everything is healthy, 1 otherwise.

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

typeset -i ok_count=0
missing=()
not_symlink=()
wrong_target=()
broken=()

info "Checking package files have matching symlinks at their stow targets"
cd "$REPO_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
	[[ -d $pkg ]] || { warn "package dir missing: $pkg"; continue; }
	target_base="${PKG_TARGET[$pkg]}"
	while IFS= read -r -d $'\0' file; do
		rel="${file#$pkg/}"
		target="$target_base/$rel"
		expected="$REPO_DIR/$file"

		if [[ ! -L $target ]]; then
			if [[ -e $target ]]; then
				not_symlink+=("$target")
			else
				missing+=("$target")
			fi
			continue
		fi

		resolved="${target:A}"
		if [[ $resolved != $expected ]]; then
			wrong_target+=("$target -> $resolved (expected $expected)")
		elif [[ ! -e $target ]]; then
			broken+=("$target -> $(readlink "$target")")
		else
			(( ++ok_count ))
		fi
	done < <(find "$pkg" -type f -not -name '.DS_Store' -print0)
done

info "Looking for orphan symlinks under \$HOME (point into dotfiles/, target gone)"
orphans=()
while IFS= read -r -d $'\0' link; do
	[[ -e $link ]] || orphans+=("$link -> $(readlink "$link")")
done < <(find "$HOME" -maxdepth 5 -type l -lname '*dotfiles/*' -print0 2>/dev/null)

print
typeset -i total_bad=$(( ${#missing} + ${#not_symlink} + ${#wrong_target} + ${#broken} + ${#orphans} ))

if (( ${#missing} > 0 )); then
	bad "MISSING (${#missing}): symlink not created — run 'make install-links'"
	printf '    %s\n' "${missing[@]}"
fi
if (( ${#not_symlink} > 0 )); then
	bad "NOT SYMLINK (${#not_symlink}): a real file/dir is shadowing the target"
	printf '    %s\n' "${not_symlink[@]}"
fi
if (( ${#wrong_target} > 0 )); then
	bad "WRONG TARGET (${#wrong_target}): symlink points to the wrong place"
	printf '    %s\n' "${wrong_target[@]}"
fi
if (( ${#broken} > 0 )); then
	bad "BROKEN (${#broken}): symlink target is missing"
	printf '    %s\n' "${broken[@]}"
fi
if (( ${#orphans} > 0 )); then
	bad "ORPHAN (${#orphans}): \$HOME symlink whose dotfiles/ target was removed"
	printf '    %s\n' "${orphans[@]}"
fi

if (( total_bad == 0 )); then
	ok "All $ok_count symlinks healthy"
	exit 0
else
	print
	bad "$total_bad issue(s) found; $ok_count healthy"
	exit 1
fi
