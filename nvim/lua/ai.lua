-- @see https://github.com/github/copilot.vim
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = { ["*"] = true, }
vim.keymap.set('i', '<C-\\>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})

-- To add ADDITIONAL workspace folders for cross-project context,
-- create a .nvim.lua file in your project root with:
-- vim.g.copilot_workspace_folders = {
--   vim.fn.expand("~/Sites/foo/bar"),
--   vim.fn.expand("~/Sites/foo/baz"),
-- }

-- @see https://codecompanion.olimorris.dev/
require("codecompanion").setup({
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
