# Homebrew git, not macOS's, because gitconfig's pager and zshrc's prompt use
# helpers only it ships.
brews = gh git ripgrep tree
dots = gitconfig gitconfig.local vimrc zshrc

# --------------------------------------

#/ help            Print this message (default)
help:
	@printf "%sUsage: make TARGET\n"
	@cat ./Makefile | grep '^#\/' | sed "s/#\//  /g"
	@printf "%s\nGlobal packages:\n"
	@printf "%sbrew: $(brews)\n"

#/ install         Installs homebrews and dotfiles
install:
	/opt/homebrew/bin/brew install $(brews)
	@for file in $(dots); do ln -sfv `pwd`/$$file $$HOME/.$$file; done
	@printf "%s\nSetup macOS defaults: make macos\n"

#/ uninstall       Removes homebrews and dotfiles
uninstall:
	brew uninstall $(brews)
	@for file in $(dots); do rm -v $$HOME/.$$file; done

#/ update          Updates homebrews
update:
	brew update
	@printf "%s----\n"
	brew outdated
	@printf "%s----\n"
	brew upgrade
	@printf "%s----\n"
	brew cleanup
	@printf "%s----\n"
	brew doctor || true
	@printf "%s----\n"
	@printf "%sUpdate complete\n"

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
