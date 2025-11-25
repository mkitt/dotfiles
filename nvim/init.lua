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
require('options')
require('plugins')
require('editing')
require('ui')
require('ai')
require('git')
require('lsp')
require('cmp')
require('fuzzy')
require('tree')
require('keymaps')
-- -------------------------------------
vim.cmd('colorscheme nordish')
