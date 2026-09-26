return {
  {
    'lervag/vimtex',
    ft = 'tex',
    priority = 1000,
    init = function ()
      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_format_enabled = 1
      vim.g.vimtex_imap_enable = 1
      vim.g.vimtex_view_method = 'sioyek'
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_compiler_latexmk_engine = { ['_'] = '-lualatex' }
      vim.g.vimtex_ui_method = { confirm = 'nvim', input = 'nvim', select = 'nvim' }
    end
  },
}
