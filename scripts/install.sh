#!/usr/bin/env zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
BACKUP_DIR="${SCRIPT_DIR:h}/Backup"
BREWFILE="$BACKUP_DIR/Brewfile"
PIPFILE="$BACKUP_DIR/requirements.txt"
CLAUDE_SETTINGS="$BACKUP_DIR/claude-settings.json"

echo "------------------------------------"
echo "- Installing BREW bundle           -"
echo "------------------------------------"
# brew bundle natively covers taps, formulas, casks, mas, vscode
# extensions, cargo and npm packages — one manifest for all of them.
if command -v brew >/dev/null 2>&1 && [ -f "$BREWFILE" ]; then
	brew bundle install --file="$BREWFILE"
else
	echo "skip: brew not installed or $BREWFILE missing"
fi

echo "------------------------------------"
echo "- Installing PIP packages          -"
echo "------------------------------------"
if command -v pip3 >/dev/null 2>&1 && [ -f "$PIPFILE" ]; then
	pip3 install --user --break-system-packages -r "$PIPFILE"
else
	echo "skip: pip3 not installed or $PIPFILE missing"
fi

echo "------------------------------------"
echo "- Installing FISH plugins          -"
echo "------------------------------------"
# fisher comes from the Brewfile and reads the stowed
# ~/.config/fish/fish_plugins; `fisher update` installs everything in it.
if command -v fish >/dev/null 2>&1 && [ -f "$HOME/.config/fish/fish_plugins" ]; then
	fish -c "fisher update"
else
	echo "skip: fish not installed or fish_plugins not stowed"
fi

echo "------------------------------------"
echo "- Installing TPM                   -"
echo "------------------------------------"
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
	git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins"

echo "------------------------------------"
echo "- Restoring Claude settings        -"
echo "------------------------------------"
# ~/.claude/settings.json is deliberately NOT stowed — Claude Code
# rewrites it in place, which replaces a symlink with a real file.
# Seed it from the backup only when absent; never clobber a live one.
if [ ! -f "$HOME/.claude/settings.json" ] && [ -f "$CLAUDE_SETTINGS" ]; then
	mkdir -p "$HOME/.claude"
	cp "$CLAUDE_SETTINGS" "$HOME/.claude/settings.json"
	echo "seeded ~/.claude/settings.json from Backup/"
else
	echo "skip: ~/.claude/settings.json already present"
fi
