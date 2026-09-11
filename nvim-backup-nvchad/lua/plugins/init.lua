vim.g.maplocalleader = ","
return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "latex",
        "typst", "markdown", "markdown_inline",
        "yaml", "json", "jsonc", "python",
        "toml",
      },
    },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.hlchunk"
    end,
  },
  {
    "nvim-orgmode/orgmode",
    lazy = true,
    -- event = 'VeryLazy',
    ft = { "org" },
    config = function()
      -- Setup orgmode
      require("orgmode").setup {
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      }
      -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
      -- add ~org~ to ignore_install
      -- require('nvim-treesitter.configs').setup({
      --   ensure_installed = 'all',
      --   ignore_install = { 'org' },
      -- })
    end,
  },
  {
    "nvim-orgmode/org-bullets.nvim",
    lazy = true,
    -- event = 'VeryLazy',
    ft = { "org" },
    config = function()
      require("org-bullets").setup {
        concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
        symbols = {
          -- list symbol
          list = "+",
          -- headlines can be a list
          headlines = { "◉", "○", "✸", "✿" },
          -- or a function that receives the defaults and returns a list
          -- headlines = function(default_list)
          --   table.insert(default_list, "♥")
          --   return default_list
          -- end,
          -- -- or false to disable the symbol. Works for all symbols
          -- headlines = false,
          -- or a table of tables that provide a name
          -- and (optional) highlight group for each headline level
          -- headlines = {
          --   { "◉", "MyBulletL1" },
          --   { "○", "MyBulletL2" },
          --   { "✸", "MyBulletL3" },
          --   { "✿", "MyBulletL4" },
          -- },
          checkboxes = {
            half = { "", "@org.checkbox.halfchecked" },
            done = { "✓", "@org.keyword.done" },
            todo = { "˟", "@org.keyword.todo" },
          },
        },
      }
    end,
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_compiler_latexmk_engines = 'lualatex'
    end,
    config = function()
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        executable = "latexmk",
        options = {
          "-lualatex",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },
}
