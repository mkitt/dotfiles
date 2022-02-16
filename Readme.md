<img src="https://mkitt.net/apple-touch-icon.png" width="80px" height="80px" />

# dotfiles

My personal dotfiles for macOS. Tuned to work with Apple's Terminal.app

&hearts; the Vim.

## Commands

The main tasks are `Makefile` targets. To see the available commands provided by
the `install`, `uninstall`, `update` and `help` scripts run:

```
make help
```

## Tips

### Git credentials

To setup your git credentials you'll need to add a `.gitconfig.local` file to
your `$HOME` directory and add the following:

```
[user]
  name = YOUR_GIT_AUTHOR_NAME
  email = YOUR_GIT_AUTHOR_EMAIL
  signingKey = YOUR_GIT_SIGNING_KEY
[github]
  user = YOUR_GITHUB_USERNAME
```

Note: Git will ignore `*.local` files. The `install`/`uninstall` script
symlinks/removes a `gitconfig.local`.

### GPG

Install GPG Keychain for GPG signing to happen automatically. See [GPG
Tools][gpg_tools] for more information. To get your GPG signing key you can
either open up GPG Keychain, or run `gpg --list-keys` and add this to in your
`.gitconfig.local` file. If you are transferring a key to a new computer
see [the knowledge base article][gpg_transfer]

### Install Terminal.app themes

Included in the vimrc is `Plug mkitt/pigment`. This is the color settings for
Vim. Any color profile should work with this theme including the defaults from
Apple. Included from the [pigment][pigment] repository are light and dark
profiles. Import these profiles into Apple's Terminal.app and set one as the
default. The location of the profiles is:

```
~/.vim/plugged/pigment/profiles/
```

### Migrating to a new machine

1. Setup iCloud
1. Download App store applications
1. Run `xcode-select --install`
1. Install [homebrew][homebrew]
1. Run `brew install git`
1. Run `git clone https://github.com/mkitt/dotfiles.git && cd dotfiles`
1. Add the `gitconfig.local` file to the `dotfiles` directory
1. Run `make install`
1. Follow post install instructions (Vim plugins)
1. Install Terminal colors
1. Map caps lock to the control key
1. Set other reasonable [macOS defaults][macos_defaults]
1. Create new SSH & update GPG keys (see account settings in GitHub)
1. Switch the dotfiles repo [from https to ssh][git-remotes]
1. Pull down key repositories
1. [Wipe old computer][wipe]

---

[mkitt.net][mkitt.net] | [github/mkitt][github]

<!-- Markdown links!! -->

[git-remotes]: https://help.github.com/en/github/using-git/changing-a-remotes-url#switching-remote-urls-from-https-to-ssh
[github]: https://github.com/mkitt 'github.com/mkitt'
[gpg_tools]: https://gpgtools.org/ 'gpg tools'
[gpg_transfer]: https://gpgtools.tenderapp.com/kb/gpg-keychain-faq/backup-or-transfer-your-keys 'transfer gpg'
[homebrew]: https://brew.sh "homebrew's home"
[macos_defaults]: http://mths.be/macos 'macos defaults'
[mkitt.net]: https://mkitt.net '🏔'
[pigment]: https://github.com/mkitt/pigment 'vim and zsh colors'
[wipe]: https://support.apple.com/en-us/HT201065 'wipe'
