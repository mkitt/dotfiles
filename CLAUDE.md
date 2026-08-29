# Dotfiles

Personal dotfiles for macOS. Files here are symlinked to the home directory via `make install`.

## Structure

- `claude/` — User-level Claude Code config (symlinked to `~/.claude` via Makefile)
- `claude-plugins/` — Claude Code custom plugins
- `ghostty/` — Ghostty terminal config (symlinked to `~/.config/ghostty` via Makefile)
- `mise/` — Global tool versions (symlinked to `~/.config/mise` via Makefile)
- `nvim/` — Neovim config (symlinked to `~/.config/nvim` via Makefile)
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

## Neovim

- 7 Lua files: `init.lua`, `lua/` (editor, keymaps, lsp, theme), `colors/` (beamish, nordish)
- nvim-treesitter is on `main` branch (new rewrite), parsers managed via explicit install list
- `tree-sitter` and `tree-sitter-cli` come from `make install`; both are in the Makefile `brews` list

## Gotchas

- `.gitignore` treats `claude/` as an allowlist: `claude/*` is ignored, with negations for `CLAUDE.md`, `agents/`, `commands/`, `settings.json` and `skills/`. Any other new config path (`claude/hooks/`, say) is silently untracked until you add its negation
- Nerd font unicode characters get corrupted through Read/Edit tools — let the user make edits involving nerd font icons
- `mkitt-lsp/.lsp.json` declares one server per extension on purpose: Claude Code starts only the first server registered for an extension and never starts the rest, so tailwindcss, oxlint and oxfmt stay Neovim-only — see the [plugins reference](https://code.claude.com/docs/en/plugins-reference)
- LSP fugitive buffer error (workspace URI) is a known Neovim limitation, living with it
