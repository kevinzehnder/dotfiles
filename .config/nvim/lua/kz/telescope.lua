vim.g.theme_switcher_loaded = true
require('telescope').setup{
  defaults = {

    set_env = { ["COLORTERM"] = "truecolor" },
    -- color_devicons = true,
    winblend = 0,

    sorting_strategy = "ascending",

    layout_strategy = "horizontal",
    layout_config = {
      preview_cutoff = 120,
      vertical = { width = 0.8 },
      horizontal = {
        width = 0.9 ,
        prompt_position = "top",
      },
      preview_width = 0.5,
    },
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
      ["<ESC>"] = "close",
      ["<C-h>"] = "which_key",
      ["<C-j>"] = "move_selection_next",
      ["<C-k>"] = "move_selection_previous",
      }
    },
  },
  pickers = {
      find_files = {
        -- find_command = { "rg", "--files", "--ignore", "--hidden"}
        find_command = { "rg", "--files", "--ignore", "--hidden", "--no-ignore-vcs" }
    },
      git_files = {
        -- find_command = { "rg", "--files", "--ignore", "--hidden"}
        find_command = { "rg", "--files", "--ignore", "--hidden", "--no-ignore-vcs" }
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_File_sorter = true,
      case_mode = "smart_case",

    }
  }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

local M = {}
M.search_dotfiles = function()
  require("telescope.builtin").find_files({
    prompt_title = "<VIMRC>",
    cwd = "~/.config/nvim",
  })
end

M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

return M


