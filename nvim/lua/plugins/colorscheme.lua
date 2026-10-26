return {
  {
    'datsfilipe/vesper.nvim',
    lazy = true,
    opts = {
      transparent = true,
    },
  },
  {
    url = 'https://codeberg.org/evergarden/nvim.git',
    name = 'evergarden',
    lazy = false,
    priority = 1000,
    opts = {
      theme = {
        variant = 'winter',
        accent = 'green',
      },
      editor = {
        transparent_background = true,
        override_terminal = true,
        sign = { color = 'none' },
        float = { color = 'none', solid_border = false }, -- 浮窗透明（单独控制）
        completion = { color = 'none' }, -- 补全菜单透明（单独控制）
      },
      cache = true,
    },
    config = function(_, opts)
      require('evergarden').setup(opts)
      vim.cmd.colorscheme 'evergarden'
    end,
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
      -- vim.cmd.colorscheme 'everforest'
    end,
  },
}
