return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<A-J>]],
			terminal_mappings = true,
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
			float_opts = {
				border = "single",
				width = function()
					return math.floor(vim.o.columns - 3)
				end,
				height = function()
					return math.floor(vim.o.lines - 3)
				end,
			},
			start_in_insert = true,
			insert_mappings = true,
		})

		function _lazygit_toggle()
			lazygit:toggle()
		end

		vim.api.nvim_set_keymap("n", "<A-L>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<A-L>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
	end,
}
