brews = git gh node ripgrep tree watchman
casks = abstract appcleaner backblaze gpg-suite imageoptim insomnia rectangle rowanj-gitx slack zoom
cocs = coc-css coc-eslint coc-html coc-json coc-marketplace coc-lists coc-prettier coc-sh coc-tsserver coc-vimlsp coc-yaml
dots = gitconfig gitconfig.local vimrc zprofile zshrc
tmps = tmp/yankring
plug = https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# --------------------------------------

#/ help            Print this message (default)
help:
	@printf "%sUsage: make TARGET\n"
	@cat ./Makefile | grep '^#\/' | sed "s/#\//  /g"
	@printf "%s\nGlobal packages:\n"
	@printf "%sbrew: $(brews)\n"
	@printf "%scask: $(casks)\n"
	@printf "%scocs: $(cocs)\n"

#/ install         Installs homebrews, casks and dotfiles
install:
	sudo -v
	brew install $(brews)
	brew install macvim
	brew install --cask $(casks)
	npm install -g @tailwindcss/language-server graphql-language-service-cli graphql
	@for file in $(dots); do ln -sfv `pwd`/$$file $$HOME/.$$file; done
	@if [[ -d $$HOME/.vim ]]; then rm -rf $$HOME/.vim; fi
	@for tmp in $(tmps); do mkdir -pv $$HOME/.vim/$$tmp; done
	@ln -sfv `pwd`/coc-settings.json $$HOME/.vim/
	@curl -fLo ~/.vim/autoload/plug.vim --create-dirs $(plug)
	@printf "%s\nInstall vim plugins: :PlugInstall and :CocInstall $(cocs)"
	@printf "%s\nSetup gh defaults: make gh\n"
	@printf "%s\nSetup macOS defaults: make macos\n"

#/ uninstall       Removes homebrews, casks and dotfiles
uninstall:
	sudo -v
	brew uninstall $(brews) macvim
	brew uninstall --cask $(casks)
	@rm -rfv $$HOME/.vim
	@for file in $(dots); do rm -v $$HOME/.$$file; done

#/ update          Updates homebrews and casks
update:
	brew update
	@printf "%s----\n"
	brew outdated
	@printf "%s----\n"
	brew upgrade
	@printf "%s----\n"
	brew cleanup
	@printf "%s----\n"
	brew doctor
	@printf "%s----\n"
	npm update -g @tailwindcss/language-server graphql-language-service-cli graphql
	@printf "%sUpdate vim plugins: :PlugUpgrade, :PlugUpdate, :CocRebuild, :CocUpdate\n"

#/ node14          Use node@14 globally from hombrew
node14:
	brew unlink node
	brew link node@14 --force --overwrite

#/ gh              Setup a aliases for the GitHub cli tool
gh:
	gh alias set browse 'repo view --web'

#/ macos           Setup macOS defaults: https://mths.be/macos
macos:
	sudo -v
	@# Automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
	@# Disable press-and-hold for keys in favor of key repeat
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	@# Set a blazingly fast keyboard repeat rate -- REQUIRES LOGOUT!
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
	@# Set Rectangle App settings
	defaults write com.knollsoft.Rectangle almostMaximizeWidth -float 0.95
	defaults write com.knollsoft.Rectangle almostMaximizeHeight -float 0.95
	defaults write com.knollsoft.Rectangle curtainChangeSize -int 2
	defaults write com.knollsoft.Rectangle specified -dict-add keyCode -float 45 modifierFlags -float 786721
	defaults write com.knollsoft.Rectangle specifiedWidth -float 2048
	defaults write com.knollsoft.Rectangle specifiedHeight -float 1152

.PHONY: help install uninstall update macos
