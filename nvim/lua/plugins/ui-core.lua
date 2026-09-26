return {
  {
    'NMAC427/guess-indent.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    opts = {
      attach_to_untracked = true,
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
      -- gitsigns.nvim's recommended keymaps:
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        -- Navigation
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange', buf = bufnr })

        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange', buf = bufnr })

        -- Visual mode actions
        vim.keymap.set(
          'v',
          '<leader>hs',
          function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
          { desc = 'git [s]tage hunk', buf = bufnr }
        )
        vim.keymap.set(
          'v',
          '<leader>hr',
          function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
          { desc = 'git [r]eset hunk', buf = bufnr }
        )
        -- Normal mode actions
        vim.keymap.set(
          'n',
          '<leader>hs',
          gitsigns.stage_hunk,
          { desc = 'git [s]tage hunk', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>hr',
          gitsigns.reset_hunk,
          { desc = 'git [r]eset hunk', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>hS',
          gitsigns.stage_buffer,
          { desc = 'git [S]tage buffer', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>hR',
          gitsigns.reset_buffer,
          { desc = 'git [R]eset buffer', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>hp',
          gitsigns.preview_hunk,
          { desc = 'git [p]review hunk', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>hi',
          gitsigns.preview_hunk_inline,
          { desc = 'git preview hunk [i]nline', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>hb',
          function() gitsigns.blame_line { full = true } end,
          { desc = 'git [b]lame line', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>hd',
          gitsigns.diffthis,
          { desc = 'git [d]iff against index', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>hD',
          function() gitsigns.diffthis '~' end,
          { desc = 'git [D]iff against last commit', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>hQ',
          function() gitsigns.setqflist 'all' end,
          {
            desc = 'git hunk [Q]uickfix list (all files in repo)',
            buf = bufnr,
          }
        )
        vim.keymap.set('n', '<leader>hq', gitsigns.setqflist, {
          desc = 'git hunk [q]uickfix list (all changes in this file)',
          buf = bufnr,
        })
        -- Toggles
        vim.keymap.set(
          'n',
          '<leader>tb',
          gitsigns.toggle_current_line_blame,
          { desc = '[T]oggle git show [b]lame line', buf = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>tw',
          gitsigns.toggle_word_diff,
          { desc = '[T]oggle git intra-line [w]ord diff', buf = bufnr }
        )
        -- Text object
        vim.keymap.set(
          { 'o', 'x' },
          'ih',
          gitsigns.select_hunk,
          { desc = 'text object [i]nside [h]unk', buf = bufnr }
        )
      end,
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      -- Delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    event = {'BufReadPost', 'BufNewFile'},
    opts = { sign = true },
  },
  {
    'nvim-tree/nvim-web-devicons',
    opts = {},
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {

      -- options = {
      -- component_separators = { left = '', right = '' },
      -- section_separators = { left = '', right = '' },
      -- }
    },
  },

  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup {
        -- NOTE: Avoid conflicts with the built-in incremental selection mappings
        -- on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
        mappings = {
          around_next = 'aa',
          inside_next = 'ii',
        },
        n_lines = 500,
      }
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
      require('mini.files').setup {
        windows = {
          max_number = 2,
          preview = true,
          width_preview = 82,
          width_focus = 40,
          width_nofocus = 20,
        },
        mappings = { go_in = 'L', go_in_plus = 'l' },
      }
      vim.keymap.set({ 'n', 'v' }, '<leader>mf', function()
        if MiniFiles.close() == nil then
          MiniFiles.open(vim.api.nvim_buf_get_name(0))
        end
      end, { desc = 'MiniFiles' })
    end,
  },
  { 'datsfilipe/vesper.nvim', lazy = true, opts = {} },
  {
    url = 'https://codeberg.org/evergarden/nvim.git',
    name = 'evergarden',
    lazy = false,
    priority = 1000,
    opts = {
      theme = {
        variant = 'winter', -- 'winter'|'fall'|'spring'|'summer'
        accent = 'green',
      },
      editor = {
        transparent_background = false,
        sign = { color = 'none' },
        float = {
          color = 'mantle',
          solid_border = false,
        },
        completion = {
          color = 'surface0',
        },
      },
    },
    config = function() vim.cmd.colorscheme 'evergarden-winter' end,
  },
  {
    'sainnhe/everforest',
    lazy = true,
    opts = {},
    config = function()
      vim.g.everforest_background = 'medium'
      vim.g.everforest_transparent_background = 2
      vim.g.everforest_better_performance = 1
      vim.g.everforest_show_eob = 1
      vim.g.everforest_dim_inactive_windows = 0
    end,
  },
}
