DOT_SCRIPTS = ./scripts

# Packages whose contents land directly in $HOME (leading-dot files at top level)
STOW_HOME    = bash czrc vim zsh
# Packages whose contents land under a nested target dir (flat package layout)
STOW_ARIA2   = aria2
STOW_CLAUDE  = claude
STOW_CONFIG  = config

.DEFAULT_GOAL := help

.PHONY: help bootstrap backup install update install-links uninstall-links relink symlinks-check

help:  ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap:  ## Fresh-machine setup: brew + stow + symlinks + make install
	@echo "~>> [[ Bootstrapping fresh machine ]] <<~"
	@echo
	@$(DOT_SCRIPTS)/bootstrap.sh

update:  ## Upgrade brew/npm/pipx/cargo/mas packages and refresh Brewfile
	@echo "~>> [[ Updating ]] <<~"
	@echo
	@$(DOT_SCRIPTS)/update.sh

backup:  ## Re-dump all package lists into Backup/ for committing
	@echo "~>> [[ Backing up ]] <<~"
	@echo
	@$(DOT_SCRIPTS)/backup.sh

install:  ## Install all packages from Backup/ (brew/npm/pip/cargo/fish/tpm)
	@echo "~>> [[ Installing ]] <<~"
	@echo
	@$(DOT_SCRIPTS)/install.sh

install-links:  ## Stow every package into its mapped target
	@echo "~>> [[ Stowing packages ]] <<~"
	@echo
	@mkdir -p $(HOME)/.aria2 $(HOME)/.claude $(HOME)/.config
	stow -v -t $(HOME)          $(STOW_HOME)
	stow -v -t $(HOME)/.aria2   $(STOW_ARIA2)
	stow -v -t $(HOME)/.claude  $(STOW_CLAUDE)
	stow -v -t $(HOME)/.config  $(STOW_CONFIG)

uninstall-links:  ## Remove all stowed symlinks (configs stay in repo)
	@echo "~>> [[ Unstowing packages ]] <<~"
	@echo
	stow -v -D -t $(HOME)          $(STOW_HOME)
	stow -v -D -t $(HOME)/.aria2   $(STOW_ARIA2)
	stow -v -D -t $(HOME)/.claude  $(STOW_CLAUDE)
	stow -v -D -t $(HOME)/.config  $(STOW_CONFIG)

relink: uninstall-links install-links  ## Re-run unstow then stow (after adding files)

symlinks-check:  ## Verify every package file has a healthy symlink at its target
	@$(DOT_SCRIPTS)/check-links.sh
