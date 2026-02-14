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
