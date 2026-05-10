#!/usr/bin/env bash
set -euo pipefail

BREWFILE=~/Backup/Brewfile
CARGOFILE=~/Backup/Cargofile
FISHFILE=~/Backup/Fishfile
NPMFILE=~/Backup/Npmfile
PIPFILE=~/Backup/Pipfile

echo "------------------------------------"
echo "- Installing BREW and MAS packages -"
echo "------------------------------------"
if command -v brew >/dev/null 2>&1 && [ -f "$BREWFILE" ]; then
	brew bundle install --file="$BREWFILE"
else
	echo "skip: brew not installed or $BREWFILE missing"
fi

echo "------------------------------------"
echo "- Installing NPM packages          -"
echo "------------------------------------"
if command -v npm >/dev/null 2>&1 && [ -s "$NPMFILE" ]; then
	xargs npm install --location=global <"$NPMFILE"
else
	echo "skip: npm not installed or $NPMFILE empty"
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
echo "- Installing CARGO packages        -"
echo "------------------------------------"
if command -v cargo >/dev/null 2>&1 && [ -s "$CARGOFILE" ]; then
	xargs cargo install <"$CARGOFILE"
else
	echo "skip: cargo not installed or $CARGOFILE empty"
fi

echo "------------------------------------"
echo "- Installing FISH packages         -"
echo "------------------------------------"
if command -v fish >/dev/null 2>&1 && [ -f "$FISHFILE" ]; then
	while IFS= read -r plugin; do
		[ -z "$plugin" ] && continue
		echo "$plugin"
		fish -c "fisher install $plugin"
	done <"$FISHFILE"
else
	echo "skip: fish not installed or $FISHFILE missing"
fi

echo "------------------------------------"
echo "- Installing TPM                   -"
echo "------------------------------------"
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
	git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins"
