# Dotfiles

Personal dotfiles for macOS. Files here are symlinked to the home directory via `make install`.

## Structure

- `claude/` — Claude Code config (symlinked to `~/.claude` via Makefile)
- `claude-plugins/` — Claude Code custom plugins
- `ghostty/` — Ghostty terminal config (symlinked to `~/.config/ghostty` via Makefile)
- `nvim/` — Neovim config (symlinked to `~/.config/nvim` via Makefile)
- `Makefile` — Install, uninstall, update, and macOS defaults
- Dotfiles in the `dots` variable (`gitconfig`, `vimrc`, `zshrc`) are symlinked as `~/.{filename}`
- `.local` files (`gitconfig.local`, `zshrc.local`) are for machine-specific overrides and not checked in

## Commands

```bash
make install    # Symlink dotfiles, install brews/casks/LSPs
make uninstall  # Remove symlinks, uninstall brews/casks/LSPs
make update     # Update brews, casks, and LSP servers
make macos      # Apply macOS system defaults
```

## Neovim

- 4 files: `init.lua`, `editor.lua`, `lsp.lua`, `keymaps.lua` + theme module
- nvim-treesitter is on `main` branch (new rewrite), parsers managed via explicit install list
- Requires: `brew install tree-sitter tree-sitter-cli`

## Gotchas

- Nerd font unicode characters get corrupted through Read/Edit tools — let the user make edits involving nerd font icons
- LSP fugitive buffer error (workspace URI) is a known Neovim limitation, living with it
