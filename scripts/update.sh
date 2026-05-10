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
    printf '\n%s==> %s%s\n' "$GREEN" "$*" "$CLEAR"
}

print_err() {
    printf '%s%s%s\n' "$RED" "$*" "$CLEAR" >&2
}

print_skip() {
    printf '%s--> skip: %s (%s not found)%s\n' "$YELLOW" "$1" "$2" "$CLEAR"
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
    # shellcheck disable=SC2207  # word splitting on newline-separated crate names is intentional
    crates=( $(cargo install --list | grep -E '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ') )
    if [ "${#crates[@]}" -gt 0 ]; then
        track "Rust" cargo install "${crates[@]}"
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

printf '\n%s%s==> Summary%s\n' "$BLUE" "$BOLD" "$CLEAR"
for s in "${SUCCEEDED[@]}"; do
    printf '  %s✓%s %s\n' "$GREEN" "$CLEAR" "$s"
done
for s in "${SKIPPED[@]}"; do
    printf '  %s-%s %s (skipped)\n' "$YELLOW" "$CLEAR" "$s"
done
for s in "${FAILED[@]}"; do
    printf '  %s✗%s %s\n' "$RED" "$CLEAR" "$s"
done

[ ${#FAILED[@]} -eq 0 ]
