return {
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    opts = {},
    version = '2.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    build = 'make install_jsregexp',
    -- build = function()
    --   if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
    --     vim.cmd '!make install_jsregexp'
    --   end
    -- end,
    config = function ()
      require('luasnip.loaders.from_vscode').lazy_load()
    end
  },
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = { 'rafamadriz/friendly-snippets' },
    build = 'cargo build --release',
    version = '1.*',
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 100 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'omni' },
      },
      snippets = { preset = 'luasnip' },
      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- the rust implementation via `'prefer_rust_with_warning'`
      -- See `:help blink-cmp-config-fuzzy` for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      -- fuzzy = { implementation = 'lua' },
      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
