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
vim.keymap.set({ 'n', 'v' }, '<leader>mf', function()
  if MiniFiles.close() == nil then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end, { desc = 'MiniFiles' })

-- vim.pack.add {
-- gh 'MunifTanjim/nui.nvim',
-- gh 'rcarriga/nvim-notify',
-- gh 'folke/noice.nvim',
-- }
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

require('mini.starter').setup {}
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
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  dim = { enabled = true },
  explorer = {
    enabled = true,
    replace_netrw = true,
    follow_file = true,
  },
  image = {
    enabled = true,
  },
  indent = {
    enabled = true,
    chunk = {
      enabled = true,
      char = {
        corner_top = '╭',
        corner_bottom = '╰',
      },
    },
  },
  input = { enabled = true },
  ---@class snacks.picker
  ---@class snacks.picker.Config
  ---@class snacks.picker.layout.Config
  picker = {
    enabled = true,
    layout = {
      reverse = false,
      fullscreen = true,
      preset = 'ivy',
    },
    sources = {
      explorer = {
        layout = { reverse = false, fullscreen = false, preset = 'sidebar' },
      },
    },
  },
  notifier = {
    enabled = true,
    timeout = 9000,
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = false },
  statuscolumn = { enabled = true },
  words = { enabled = true },
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
      width = 90,
      height = 30,
      backdrop = {
        transparent = false,
        blend = 99,
      },
    },
  },
}
-- Top Pickers & Explorer
vim.keymap.set(
  { 'n' },
  '<leader><space>',
  function() Snacks.picker.smart() end,
  { desc = 'Smart Find Files' }
)
vim.keymap.set(
  { 'n' },
  '<leader>,',
  function() Snacks.picker.buffers() end,
  { desc = 'Buffers' }
)
vim.keymap.set(
  { 'n' },
  '<leader>/',
  function() Snacks.picker.grep() end,
  { desc = 'Grep' }
)
vim.keymap.set(
  { 'n' },
  '<leader>:',
  function() Snacks.picker.command_history() end,
  { desc = 'Command History' }
)
vim.keymap.set(
  { 'n' },
  '<leader>n',
  function() Snacks.picker.notifications() end,
  { desc = 'Notification History' }
)
vim.keymap.set(
  { 'n' },
  '<leader>e',
  function() Snacks.explorer.open { follow_file = true } end,
  { desc = 'File Explorer' }
)
-- find
vim.keymap.set(
  { 'n' },
  '<leader>fb',
  function() Snacks.picker.buffers() end,
  { desc = 'Buffers' }
)
vim.keymap.set(
  { 'n' },
  '<leader>fc',
  function()
    Snacks.picker.files { cwd = vim.fn.stdpath 'config', follow = true }
  end,
  { desc = 'Find Config File' }
)
vim.keymap.set(
  { 'n' },
  '<leader>ff',
  function() Snacks.picker.files() end,
  { desc = 'Find Files' }
)
vim.keymap.set(
  { 'n' },
  '<leader>fg',
  function() Snacks.picker.git_files() end,
  { desc = 'Find Git Files' }
)
vim.keymap.set(
  { 'n' },
  '<leader>fp',
  function() Snacks.picker.projects() end,
  { desc = 'Projects' }
)
vim.keymap.set(
  { 'n' },
  '<leader>fr',
  function() Snacks.picker.recent() end,
  { desc = 'Recent' }
)
-- git
vim.keymap.set(
  { 'n' },
  '<leader>gb',
  function() Snacks.picker.git_branches() end,
  { desc = 'Git Branches' }
)
vim.keymap.set(
  { 'n' },
  '<leader>gl',
  function() Snacks.picker.git_log() end,
  { desc = 'Git Log' }
)
vim.keymap.set(
  { 'n' },
  '<leader>gL',
  function() Snacks.picker.git_log_line() end,
  { desc = 'Git Log Line' }
)
vim.keymap.set(
  { 'n' },
  '<leader>gs',
  function() Snacks.picker.git_status() end,
  { desc = 'Git Status' }
)
vim.keymap.set(
  { 'n' },
  '<leader>gS',
  function() Snacks.picker.git_stash() end,
  { desc = 'Git Stash' }
)
vim.keymap.set(
  { 'n' },
  '<leader>gd',
  function() Snacks.picker.git_diff() end,
  { desc = 'Git Diff (Hunks)' }
)
vim.keymap.set(
  { 'n' },
  '<leader>gf',
  function() Snacks.picker.git_log_file() end,
  { desc = 'Git Log File' }
)
-- gh
vim.keymap.set(
  { 'n' },
  '<leader>gi',
  function() Snacks.picker.gh_issue() end,
  { desc = 'GitHub Issues (open)' }
)
vim.keymap.set(
  { 'n' },
  '<leader>gI',
  function() Snacks.picker.gh_issue { state = 'all' } end,
  { desc = 'GitHub Issues (all)' }
)
vim.keymap.set(
  { 'n' },
  '<leader>gp',
  function() Snacks.picker.gh_pr() end,
  { desc = 'GitHub Pull Requests (open)' }
)
vim.keymap.set(
  { 'n' },
  '<leader>gP',
  function() Snacks.picker.gh_pr { state = 'all' } end,
  { desc = 'GitHub Pull Requests (all)' }
)
-- Grep
vim.keymap.set(
  { 'n' },
  '<leader>sb',
  function() Snacks.picker.lines() end,
  { desc = 'Buffer Lines' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sB',
  function() Snacks.picker.grep_buffers() end,
  { desc = 'Grep Open Buffers' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sg',
  function() Snacks.picker.grep() end,
  { desc = 'Grep' }
)
vim.keymap.set(
  { 'n', 'x' },
  '<leader>sw',
  function() Snacks.picker.grep_word() end,
  { desc = 'Visual selection or word' }
)
-- search
vim.keymap.set(
  { 'n' },
  '<leader>s"',
  function() Snacks.picker.registers() end,
  { desc = 'Registers' }
)
vim.keymap.set(
  { 'n' },
  '<leader>s/',
  function() Snacks.picker.search_history() end,
  { desc = 'Search History' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sa',
  function() Snacks.picker.autocmds() end,
  { desc = 'Autocmds' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sb',
  function() Snacks.picker.lines() end,
  { desc = 'Buffer Lines' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sc',
  function() Snacks.picker.command_history() end,
  { desc = 'Command History' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sC',
  function() Snacks.picker.commands() end,
  { desc = 'Commands' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sd',
  function() Snacks.picker.diagnostics() end,
  { desc = 'Diagnostics' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sD',
  function() Snacks.picker.diagnostics_buffer() end,
  { desc = 'Buffer Diagnostics' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sh',
  function() Snacks.picker.help() end,
  { desc = 'Help Pages' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sH',
  function() Snacks.picker.highlights() end,
  { desc = 'Highlights' }
)
vim.keymap.set(
  { 'n' },
  '<leader>si',
  function() Snacks.picker.icons() end,
  { desc = 'Icons' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sj',
  function() Snacks.picker.jumps() end,
  { desc = 'Jumps' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sk',
  function() Snacks.picker.keymaps() end,
  { desc = 'Keymaps' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sl',
  function() Snacks.picker.loclist() end,
  { desc = 'Location List' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sm',
  function() Snacks.picker.marks() end,
  { desc = 'Marks' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sM',
  function() Snacks.picker.man() end,
  { desc = 'Man Pages' }
)
-- vim.keymap.set(
--   { 'n' },
--   '<leader>sp',
--   function() Snacks.picker.lazy() end,
--   { desc = 'Search for Plugin Spec' }
-- )
vim.keymap.set(
  { 'n' },
  '<leader>sq',
  function() Snacks.picker.qflist() end,
  { desc = 'Quickfix List' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sR',
  function() Snacks.picker.resume() end,
  { desc = 'Resume' }
)
vim.keymap.set(
  { 'n' },
  '<leader>su',
  function() Snacks.picker.undo() end,
  { desc = 'Undo History' }
)
vim.keymap.set(
  { 'n' },
  '<leader>uC',
  function() Snacks.picker.colorschemes() end,
  { desc = 'Colorschemes' }
)
vim.keymap.set(
  { 'n' },
  'gd',
  function() Snacks.picker.lsp_definitions() end,
  { desc = 'Goto Definition' }
)
vim.keymap.set(
  { 'n' },
  'gD',
  function() Snacks.picker.lsp_declarations() end,
  { desc = 'Goto Declaration' }
)
-- vim.keymap.set({'n'}, "gr", function() Snacks.picker.lsp_references() end, nowait = true, {desc = "References" })
vim.keymap.set(
  { 'n' },
  'gI',
  function() Snacks.picker.lsp_implementations() end,
  { desc = 'Goto Implementation' }
)
vim.keymap.set(
  { 'n' },
  'gy',
  function() Snacks.picker.lsp_type_definitions() end,
  { desc = 'Goto T[y]pe Definition' }
)
vim.keymap.set(
  { 'n' },
  'gai',
  function() Snacks.picker.lsp_incoming_calls() end,
  { desc = 'C[a]lls Incoming' }
)
vim.keymap.set(
  { 'n' },
  'gao',
  function() Snacks.picker.lsp_outgoing_calls() end,
  { desc = 'C[a]lls Outgoing' }
)
vim.keymap.set(
  { 'n' },
  '<leader>ss',
  function() Snacks.picker.lsp_symbols() end,
  { desc = 'LSP Symbols' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sS',
  function() Snacks.picker.lsp_workspace_symbols() end,
  { desc = 'LSP Workspace Symbols' }
)
-- require('todo-comments').setup{}
vim.keymap.set(
  { 'n' },
  '<leader>st',
  function() Snacks.picker.todo_comments() end,
  { desc = 'Todo' }
)
vim.keymap.set(
  { 'n' },
  '<leader>sT',
  function()
    Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
  end,
  { desc = 'Todo/Fix/Fixme' }
)
vim.keymap.set(
  { 'n', 'v' },
  '<leader>sz',
  function() Snacks.zen() end,
  { desc = 'Snacks zen' }
)
vim.keymap.set(
  { 'n', 'v' },
  '<leader>mh',
  function() Snacks.notifier.show_history() end,
  { desc = 'message history(Snacks)' }
)

-- vim.cmd.packadd { 'nvim.undotree', bang = true }
-- vim.keymap.set(
--   { 'n', 'v' },
--   '<leader>uu',
--   '<cmd>Undotree<CR>',
--   { desc = 'nvim_pack_undotree' }
-- )

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
