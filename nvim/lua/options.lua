-- Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Editor Behavior
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
