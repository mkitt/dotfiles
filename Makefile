raw = https://raw.githubusercontent.com/mkitt/dotfiles/main
releases = https://github.com/cli/cli/releases
bin = $(HOME)/.local/bin
completions = $(HOME)/.local/share/zsh/site-functions

# --------------------------------------

#/ help            Print this message (default)
help:
	@echo "Usage: make TARGET"
	@grep '^#/' $(firstword $(MAKEFILE_LIST)) | sed 's/^#\//  /'

#/ install         Copies the dotfiles and installs gh
install: update

#/ update          Refreshes the dotfiles, this Makefile and gh
update: dotfiles gh

# Download to a temp file and mv, so a failed download never leaves a
# half-written file and an old symlink is replaced rather than written through.
dotfiles:
	@set -e; for f in zshrc gitconfig; do \
	  curl -fsSL $(raw)/$$f -o $(HOME)/.$$f.tmp; mv $(HOME)/.$$f.tmp $(HOME)/.$$f; \
	  echo "Copied ~/.$$f"; \
	done
	@curl -fsSL $(raw)/Makefile -o $(HOME)/Makefile.tmp
	@mv $(HOME)/Makefile.tmp $(HOME)/Makefile && echo "Copied ~/Makefile"

# The latest release URL redirects to its tag, which avoids parsing the API's JSON.
gh:
	@set -e; \
	tag=$$(curl -fsSLo /dev/null -w '%{url_effective}' $(releases)/latest); v=$${tag##*/v}; \
	if [ "$$($(bin)/gh --version 2>/dev/null | awk 'NR==1{print $$3}')" = "$$v" ]; then \
	  echo "gh $$v is current"; exit 0; \
	fi; \
	case $$(uname -m) in x86_64) arch=amd64 ;; *) arch=arm64 ;; esac; \
	zip=gh_$${v}_macOS_$$arch.zip; \
	tmp=$$(mktemp -d); trap 'rm -rf "$${tmp:?}"' EXIT; cd $$tmp; \
	curl -fsSLO $(releases)/download/v$$v/$$zip; \
	curl -fsSL $(releases)/download/v$$v/gh_$${v}_checksums.txt | grep " $$zip$$" | shasum -a 256 -c -s || { echo "$$zip failed its checksum"; exit 1; }; \
	unzip -q $$zip; \
	mkdir -p $(bin); install -m 755 $$tmp/*/bin/gh $(bin)/gh; \
	echo "Installed gh $$v"
	@mkdir -p $(completions)
	@$(bin)/gh completion -s zsh > $(completions)/_gh && echo "Wrote gh completion"

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

.PHONY: dotfiles gh help install macos update
