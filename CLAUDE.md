# Dotfiles

Personal dotfiles for macOS. Files here are symlinked to the home directory via `make install`.

The Macs these run on are access devices: development happens in Claude cloud sessions, so this repo carries only a shell, git, gh, a couple of CLI helpers and system Vim. Editors, terminals, runtimes and language servers stay out.

## Structure

- `Makefile` — Install, uninstall, update, and macOS defaults
- Dotfiles in the `dots` variable (`gitconfig`, `gitconfig.local`, `vimrc`, `zshrc`) are symlinked as `~/.{filename}`
- `*.local` is ignored by the repo's own `.gitignore` for machine-specific overrides; `gitconfig.local` is untracked and must be created by hand on a new machine (see Readme)

## Commands

```bash
make install    # Install brews and casks, and symlink dotfiles
make uninstall  # Uninstall brews and casks, and remove symlinks
make update     # Update brews
make macos      # Apply macOS system defaults
```

## Gotchas

- Nothing here can be run from a cloud session: `make`, Homebrew and `defaults` need a Mac, so changes are tested by running `make install` locally before merging
- `gitconfig`'s pager and `zshrc`'s prompt use helpers shipped with Homebrew git, which is why `git` stays in `brews` even though macOS has its own
