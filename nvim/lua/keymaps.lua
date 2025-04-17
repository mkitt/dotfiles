-- :map
-- -------------------------------------
local aichat = require('CopilotChat')
local fuzzy = require('fzf-lua')

-- Move between splits
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { desc = 'Move to the left window', noremap = true })
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { desc = 'Move to the window below', noremap = true })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { desc = 'Move to the window above', noremap = true })
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { desc = 'Move to the right window', noremap = true })

-- Yanky
vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)', { desc = 'Put (paste) cb after', noremap = true })
vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)', { desc = 'Put (paste) cb before', noremap = true })
vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)', { desc = 'Put cb after (w/ cursor)', noremap = true })
vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)', { desc = 'Put cb before (w/ cursor)', noremap = true })
vim.keymap.set('n', '<C-P>', '<Plug>(YankyCycleForward)', { desc = 'Cycle forward through the cb', noremap = true })
vim.keymap.set('n', '<C-N>', '<Plug>(YankyCycleBackward)', { desc = 'Cycle backward through the cb', noremap = true })

-- The `<C->` commands "Open things", sometimes with visual context
vim.keymap.set('n', '<C-Space>', fuzzy.builtin, { desc = 'Open fzf-lua builtins', noremap = true })
vim.keymap.set('n', '<C-B>', fuzzy.buffers, { desc = 'Fuzzy find buffer files', noremap = true })
vim.keymap.set({ 'n', 'v' }, '<C-C>', aichat.open, { desc = 'Open CopilotChat', noremap = true, })
vim.keymap.set('n', '<C-E>', fuzzy.files, { desc = 'Fuzzy find filesystem files', noremap = true })
vim.keymap.set('n', '<C-F>', fuzzy.live_grep, { desc = 'Fuzzy search within files', noremap = true })
vim.keymap.set('v', '<C-F>', fuzzy.grep_visual, { desc = 'Fuzzy search the visual selection', noremap = true })
vim.keymap.set('n', '<C-G>', fuzzy.git_status, { desc = 'Fuzzy find git status files', noremap = true })
vim.keymap.set('n', '<C-Q>',
    function() require('CopilotChat').select_prompt() end,
    { desc = "CopilotChat - Prompt actions" })
vim.keymap.set('n', '<C-S>', ':Neotree document_symbols toggle right<CR>',
    { desc = 'Open document symbols explorer', noremap = true, silent = true })
vim.keymap.set('n', '<C-T>', fuzzy.resume, { desc = 'Open fzf-lua with the last source used', noremap = true })
vim.keymap.set('n', '<C-Y>', ':Neotree toggle left<CR>',
    { desc = 'Open the filesystem tree explorer in the drawer', noremap = true, silent = true })

-- The `operator` commands
vim.keymap.set('n', '-', ':Neotree filesystem float reveal<CR>',
    { desc = 'Open the filesystem tree explorer in a float', noremap = true, silent = true })
vim.keymap.set('n', '\\', ':nohlsearch<CR>',
    { desc = 'Clear search highlighting', noremap = true, silent = true })

-- Leader commands
vim.keymap.set('n', '<leader>C', ':Copilot panel<CR>',
    { desc = 'Open the Copilot panel', noremap = true })
vim.keymap.set('n', '<leader>D', vim.diagnostic.setqflist,
    { desc = 'Open diagnostics in a quickfix list', noremap = true })
vim.keymap.set('n', '<leader>M', ':CopilotChatModels<CR>',
    { desc = 'Open the CopilotChat Model selector', noremap = true })

-- The `g` commands "go somewhere", see the LSP `g` commands below
-- Available: `g(?|a|)` is not in use
vim.keymap.set('n', 'gb', ':e#<CR>',
    { desc = 'Edit last file', noremap = true, silent = true })
vim.keymap.set('n', 'gV', '`[v`]',
    { desc = 'Re-select last pasted text', noremap = true })

-- LSP Key mappings
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('theLspAttach', { clear = true }),
    callback = function(e)
        -- @deprecate in favor of the native `gra`
        vim.keymap.set({ 'n', 'v' }, 'g.', vim.lsp.buf.code_action, { desc = 'code actions', buffer = e.buf })
        vim.keymap.set('n', 'g>', ':VtsExec source_actions<CR>', { desc = 'source actions (vtsls)', buffer = e.buf })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'goto declaration', buffer = e.buf })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'goto definition', buffer = e.buf })
        vim.keymap.set('n', 'gf', vim.lsp.buf.definition, { desc = 'goto definition', buffer = e.buf })
        vim.keymap.set('n', 'gF', '<Cmd>vsplit | lua vim.lsp.buf.definition()<CR>',
            { desc = 'goto definition in vsplit', buffer = e.buf })
        vim.keymap.set('n', 'gS', vim.lsp.buf.signature_help, { desc = 'show signature', buffer = e.buf })
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { desc = 'goto types definition', buffer = e.buf })
    end

})
