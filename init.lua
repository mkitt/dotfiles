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

vim.cmd [[
  colorscheme pigment
  hi Delimiter cterm=NONE ctermbg=NONE ctermfg=4
  hi Float cterm=NONE ctermbg=NONE ctermfg=5
  hi Number cterm=NONE ctermbg=NONE ctermfg=5
  hi Tag cterm=NONE ctermbg=NONE ctermfg=12
  hi TelescopeBorder ctermbg=08 ctermfg=08
  hi TelescopePromptCounter ctermfg=06
  hi TelescopePromptTitle ctermfg=07
  hi def link NvimTreeRootFolder Directory
]]
-- https://neovim.io/doc/user/treesitter.html
vim.api.nvim_set_hl(0, "@constructor", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@exception", { link = "Special" })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "Normal" })
vim.api.nvim_set_hl(0, "@punctuation.special", { ctermfg = 11 })
vim.api.nvim_set_hl(0, "@tag.attribute", { link = "Statement" })
vim.api.nvim_set_hl(0, "@variable", { link = "Normal" })
vim.api.nvim_set_hl(0, "@text.literal", { link = "Normal" })
vim.api.nvim_set_hl(0, "@conceal", { link = "Conceal" })
-- CopilotLabel = { fg = nord.nord3_gui, bg = nord.none },

-- Key Mappings
-- -------------------------------------
local builtin = require("telescope.builtin")
local cocs = require("telescope").extensions.coc
local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
local nor = { noremap = true }
local norsil = { noremap = true, silent = true }
local norsilexp = { noremap = true, silent = true, expr = true }

-- Move between splits
vim.keymap.set("n", "<C-H>", "<C-W><C-H>", nor)
vim.keymap.set("n", "<C-J>", "<C-W><C-J>", nor)
vim.keymap.set("n", "<C-K>", "<C-W><C-K>", nor)
vim.keymap.set("n", "<C-L>", "<C-W><C-L>", nor)

vim.g.VM_maps = { ["Find Under"] = "<C-\\>",["Find Subword Under"] = "<C-\\>" }
vim.keymap.set("n", "<leader><leader>", ":nohlsearch<CR>", norsil)

-- Yanky
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", nor)
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", nor)
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", nor)
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", nor)
vim.keymap.set("n", "<C-P>", "<Plug>(YankyCycleForward)", nor)
vim.keymap.set("n", "<C-N>", "<Plug>(YankyCycleBackward)", nor)

-- Completion popup-menu
vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<TAB>",
    "coc#pum#visible() ? coc#pum#next(1) : exists('b:_copilot.suggestions') ? copilot#Accept('<CR>') : '<TAB>'",
    norsilexp)
vim.keymap.set("i", "<S-TAB>", "coc#pum#visible() ? coc#pum#prev(1) : '<C-h>'", norsilexp)
vim.keymap.set("i", "<CR>", "coc#pum#visible() ? coc#pum#confirm() : '<C-G>u<CR><C-R>=coc#on_enter()<CR>'", norsilexp)
vim.keymap.set("i", "<C-Space>", "coc#refresh()", norsilexp)

-- Telescope navigation ... <C-G>
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
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", norsil)
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", norsil)

-- Auto Commands
-- -------------------------------------
vim.cmd [[
   func! Eatchar(pat)
      let c = nr2char(getchar(0))
      return (c =~ a:pat) ? '' : c
   endfunc
  augroup FTOptions
    autocmd!
    autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal spell
    autocmd FileType markdown,text,txt setlocal textwidth=80 linebreak nolist wrap spell
    autocmd FileType javascript,typescript,typescriptreact iabbrev <buffer> cdl console.log()<Left><C-R>=Eatchar('\s')<CR>
  augroup END
]]

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
        requires = "nvim-treesitter/playground",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all",
                highlight = { enable = true, disable = { "gitcommit", "graphql" } },
            }
        end
    }
    use {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
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
    use "mg979/vim-visual-multi"
    use "mkitt/pigment"
    use "jparise/vim-graphql"
    use "tpope/vim-commentary"
    use "tpope/vim-fugitive"
    use "tpope/vim-repeat"
    use "tpope/vim-rhubarb"
    use "tpope/vim-surround"
    use "tpope/vim-unimpaired"
end)
