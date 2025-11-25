-- @see https://github.com/nvim-neo-tree/neo-tree.nvim
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
  sources = { 'filesystem', 'buffers', 'git_status', },
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
    follow_current_file = {
      enabled = true,
    },
  },
})
