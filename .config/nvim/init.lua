require("config.main")
require("config.lazy")
require("config.colors")

if vim.g.neovide then
	vim.g.neovide_theme = "auto"
	vim.o.guifont = "IosevkaTerm_Nerd_Font:h12" -- text below applies for VimScript
end
