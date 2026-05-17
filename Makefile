DOT_SCRIPTS = ./scripts

# Auto-discover packages: every top-level dir except these
EXCLUDE_DIRS    = scripts Backup .github .git
STOW_PACKAGES  := $(filter-out $(EXCLUDE_DIRS),$(patsubst %/,%,$(wildcard */)))

.DEFAULT_GOAL := help

.PHONY: help bootstrap backup install update install-links uninstall-links relink symlinks-check doctor print-packages

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

install-links:  ## Stow every package into $HOME
	@echo "~>> [[ Stowing $(words $(STOW_PACKAGES)) packages ]] <<~"
	@echo
	@mkdir -p $(HOME)/.config $(HOME)/.aria2 $(HOME)/.claude
	stow -v --no-folding -t $(HOME) $(STOW_PACKAGES)

uninstall-links:  ## Remove all stowed symlinks (configs stay in repo)
	@echo "~>> [[ Unstowing $(words $(STOW_PACKAGES)) packages ]] <<~"
	@echo
	stow -v --no-folding -D -t $(HOME) $(STOW_PACKAGES)

relink: uninstall-links install-links  ## Re-run unstow then stow (after adding files)

symlinks-check:  ## Verify every package file has a healthy symlink at its target
	@$(DOT_SCRIPTS)/check-links.sh

doctor:  ## Run all repo health checks (script syntax, symlinks, Brewfile, git state)
	@$(DOT_SCRIPTS)/doctor.sh

print-packages:  ## Print the auto-discovered package list
	@echo $(STOW_PACKAGES)
