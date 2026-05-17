DOT_SCRIPTS = ./scripts

# Packages whose contents land directly in $HOME (leading-dot files at top level)
STOW_HOME    = bash czrc vim zsh
# Packages whose contents land under a nested target dir (flat package layout)
STOW_ARIA2   = aria2
STOW_CLAUDE  = claude
STOW_CONFIG  = config

.PHONY: bootstrap backup install update install-links uninstall-links relink symlinks-check

bootstrap:
	@echo "~>> [[ Bootstrapping fresh machine ]] <<~"
	@echo
	@$(DOT_SCRIPTS)/bootstrap.sh

update:
	@echo "~>> [[ Updating ]] <<~"
	@echo
	@$(DOT_SCRIPTS)/update.sh

backup:
	@echo "~>> [[ Backing up ]] <<~"
	@echo
	@$(DOT_SCRIPTS)/backup.sh

install:
	@echo "~>> [[ Installing ]] <<~"
	@echo
	@$(DOT_SCRIPTS)/install.sh

install-links:
	@echo "~>> [[ Stowing packages ]] <<~"
	@echo
	@mkdir -p $(HOME)/.aria2 $(HOME)/.claude $(HOME)/.config
	stow -v -t $(HOME)          $(STOW_HOME)
	stow -v -t $(HOME)/.aria2   $(STOW_ARIA2)
	stow -v -t $(HOME)/.claude  $(STOW_CLAUDE)
	stow -v -t $(HOME)/.config  $(STOW_CONFIG)

uninstall-links:
	@echo "~>> [[ Unstowing packages ]] <<~"
	@echo
	stow -v -D -t $(HOME)          $(STOW_HOME)
	stow -v -D -t $(HOME)/.aria2   $(STOW_ARIA2)
	stow -v -D -t $(HOME)/.claude  $(STOW_CLAUDE)
	stow -v -D -t $(HOME)/.config  $(STOW_CONFIG)

relink: uninstall-links install-links

symlinks-check:
	@$(DOT_SCRIPTS)/check-links.sh
