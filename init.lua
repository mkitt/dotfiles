-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- Preferences
-- -------------------------------------
-- Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.backup = false
vim.opt.clipboard = 'unnamed'
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' }
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = 'tab:▸ ,eol:¬,trail:·'
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.showcmd = false
vim.opt.sidescrolloff = 3
vim.opt.signcolumn = 'number'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.title = true
vim.opt.updatetime = 50
vim.opt.wildignore:append({ '.DS_Store' })
vim.opt.wrap = false
vim.opt.writebackup = false
if vim.fn.executable('rg') > 0 then vim.opt.grepprg = 'rg --vimgrep' end

vim.diagnostic.config({
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "☠️'",
            [vim.diagnostic.severity.WARN] = "⚠️'",
            [vim.diagnostic.severity.HINT] = "💡",
            [vim.diagnostic.severity.INFO] = "ℹ️",
        },
    },
})

-- Manage Plugins :: lazy.nvim
-- -------------------------------------
require('lazy').setup({
    -- Utility Dependencies
    { 'nvim-lua/plenary.nvim', },
    { 'MunifTanjim/nui.nvim', },
    -- Editing
    { 'nvim-treesitter/nvim-treesitter',             build = ':TSUpdate', },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'JoosepAlviste/nvim-ts-context-commentstring', },
    { 'numToStr/Comment.nvim', },
    { 'tpope/vim-repeat', },
    { 'tpope/vim-surround', },
    { 'tpope/vim-unimpaired', },
    { 'gbprod/yanky.nvim', },
    -- AI
    { 'zbirenbaum/copilot.lua',                      build = ':Copilot auth' },
    { 'CopilotC-Nvim/CopilotChat.nvim',              branch = 'main',        build = 'make tiktoken', },
    -- GIT
    { 'tpope/vim-fugitive', },
    { 'tpope/vim-rhubarb', },
    -- Editor/UI
    { 'nvim-tree/nvim-web-devicons', },
    -- LSP
    { 'williamboman/mason.nvim', },
    { 'williamboman/mason-lspconfig.nvim', },
    { 'neovim/nvim-lspconfig', },
    { 'folke/lazydev.nvim', },
    -- Formatting
    { 'stevearc/conform.nvim', },
    -- CMP
    { 'saghen/blink.cmp',                            version = '*', },
    -- Fuzzy
    { 'ibhagwan/fzf-lua' },
    -- Tree + Outline
    { 'nvim-neo-tree/neo-tree.nvim',                 branch = 'v3.x', },
}, {})

-- Plugin Setup :: Neovim
-- -------------------------------------
-- Store Core Plugins
local aichat = require('CopilotChat')
local lspconfig = require('lspconfig')
local cmp = require('blink.cmp')
local fuzzy = require('fzf-lua')
local tree = require('neo-tree')

-- Editing
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup({
    auto_install = true,
    highlight = { enable = true, disable = { 'gitcommit' } },
    indent = { enable = true },
    incremental_selection = { enable = true, },
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
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                [']a'] = '@parameter.inner',
            },
            swap_previous = {
                ['[a'] = '@parameter.inner',
            },
        },
    }
})

require('ts_context_commentstring').setup({
    enable_autocmd = false,
})

---@diagnostic disable-next-line: missing-fields
require('Comment').setup({
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

require('yanky').setup({
    highlight = { timer = 100 },
})

-- AI
require('copilot').setup({
    filetypes = { ['*'] = true, },
    panel = { enabled = false },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = { accept = '<C-\\>', }
    },
})

aichat.setup({
    model = 'claude-3.5-sonnet',
    question_header = '󰯈 Human ',
    answer_header = ' Copilot ',
    error_header = ' Error ',
    mappings = {
        reset = {
            normal = 'gR',
            insert = '',
        },
    },
})

-- Editor/UI
require('nvim-web-devicons').setup()

-- LSP
require('mason').setup()
require('mason-lspconfig').setup({
    automatic_installation = true,
    -- TODO: Add 'marksman'?
    ensure_installed = { 'bashls', 'cssls', 'eslint', 'graphql', 'html', 'jsonls', 'lua_ls', 'tailwindcss', 'vtsls', 'yamlls', },
})

local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp.get_lsp_capabilities()
)

require('mason-lspconfig').setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            capabilities = capabilities,
        })
    end,
})

lspconfig.eslint.setup({
    capabilities = capabilities,
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
        })
    end,
})

lspconfig.graphql.setup({
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*', 'package.json'),
})

lspconfig.vtsls.setup({
    capabilities = capabilities,
    init_options = {
        vtsls = { autoUseWorkspaceTsdk = true, },
    },
})

require('lazydev').setup()

-- Formatting
require('conform').setup({
    formatters_by_ft = {
        css = { 'prettierd', 'prettier', stop_after_first = true },
        graphql = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        lua = { 'stylua' },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
    },
    format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
    },
})

-- CMP
cmp.setup({
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
        menu = {
            draw = {
                columns = { { 'kind_icon' }, { 'label', 'label_description', 'source_name', gap = 1 } },
                treesitter = { 'lsp' },
            },
            max_height = 20,
        },
    },
    keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback', },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback', },
    },
    signature = { enabled = true, },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        cmdline = {},
        providers = {
            lazydev = {
                module = 'lazydev.integrations.blink',
                name = '',
                score_offset = 100,
            },
            lsp = { name = '' },
            path = { name = '' },
            snippets = { name = '' },
            buffer = { name = '' },
        },
    },
})

-- Fuzzy
fuzzy.setup({
    'default',
    defaults      = {
        formatter = "path.dirname_first",
        prompt = "  👽 ",
        cwd_prompt = false,
    },
    buffers       = { prompt = "  🗂️ ", },
    diagnostics   = {
        prompt = "  🚑 ",
        winopts = { preview = { hidden = true, } }
    },
    files         = {
        winopts = { preview = { hidden = true, } }
    },
    fzf_colors    = true,
    grep          = { prompt = " 🔍 ", },
    git           = {
        icons = {
            ["M"] = { icon = "󰜥", color = "yellow" },
            ["D"] = { icon = "✖", color = "red" },
            ["A"] = { icon = "✚", color = "green" },
            ["R"] = { icon = "󰁕", color = "yellow" },
            ["C"] = { icon = "", color = "yellow" },
            ["T"] = { icon = "", color = "magenta" },
            ["?"] = { icon = "", color = "magenta" },
        },
        status = { prompt = " 🚧 ", },
    },
    lsp           = {
        code_actions = {
            prompt = "  ✨ ",
            winopts = { preview = { hidden = true, } }
        }
    },
    keymap        = {
        builtin = {
            false,
            ["<Esc>"] = "hide",
            ["<F1>"]  = "toggle-help",
            ["<F2>"]  = "toggle-fullscreen",
            ["<F4>"]  = "toggle-preview",
            ["<F5>"]  = "toggle-preview-ccw",
            ["<F6>"]  = "toggle-preview-cw",
            ["<c-f>"] = "preview-page-down",
            ["<c-b>"] = "preview-page-up"
        },
        fzf = {
            false,
            ["ctrl-z"] = "abort",
            ["ctrl-q"] = "select-all+accept",
            ["ctrl-u"] = "half-page-up",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-x"] = "jump",
            ["ctrl-f"] = "preview-page-down",
            ["ctrl-b"] = "preview-page-up",
            ["ctrl-a"] = "toggle-all",
        }
    },
    spell_suggest = { prompt = " ✏️ ", },
    winopts       = {
        title_pos = "left",
        preview = {
            layout    = 'vertical',
            title_pos = "left",
            vertical  = "down:70%",
        }
    }
})
fuzzy.register_ui_select()

-- Tree + Outline
tree.setup({
    default_component_configs = {
        git_status = {
            symbols = {
                modified = '', -- Use unstaged instead
                unstaged = '󰜥',
            },
        },
    },
    popup_border_style = 'solid',
    sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols', },
    window = {
        mappings = {
            ['<C-V>'] = 'open_vsplit',
        },
        popup = {
            size = { width = '80%', },
        },
    },
    -- source configs
    filesystem = {
        find_by_full_path_words = true,
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            visible = true,
        },
        follow_current_file = {
            enabled = true,
        },
    },
    document_symbols = {
        -- The graphql language server currently blows up the symbols list 🙁
        client_filters = { ignore = { 'graphql' }, },
        follow_cursor = true,
    },
})

-- Key Mappings
-- :map
-- -------------------------------------
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
-- fzf-lua, CopilotChat, Neotree
vim.keymap.set('n', '<C-Space>', fuzzy.builtin, { desc = 'Open fzf-lua builtins', noremap = true })
vim.keymap.set('n', '<C-B>', fuzzy.buffers, { desc = 'Fuzzy find buffer files', noremap = true })
vim.keymap.set({ 'n', 'v' }, '<C-C>', aichat.open, { desc = 'Open CopilotChat', noremap = true, })
vim.keymap.set('n', '<C-E>', fuzzy.files, { desc = 'Fuzzy find filesystem files', noremap = true })
vim.keymap.set('n', '<C-F>', fuzzy.live_grep, { desc = 'Fuzzy search within files', noremap = true })
vim.keymap.set('v', '<C-F>', fuzzy.grep_visual, { desc = 'Fuzzy search the visual selection', noremap = true })
vim.keymap.set('n', '<C-G>', fuzzy.git_status, { desc = 'Fuzzy find git status files', noremap = true })
vim.keymap.set('n', '<C-S>', ':Neotree document_symbols toggle right<CR>',
    { desc = 'Open document symbols explorer', noremap = true, silent = true })
vim.keymap.set('n', '<C-T>', fuzzy.resume, { desc = 'Open fzf-lua with the last source used', noremap = true })
vim.keymap.set('n', '<C-Q>', function()
    require('CopilotChat.integrations.fzflua').pick(require('CopilotChat.actions').prompt_actions())
end, { desc = "CopilotChat - Prompt actions" })
-- <C-X> is mapped to lsp.buf.code_action in LspAttach autocmd
vim.keymap.set('n', '<C-Y>', ':Neotree toggle left<CR>',
    { desc = 'Open the filesystem tree explorer in the drawer', noremap = true, silent = true })

-- The `operator` commands
vim.keymap.set('n', '-', ':Neotree filesystem float reveal<CR>',
    { desc = 'Open the filesystem tree explorer in a float', noremap = true, silent = true })
vim.keymap.set('n', '\\', ':nohlsearch<CR>',
    { desc = 'Clear search highlighting', noremap = true, silent = true })

-- TODO
-- lua require'fzf-lua'.fzf_exec("rg --files", { previewer = "builtin" })

-- Leader commands
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


-- Auto Commands
-- -------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('theLspAttach', { clear = true }),
    callback = function(e)
        vim.keymap.set('n', '<C-X>', vim.lsp.buf.code_action, { desc = 'code actions', buffer = e.buf })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'goto declaration', buffer = e.buf })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'goto definition', buffer = e.buf })
        vim.keymap.set('n', 'gf', vim.lsp.buf.definition, { desc = 'goto definition', buffer = e.buf })
        vim.keymap.set('n', 'gF', '<Cmd>vsplit | lua vim.lsp.buf.definition()<CR>',
            { desc = 'goto definition in vsplit', buffer = e.buf })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'goto implementation', buffer = e.buf })
        vim.keymap.set('n', 'gS', vim.lsp.buf.signature_help, { desc = 'show signature', buffer = e.buf })
        vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { desc = 'rename', buffer = e.buf })
        vim.keymap.set('n', 'gu', vim.lsp.buf.references, { desc = 'show references', buffer = e.buf })
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { desc = 'goto types definition', buffer = e.buf })
        -- vim.keymap.set('n', 'g????', vim.lsp.buf.workspace_symbol, opts)

        -- Disable LSP semantic highlights
        local id = vim.tbl_get(e, 'data', 'client_id')
        local client = id and vim.lsp.get_client_by_id(id)
        if client ~= nil then
            client.server_capabilities.semanticTokensProvider = nil

            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    buffer = e.buf,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                    buffer = e.buf,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end
    end
})
vim.cmd [[
    func! Eatchar(pat)
        let c = nr2char(getchar(0))
        return (c =~ a:pat) ? '' : c
    endfunc
]]
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    command = "iabbrev <buffer> cdl console.log()<Left><C-R>=Eatchar('\\s')<CR>",
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'md', 'markdown', 'text', 'txt' },
    command = 'setlocal textwidth=80 linebreak nolist wrap spell',
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 'COMMIT_EDITMSG' },
    command = 'setlocal spell',
})
-- Editor group [:vert help highlight-groups]
-- Syntax group [:vert help group-name]
-- Treesitter https://neovim.io/doc/user/treesitter.html

-- Colors
-- :highlight
-- -------------------------------------
local function apply_theme(theme, overrides)
    local highlights = {
        -- GUI
        Normal = { bg = theme.base00, fg = theme.base04 },
        -- Normal = {  fg = theme.base04 },
        NonText = { fg = theme.base03 },
        SpecialKey = { fg = theme.base0B },
        Cursor = { bg = theme.base0F },
        CursorLine = { bg = theme.base01 },
        CursorColumn = { link = 'CursorLine' },
        ColorColumn = { link = 'CursorColumn' },
        LineNr = { link = 'NonText' },
        CursorLineNr = { fg = theme.base0F },
        WinSeparator = { bg = theme.base01, fg = theme.base01 },
        -- SignColumn = {  bg = theme.base00 },
        QuickFixLine = { link = 'CursorLine' },
        Directory = { fg = theme.base09 },
        Conceal = { fg = theme.base09 },
        Title = { fg = theme.base06, bold = true },

        -- Status & Tab Lines
        StatusLine = { bg = theme.base01, fg = theme.base0A },
        StatusLineNC = { bg = theme.base01, fg = theme.base03 },
        TabLine = { bg = theme.base01, fg = theme.base03 },
        TabLineSel = { link = "Title" },
        TabLineFill = { bg = theme.base01, fg = theme.base03 },

        -- Search & Selection
        Visual = { bg = theme.base02 },
        CurSearch = { bg = theme.base0A, fg = theme.base05 },
        Search = { bg = theme.base01 },
        IncSearch = { bg = theme.base01, fg = theme.base0C },
        MatchParen = { bg = theme.base03 },
        LspReferenceText = { link = 'Search' },

        -- Popup Menus & Floating Windows
        Pmenu = { bg = theme.base01 },
        PmenuSel = { bg = theme.base03 },
        PmenuThumb = { bg = theme.base02 },
        PmenuSbar = { bg = theme.base00 },
        WildMenu = { link = 'CurSearch' },
        NormalFloat = { link = 'Pmenu' },
        WinBar = { link = 'Pmenu' },
        WinBarNC = { link = 'Pmenu' },

        -- Syntax Highligting [:vert help group-name]
        Comment = { fg = theme.base03 },
        Constant = { fg = theme.base07 },  -- + Boolean
        Number = { fg = theme.base0F },
        Float = { link = 'Number' },
        String = { fg = theme.base0E },
        Character = { link = 'String' },
        Identifier = { fg = theme.base08 },  -- + Function
        Statement = { fg = theme.base09 },   -- + Conditional + Repeat + Label + Operator + Keyword + Exception
        PreProc = { fg = theme.base0A },     -- + Include + Define + Macro + PreCondit
        Type = { fg = theme.base07 },        -- + StorageClass + Structure + Typedef
        Special = { fg = theme.base0F },     -- + SpecialChar + SpecialComment
        Delimiter = { fg = theme.base09 },
        Tag = { fg = theme.base09 },
        Debug = { fg = theme.base0C },
        Underlined = { underline = true },
        Ignore = { fg = theme.base08 },
        Error = { fg = theme.base0B },
        Todo = { fg = theme.base0B, underline = true },

        -- Messages and diagnostics
        Added = { fg = theme.base0E },
        Changed = { fg = theme.base0D },
        Removed = { fg = theme.base0B },
        DiagnosticError = { fg = theme.base0B },
        DiagnosticWarn = { fg = theme.base0D },
        DiagnosticInfo = { fg = theme.base07 },
        DiagnosticHint = { fg = theme.base09 },
        DiagnosticOk = { fg = theme.base0E },
        DiagnosticDeprecated = { fg = theme.base0C },
        DiagnosticUnnecessary = { underline = true },
        DiagnosticUnderlineError = { fg = theme.base0B, underline = true },
        DiagnosticUnderlineWarn = { fg = theme.base0D, underline = true },
        DiagnosticUnderlineInfo = { fg = theme.base07, underline = true },
        DiagnosticUnderlineHint = { fg = theme.base09, underline = true },
        DiagnosticUnderlineOk = { fg = theme.base0E, underline = true },
        ErrorMsg = { link = "DiagnosticError" },
        ModeMsg = { link = "DiagnosticHint" },
        MoreMsg = { link = "DiagnosticHint" },
        WarningMsg = { link = "DiagnosticWarn" },
        Question = { fg = theme.base0C },

        -- Diffs
        DiffAdd = { bg = theme.base0E, fg = theme.base02 },
        DiffChange = { bg = theme.base0D, fg = theme.base02 },
        DiffDelete = { bg = theme.base0B, fg = theme.base02 },
        DiffText = { bg = theme.base09, fg = theme.base02 },

        -- Folds
        Folded = { fg = theme.base03 },
        FoldColumn = { link = 'Folded' },

        -- Spelling
        SpellBad = { underline = true },
        SpellCap = { underline = true },
        SpellLocal = { underline = true },
        SpellRare = { underline = true },

        -- Treesitter https://neovim.io/doc/user/treesitter.html
        ['@conceal'] = { link = 'Conceal' },
        ['@constructor'] = { link = 'Identifier' },
        ['@exception'] = { link = 'Special' },
        ['@punctuation.bracket'] = { fg = theme.base04 },
        ['@punctuation.special'] = { link = 'Debug' },
        ['@string.regex'] = { link = 'WarningMsg' },
        ['@tag.attribute'] = { link = 'Statement' },
        ['@text.literal'] = { fg = theme.base04 },
        ['@variable'] = { fg = theme.base04 },

        -- Plugins
        FzfLuaBorder = { fg = theme.base00, bg = theme.base00, },
        FzfLuaTitle = { link = "Title" },
        FzfLuaHeaderText = { link = "NonText" },
        FzfLuaTabTitle = { link = "NonText" },
        FzfLuaHeaderBind = { link = "NonText" },
        FzfLuaPathColNr = { link = "Debug" },
        FzfLuaPathLineNr = { link = "Debug" },
        FzfLuaBufNr = { link = "Debug" },
        FzfLuaBufFlagCur = { link = "Debug" },
        FzfLuaBufFlagAlt = { link = "Debug" },
        FzfLuaTabMarker = { link = "Debug" },
        FzfLuaLivePrompt = { link = "Debug" },
        FzfLuaLiveSym = { link = "Debug" },
        -- Tree Elements
        NeoTreeDimText = { link = "NonText" },
        NeoTreeDotfile = { link = "NonText" },
        NeoTreeFadeText1 = { link = "NonText" },
        NeoTreeFadeText2 = { link = "NonText" },
        NeoTreeFloatTitle = { link = "Title" },
        NeoTreeMessage = { link = "DiagnosticHint" },
        NeoTreeRootName = { link = "Title" },
        NeoTreeTitleBar = { link = "Title" },
        -- Tab Related
        NeoTreeTabActive = { link = "TablineSel" },
        NeoTreeTabInactive = { link = "Tabline" },
        NeoTreeTabSeparatorActive = { link = "TablineFill" },
        NeoTreeTabSeparatorInactive = { link = "TablineFill" },
        -- File Status
        NeoTreeAdded = { link = "Added" },
        NeoTreeDeleted = { link = "Removed" },
        NeoTreeModified = { link = "Changed" },
        NeoTreeFileStats = { link = "NonText" },
        NeoTreeFileStatsHeader = { link = "Title" },
        -- Git Status
        NeoTreeGitAdded = { link = "Added" },
        NeoTreeGitConflict = { link = "Error" },
        NeoTreeGitDeleted = { link = "Removed" },
        NeoTreeGitIgnored = { link = "NonText" },
        NeoTreeGitModified = { link = "Changed" },
        NeoTreeGitUntracked = { link = "Added" },
        -- Misc
        YankyPut = { link = "Search" },
        YankyYanked = { link = "MatchParen" },
    }
    -- Apply overrides
    for group, opts in pairs(overrides or {}) do
        highlights[group] = vim.tbl_extend('force', highlights[group] or {}, opts)
    end
    -- Set highlights
    for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

-- @see https://www.nordtheme.com/docs/colors-and-palettes
-- @see https://github.com/chriskempson/base16/blob/main/styling.md

local nordish = {
    base00 = '#2e3440', -- Background
    base01 = '#3b4252', -- UI Elements
    base02 = '#434c5e', -- Selections
    base03 = '#666978', -- Comments, NonText (20% lighter from Nord's #4c566a)
    base04 = '#d8dee9', -- Foreground
    base05 = '#e5e9f0', -- Subtle Elements
    base06 = '#eceff4', -- Brighter Elements
    base07 = '#8fbcbb', -- Classes, Types, Primitives (Cyanish)
    base08 = '#88c0d0', -- Functions, Methods, Routines (Blueish)
    base09 = '#81a1c1', -- Statements, Conditionals, Operators, Keywords (Bluish)
    base0A = '#5e81ac', -- Pragmas, PreProcs (Bluish)
    base0B = '#bf616a', -- Errors, Deletions (Redish)
    base0C = '#d08770', -- Annotations, Support (Orangeish)
    base0D = '#ebcb8b', -- Warnings, Changes (Yellowish)
    base0E = '#a3be8c', -- Strings, Additions (Greenish)
    base0F = '#b48ead', -- Numbers, Specials (Purpleish)
}

apply_theme(nordish, {
    -- Pmenu = {  bg = theme.base1, fg = theme.base5 },
})
