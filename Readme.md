<img src="https://mkitt.net/apple-touch-icon.png" width="80px" height="80px" />

# dotfiles

The dotfiles for macOS.

Used to &hearts; the Vim.

## New Machine

1. Setup iCloud
1. Add Internet Accounts
1. Install [Claude Desktop][claude-desktop]
1. Install Xcode (App Store) & Components
1. Run `xcode-select --install`
1. Remap caps lock to control
1. Create a Authentication SSH key and add to [GitHub][gh-keys]
1. Create a Signing SSH key and add to [GitHub][gh-keys]
1. Download the Makefile and install:
   ```sh
   cd ~ && curl -fsSLO https://raw.githubusercontent.com/mkitt/dotfiles/main/Makefile && make install
   ```
1. Run `make macos` for [macOS defaults][macos_defaults]
1. Open a new terminal (to pick up `~/.local/bin`) and run `gh auth login`
1. Restart to pick up macOS defaults
1. Setup System Settings and Preferences
1. Install App Store Applications
1. [Wipe old computer][wipe]

## Tips

### Commit Signing

Commits are signed with the SSH key, so nothing beyond macOS's own `ssh-keygen`
is needed. `gitconfig` sets `gpg.format = ssh` and points `signingKey` at the
public key. GitHub marks the commits Verified once the same key is added as a
[signing key][gh-ssh-signing]. To create a key:

```sh
ssh-keygen -t ed25519 -C YOUR_GIT_AUTHOR_EMAIL
```

If a commit fails to sign, load the key into the agent with
`ssh-add --apple-use-keychain ~/.ssh/id_ed25519`.

---

[mkitt.net][mkitt.net] | [github/mkitt][github]

<!-- Markdown Links! -->

[claude-desktop]: https://claude.com/download
[gh-keys]: https://github.com/settings/keys
[gh-ssh-signing]: https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#ssh-commit-signature-verification
[github]: https://github.com/mkitt "github.com/mkitt"
[macos_defaults]: https://mths.be/macos "macos defaults"
[mkitt.net]: https://mkitt.net "🏔"
[wipe]: https://support.apple.com/en-us/102664 "Erase your Mac and reset it to factory settings"
