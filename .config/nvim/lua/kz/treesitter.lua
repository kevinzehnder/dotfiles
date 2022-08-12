local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

-- treesitter
configs.setup {
  ensure_installed = "all", --only uses parsers that are maintained
  sync_install = false,
  highlight = { --enable highlighting
    enable = true,
    use_languagetree = true,
    -- disable = { "c", "rust" },
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { "python", "cscs", "yaml" },
  }
}
