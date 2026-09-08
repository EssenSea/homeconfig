local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    C = { "clang-format" },
    -- typst = { "tinymist.formatterMode" },
    latex = { "latexindent" },
    markdown = { "prettierd" },
    -- vim = { "vim-ls" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
