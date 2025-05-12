return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function ()
		require("toggleterm").setup({
			size = function ()
				return vim.o.columns * 0.4
			end,
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

		-- Lazygit terminal configuration
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
			float_opts = {
				border = "single",
				width = function ()
					return math.floor(vim.o.columns - 3)
				end,
				height = function ()
					return math.floor(vim.o.lines - 3)
				end,
			},
			start_in_insert = true,
			insert_mappings = true,
		})

		-- Aider terminal configuration
		local aider_term = Terminal:new({
			cmd = "aider", -- Command to execute
			hidden = true, -- Keep it hidden by default
			direction = "vertical", -- Make it a vertical split
			border = "curved",
			count = 2,     -- Assign a unique count to this terminal instance
			start_in_insert = true,
			insert_mappings = true,
		})

		-- Define buffer-local keymaps for the aider terminal
		-- These override the terminal's key handling for C-h/j/k/l
		vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window", buffer = aider_term.bufnr })
		vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to lower window", buffer = aider_term.bufnr })
		vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to upper window", buffer = aider_term.bufnr })
		vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window", buffer = aider_term.bufnr })

		-- Function to toggle the lazygit terminal
		function _lazygit_toggle()
			lazygit:toggle()
		end

		-- Function to toggle the aider terminal
		function _aider_toggle()
			aider_term:toggle()
		end

		-- Keymap for lazygit toggle
		vim.api.nvim_set_keymap("n", "<A-L>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true, desc = "Toggle Lazygit" })
		vim.api.nvim_set_keymap("t", "<A-L>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true, desc = "Toggle Lazygit" })

		-- Keymap for aider terminal toggle (<Leader>aa)
		vim.api.nvim_set_keymap("n", "<Leader>aa", "<cmd>lua _aider_toggle()<CR>", { noremap = true, silent = true, desc = "Toggle Aider Term" })
		vim.api.nvim_set_keymap("t", "<Leader>aa", "<cmd>lua _aider_toggle()<CR>", { noremap = true, silent = true, desc = "Toggle Aider Term" })
	end
}
