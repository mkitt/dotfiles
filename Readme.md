<img src="https://mkitt.net/apple-touch-icon.png" width="80px" height="80px" />

# dotfiles

The dotfiles for macOS.

&hearts; the Vim.

## Commands

The main tasks are `Makefile` targets. To see the available commands provided by
the `install`, `uninstall`, `update` and `help` scripts run:

```sh
make help
```

## New Machine

1. Setup iCloud
1. Install App store applications
1. Map caps lock to the control key
1. Install [Ghostty][ghostty]
1. Run `xcode-select --install`
1. Install [homebrew][homebrew]
1. Run `/opt/homebrew/bin/brew install git`
1. Run `git clone https://github.com/mkitt/dotfiles.git && cd dotfiles`
1. Add the [`gitconfig.local`](#git-credentials) file to the `dotfiles` directory
1. Run `make install` for dotfiles
1. Install [Claude Code][claude_code]
1. Follow post install instructions (Vim plugins)
1. Set other reasonable [macOS defaults][macos_defaults]
1. Restart to pick up reasonable defaults
1. Create new [SSH & update GPG keys][gh-ssh-gpg]
1. Run `gh auth login`
1. Switch the dotfiles repo [from https to ssh][git-remotes]
1. Pull down key repositories
1. Setup all Application settings
1. [Wipe old computer][wipe]

## Tips

### Git Credentials

To setup your git credentials you'll need to add a `gitconfig.local` file to
your the root directory and add the following:

```
[user]
  name = YOUR_GIT_AUTHOR_NAME
  email = YOUR_GIT_AUTHOR_EMAIL
  # signingKey = YOUR_GIT_GPG_SIGNING_KEY
[github]
  user = YOUR_GITHUB_USERNAME
```

- The `install`script symlinks this file to `$HOME/.gitconfig.local`
- The global `.gitignore` is set to omit any `*.local` files

### GPG

Install GPG Keychain for GPG signing to happen automatically. See [GPG
Tools][gpg_tools] for more information. To get your GPG signing key you can
either open up GPG Keychain, or run `gpg --list-keys` and add this to in your
`.gitconfig.local` file. If you are transferring a key to a new computer
see [the knowledge base article][gpg_transfer]

---

[mkitt.net][mkitt.net] | [github/mkitt][github]

<!-- Markdown Links! -->

[claude_code]: https://claude.com/product/claude-code
[gh-ssh-gpg]: https://github.com/settings/keys
[ghostty]: https://ghostty.org "ghostty"
[git-remotes]: https://help.github.com/en/github/using-git/changing-a-remotes-url#switching-remote-urls-from-https-to-ssh
[github]: https://github.com/mkitt "github.com/mkitt"
[gpg_tools]: https://gpgtools.org/ "gpg tools"
[gpg_transfer]: https://gpgtools.tenderapp.com/kb/gpg-keychain-faq/backup-or-transfer-your-keys "transfer gpg"
[homebrew]: https://brew.sh "homebrew's home"
[macos_defaults]: http://mths.be/macos "macos defaults"
[mkitt.net]: https://mkitt.net "🏔"
[wipe]: https://support.apple.com/en-us/HT201065 "wipe"

<!--
```
  󰨈 󰮖 󰦌             󰯈 󰊠 󰋋 󰯉   󰮯 
```
-->
