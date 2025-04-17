-- @see https://lazy.folke.io
require('lazy').setup({
    -- Utility Dependencies
    { 'nvim-lua/plenary.nvim', },
    { 'MunifTanjim/nui.nvim', },
    -- Editing
    { 'nvim-treesitter/nvim-treesitter',             build = ':TSUpdate', },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'JoosepAlviste/nvim-ts-context-commentstring', },
    { 'numToStr/Comment.nvim', },
    { 'tpope/vim-repeat', },
    { 'tpope/vim-surround', },
    { 'tpope/vim-unimpaired', },
    { 'gbprod/yanky.nvim', },
    -- UI
    { 'nvim-tree/nvim-web-devicons', },
    -- AI
    { 'zbirenbaum/copilot.lua', },
    { 'CopilotC-Nvim/CopilotChat.nvim',              branch = 'main',     build = 'make tiktoken', },
    -- GIT
    { 'tpope/vim-fugitive', },
    { 'tpope/vim-rhubarb', },
    -- LSP
    { 'williamboman/mason.nvim', },
    { 'williamboman/mason-lspconfig.nvim', },
    { 'neovim/nvim-lspconfig', },
    { 'folke/lazydev.nvim', },
    { 'yioneko/nvim-vtsls', },
    { 'stevearc/conform.nvim', },
    -- CMP
    { 'saghen/blink.cmp',                            version = '*', },
    -- Fuzzy
    { 'ibhagwan/fzf-lua' },
    -- Tree + Outline
    { 'nvim-neo-tree/neo-tree.nvim',                 branch = 'v3.x', },
}, {})
