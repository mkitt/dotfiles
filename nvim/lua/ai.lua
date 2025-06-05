-- @see https://github.com/github/copilot.vim
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = { ["*"] = true, }
vim.keymap.set('i', '<C-\\>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})

vim.g.copilot_workspace_folders = {
    "~/Sites/aura-finance/aura",
    "~/Sites/cakeflight/balance",
    "~/Sites/mkitt/binarymilkshake.com",
    "~/Sites/mkitt/dotfiles",
    "~/Sites/mkitt/mkitt.net",
    "~/Sites/mkitt/slush",
    "~/Sites/nauwork/nauwork-portal-frontend",
    "~/Sites/nauwork/portal-ts-client"
}

-- @see https://codecompanion.olimorris.dev/
require("codecompanion").setup({
    adapters = {
        copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
                schema = { model = { default = "claude-sonnet-4", }, },
            })
        end,
    },
    display = { chat = { show_header_separator = true, }, },
    strategies = { chat = { roles = { user = "󰯈 Human", }, }, },
})

vim.api.nvim_create_autocmd("User", {
    pattern = { "CodeCompanionChatSubmitted", "CodeCompanionRequestFinished" },
    callback = function(args)
        local msg = args.match == "CodeCompanionChatSubmitted" and "🤖 CodeCompanion is working..." or ""
        vim.notify(msg, vim.log.levels.INFO, { replace = true })
    end,
})
