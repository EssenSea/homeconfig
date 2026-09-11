require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
local o = vim.o
local g = vim.g
-- g.maplocalleader = ","
o.cursorlineopt = "both" -- to enable cursorline!
o.colorcolumn = "+1"
o.textwidth = 78
o.backup = false
o.signcolumn = "yes"
g.ft_man_open_mode = "vert"

-- g.ft_man_folding_enable = true

if g.neovide then
  -- o.guifont = "libertinus mono:h14"
  o.guifont = "Sarasa Term SC Nerd:h16"
  o.linespace = 0
  g.neovide_opacity = 1
  g.neovide_normal_opacity = 0.8
  g.transparency = 1
end
