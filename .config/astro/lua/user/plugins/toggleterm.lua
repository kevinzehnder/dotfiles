return {
  "akinsho/toggleterm.nvim",
  opts = {
    open_mapping = [[<C-A-j>]],
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened termina
    size = 20,
    direction = "float",
    highlights = {
      -- highlights which map to a highlight group name and a table of it's values
      -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
      Normal = {
        -- guibg = "#afafaf",
      },
      NormalFloat = {
        link = "Normal",
      },
    },
    shade_terminals = false, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
    shading_factor = 3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
  },
}
