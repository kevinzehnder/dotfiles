
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:

    layout_config = {
      vertical = { width = 0.5 }
      -- other layout configuration here
    },
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
      ["<C-h>"] = "which_key",
      ["<C-n>"] = "move_selection_next",
      ["<C-p>"] = "move_selection_previous",
      }
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

