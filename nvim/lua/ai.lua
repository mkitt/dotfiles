-- @see https://github.com/zbirenbaum/copilot.lua
require('copilot').setup({
    filetypes = { ['*'] = true, },
    panel = {
        enabled = true,
        auto_refresh = true,
        layout = { position = "vertical", },
    },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = { accept = '<C-\\>', }
    },
})

-- @see https://github.com/CopilotC-Nvim/CopilotChat.nvim
require('CopilotChat').setup({
    model = 'claude-3.7-sonnet',
    question_header = '󰯈 Human ',
    answer_header = ' Copilot ',
    error_header = ' Error ',
})
