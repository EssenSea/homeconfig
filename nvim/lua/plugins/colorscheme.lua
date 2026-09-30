return {
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
        transparent_background = true,
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
