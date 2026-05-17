DOT_SCRIPTS = ./scripts
STOW_PACKAGES = aria2 bash claude config czrc vim zsh

.PHONY: bootstrap backup install update install-links uninstall-links relink

bootstrap:
	@echo "~>> [[ Bootstrapping fresh machine ]] <<~"
	@echo
	@bash -c $(DOT_SCRIPTS)/bootstrap.sh

update:
	@echo "~>> [[ Updating ]] <<~"
	@echo
	@bash -c $(DOT_SCRIPTS)/update.sh

backup:
	@echo "~>> [[ Backing up ]] <<~"
	@echo
	@bash -c $(DOT_SCRIPTS)/backup.sh

install:
	@echo "~>> [[ Installing ]] <<~"
	@echo
	@bash -c $(DOT_SCRIPTS)/install.sh

install-links:
	@echo "~>> [[ Stowing packages into \$$HOME ]] <<~"
	@echo
	stow -v -t $(HOME) $(STOW_PACKAGES)

uninstall-links:
	@echo "~>> [[ Unstowing packages from \$$HOME ]] <<~"
	@echo
	stow -v -D -t $(HOME) $(STOW_PACKAGES)

relink: uninstall-links install-links
