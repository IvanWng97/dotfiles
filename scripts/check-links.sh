#!/usr/bin/env zsh
#
# Verify every file in every stow package has a matching symlink in $HOME
# resolving back to the repo file. Reports orphan symlinks (whose dotfiles/
# target was removed) as well.
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

# Auto-discover packages: every top-level dir minus these
NON_PACKAGES=(scripts Backup .github .git)
cd "$REPO_DIR"
STOW_PACKAGES=( *(/N:t) )
STOW_PACKAGES=( ${STOW_PACKAGES:|NON_PACKAGES} )

typeset -i ok_count=0
missing=()
not_symlink=()
wrong_target=()
broken=()

# git ls-files (not find) so gitignored machine-local cruft inside a
# package dir doesn't get demanded a symlink.
info "Checking ${#STOW_PACKAGES} packages for healthy symlinks under \$HOME"
for pkg in "${STOW_PACKAGES[@]}"; do
	[[ -d $pkg ]] || { warn "package dir missing: $pkg"; continue; }
	while IFS= read -r -d $'\0' file; do
		rel="${file#$pkg/}"
		target="$HOME/$rel"
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
	done < <(git ls-files -z -- "$pkg")
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
