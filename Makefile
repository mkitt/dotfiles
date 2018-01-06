brews = bash-completion ctags git git-standup heroku hub node ripgrep tidy-html5 tree watchman wget write-good yarn
casks = appcleaner backblaze charles google-chrome gpgtools imageoptim rowanj-gitx shiftit sketch qlstephen
npms = eslint_d
dots = bash_profile bashrc gitconfig gitconfig.local gitignore inputrc vimrc
tmps = tmp/ctrlp tmp/swap tmp/yankring
vimplug = https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# --------------------------------------

help:
	@printf "%sUsage: make TARGET\n"
	@printf "%2shelp        Print this message (default)\n"
	@printf "%2sinstall     Installs homebrews, casks, global npms and dotfiles\n"
	@printf "%2suninstall   Removes homebrews, casks, global npms and dotfiles\n"
	@printf "%2supdate      Updates homebrews, casks and global npm packages\n"
	@printf "%2smacos       Setup macOS defaults: https://mths.be/macos\n"
	@printf "%s\nGlobal packages:\n"
	@printf "%2shomebrews: $(brews)\n"
	@printf "%2scasks: $(casks)\n"
	@printf "%2snpm: $(npms)\n"

install:
	sudo -v
	brew install $(brews)
	brew install macvim --with-override-system-vim
	brew cask install $(casks)
	npm install $(npms) --global
	@for file in $(dots); do ln -sfv `pwd`/$$file $$HOME/.$$file; done
	@if [[ -d $$HOME/.vim ]]; then rm -rf $$HOME/.vim; fi
	@for tmp in $(tmps); do mkdir -pv $$HOME/.vim/$$tmp; done
	@curl -fLo ~/.vim/autoload/plug.vim --create-dirs $(vimplug)
	@printf "%s\nInstall vim plugins: :PlugInstall"
	@printf "%s\nSetup macOS defaults: make macos\n"

uninstall:
	sudo -v
	brew uninstall $(brews) macvim
	brew cask uninstall $(casks)
	npm uninstall $(npms) --global
	@rm -rfv $$HOME/.vim
	@for file in $(dots); do rm -v $$HOME/.$$file; done

update:
	brew update
	brew outdated
	brew upgrade
	brew cleanup
	brew prune
	brew doctor
	brew cask doctor
	npm update $(npms) --global
	@printf "%s\nUpdate vim plugins: :PlugUpgrade, :PlugUpdate\n"

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
	defaults write com.apple.screencapture location -string "${HOME}/Desktop"
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
