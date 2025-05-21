-- @see https://github.com/github/copilot.vim
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = { ["*"] = true, }
vim.keymap.set('i', '<C-\\>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})

vim.g.copilot_workspace_folders = {
    -- Drop workspace paths in here
}

-- @see https://codecompanion.olimorris.dev/
require("codecompanion").setup({
    adapters = {
        copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
                schema = {
                    model = { default = "claude-3.7-sonnet", },
                },
            })
        end,
    },
    display = {
        chat = { show_header_separator = true, },
    },
    strategies = {
        chat = {
            roles = { user = "󰯈 Human", },
        },
    },
})

-- @deprecate
-- @see https://github.com/CopilotC-Nvim/CopilotChat.nvim
require('CopilotChat').setup({
    model = 'claude-3.7-sonnet',
    question_header = '󰯈 Human ',
    answer_header = ' Copilot ',
    error_header = ' Error ',
})
