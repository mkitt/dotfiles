-- -------------------------------------
-- Editing
require('nvim-treesitter').install({
  'bash', 'css', 'diff', 'dockerfile', 'git_config', 'git_rebase', 'gitignore', 'go', 'graphql', 'html', 'javascript', 'jsdoc', 'json',
  'make', 'mermaid', 'python', 'regex', 'ruby', 'scss', 'sql', 'swift', 'terraform', 'toml', 'tsx', 'typescript', 'xml', 'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require('yanky').setup({
  highlight = { timer = 100 },
})

-- -------------------------------------
-- Editor
require('nvim-web-devicons').setup()

require('blink.cmp').setup({
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    menu = {
      draw = {
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
        treesitter = { 'lsp' },
      },
      max_height = 20,
    },
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
  },
  cmdline = {
    enabled = false
  },
  keymap = {
    preset = 'enter',
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback', },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback', },
  },
  signature = {
    enabled = true,
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
})

-- fzf-lua asks for a socket named "fzf-lua.<os.time()>", which overflows macOS's
-- 104 byte sun_path limit under our long $TMPDIR. Nvim already appends
-- ".<pid>.<counter>" for uniqueness, so claim a shorter name before it does.
vim.g.fzf_lua_server = vim.fn.serverstart('fzf-lua')

local fuzzy = require('fzf-lua')
fuzzy.setup({
  'default',
  defaults   = {
    formatter = "path.dirname_first",
    cwd_prompt = false,
  },
  fzf_colors = true,
  keymap     = {
    builtin = {
      ["<Esc>"] = "hide",
    },
    fzf = {
      ["ctrl-q"] = "select-all+accept",
      ["ctrl-a"] = "toggle-all",
    }
  },
  winopts    = {
    title_pos = "left",
    ---@diagnostic disable-next-line: missing-fields
    preview = {
      hidden = true,
    }
  }
})
fuzzy.register_ui_select()

require('neo-tree').setup({
  default_component_configs = {
    git_status = {
      symbols = {
        modified = '', -- Use unstaged instead
        unstaged = '󰜥',
      },
    },
  },
  popup_border_style = 'solid',
  window = {
    mappings = {
      ['<C-V>'] = 'open_vsplit',
    },
    popup = {
      size = { width = '80%', },
      title = function() return "File Explorer" end,
    },
  },
  filesystem = {
    find_by_full_path_words = true,
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      visible = true,
    },
  },
})

-- -------------------------------------
-- Auto Commands

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown', 'text' },
  command = 'setlocal linebreak nolist wrap spell',
})
