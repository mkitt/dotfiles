local theme = require('theme')
local M = {}

M.colors = {
  base00 = '#ffffff', -- Background (pure white for sunlight)
  base01 = '#f5f5f5', -- UI Elements
  base02 = '#e8e8e8', -- Selections
  base03 = '#505050', -- Comments, NonText
  base04 = '#000000', -- Foreground
  base05 = '#0a0a0a', -- Subtle Elements
  base06 = '#000000', -- Brighter Elements
  base07 = '#cc0066', -- Classes, Types, Primitives (Magentaish)
  base08 = '#0044aa', -- Functions, Methods, Routines (Blueish)
  base09 = '#0055dd', -- Statements, Conditionals, Operators, Keywords (Bluish)
  base0A = '#003399', -- Pragmas, PreProcs (Bluish)
  base0B = '#cc0000', -- Errors, Deletions (Redish)
  base0C = '#ff6600', -- Annotations, Support (Orangeish)
  base0D = '#ff9900', -- Warnings, Changes (Yellowish)
  base0E = '#008833', -- Strings, Additions (Greenish)
  base0F = '#6633cc', -- Numbers, Specials (Purpleish)
}

vim.cmd('hi clear')
vim.g.colors_name = 'beamish'
theme.apply(M.colors)

return M
