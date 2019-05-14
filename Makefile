brews = bash-completion ctags git hub ripgrep tidy-html5 tree watchman wget write-good yarn
casks = appcleaner backblaze charles google-chrome gpg-suite graphql-playground imageoptim rowanj-gitx slack shiftit sketch qlstephen
cocs = coc-css coc-eslint coc-html coc-json coc-lists coc-prettier coc-tsserver
npms = eslint_d serve
dots = bash_profile bashrc gitconfig gitconfig.local inputrc vimrc Brewfile
tmps = tmp/ctrlp tmp/yankring
plug = https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# --------------------------------------

#/ help            Print this message (default)
help:
	@printf "%sUsage: make TARGET\n"
	@cat ./Makefile | grep '^#\/' | sed "s/#\//  /g"
	@printf "%s\nGlobal packages:\n"
	@printf "%snpm: $(npms)\n"

#/ install         Installs homebrews, casks, global npms and dotfiles
install:
	sudo -v
	@for file in $(dots); do ln -sfv `pwd`/$$file $$HOME/.$$file; done
	brew bundle install --global --all
	npm install $(npms) --global
	@if [[ -d $$HOME/.vim ]]; then rm -rf $$HOME/.vim; fi
	@for tmp in $(tmps); do mkdir -pv $$HOME/.vim/$$tmp; done
	@ln -sfv `pwd`/coc-settings.json $$HOME/.vim/
	@curl -fLo ~/.vim/autoload/plug.vim --create-dirs $(plug)
	@printf "%s\nInstall vim plugins: :PlugInstall and :CocInstall $(cocs)"
	@printf "%s\nSetup macOS defaults: make macos\n"

#/ uninstall       Removes homebrews, casks, global npms and dotfiles
uninstall:
	sudo -v
	npm uninstall $(npms) --global
	@rm -rfv $$HOME/.vim
	@for file in $(dots); do rm -v $$HOME/.$$file; done

#/ update          Updates homebrews, casks and global npm packages
update:
	brew update
	brew outdated
	brew upgrade
	brew cask outdated
	brew cask upgrade
	brew cleanup
	brew autoremove
	brew doctor
	npm install $(npms) --global
	@printf "%s\nUpdate vim plugins: :PlugUpgrade, :PlugUpdate, :CocUpdate\n"
	@printf "%s\nMay need to run :CocRebuild if node.js was upgraded\n"

#/ macos           Setup macOS defaults: https://mths.be/macos
macos:
	sudo -v
	@# Automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
	@# Disable press-and-hold for keys in favor of key repeat
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	@# Set a blazingly fast keyboard repeat rate
	defaults write NSGlobalDomain KeyRepeat -int 1
	defaults write NSGlobalDomain InitialKeyRepeat -int 15
	@# Save screenshots to the desktop
	defaults write com.apple.screencapture location -string "${HOME}/Downloads"
	@# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "png"
	@# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true
	@# Finder: allow text selection in Quick Look
	defaults write com.apple.finder QLEnableTextSelection -bool true
	@# Avoid creating .DS_Store files on network volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	@# Show the ~/Library folder
	chflags nohidden ~/Library
	@# Make Dock icons of hidden applications translucent
	defaults write com.apple.dock showhidden -bool true

.PHONY: help install uninstall update macos
