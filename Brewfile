# Helper to detect MDM/Jamf-installed apps (memoized)
@mdm_cache = {}
def mdm_installed?(app_name)
  @mdm_cache[app_name] ||= Dir.glob("/var/db/receipts/com.jamf.appinstallers.#{app_name}*.plist").any?
end

# Machine use detection based on Jamf MDM presence (memoized)
def work_machine?
  @is_work_machine ||= Dir.glob("/var/db/receipts/com.jamf*.plist").any?
end

def personal_machine?
  !work_machine?
end

tap "aws/tap"
tap "filosottile/gomod"
tap "github/gh"
tap "golangci/tap"
tap "heroku/brew"
brew "mise"
brew "aws-vault"
brew "awscli"
brew "gdbm"
brew "python@3.10"
brew "awslogs"
brew "ca-certificates"
brew "cheat"
brew "cjson"
brew "cmake"
brew "cmocka"
brew "libunistring"
brew "guile"
brew "libevent"
brew "libidn2"
brew "libnghttp2"
brew "libtasn1"
brew "nettle"
brew "p11-kit"
brew "unbound"
brew "gnutls"
brew "libusb"
brew "lz4"
brew "snappy"
brew "zstd"
brew "colima"
brew "coreutils"
brew "ctags"
brew "dav1d"
brew "difftastic"
brew "docbook"
brew "docbook-xsl"
brew "docker"
brew "git"
brew "git-extras"
brew "gnu-getopt", link: true
brew "libgpg-error"
brew "libassuan"
brew "libgcrypt"
brew "libksba"
brew "npth"
brew "pinentry"
brew "gnupg"
brew "go"
brew "gofumpt"
brew "golangci/tap/golangci-lint"
brew "graphviz"
brew "heroku/brew/heroku"
brew "hub"
brew "icu4c", link: true
brew "jq"
brew "krb5", link: true
brew "libpq"
brew "neovim"
brew "readline"
brew "redis", restart_service: true
brew "ripgrep"
brew "ruby-lsp"
brew "shared-mime-info"
brew "sqlite", link: true
brew "terraform-ls"
brew "tree"
brew "unzip"
brew "wget"
cask "gpg-suite"
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
