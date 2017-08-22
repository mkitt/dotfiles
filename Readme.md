# dotfiles
My personal dotfiles for macOS.

Over the years these have shaped various organization dotfiles:

1. [Ello](https://github.com/ello/dotfiles) (active)
- [Mode Set](https://github.com/modeset/dotset) (inactive)
- [Factory Labs](https://github.com/factorylabs/vimfiles) (inactive)

&hearts; the Vim.

## Commands
The main tasks are wrapped by the `Makefile` targets. To see all of the
available commands provided by the `install`, `uninstall`, `update` and `help`
scripts run:

```
make help
```

## Tips

### Git credentials
To setup your git credentials correctly you'll need to add a `.gitconfig.local`
file to your `$HOME` directory and add the following:

```
[user]
  name = YOUR_GIT_AUTHOR_NAME
  email = YOUR_GIT_AUTHOR_EMAIL
  signingKey = YOUR_GIT_SIGNING_KEY
[github]
  user = YOUR_GITHUB_USERNAME
```

Note: Any `*.local` files are ignored by git. The `install`/`uninstall` script
symlinks/removes a `gitconfig.local`. On my machine the dotfiles directory is
stored in iCloud so it's just there as a convenience.

### GPG
Install GPG Keychain for GPG signing to happen automatically. See [GPG
Tools][gpg_tools] for more information. To obtain your GPG signing key you can
either open up GPG Keychain, or run `gpg --list-keys` and add this to in your
`.gitconfig.local` file.

### Install Polarized terminal themes
Included in the vimrc is `Plug mkitt/pigment`. This is the color settings for
Vim. Any color profile should work with this theme including the defaults from
Apple. Included from the [pigment][pigment] repository is the Polarized light
and dark profiles. Import these profiles into Apple's Terminal.app and set one
as the default. They should be found in:

```
~/.vim/plugged/pigment/profiles/
```

### Turn caps lock into the control key
The control key is in an awkward position and the caps lock key is
basically useless. It's right there in the home row, so you might as
well put it to good use.

1. Open up System Preferences
- Select `Keyboard`
- Select `Modifier Keys`
- From the drop down, select `^ Control` under the `Caps Lock` setting
- In the `Select Keyboard` drop down, set it for both internal and external keyboards

### Mouse support for Terminal
To get full mouse support (scrolling, clicking, etc...) within Terminal
Vim, install the [SIMBL][simbl] [MouseTerm][mouseterm] plug-in.

### Migrating to a new machine
1. Setup iCloud 
- Download App store applications
- `xcode-select --install`
- `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
- Navigate to this dotfiles directory
- Run `make install`
- Follow post install instructions (Vim plugins)
- Install Terminal colors
- Map caps lock to the control key
- [Setup accessibility][shiftit_setup] for [Shift It][shiftit]
- Install [SIMBL][simbl]
- Install [MouseTerm][mouseterm]
- Install [QLStephen][qlstephen]
- Install [Heroku Toolbelt][toolbelt]
- Set other reasonable [macOS defaults][macos_defaults]
- Setup SSH & GPG keys (see account settings in GitHub)
- Pull down key repositories
- [Wipe old computer][wipe]

<!-- Markdown links -->
[gpg_tools]: https://gpgtools.org/
[macos_defaults]: http://mths.be/osx
[mouseterm]: http://bitheap.org/mouseterm/
[pigment]: https://github.com/mkitt/pigment
[qlstephen]: https://github.com/whomwah/qlstephen
[shiftit]: https://github.com/fikovnik/ShiftIt
[shiftit_setup]: https://github.com/fikovnik/ShiftIt/issues/110#issuecomment-20834932
[simbl]: http://www.culater.net/software/SIMBL/SIMBL.php
[toolbelt]: https://toolbelt.heroku.com
[wipe]: https://support.apple.com/en-us/HT201065
