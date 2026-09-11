require("hlchunk").setup {
  chunk = {
    enable = true,
    use_treesitter = true,
    style = {
      "#d3c6aa",
    },
    chars = {
      horizontal_line = "─",
      vertical_line = "│",
      left_top = "╭",
      left_bottom = "╰",
      right_arrow = ">",
    },
    notify = true,
    priority = 0,
    error_sign = true,
    exclude_filetypes = {},
    duration = 200,
    delay = 50,
  },

  indent = {
    enable = true,
  },

  line_num = {
    enable = true,
  },

  blank = {
    enable = true,
  },
}
