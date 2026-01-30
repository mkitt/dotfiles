# Helper to detect MDM/Jamf-installed apps
def mdm_installed?(app_name)
  Dir.glob("/var/db/receipts/com.jamf.appinstallers.#{app_name}*.plist").any?
end

# Machine use detection via DOTFILES_MACHINE_USE env var (values: "work" or "personal")
# Defaults to "personal" if not set
def machine_use
  (ENV["DOTFILES_MACHINE_USE"] || "personal").downcase
end

def work_machine?
  machine_use == "work"
end

def personal_machine?
  machine_use == "personal"
end

tap "aws/tap"
tap "github/gh"
tap "golangci/tap"
tap "heroku/brew"
brew "asdf"
brew "aws-vault"
brew "awscli"
brew "awslogs"
brew "ca-certificates"
brew "cheat"
brew "cmake"
brew "colima"
brew "coreutils"
brew "ctags"
brew "difftastic"
brew "docker"
brew "git"
brew "git-extras"
brew "gnupg"
brew "gofumpt"
brew "golangci/tap/golangci-lint"
brew "graphviz"
brew "heroku/brew/heroku"
brew "hub"
brew "icu4c", link: true
brew "jq"
brew "libpq"
brew "neovim"
brew "readline"
brew "redis", restart_service: true
brew "ripgrep"
brew "shared-mime-info"
brew "sqlite", link: true
brew "tree"
brew "unzip"
brew "wget"
cask "1password@beta" unless mdm_installed?("1Password")
cask "1password-cli"
cask "backblaze" if personal_machine?
cask "dynamodb-local"
cask "dropbox" if personal_machine?
cask "ghostty"
cask "muzzle"
cask "obsidian"
cask "postman"
cask "proxyman"
cask "gitx"
cask "notion-calendar"
cask "secretive"
cask "signal" if personal_machine?
cask "slack@beta" unless mdm_installed?("Slack")
cask "sonos"
cask "spotify"
cask "xquartz"
cask "zoom" unless mdm_installed?("Zoom")
