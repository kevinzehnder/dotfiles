require("config.main")
require("config.lazy")
require("config.colors")
require("config.keymaps")

if vim.g.neovide then
	-- vim.g.neovide_theme = "auto"
	vim.o.guifont = "IosevkaTerm_Nerd_Font:h12" -- text below applies for VimScript
	vim.api.nvim_set_keymap("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
end
