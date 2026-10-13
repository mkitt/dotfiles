<img src="https://mkitt.net/apple-touch-icon.png" width="80px" height="80px" />

# dotfiles

The dotfiles for macOS.

These Macs are access devices: development happens in cloud sessions, so this
repo carries only a shell, git, gh and a few command line helpers.

Used to &hearts; the Vim.

## Commands

The main tasks are `Makefile` targets. To see them, run:

```sh
make help
```

## New Machine

1. Setup iCloud
1. Install App store applications
1. Install Core Applications
1. Run `xcode-select --install`
1. Install [homebrew][homebrew]
1. Create an SSH key and add it to [GitHub][gh-keys] twice, once as an
   authentication key and once as a signing key
1. Run `git clone https://github.com/mkitt/dotfiles.git && cd dotfiles`
1. Add the [`gitconfig.local`](#git-credentials) file to the `dotfiles` directory
1. Run `make install` for dotfiles
1. Run `make macos` for reasonable [macOS defaults][macos_defaults]
1. Restart to pick up reasonable defaults
1. Run `gh auth login`
1. Switch the dotfiles repo [from https to ssh][git-remotes]
1. Setup all Application settings
1. [Wipe old computer][wipe]

## Tips

### Git Credentials

To setup your git credentials you'll need to add a `gitconfig.local` file to
the root directory and add the following:

```
[user]
  name = YOUR_GIT_AUTHOR_NAME
  email = YOUR_GIT_AUTHOR_EMAIL
  signingkey = ~/.ssh/id_ed25519.pub
```

- The `install` script symlinks this file to `$HOME/.gitconfig.local`
- The repo's `.gitignore` keeps any `*.local` file out of git

### Commit Signing

Commits are signed with the SSH key rather than GPG, so nothing beyond macOS's
own `ssh-keygen` is needed. `gitconfig` sets `gpg.format = ssh`, and the
`signingkey` above points at the public key. GitHub marks the commits Verified
once the same key is added as a [signing key][gh-ssh-signing]. To create a key:

```sh
ssh-keygen -t ed25519 -C YOUR_GIT_AUTHOR_EMAIL
```

If a commit fails to sign, load the key into the agent with
`ssh-add --apple-use-keychain ~/.ssh/id_ed25519`.

---

[mkitt.net][mkitt.net] | [github/mkitt][github]

<!-- Markdown Links! -->

[gh-keys]: https://github.com/settings/keys
[gh-ssh-signing]: https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#ssh-commit-signature-verification
[git-remotes]: https://docs.github.com/en/get-started/getting-started-with-git/managing-remote-repositories#switching-remote-urls-from-https-to-ssh
[github]: https://github.com/mkitt "github.com/mkitt"
[homebrew]: https://brew.sh "homebrew's home"
[macos_defaults]: http://mths.be/macos "macos defaults"
[mkitt.net]: https://mkitt.net "🏔"
[wipe]: https://support.apple.com/en-us/HT201065 "wipe"
