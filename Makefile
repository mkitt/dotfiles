brews = gh git ripgrep tree
dots = gitconfig gitconfig.local zshrc

# --------------------------------------

#/ help            Print this message (default)
help:
	@echo "Usage: make TARGET"
	@cat ./Makefile | grep '^#\/' | sed "s/#\//  /g"
	@echo
	@echo "Global packages:"
	@echo "brew: $(brews)"

#/ install         Installs homebrews and dotfiles
install:
	/opt/homebrew/bin/brew install $(brews)
	@for file in $(dots); do ln -sfv `pwd`/$$file $$HOME/.$$file; done
	@echo
	@echo "Setup macOS defaults: make macos"

#/ uninstall       Removes homebrews and dotfiles
uninstall:
	brew uninstall $(brews)
	@for file in $(dots); do rm -fv $$HOME/.$$file; done

#/ update          Updates homebrews
update:
	brew update
	@echo "----"
	brew upgrade
	@echo "----"
	brew cleanup
	@echo "----"
	brew doctor || true
	@echo "----"
	@echo "Update complete"

#/ macos           Setup macOS defaults: https://mths.be/macos
macos:
	@# Automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
	@# Disable press-and-hold for keys in favor of key repeat
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	@# Set a blazingly fast keyboard repeat rate -- REQUIRES LOGOUT!
	defaults write NSGlobalDomain KeyRepeat -int 1
	defaults write NSGlobalDomain InitialKeyRepeat -int 15
	@# Save screenshots to Downloads
	defaults write com.apple.screencapture location -string "${HOME}/Downloads"
	@# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true
	@# Avoid creating .DS_Store files on network volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	@# Make Dock icons of hidden applications translucent
	defaults write com.apple.dock showhidden -bool true

.PHONY: help install macos uninstall update
