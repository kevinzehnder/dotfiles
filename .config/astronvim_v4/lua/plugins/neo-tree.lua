return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.filesystem.hijack_netrw_behavior = "open_default"
    opts.filesystem.filtered_items = {
      visible = false,
      hide_dotfiles = true,
      hide_gitignored = true,
      always_show = { -- remains visible even if other settings would normally hide it
        ".envrc",
        ".env",
      },
    }
    opts.window.position = "left"
    opts.window.width = 35
    opts.window.mappings["<cr>"] = "open_with_window_picker"
    opts.window.mappings["s"] = "split_with_window_picker"
    opts.window.mappings["S"] = "vsplit_with_window_picker"
    opts.source_selector.sources = {
      { source = "filesystem", display_name = "󰉓 Files" },
    }
  end,
}
