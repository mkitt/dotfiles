brews = fd git gh node ripgrep tree
casks = gpg-suite imageoptim rectangle slack
cocs = coc-css coc-eslint coc-html coc-json coc-lists coc-lua coc-marketplace coc-prettier coc-sh coc-tsserver coc-vimlsp coc-yaml
npms = @tailwindcss/language-server graphql-language-service-cli
dots = gitconfig gitconfig.local vimrc zprofile zshrc

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
	brew install neovim
	brew install --cask $(casks)
	npm install -g $(npms)
	@for file in $(dots); do ln -sfv `pwd`/$$file $$HOME/.$$file; done
	@if [[ -d $$HOME/.config/nvim ]]; then rm -rf $$HOME/.config/nvim; fi
	@mkdir -pv $$HOME/.config/nvim
	@ln -sfv `pwd`/coc-settings.json $$HOME/.config/nvim/
	@ln -sfv `pwd`/init.lua $$HOME/.config/nvim/
	@git clone --depth 1 https://github.com/wbthomason/packer.nvim\
		~/.local/share/nvim/site/pack/packer/start/packer.nvim
	@printf "%s\nInstall nvim plugins: :PackerInstall and :CocInstall $(cocs)"
	@printf "%s\nSetup macOS defaults: make macos\n"

#/ uninstall       Removes homebrews, casks and dotfiles
uninstall:
	sudo -v
	brew uninstall $(brews) macvim
	brew uninstall --cask $(casks)
	@rm -rfv $$HOME/.config
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
	npm update -g $(npms)
	@printf "%sUpdate nvim plugins: :PackerUpdate, :TSUpdate, :CocUpdate\n"

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
