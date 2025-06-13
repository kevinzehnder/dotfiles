return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {
		indent = { char = "▎", tab_char = "▎" },
		scope = { enabled = true, show_start = true, show_end = true },
		exclude = {
			buftypes = {
				"nofile",
				"terminal",
			},
			filetypes = {
				"help",
				"startify",
				"aerial",
				"alpha",
				"dashboard",
				"lazy",
				"neogitstatus",
				"NvimTree",
				"neo-tree",
				"Trouble",
				"py",
			},
		},
	},
}
