-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Iterate over all Lua files in the plugins directory and load them.
-- `vim.fs.dir()` iteration order is unspecified and must not be relied upon.
local plugins_dir =
  vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir, { follow = true }) do
  if
    (type == 'file' or type == 'link')
    and file_name:match '%.lua$'
    and file_name ~= 'init.lua'
  then
    local module = file_name:gsub('%.lua$', '')
    require('custom.plugins.' .. module)
  end
end
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'lervag/vimtex' }
vim.g.vimtex_indent_enabled = 1
vim.g.vimtex_format_enabled = 1
vim.g.vimtex_imap_enable = 1
vim.g.vimtex_view_method = 'sioyek'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_compiler_latexmk_engine = { ['_'] = '-lualatex' }
vim.g.vimtex_ui_method = {
  ['confirm'] = 'nvim',
  ['input'] = 'nvim',
  ['select'] = 'nvim',
}

-- vim.pack.add { gh 'stevearc/aerial.nvim' }
-- require('aerial').setup {
--   -- optionally use on_attach to set keymaps when aerial has attached to a buffer
--   on_attach = function(bufnr)
--     -- Jump forwards/backwards with '{' and '}'
--     vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
--     vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
--   end,
-- }
-- -- You probably also want to set a keymap to toggle aerial
-- vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')

-- require('mini.pairs').setup()

require('mini.files').setup {
  content = {
    -- filter = true,
  },
  windows = {
    max_number = 2,
    preview = true,
    width_preview = 80,
    width_focus = 40,
    width_nofocus = 20,
  },
  mappings = {
    go_in = 'L',
    go_in_plus = 'l',
  },
}
vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
  if MiniFiles.close() == nil then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end, { desc = 'MiniFiles' })

vim.pack.add { gh 'shellRaining/hlchunk.nvim' }
require('hlchunk').setup {
  chunk = {
    enable = true,
    use_treesitter = true,
    style = {
      '#d3c6aa',
    },
    chars = {
      horizontal_line = '─',
      vertical_line = '│',
      left_top = '╭',
      left_bottom = '╰',
      right_arrow = '>',
    },
    notify = true,
    priority = 0,
    error_sign = true,
    exclude_filetypes = {},
    duration = 200,
    delay = 50,
  },
  indent = {
    enable = true,
  },
  line_num = {
    enable = true,
  },
  blank = {
    enable = true,
  },
}

vim.pack.add {
  -- gh 'MunifTanjim/nui.nvim',
  -- gh 'rcarriga/nvim-notify',
  gh 'folke/noice.nvim',
}
--
-- vim.notify = require 'notify'
--
-- require('noice').setup {
--   lsp = {
--     -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
--     override = {
--       ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
--       ['vim.lsp.util.stylize_markdown'] = true,
--       ['cmp.entry.get_documentation'] = false, -- requires hrsh7th/nvim-cmp
--     },
--   },
--   -- you can enable a preset for easier configuration
--   presets = {
--     bottom_search = false, -- use a classic bottom cmdline for search
--     command_palette = true, -- position the cmdline and popupmenu together
--     long_message_to_split = true, -- long messages will be sent to a split
--     inc_rename = false, -- enables an input dialog for inc-rename.nvim
--     lsp_doc_border = true, -- add a border to hover docs and signature help
--   },
-- }

vim.pack.add { gh 'aserowy/tmux.nvim' }
require('tmux').setup()

vim.pack.add { gh 'folke/snacks.nvim' }
require('mini.diff').setup {
  view = {
    style = 'sign',
    signs = { add = '+', change = '~', delete = '-' },
  },
}
require('snacks').setup {
  ---@type snacks.Config
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  dim = { enabled = true },
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = false },
  picker = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 9000,
  },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
  styles = {
    zen = {
      keys = { q = 'close' },
    },
    zoom_indicator = {
      enter = true,
      focusable = true,
    },
  },
  toggle = {
    map = vim.keymap.set,
  },
  zen = {
    toggles = {
      dim = false,
      mini_diff_signs = true,
    },
    win = {
      width = 100,
      height = 30,
      backdrop = {
        transparent = false,
        blend = 99,
      },
    },
  },
}

vim.keymap.set(
  { 'n', 'v' },
  '<leader>fs',
  function() Snacks.explorer() end,
  { desc = 'Snacks.explorer' }
)
vim.keymap.set(
  { 'n', 'v' },
  '<leader>zz',
  function() Snacks.zen() end,
  { desc = 'Snacks.zen' }
)
vim.keymap.set(
  { 'n', 'v' },
  '<leader>mh',
  function() Snacks.notifier.show_history() end,
  { desc = 'message history(Snacks)' }
)

vim.cmd.packadd { 'nvim.undotree', bang = true }
vim.keymap.set(
  { 'n', 'v' },
  '<leader>uu',
  '<cmd>Undotree<CR>',
  { desc = 'nvim.pack.undotree' }
)

-- vim.pack.add { gh 'folke/zen-mode.nvim', gh 'folke/twilight.nvim' }
-- require('zen-mode').setup {
--   window = {
--     backdrop = 0.3,
--   },
--   plugins = {
--     options = { enabled = true },
--     twilight = { enabled = true },
--   },
-- }

-- vim.api.nvim_create_augroup('zen', )
