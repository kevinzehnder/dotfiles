return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",

  opts = {
    indent = { char = "▎", tab_char = "▎" },
    scope = { show_start = false, show_end = false },
    exclude = {
      buftypes = {
        "nofile",
        "terminal",
      },
      filetypes = {
        "help",
        "startify",
        "aerial",
        "alpha",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "neo-tree",
        "Trouble",
        "py"
      },
    },
  },
}
