
-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", --only uses parsers that are maintained
  sync_install = false,
  highlight = { --enable highlighting
    enable = true,
    use_languagetree = true,
    -- disable = { "c", "rust" },
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
    disable = { "yaml" },
  }
}
