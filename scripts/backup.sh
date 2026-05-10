#!/usr/bin/env bash
set -euo pipefail

BREWFILE=~/Backup/Brewfile
CARGOFILE=~/Backup/Cargofile
FISHFILE=~/Backup/Fishfile
NPMFILE=~/Backup/Npmfile
PIPFILE=~/Backup/Pipfile

mkdir -p ~/Backup

echo "---------------------------------"
echo "- Deleting old Backup Files     -"
echo "---------------------------------"
rm -f "$BREWFILE" "$CARGOFILE" "$FISHFILE" "$NPMFILE" "$PIPFILE"

echo "---------------------------------"
echo "- Dumping BREW and MAS packages -"
echo "---------------------------------"
if command -v brew >/dev/null 2>&1; then
	brew bundle dump --describe --file="$BREWFILE"
else
	echo "skip: brew not installed"
fi

echo "---------------------------------"
echo "- Dumping NPM packages          -"
echo "---------------------------------"
if command -v npm >/dev/null 2>&1; then
	npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' >"$NPMFILE"
else
	echo "skip: npm not installed"
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
echo "- Dumping CARGO packages        -"
echo "---------------------------------"
if command -v cargo >/dev/null 2>&1; then
	cargo install --list | grep -E '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ' >"$CARGOFILE"
else
	echo "skip: cargo not installed"
fi

echo "---------------------------------"
echo "- Dumping FISH packages         -"
echo "---------------------------------"
if [ -f ~/.config/fish/fish_plugins ]; then
	cp ~/.config/fish/fish_plugins "$FISHFILE"
else
	echo "skip: ~/.config/fish/fish_plugins missing"
fi
