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
vim.api.nvim_set_hl(0, "Normal", { ctermbg = 'NONE', ctermfg = 'NONE' })
vim.api.nvim_set_hl(0, "Cursor", { ctermbg = 5 })
vim.api.nvim_set_hl(0, "Visual", { ctermbg = 9 })
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 8 })
vim.api.nvim_set_hl(0, "CursorColumn", { ctermbg = 8 })
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 8 })
vim.api.nvim_set_hl(0, "QuickFixLine", { ctermbg = 8 })
vim.api.nvim_set_hl(0, "VertSplit", { ctermbg = 8, ctermfg = 8 })
vim.api.nvim_set_hl(0, "StatusLine", { ctermbg = 8, ctermfg = 12 })
vim.api.nvim_set_hl(0, "TabLineSel", { ctermfg = 12 })
vim.api.nvim_set_hl(0, "StatusLineNC", { ctermbg = 8, ctermfg = 10 })
vim.api.nvim_set_hl(0, "TabLine", { ctermbg = 8, ctermfg = 10 })
vim.api.nvim_set_hl(0, "TabLineFill", { ctermbg = 8, ctermfg = 10 })
vim.api.nvim_set_hl(0, "Search", { ctermbg = 9, ctermfg = 12 })
vim.api.nvim_set_hl(0, "IncSearch", { ctermbg = 9, ctermfg = 3 })
vim.api.nvim_set_hl(0, "WildMenu", { ctermbg = 12, ctermfg = 0 })
vim.api.nvim_set_hl(0, "SignColumn", { ctermfg = 'NONE' })
vim.api.nvim_set_hl(0, "LineNr", { ctermfg = 8 })
vim.api.nvim_set_hl(0, "CursorLineNr", { ctermfg = 8 })
vim.api.nvim_set_hl(0, "NonText", { ctermfg = 8 })
vim.api.nvim_set_hl(0, "Title", { ctermfg = 12 })
vim.api.nvim_set_hl(0, "SpecialKey", { ctermfg = 1 })
vim.api.nvim_set_hl(0, "ErrorMsg", { ctermfg = 1 })
vim.api.nvim_set_hl(0, "MatchParen", { ctermbg = 9 })
vim.api.nvim_set_hl(0, "WarningMsg", { ctermfg = 3 })
vim.api.nvim_set_hl(0, "Conceal", { ctermfg = 4 })
vim.api.nvim_set_hl(0, "Directory", { ctermfg = 4 })
vim.api.nvim_set_hl(0, "ModeMsg", { ctermfg = 2 })
vim.api.nvim_set_hl(0, "MoreMsg", { ctermfg = 2 })
vim.api.nvim_set_hl(0, "Question", { ctermfg = 4 })
vim.api.nvim_set_hl(0, "Folded", { ctermfg = 10 })
vim.api.nvim_set_hl(0, "FoldColumn", { ctermfg = 10 })
vim.api.nvim_set_hl(0, "Pmenu", { ctermbg = 8 })
vim.api.nvim_set_hl(0, "PmenuSel", { ctermbg = 12, ctermfg = 0 })
vim.api.nvim_set_hl(0, "PmenuThumb", { ctermbg = 10 })
vim.api.nvim_set_hl(0, "PmenuSbar", { ctermbg = "NONE", ctermfg = "NONE" })
vim.api.nvim_set_hl(0, "DiffAdd", { ctermbg = 2, ctermfg = 0 })
vim.api.nvim_set_hl(0, "DiffChange", { ctermbg = 3, ctermfg = 0 })
vim.api.nvim_set_hl(0, "DiffDelete", { ctermbg = 1, ctermfg = 0 })
vim.api.nvim_set_hl(0, "DiffText", { ctermbg = 4, ctermfg = 0 })
vim.api.nvim_set_hl(0, "SpellBad", { underline = true })
vim.api.nvim_set_hl(0, "SpellCap", { underline = true })
vim.api.nvim_set_hl(0, "SpellRare", { underline = true })
vim.api.nvim_set_hl(0, "SpellLocal", { underline = true })
-- Syntax group [:vert help group-name]
vim.api.nvim_set_hl(0, "Comment", { ctermfg = 10 })
vim.api.nvim_set_hl(0, "Constant", { ctermfg = 6 }) -- + Boolean
vim.api.nvim_set_hl(0, "Number", { ctermfg = 5 })
vim.api.nvim_set_hl(0, "Float", { link = "Number" })
vim.api.nvim_set_hl(0, "String", { ctermfg = 2 })
vim.api.nvim_set_hl(0, "Character", { ctermfg = 2 })
vim.api.nvim_set_hl(0, "Identifier", { ctermfg = 12 }) -- + Function
vim.api.nvim_set_hl(0, "Statement", { ctermfg = 4 })   -- + Conditional + Repeat + Label + Operator + Keyword + Exception
vim.api.nvim_set_hl(0, "PreProc", { ctermfg = 13 })    -- + Include + Define + Macro + PreCondit
vim.api.nvim_set_hl(0, "Type", { ctermfg = 4 })        -- + StorageClass + Structure + Typedef
vim.api.nvim_set_hl(0, "Special", { ctermfg = 5 })     -- + SpecialChar + SpecialComment
vim.api.nvim_set_hl(0, "Delimiter", { ctermfg = 4 })
vim.api.nvim_set_hl(0, "Tag", { ctermfg = 12 })
vim.api.nvim_set_hl(0, "Debug", { ctermfg = 11 })
vim.api.nvim_set_hl(0, "Underlined", { underline = true })
vim.api.nvim_set_hl(0, "Ignore", { ctermfg = 14 })
vim.api.nvim_set_hl(0, "Error", { ctermfg = 1 })
vim.api.nvim_set_hl(0, "Todo", { underline = true, ctermfg = 1 })
-- Plugins group
vim.api.nvim_set_hl(0, "CopilotSuggestion", { link = 'NonText' })
vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { link = "Directory" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "VertSplit" })
vim.api.nvim_set_hl(0, "TelescopePromptCounter", { link = "Constant" })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { ctermfg = 7 })
-- Treesitter https://neovim.io/doc/user/treesitter.html
vim.api.nvim_set_hl(0, "@constructor", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@exception", { link = "Special" })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "Normal" })
vim.api.nvim_set_hl(0, "@punctuation.special", { link = "Debug" })
vim.api.nvim_set_hl(0, "@tag.attribute", { link = "Statement" })
vim.api.nvim_set_hl(0, "@variable", { link = "Normal" })
vim.api.nvim_set_hl(0, "@text.literal", { link = "Normal" })
vim.api.nvim_set_hl(0, "@conceal", { link = "Conceal" })

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

-- Multiple cursor
vim.g.VM_maps = { ["Find Under"] = "<C-\\>", ["Find Subword Under"] = "<C-\\>" }

-- Yanky
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", nor)
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", nor)
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", nor)
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", nor)
vim.keymap.set("n", "<C-P>", "<Plug>(YankyCycleForward)", nor)
vim.keymap.set("n", "<C-N>", "<Plug>(YankyCycleBackward)", nor)

-- Completion pum
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap('i', '<C-\\>', 'copilot#Accept("<CR>")', norsilexp)
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
vim.keymap.set("n", "<C-Y>", ":NvimTreeToggle<CR>", norsil)
vim.keymap.set("n", "-", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", norsil)

-- The `g` commands
vim.keymap.set("n", "g.", cocs.file_code_actions, norsil)
vim.keymap.set("n", "gb", ":e#<CR>", norsil)
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", norsil)
vim.keymap.set("n", "gf", ":call CocActionAsync('jumpDefinition')<CR>", norsil)
vim.keymap.set("n", "gF", ":call CocActionAsync('jumpDefinition', 'vsplit')<CR>", norsil)
vim.keymap.set("n", "gh", ":call CocActionAsync('doHover')<CR>", norsil)
vim.keymap.set("n", "gr", "<Plug>(coc-rename)", norsil)
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
    pattern = { "javascript", "typescript", "typescriptreact" },
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

-- Plugins
-- -------------------------------------
return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"
    use { "neoclide/coc.nvim", branch = "release", run = ":CocUpdate" }
    use {
        "gbprod/yanky.nvim",
        config = function()
            require("yanky").setup({ highlight = { timer = 50 } })
        end
    }
    use {
        "nvim-treesitter/nvim-treesitter",
        requires = {
            { "nvim-treesitter/playground" },
            { "JoosepAlviste/nvim-ts-context-commentstring" },
        },
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all",
                context_commentstring = { enable = true, },
                highlight = { enable = true, disable = { "gitcommit", "graphql" } },
            }
        end
    }
    use {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                actions = { open_file = { window_picker = { enable = false, }, }, },
                filters = { custom = { ".DS_Store" } },
                git = { ignore = false, },
                renderer = {
                    icons = {
                        show = { file = false, folder = false, },
                        glyphs = {
                            folder = { arrow_closed = "▸", arrow_open = "▾", },
                            git = { deleted = "-", unmerged = "‡", unstaged = "~" },
                        },
                    }
                },
            })
        end
    }
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "fannheyward/telescope-coc.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim",    run = "make" },
            { "nvim-telescope/telescope-file-browser.nvim" },
            { "nvim-telescope/telescope-live-grep-args.nvim" },
        },
        config = function()
            require("telescope").setup {
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
            }
            require("telescope").load_extension("coc")
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("file_browser")
            require("telescope").load_extension("yank_history")
            require("telescope").load_extension("live_grep_args")
        end
    }
    use "github/copilot.vim"
    use "jparise/vim-graphql"
    use "mg979/vim-visual-multi"
    use "tpope/vim-commentary"
    use "tpope/vim-fugitive"
    use "tpope/vim-repeat"
    use "tpope/vim-rhubarb"
    use "tpope/vim-surround"
    use "tpope/vim-unimpaired"
end)
