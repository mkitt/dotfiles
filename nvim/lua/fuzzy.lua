-- @see https://github.com/ibhagwan/fzf-lua
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
    preview = {
      hidden = true,
    }
  }
})

fuzzy.register_ui_select()
