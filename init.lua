-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath, })
end
vim.opt.rtp:prepend(lazypath)

-- Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Plugins
-- -------------------------------------
require("lazy").setup({
        {
            "neoclide/coc.nvim",
            branch = "release",
            build = ":CocUpdate"
        },

        -- Editing
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            dependencies = {
                "nvim-treesitter/nvim-treesitter-textobjects",
            },
            config = function()
                require("nvim-treesitter.configs").setup({
                    auto_install = true,
                    highlight = { enable = true, disable = { "gitcommit", "graphql" } },
                    indent = { enable = true },
                    incremental_selection = { enable = true, },
                    textobjects = {
                        select = { enable = true, lookahead = true },
                        move = { enable = true, set_jumps = true },
                        swap = { enable = true },
                    }
                })
            end
        },
        {
            "folke/ts-comments.nvim",
            opts = {},
        },
        -- TODO: Deprecate with LSP + treesitter
        "jparise/vim-graphql",
        {
            "gbprod/yanky.nvim",
            opts = { highlight = { timer = 50 }, }
        },
        {
            "echasnovski/mini.ai",
            opts = {}
        },
        {
            "echasnovski/mini.bracketed",
            opts = {}
        },
        {
            "echasnovski/mini.comment",
            opts = {}
        },
        {
            "echasnovski/mini.move",
            opts = {}
        },
        {
            "echasnovski/mini.pairs",
            opts = {}
        },
        {
            "echasnovski/mini.surround",
            opts = {
                mappings = {
                    add = 'ys',
                    delete = 'ds',
                    find = 'yf',
                    find_left = 'yF',
                    highlight = 'yh',
                    replace = 'cs',
                    update_n_lines = '',
                },
                search_method = 'cover_or_next',
            }
        },
        -- TODO: Is there a lua replacement?
        "tpope/vim-repeat",
        -- TODO: Neovim 0.12 https://neovim.io/roadmap/
        {
            "mg979/vim-visual-multi",
            init = function() vim.g.VM_maps = { ["Find Under"] = "<C-\\>", ["Find Subword Under"] = "<C-\\>" } end,
        },

        -- AI
        {
            "zbirenbaum/copilot.lua",
            build = ":Copilot auth",
            cmd = "Copilot",
            event = "InsertEnter",
            opts = {
                filetypes = { ["*"] = true, },
                panel = { enabled = false },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = { accept = "<C-\\>", }
                },
            },
        },
        {
            "CopilotC-Nvim/CopilotChat.nvim",
            branch = "main",
            build = "make tiktoken",
            dependencies = { { "zbirenbaum/copilot.lua" }, { "nvim-lua/plenary.nvim" }, },
            opts = {},
        },

        -- GIT
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb",

        -- Editor
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "fannheyward/telescope-coc.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
                "nvim-telescope/telescope-file-browser.nvim",
                "nvim-telescope/telescope-live-grep-args.nvim",
            },
            config = function()
                local telescope = require("telescope")
                telescope.setup({
                    defaults = {
                        layout_strategy = "vertical",
                        layout_config = {
                            vertical = { mirror = true, preview_cutoff = 0, prompt_position = "top", }
                        },
                        prompt_prefix = "👽 ",
                        selection_caret = "• ",
                        sorting_strategy = 'ascending',
                    },
                    extensions = {
                        coc = { prefer_locations = true },
                        file_browser = { dir_icon = "▸", grouped = true, hidden = true, prompt_path = true }
                    },
                })
                telescope.load_extension("coc")
                telescope.load_extension("fzf")
                telescope.load_extension("file_browser")
                telescope.load_extension("yank_history")
                telescope.load_extension("live_grep_args")
            end
        },
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
            },
            config = function()
                require("neo-tree").setup({
                    sources = {
                        "filesystem",
                        "buffers",
                        "git_status",
                        "document_symbols",
                    },
                    default_component_configs = {
                        icon = {
                            folder_closed = "▸",
                            folder_open = "▾",
                            folder_empty = ".",
                            default = "",
                        },
                        name = {
                            trailing_slash = true,
                            use_git_status_colors = false,
                        },
                        git_status = {
                            align = "right",
                            symbols = {
                                -- Change type
                                added     = "✚",
                                deleted   = "-",
                                modified  = "", -- Use unstaged instead
                                renamed   = "➜",
                                -- Status type
                                untracked = "★",
                                ignored   = "◌",
                                unstaged  = "~",
                                staged    = "✓",
                                conflict  = "✖",
                                -- unmerged = "‡" -- Not in neo-tree
                            },
                        },
                    },
                    window = {
                        mappings = {
                            ['<C-V>'] = "open_vsplit",
                            ['B'] = "Neotree_buffers",
                            ['E'] = "Neotree_filesystem",
                            ['F'] = "focus_preview",
                            ['G'] = "Neotree_git_status",
                            ['Z'] = "Neotree_symbols",
                            ['-'] = "parent_directory",
                            ['l'] = false,
                        },
                    },
                    commands = {
                        Neotree_filesystem = function() vim.cmd('Neotree filesystem') end,
                        Neotree_buffers = function() vim.cmd('Neotree buffers') end,
                        Neotree_git_status = function() vim.cmd('Neotree git_status') end,
                        Neotree_symbols = function() vim.cmd('Neotree document_symbols right') end,
                        parent_directory = function() vim.cmd('Neotree current %:p:h:h') end,
                    },
                    filesystem = {
                        filtered_items = {
                            hide_dotfiles = false,
                            hide_gitignored = false,
                        },
                    },
                })
            end
        },
    },
    {
        ui = {
            icons = {
                cmd = "⌘",
                config = "🛠",
                event = "📅",
                ft = "📂",
                init = "⚙",
                keys = "🗝",
                lazy = "💤 ",
                plugin = "🔌",
                require = "🌙",
                runtime = "💻",
                source = "📄",
                start = "🚀",
                task = "📌",
            },
        },
    }
)

-- Preferences
-- -------------------------------------
vim.opt.backup = false
vim.opt.clipboard = "unnamed"
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = "tab:▸ ,eol:¬,trail:·"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.showcmd = false
vim.opt.sidescrolloff = 3
vim.opt.signcolumn = "number"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.title = true
vim.opt.updatetime = 50
vim.opt.wildignore:append({ '.DS_Store' })
vim.opt.wrap = false
vim.opt.writebackup = false
if vim.fn.executable("rg") > 0 then vim.opt.grepprg = "rg --vimgrep" end

-- Colors
-- -------------------------------------
-- Editor group [:vert help highlight-groups]
vim.api.nvim_set_hl(0, "Normal", { ctermbg = "NONE", ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "Cursor", { ctermbg = 5, ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "Visual", { ctermbg = 9, ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 8, ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "CursorColumn", { ctermbg = 8, ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 8, ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "QuickFixLine", { ctermbg = 8, ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "WinSeparator", { ctermbg = 8, ctermfg = 8 })
vim.api.nvim_set_hl(0, "StatusLine", { ctermbg = 8, ctermfg = 12 })
vim.api.nvim_set_hl(0, "TabLineSel", { ctermbg = "NONE", ctermfg = 12 })
vim.api.nvim_set_hl(0, "StatusLineNC", { ctermbg = 8, ctermfg = 10 })
vim.api.nvim_set_hl(0, "TabLine", { ctermbg = 8, ctermfg = 10 })
vim.api.nvim_set_hl(0, "TabLineFill", { ctermbg = 8, ctermfg = 10 })
vim.api.nvim_set_hl(0, "Search", { ctermbg = 9, ctermfg = 12 })
vim.api.nvim_set_hl(0, "IncSearch", { ctermbg = 9, ctermfg = 11 })
vim.api.nvim_set_hl(0, "WildMenu", { ctermbg = 12, ctermfg = 'NONE' })
vim.api.nvim_set_hl(0, "SignColumn", { ctermbg = "NONE", ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "LineNr", { ctermbg = "NONE", ctermfg = 8 })
vim.api.nvim_set_hl(0, "CursorLineNr", { ctermbg = "NONE", ctermfg = 8 })
vim.api.nvim_set_hl(0, "NonText", { ctermbg = "NONE", ctermfg = 8 })
vim.api.nvim_set_hl(0, "Title", { ctermbg = "NONE", ctermfg = 12 })
vim.api.nvim_set_hl(0, "SpecialKey", { ctermbg = "NONE", ctermfg = 1 })
vim.api.nvim_set_hl(0, "ErrorMsg", { ctermbg = "NONE", ctermfg = 1 })
vim.api.nvim_set_hl(0, "MatchParen", { ctermbg = 9, ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "WarningMsg", { ctermbg = "NONE", ctermfg = 3 })
vim.api.nvim_set_hl(0, "Conceal", { ctermbg = "NONE", ctermfg = 4 })
vim.api.nvim_set_hl(0, "Directory", { ctermbg = "NONE", ctermfg = 4 })
vim.api.nvim_set_hl(0, "ModeMsg", { ctermbg = "NONE", ctermfg = 4 })
vim.api.nvim_set_hl(0, "MoreMsg", { ctermbg = "NONE", ctermfg = 4 })
vim.api.nvim_set_hl(0, "Question", { ctermbg = "NONE", ctermfg = 4 })
vim.api.nvim_set_hl(0, "Folded", { ctermbg = "NONE", ctermfg = 10 })
vim.api.nvim_set_hl(0, "FoldColumn", { ctermbg = "NONE", ctermfg = 10 })
vim.api.nvim_set_hl(0, "Pmenu", { ctermbg = 8, ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "PmenuSel", { ctermbg = 9, ctermfg = 'NONE' })
vim.api.nvim_set_hl(0, "PmenuThumb", { ctermbg = 9, ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "PmenuSbar", { ctermbg = "NONE", ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "DiffAdd", { ctermbg = 2, ctermfg = 9 })
vim.api.nvim_set_hl(0, "DiffChange", { ctermbg = 3, ctermfg = 9 })
vim.api.nvim_set_hl(0, "DiffDelete", { ctermbg = 1, ctermfg = 9 })
vim.api.nvim_set_hl(0, "DiffText", { ctermbg = 4, ctermfg = 9 })
vim.api.nvim_set_hl(0, "SpellBad", { ctermbg = "NONE", ctermfg = "NONE", underline = true })
vim.api.nvim_set_hl(0, "SpellCap", { ctermbg = "NONE", ctermfg = "NONE", underline = true })
vim.api.nvim_set_hl(0, "SpellRare", { ctermbg = "NONE", ctermfg = "NONE", underline = true })
vim.api.nvim_set_hl(0, "SpellLocal", { ctermbg = "NONE", ctermfg = "NONE", underline = true })
-- Syntax group [:vert help group-name]
vim.api.nvim_set_hl(0, "Comment", { ctermbg = "NONE", ctermfg = 10 })
vim.api.nvim_set_hl(0, "Constant", { ctermbg = "NONE", ctermfg = 6 }) -- + Boolean
vim.api.nvim_set_hl(0, "DiagnosticError", { link = "Error" })
vim.api.nvim_set_hl(0, "Number", { ctermbg = "NONE", ctermfg = 5 })
vim.api.nvim_set_hl(0, "Float", { link = "Number" })
vim.api.nvim_set_hl(0, "String", { ctermbg = "NONE", ctermfg = 2 })
vim.api.nvim_set_hl(0, "Character", { ctermbg = "NONE", ctermfg = 2 })
vim.api.nvim_set_hl(0, "Identifier", { ctermbg = "NONE", ctermfg = 14 }) -- + Function
vim.api.nvim_set_hl(0, "Statement", { ctermbg = "NONE", ctermfg = 4 })   -- + Conditional + Repeat + Label + Operator + Keyword + Exception
vim.api.nvim_set_hl(0, "PreProc", { ctermbg = "NONE", ctermfg = 12 })    -- + Include + Define + Macro + PreCondit
vim.api.nvim_set_hl(0, "Type", { ctermbg = "NONE", ctermfg = 6 })        -- + StorageClass + Structure + Typedef
vim.api.nvim_set_hl(0, "Special", { ctermbg = "NONE", ctermfg = 5 })     -- + SpecialChar + SpecialComment
vim.api.nvim_set_hl(0, "Delimiter", { ctermbg = "NONE", ctermfg = 4 })
vim.api.nvim_set_hl(0, "Tag", { ctermbg = "NONE", ctermfg = 4 })
vim.api.nvim_set_hl(0, "Debug", { ctermbg = "NONE", ctermfg = 11 })
vim.api.nvim_set_hl(0, "Underlined", { underline = true })
vim.api.nvim_set_hl(0, "Ignore", { ctermbg = "NONE", ctermfg = 14 })
vim.api.nvim_set_hl(0, "Error", { ctermbg = "NONE", ctermfg = 1 })
vim.api.nvim_set_hl(0, "Todo", { ctermbg = "NONE", ctermfg = 1, underline = true })
-- Plugins group
vim.api.nvim_set_hl(0, "CocCodeLens", { link = 'Special' })
vim.api.nvim_set_hl(0, "CocFloating", { link = 'Pmenu' })
vim.api.nvim_set_hl(0, "CocFloatSbar", { link = 'PmenuSbar' })
vim.api.nvim_set_hl(0, "CocFloatThumb", { link = 'PmenuThumb' })
vim.api.nvim_set_hl(0, "CocListSearch", { link = 'Special' })
vim.api.nvim_set_hl(0, "CocMenuSel", { link = 'PmenuSel' })
vim.api.nvim_set_hl(0, "CocSearch", { link = 'Special' })
vim.api.nvim_set_hl(0, "CopilotSuggestion", { link = 'NonText' })
vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { ctermbg = "NONE", ctermfg = 9 })
vim.api.nvim_set_hl(0, "NeoTreeRootName", { link = "Directory" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "WinSeparator" })
vim.api.nvim_set_hl(0, "TelescopePromptCounter", { link = "Constant" })
-- Treesitter https://neovim.io/doc/user/treesitter.html
vim.api.nvim_set_hl(0, "@conceal", { link = "Conceal" })
vim.api.nvim_set_hl(0, "@constructor", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@exception", { link = "Special" })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "Normal" })
vim.api.nvim_set_hl(0, "@punctuation.special", { link = "Debug" })
vim.api.nvim_set_hl(0, "@string.regex", { link = "WarningMsg" })
vim.api.nvim_set_hl(0, "@tag.attribute", { link = "Statement" })
vim.api.nvim_set_hl(0, "@text.literal", { link = "Normal" })
vim.api.nvim_set_hl(0, "@variable", { link = "Normal" })

-- Key Mappings
-- -------------------------------------
local nor = { noremap = true }
local norsil = { noremap = true, silent = true }
local norsilexp = { noremap = true, silent = true, expr = true }

-- Move between splits
vim.keymap.set("n", "<C-H>", "<C-W><C-H>", nor)
vim.keymap.set("n", "<C-J>", "<C-W><C-J>", nor)
vim.keymap.set("n", "<C-K>", "<C-W><C-K>", nor)
vim.keymap.set("n", "<C-L>", "<C-W><C-L>", nor)

-- Add a blank line above/below the cursor
vim.api.nvim_set_keymap('n', '[<Space>', 'O<Esc>0"_D', norsil)
vim.api.nvim_set_keymap('n', ']<Space>', 'o<Esc>0"_D', norsil)

-- Make the surround plugin work like tpope/vim-surround
vim.keymap.del('x', 'ys')
vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
vim.keymap.set('n', 'yss', 'ys_', { remap = true })

-- Yanky
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", nor)
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", nor)
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", nor)
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", nor)
vim.keymap.set("n", "<C-P>", "<Plug>(YankyCycleForward)", nor)
vim.keymap.set("n", "<C-N>", "<Plug>(YankyCycleBackward)", nor)

-- Completion pum
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<C-\\>', function() require("copilot.suggestion").accept() end, norsilexp)
vim.keymap.set("i", "<TAB>", "coc#pum#visible() ? coc#pum#next(1) : '<TAB>'", norsilexp)
vim.keymap.set("i", "<S-TAB>", "coc#pum#visible() ? coc#pum#prev(1) : '<C-h>'", norsilexp)
vim.keymap.set("i", "<CR>", "coc#pum#visible() ? coc#pum#confirm() : '<C-G>u<CR><C-R>=coc#on_enter()<CR>'", norsilexp)
vim.keymap.set("i", "<C-Space>", "coc#refresh()", norsilexp)

-- Telescope ... <C-G> is not in use
local builtin = require("telescope.builtin")
local cocs = require("telescope").extensions.coc
local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
vim.keymap.set("n", "<C-Space>", function() builtin.builtin { include_extensions = true } end, norsil)
vim.keymap.set("n", "<C-B>", builtin.buffers, norsil)
vim.keymap.set("n", "<C-C>", cocs.commands, norsil)
vim.keymap.set("n", "<C-E>", builtin.find_files, norsil)
vim.keymap.set("n", "<C-F>", builtin.live_grep, norsil)
vim.keymap.set("v", "<C-F>", lga_shortcuts.grep_visual_selection)
vim.keymap.set("n", "<C-S>", builtin.resume, norsil)
vim.keymap.set("n", "<C-Y>", ":Neotree toggle<CR>", norsil)
vim.keymap.set("n", "-", ":Neotree current %:p:h<CR>", norsil)
vim.keymap.set("n", "_", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", norsil)

vim.keymap.set({ "n", "v" }, "<C-G>", function()
    if vim.fn.mode() == 'v' then
        vim.cmd('normal! gv"xy')
        local selection = vim.fn.getreg('x')
        vim.cmd('CopilotChat ' .. selection)
    else
        vim.cmd('CopilotChat')
    end
end, { noremap = true, silent = true })

-- The `g` commands
vim.keymap.set("n", "g.", cocs.file_code_actions, norsil)
vim.keymap.set("n", "gb", ":e#<CR>", norsil)
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", norsil)
vim.keymap.set("n", "gf", ":call CocActionAsync('jumpDefinition')<CR>", norsil)
vim.keymap.set("n", "gF", ":call CocActionAsync('jumpDefinition', 'vsplit')<CR>", norsil)
vim.keymap.set("n", "gh", ":call CocActionAsync('doHover')<CR>", norsil)
-- vim.keymap.set("n", "gr", "<Plug>(coc-rename)", norsil)
vim.keymap.set("n", "gu", "<Plug>(coc-refactor)", norsil)
vim.keymap.set("n", "gV", "`[v`]", norsil)
vim.keymap.set('x', 'gz', 'y :CocSearch <C-R>=' .. vim.fn.escape('@', "',\"$ ") .. '<CR><CR>', nor)
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", norsil)
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", norsil)

-- Leader commands
vim.keymap.set("n", "<leader><leader>", ":nohlsearch<CR>", norsil)

-- Auto Commands
-- -------------------------------------
vim.cmd [[
    func! Eatchar(pat)
        let c = nr2char(getchar(0))
        return (c =~ a:pat) ? '' : c
    endfunc
]]
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    command = "iabbrev <buffer> cdl console.log()<Left><C-R>=Eatchar('\\s')<CR>",
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "md", "markdown", "text", "txt" },
    command = "setlocal textwidth=80 linebreak nolist wrap spell",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "COMMIT_EDITMSG" },
    command = "setlocal spell",
})
