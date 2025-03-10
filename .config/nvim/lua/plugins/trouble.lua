return {
	"folke/trouble.nvim",
	opts = {
		open_no_results = true,
		modes = {
			diagnostics = { -- Configure symbols mode
				win = {
					size = 0.3, -- 30% of the window
				},
			},
		},
	}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{ "<leader>tT", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)", },
		{ "<leader>tt", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)", },
		{ "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)", },
		{ "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
		-- { "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)", },
		-- { "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)", },
	},
}
