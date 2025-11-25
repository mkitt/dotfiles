local theme = require('theme')
local M = {}

M.colors = {
  base00 = '#2e3440',   -- Background
  base01 = '#3b4252',   -- UI Elements
  base02 = '#434c5e',   -- Selections
  base03 = '#666978',   -- Comments, NonText (20% lighter from Nord's #4c566a)
  base04 = '#d8dee9',   -- Foreground
  base05 = '#e5e9f0',   -- Subtle Elements
  base06 = '#eceff4',   -- Brighter Elements
  base07 = '#8fbcbb',   -- Classes, Types, Primitives (Cyanish)
  base08 = '#88c0d0',   -- Functions, Methods, Routines (Blueish)
  base09 = '#81a1c1',   -- Statements, Conditionals, Operators, Keywords (Bluish)
  base0A = '#5e81ac',   -- Pragmas, PreProcs (Bluish)
  base0B = '#bf616a',   -- Errors, Deletions (Redish)
  base0C = '#d08770',   -- Annotations, Support (Orangeish)
  base0D = '#ebcb8b',   -- Warnings, Changes (Yellowish)
  base0E = '#a3be8c',   -- Strings, Additions (Greenish)
  base0F = '#b48ead',   -- Numbers, Specials (Purpleish)
}

vim.cmd('hi clear')
vim.g.colors_name = 'nordish'
theme.apply(M.colors)

return M

-- @see https://www.nordtheme.com/docs/colors-and-palettes
-- @see https://github.com/chriskempson/base16/blob/main/styling.md
