return {
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
        -- Enable gitsigns recommended keymaps first
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { sign = true },
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    opts = {

      -- options = {
      -- component_separators = { left = '', right = '' },
      -- section_separators = { left = '', right = '' },
      -- }
    },
  },
  -- rubbish , just looks pretty.
  -- {
  --   'nvzone/floaterm',
  --   dependencies = 'nvzone/volt',
  --   cmd = 'FloatermToggle',
  --   keys = {
  --     { '<leader>tt', '<cmd>FloatermToggle<CR>', desc = 'Floaterm toggle' },
  --     -- {
  --     --   '<leader>tt',
  --     --   function() require('floaterm').toggle() end,
  --     --   mode = { 'n', 'v' },
  --     --   desc = 'float term toggle',
  --     -- },
  --   },
  --   opts = {
  --     border = true,
  --     mappings = {
  --       sidebar = nil,
  --       term = nil,
  --     },
  --   },
  -- },
}
