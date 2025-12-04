-- @see https://lazy.folke.io
require('lazy').setup({
  -- Utility Dependencies
  { 'nvim-lua/plenary.nvim' },
  { 'MunifTanjim/nui.nvim' },
  -- Editing
  { 'nvim-treesitter/nvim-treesitter',            build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  { 'numToStr/Comment.nvim' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-unimpaired' },
  { 'gbprod/yanky.nvim' },
  -- UI
  { 'nvim-tree/nvim-web-devicons' },
  { 'HakonHarnes/img-clip.nvim' },
  -- AI
  { 'github/copilot.vim' },
  { "olimorris/codecompanion.nvim" },
  -- GIT
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  -- LSP
  { "mrjones2014/codesettings.nvim" },
  { 'williamboman/mason.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'folke/lazydev.nvim' },
  { 'yioneko/nvim-vtsls' },
  { 'stevearc/conform.nvim' },
  -- Fuzzy
  { 'ibhagwan/fzf-lua' },
  -- CMP
  { 'saghen/blink.cmp',                           version = '*' },
  { 'fang2hou/blink-copilot' },
  -- Tree + Outline
  { 'nvim-neo-tree/neo-tree.nvim',                branch = 'v3.x' },
}, {})
