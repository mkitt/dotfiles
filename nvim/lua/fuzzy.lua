-- @see https://github.com/ibhagwan/fzf-lua
local fuzzy = require('fzf-lua')

fuzzy.setup({
  'default',
  defaults   = {
    formatter = "path.dirname_first",
    cwd_prompt = false,
  },
  fzf_colors = true,
  git        = {
    icons = {
      ["M"] = { icon = "󰜥", color = "yellow" },
      ["D"] = { icon = "✖", color = "red" },
      ["A"] = { icon = "✚", color = "green" },
      ["R"] = { icon = "󰁕", color = "yellow" },
      ["C"] = { icon = "", color = "yellow" },
      ["T"] = { icon = "", color = "magenta" },
      ["?"] = { icon = "", color = "magenta" },
    },
  },
  keymap     = {
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
  winopts    = {
    title_pos = "left",
    preview = {
      hidden    = true,
      layout    = 'vertical',
      title_pos = "left",
      vertical  = "down:70%",
    }
  }
})

fuzzy.register_ui_select()
