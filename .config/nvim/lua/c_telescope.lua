require('telescope').setup{
  defaults = {

    set_env = { ["COLORTERM"] = "truecolor" },
    -- color_devicons = true,
    winblend = 0,

    sorting_strategy = "ascending",

    layout_strategy = "horizontal",
    layout_config = {
      preview_cutoff = 120,
      vertical = { width = 0.7 },
      horizontal = {
        width = 0.9 ,
        prompt_position = "top",
      },
      preview_width = 0.4,
    },
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
      ["<C-h>"] = "which_key",
      ["<C-j>"] = "move_selection_next",
      ["<C-k>"] = "move_selection_previous",
      }
    },
  },
  pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }

    }
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_File_sorter = true,
      case_mode = "smart_case",

    }
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

require('telescope').load_extension('fzf')

