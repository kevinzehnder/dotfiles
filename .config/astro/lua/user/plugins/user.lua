return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },

  -- colorschemes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "ishan9299/nvim-solarized-lua" },
  { "morhetz/gruvbox" },
  { "sainnhe/gruvbox-material" },

  {
    "kylechui/nvim-surround",
    lazy = false,
    opts = {},
  },

  { "ThePrimeagen/harpoon" },
}
