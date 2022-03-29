
-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", --only uses parsers that are maintained
  sync_install = false,
  ignore_install = { "javascript" },
  highlight = { --enable highlighting
    enable = true,
    -- disable = { "c", "rust" },
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { "yaml" },
  }
}
