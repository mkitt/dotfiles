brews = fd fzf git gh lua-language-server node pnpm pngpaste ripgrep tree tree-sitter tree-sitter-cli
casks = gpg-suite
dots = gitconfig gitconfig.local vimrc zprofile zshrc Brewfile
lsps = \
	@tailwindcss/language-server@latest \
	@vtsls/language-server@latest \
	bash-language-server@latest \
	graphql-language-service-cli@latest \
	vscode-langservers-extracted@latest \
	yaml-language-server@latest

# --------------------------------------

#/ help            Print this message (default)
help:
	@printf "%sUsage: make TARGET\n"
	@cat ./Makefile | grep '^#\/' | sed "s/#\//  /g"
	@printf "%s\nGlobal packages:\n"
	@printf "%sbrew: $(brews)\n"
	@printf "%scask: $(casks)\n"
	@printf "%slsp:  $(lsps)\n"

#/ install         Installs homebrews, casks, dotfiles and LSP servers
install:
	sudo -v
	@if ls /var/db/receipts/com.jamf*.plist >/dev/null 2>&1; then \
		printf "%s\n✓ Jamf MDM detected - treating as work machine\n"; \
		printf "%s  Skipping personal apps (Dropbox, Backblaze, Signal)\n\n"; \
	else \
		printf "%s\n✓ No MDM detected - treating as personal machine\n\n"; \
	fi
	/opt/homebrew/bin/brew bundle install --all
	/opt/homebrew/bin/brew install $(brews)
	/opt/homebrew/bin/brew install neovim
	/opt/homebrew/bin/brew install --cask $(casks)
	@for file in $(dots); do ln -sfv `pwd`/$$file $$HOME/.$$file; done
	@if [[ -d $$HOME/.config/nvim ]]; then rm -rf $$HOME/.config/nvim; fi
	@ln -sfv `pwd`/nvim $$HOME/.config/nvim
	@if [[ -d $$HOME/.config/ghostty ]]; then rm -rf $$HOME/.config/ghostty; fi
	@ln -sfv `pwd`/ghostty $$HOME/.config/ghostty
	@if [[ -L $$HOME/.claude ]]; then rm $$HOME/.claude; fi
	@ln -sfv `pwd`/claude $$HOME/.claude
	pnpm install -g $(lsps)
	@printf "%s\nSetup macOS defaults: make macos\n"

#/ uninstall       Removes homebrews, casks, dotfiles and LSP servers
uninstall:
	sudo -v
	brew uninstall $(brews) neovim
	brew uninstall --cask $(casks)
	pnpm uninstall -g $(lsps)
	@rm -rfv $$HOME/.claude
	@rm -rfv $$HOME/.config
	@rm -rfv $$HOME/.local
	@rm -rfv $$HOME/.config/ghostty
	@for file in $(dots); do rm -v $$HOME/.$$file; done

#/ update          Updates homebrews, casks and LSP servers
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
	pnpm install -g $(lsps)
	@printf "%s----\n"
	@printf "%sUpdate nvim plugins: :Lazy update\n"

#/ claude          Symlink botfile directories
claude:
	@if [[ -L $$HOME/.claude ]]; then rm $$HOME/.claude; fi
	@ln -sfv `pwd`/claude $$HOME/.claude

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
	@# Save screenshots to Downloads
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

.PHONY: claude help install macos uninstall update
