-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- -------------------------------------
-- Options
-- Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Editor Behavior
vim.opt.confirm = true
vim.opt.expandtab = true
vim.opt.mouse = 'a'
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.updatetime = 50
vim.opt.wrap = false
-- UI + Visual Settings
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.list = true
vim.opt.listchars = 'tab:▸ ,eol:¬,trail:·'
vim.opt.number = true
vim.opt.showcmd = false
vim.opt.signcolumn = 'number'
vim.opt.title = true
-- Window Management
vim.opt.sidescrolloff = 3
vim.opt.splitbelow = true
vim.opt.splitright = true
-- File Handling
vim.opt.backup = false
vim.opt.clipboard = 'unnamed'
vim.opt.exrc = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.wildignore:append({ '.DS_Store' })
vim.opt.writebackup = false
-- Search and Completion
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
if vim.fn.executable('rg') > 0 then vim.opt.grepprg = 'rg --vimgrep' end
-- Diagnostics Configuration
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { current_line = true, },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "☠️",
      [vim.diagnostic.severity.WARN] = "⚠️",
      [vim.diagnostic.severity.HINT] = "💡",
      [vim.diagnostic.severity.INFO] = "ℹ️",
    },
  },
})

-- -------------------------------------
-- Plugins
-- @see https://lazy.folke.io
require('lazy').setup({
  -- Utility Dependencies
  { 'https://github.com/MunifTanjim/nui.nvim' },
  { 'https://github.com/nvim-lua/plenary.nvim' },
  -- Editing
  { 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring' },
  { 'https://github.com/gbprod/yanky.nvim' },
  { 'https://github.com/numToStr/Comment.nvim' },
  { 'https://github.com/nvim-treesitter/nvim-treesitter',            build = ':TSUpdate' },
  { 'https://github.com/tpope/vim-repeat' },
  { 'https://github.com/tpope/vim-surround' },
  { 'https://github.com/tpope/vim-unimpaired' },
  -- Editor
  { 'https://github.com/fang2hou/blink-copilot' },
  { 'https://github.com/github/copilot.vim' },
  { 'https://github.com/ibhagwan/fzf-lua' },
  { 'https://github.com/nvim-neo-tree/neo-tree.nvim',                branch = 'v3.x' },
  { 'https://github.com/nvim-tree/nvim-web-devicons' },
  { 'https://github.com/saghen/blink.cmp',                           version = '*' },
  { 'https://github.com/tpope/vim-fugitive' },
  { 'https://github.com/tpope/vim-rhubarb' },
  -- LSP
  { 'https://github.com/folke/lazydev.nvim' },
  { 'https://github.com/mrjones2014/codesettings.nvim' },
  { 'https://github.com/neovim/nvim-lspconfig' },
  { 'https://github.com/yioneko/nvim-vtsls' },
}, {})

-- -------------------------------------
-- Setup
require('editor')
require('lsp')
require('keymaps')
vim.cmd('colorscheme nordish')
