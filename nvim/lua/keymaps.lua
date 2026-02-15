-- :map
-- -------------------------------------
local fuzzy = require('fzf-lua')

-- Move between splits
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { desc = 'Move to the left window' })
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { desc = 'Move to the window below' })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { desc = 'Move to the window above' })
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { desc = 'Move to the right window' })

-- Copilot
vim.keymap.set('i', '<C-\\>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})

-- Yanky
vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)', { desc = 'Put (paste) cb after' })
vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)', { desc = 'Put (paste) cb before' })
vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)', { desc = 'Put cb after (w/ cursor)' })
vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)', { desc = 'Put cb before (w/ cursor)' })
vim.keymap.set('n', '<C-P>', '<Plug>(YankyCycleForward)', { desc = 'Cycle forward through the cb' })
vim.keymap.set('n', '<C-N>', '<Plug>(YankyCycleBackward)', { desc = 'Cycle backward through the cb' })

-- The `<C->` commands "Open things", sometimes with visual context
vim.keymap.set('n', '<C-Space>', fuzzy.builtin, { desc = 'Open fzf-lua builtins' })
vim.keymap.set('n', '<C-B>', fuzzy.buffers, { desc = 'Fuzzy find buffer files' })
vim.keymap.set('n', '<C-E>', fuzzy.files, { desc = 'Fuzzy find filesystem files' })
vim.keymap.set('n', '<C-F>', fuzzy.live_grep, { desc = 'Fuzzy search within files' })
vim.keymap.set('v', '<C-F>', fuzzy.grep_visual, { desc = 'Fuzzy search the visual selection' })
vim.keymap.set('n', '<C-G>', fuzzy.git_status, { desc = 'Fuzzy find git status files' })
vim.keymap.set('n', '<C-T>', fuzzy.resume, { desc = 'Open fzf-lua with the last source used' })
vim.keymap.set('n', '<C-Y>', ':Neotree toggle left<CR>', { desc = 'Toggle tree explorer', silent = true })

-- The `operator` commands
vim.keymap.set('n', '-', ':Neotree filesystem float reveal<CR>',
  { desc = 'Open the filesystem tree explorer in a float', silent = true })
vim.keymap.set('n', '\\', ':nohlsearch<CR>', { desc = 'Clear search highlighting', silent = true })

-- Leader commands
vim.keymap.set('n', '<leader>C', ':Copilot panel<CR>', { desc = 'Open the Copilot panel' })
vim.keymap.set('n', '<leader>D', vim.diagnostic.setqflist, { desc = 'Open diagnostics in a quickfix list' })
vim.keymap.set('n', '<leader>Y', ':Neotree reveal<CR>', { desc = 'Reveal the file in Neotree' })

-- The `g` commands "go somewhere", see the LSP `g` commands below
vim.keymap.set('n', 'gb', ':e#<CR>', { desc = 'Edit last file', silent = true })
vim.keymap.set('n', 'gV', '`[v`]', { desc = 'Re-select last pasted text' })

-- LSP Key mappings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspKeymaps', { clear = true }),
  callback = function(e)
    vim.keymap.set({ 'n', 'v' }, 'g.', vim.lsp.buf.code_action, { desc = 'code actions', buffer = e.buf })
    vim.keymap.set('n', 'g>', ':VtsExec source_actions<CR>', { desc = 'source actions (vtsls)', buffer = e.buf })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'goto declaration', buffer = e.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'goto definition', buffer = e.buf })
    vim.keymap.set('n', 'gF', '<Cmd>vsplit | lua vim.lsp.buf.definition()<CR>',
      { desc = 'goto definition in vsplit', buffer = e.buf })
    vim.keymap.set('n', 'gS', vim.lsp.buf.signature_help, { desc = 'show signature', buffer = e.buf })
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { desc = 'goto types definition', buffer = e.buf })
  end
})
