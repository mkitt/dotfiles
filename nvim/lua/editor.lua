-- -------------------------------------
-- Editing
require('nvim-treesitter').install({
  'bash', 'css', 'diff', 'dockerfile', 'git_config', 'git_rebase',
  'gitignore', 'go', 'graphql', 'html', 'javascript', 'jsdoc',
  'json', 'jsonc', 'make', 'mermaid', 'python', 'regex', 'ruby',
  'scss', 'sql', 'swift', 'terraform', 'toml', 'tsx', 'typescript',
  'xml', 'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
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

-- -------------------------------------
-- Editor
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = { ["*"] = true, }
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
    default = { 'copilot', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      copilot = { name = '', module = 'blink-copilot', async = true },
    },
  },
})

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
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  command = 'checktime',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown', 'text' },
  command = 'setlocal linebreak nolist wrap spell',
})
