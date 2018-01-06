#/ help            List all scripts commands and make targets
help:
	@./scripts/help world makefile

#/ install         Prints out all of the install commands sequentially
install:
	@echo 'Run:'
	@echo 'scripts/install homebrews'
	@echo 'scripts/install world'

#/ update          Runs all of the update commands
update:
	@./scripts/update world

#/ uninstall       Remove all the crap that was installed
uninstall:
	@./scripts/uninstall world

.PHONY: help install update uninstall
