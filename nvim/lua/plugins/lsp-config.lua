return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },
      { 'mason-org/mason.nvim', opts = {} },
      { 'WhoIsSethDaniel/mason-tool-installer.nvim', opts = {} },
      {
        'mason-org/mason-lspconfig.nvim',
        opts = {
          automatic_enable = false,
          ensure_installed = vim.tbl_keys(
            require('config.lsp-attach').servers
          ),
        },
      },
    },
    config = function()
      local servers = require('config.lsp-attach').servers
      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
      require('config.lsp-attach').setup_keymaps()
    end,
  },
}
