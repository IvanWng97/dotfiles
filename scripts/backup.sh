#!/usr/bin/env zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
BACKUP_DIR="${SCRIPT_DIR:h}/Backup"
BREWFILE="$BACKUP_DIR/Brewfile"
PIPFILE="$BACKUP_DIR/requirements.txt"
CLAUDE_SETTINGS="$BACKUP_DIR/claude-settings.json"

mkdir -p "$BACKUP_DIR"

# Every dump overwrites its manifest in place; a missing tool leaves the
# committed file untouched instead of deleting it.

echo "---------------------------------"
echo "- Dumping BREW bundle           -"
echo "---------------------------------"
# Covers taps, formulas, casks, mas, vscode extensions, cargo and npm
# packages in one manifest.
if command -v brew >/dev/null 2>&1; then
	brew bundle dump --force --file="$BREWFILE"
else
	echo "skip: brew not installed"
fi

echo "---------------------------------"
echo "- Dumping PIP packages          -"
echo "---------------------------------"
if command -v pip3 >/dev/null 2>&1; then
	pip3 freeze >"$PIPFILE"
else
	echo "skip: pip3 not installed"
fi

echo "---------------------------------"
echo "- Syncing Claude settings       -"
echo "---------------------------------"
# ~/.claude/settings.json is not stowed (Claude Code rewrites it in
# place); snapshot the live file into Backup/ for committing.
if [ -f "$HOME/.claude/settings.json" ]; then
	cp "$HOME/.claude/settings.json" "$CLAUDE_SETTINGS"
else
	echo "skip: ~/.claude/settings.json missing"
fi
