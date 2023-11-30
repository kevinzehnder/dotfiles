return {
  "nvim-lualine/lualine.nvim",
  lazy = false,

  opts = function(_, opts)
    -- opts.tabline = {}
    opts.winbar = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},

      lualine_y = {},
      lualine_z = {},
    }
    opts.inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

    opts.options = {
      component_separators = "|",
      section_separators = "",
      -- component_separators = { left = "", right = "" },
      -- section_separators = { left = "", right = "" },
      disabled_filetypes = { "packer", "neo-tree", "alpha" },
      globalstatus = true,
    }

    opts.sections = {
      lualine_a = { { "mode", fmt = function(str) return str:sub(1, 1) end } },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_z = { "location" },
    }
  end,
}
