do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  --  For more options, you can see `:help option-list`

  -- Make line numbers default
  vim.o.number = true
  vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  See `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable break indent
  vim.o.breakindent = true

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 700

  -- Configure how new splits should be opened
  vim.o.splitright = false
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --   See `:help lua-options`
  --   and `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = ':=>', trail = '+', nbsp = '-' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 2

  -- See `:help 'confirm'`
  vim.o.confirm = true

  vim.o.pumblend = 0
  vim.o.winborder = 'rounded'
  vim.o.winblend = 0
  vim.o.textwidth = 78
  vim.o.colorcolumn = '+1,+2'
  vim.o.shortmess = vim.o.shortmess .. 'I'
  vim.o.virtualedit = 'block,onemore'
end
