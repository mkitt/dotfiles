-- Auto required from plugins.lua
-- @see https://github.com/tpope/vim-repeat
-- @see https://github.com/tpope/vim-surround
-- @see https://github.com/tpope/vim-unimpaired

-- @see https://github.com/nvim-treesitter/nvim-treesitter
-- @see https://github.com/nvim-treesitter/nvim-treesitter-textobjects
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup({
    auto_install = true,
    highlight = { enable = true, disable = { 'gitcommit' } },
    indent = { enable = true },
    incremental_selection = { enable = true },
    textobjects = {
        lsp_interop = {
            enable = true,
            peek_definition_code = {
                ['gh'] = '@function.outer',
                ['gC'] = '@class.outer',
            },
        },
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                [']c'] = '@comment.outer',
                [']m'] = '@function.outer',
            },
            goto_next_end = {
                [']C'] = '@comment.outer',
                [']M'] = '@function.outer',
            },
            goto_previous_start = {
                ['[c'] = '@comment.outer',
                ['[m'] = '@function.outer',
            },
            goto_previous_end = {
                ['[C'] = '@comment.outer',
                ['[M'] = '@function.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                [']w'] = '@parameter.inner',
            },
            swap_previous = {
                ['[w'] = '@parameter.inner',
            },
        },
    }
})

-- @see https://github.com/JoosepAlviste/nvim-ts-context-commentstring
require('ts_context_commentstring').setup({
    enable_autocmd = false,
})

-- @see https://github.com/numToStr/Comment.nvim
---@diagnostic disable-next-line: missing-fields
require('Comment').setup({
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- @see https://github.com/gbprod/yanky.nvim
require('yanky').setup({
    highlight = { timer = 100 },
})

-- -------------------------------------
-- Auto Commands
vim.cmd [[
    func! Eatchar(pat)
        let c = nr2char(getchar(0))
        return (c =~ a:pat) ? '' : c
    endfunc
]]

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    callback = function()
        vim.cmd("iabbrev <buffer> cdl console.log()<Left><C-R>=Eatchar('\\s')<CR>")
        vim.keymap.set("n", "gq", "gw", { buffer = true, noremap = true })
        vim.keymap.set("v", "gq", "gw", { buffer = true, noremap = true })
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'md', 'markdown', 'text', 'txt' },
    command = 'setlocal textwidth=80 linebreak nolist wrap spell',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'BufEnter' }, {
    pattern = { 'COMMIT_EDITMSG', 'copilot-*' },
    command = 'setlocal spell',
})
