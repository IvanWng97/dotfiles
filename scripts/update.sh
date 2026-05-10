#!/usr/bin/env bash

readonly RED=$'\033[31m'
readonly GREEN=$'\033[32m'
readonly YELLOW=$'\033[33m'
readonly BLUE=$'\033[34m'
readonly BOLD=$'\033[1m'
readonly CLEAR=$'\033[0m'

SUCCEEDED=()
FAILED=()
SKIPPED=()

println() {
    printf "\n${GREEN}==> %s${CLEAR}\n" "$*"
}

print_err() {
    printf "${RED}%s${CLEAR}\n" "$*" >&2
}

print_skip() {
    printf "${YELLOW}--> skip: %s (%s not found)${CLEAR}\n" "$1" "$2"
    SKIPPED+=("$1")
}

track() {
    local name="$1"; shift
    if "$@"; then
        SUCCEEDED+=("$name")
    else
        print_err "$name update failed"
        FAILED+=("$name")
    fi
}

if command -v brew >/dev/null 2>&1; then
    println "Updating Brew Packages"
    ok=true
    brew update && brew upgrade --greedy || ok=false
    brew cleanup || true
    brew autoremove || true
    if $ok; then
        SUCCEEDED+=("Brew")
    else
        print_err "Brew update failed"
        FAILED+=("Brew")
    fi
else
    print_skip "Brew" "brew"
fi

if command -v npm >/dev/null 2>&1; then
    println "Updating NPM Packages"
    track "NPM" npm update --location=global
else
    print_skip "NPM" "npm"
fi

if command -v pipx >/dev/null 2>&1; then
    println "Updating Pipx Packages"
    track "Pipx" pipx upgrade-all --include-injected
else
    print_skip "Pipx" "pipx"
fi

if command -v cargo >/dev/null 2>&1; then
    println "Updating Rust Packages"
    crates=$(cargo install --list | grep -E '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ')
    if [ -n "$crates" ]; then
        track "Rust" cargo install $crates
    else
        SUCCEEDED+=("Rust")
    fi
else
    print_skip "Rust" "cargo"
fi

if command -v fish >/dev/null 2>&1; then
    println "Updating Fish Packages"
    track "Fish" fish -c "fisher update"
else
    print_skip "Fish" "fish"
fi

if command -v mas >/dev/null 2>&1; then
    println "Updating Mac Apps"
    track "Mac Apps" mas upgrade
else
    print_skip "Mac Apps" "mas"
fi

if [ -x "$HOME/.config/tmux/plugins/tpm/bin/update_plugins" ]; then
    println "Updating Tmux Plugins"
    track "Tmux" "$HOME/.config/tmux/plugins/tpm/bin/update_plugins" all
else
    print_skip "Tmux" "tpm"
fi

if command -v brew >/dev/null 2>&1; then
    println "Refreshing Brewfile"
    track "Brewfile" brew bundle dump --describe --force --file="$HOME/Backup/Brewfile"
fi

printf "\n${BLUE}${BOLD}==> Summary${CLEAR}\n"
for s in "${SUCCEEDED[@]}"; do
    printf "  ${GREEN}✓${CLEAR} %s\n" "$s"
done
for s in "${SKIPPED[@]}"; do
    printf "  ${YELLOW}-${CLEAR} %s (skipped)\n" "$s"
done
for s in "${FAILED[@]}"; do
    printf "  ${RED}✗${CLEAR} %s\n" "$s"
done

[ ${#FAILED[@]} -eq 0 ]
