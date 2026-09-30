return {
  {
    'nvim-mini/mini.nvim',
    event = 'VeryLazy',
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
        options = { use_as_default_explorer = true },
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
}
