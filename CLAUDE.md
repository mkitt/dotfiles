# Dotfiles

Personal dotfiles for macOS. Files here are symlinked to the home directory via `make install`.

## Structure

- `Makefile` — Install, uninstall, update, and macOS defaults
- Dotfiles in the `dots` variable (`gitconfig`, `gitconfig.local`, `gitignore`, `vimrc`, `zshrc`) are symlinked as `~/.{filename}`
- `*.local` is gitignored for machine-specific overrides; `gitconfig.local` is untracked and must be created by hand on a new machine (see Readme)

## Commands

```bash
make install    # Symlink dotfiles, install brews/casks/LSPs
make uninstall  # Remove symlinks, uninstall brews/casks/LSPs
make update     # Update brews, casks, and LSP servers
make macos      # Apply macOS system defaults
```
