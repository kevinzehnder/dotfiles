return {
	"GeorgesAlkhouri/nvim-aider",
	cmd = "Aider",
	-- Example key mappings for common actions:
	keys = {
		{ "<leader>aa", "<cmd>Aider toggle<cr>",       desc = "Toggle Aider" },
		{ "<leader>as", "<cmd>Aider send<cr>",         desc = "Send to Aider",                  mode = { "n", "v" } },
		{ "<leader>ac", "<cmd>Aider command<cr>",      desc = "Aider Commands" },
		{ "<leader>ab", "<cmd>Aider buffer<cr>",       desc = "Send Buffer" },
		{ "<leader>a+", "<cmd>Aider add<cr>",          desc = "Add File" },
		{ "<leader>a-", "<cmd>Aider drop<cr>",         desc = "Drop File" },
		{ "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
		{ "<leader>aR", "<cmd>Aider reset<cr>",        desc = "Reset Session" },
		-- Example nvim-tree.lua integration if needed
		{ "<leader>a+", "<cmd>AiderTreeAddFile<cr>",   desc = "Add File from Tree to Aider",    ft = "NvimTree" },
		{ "<leader>a-", "<cmd>AiderTreeDropFile<cr>",  desc = "Drop File from Tree from Aider", ft = "NvimTree" },
	},
	theme = {
		user_input_color = "#268bd2",                 -- Blue
		tool_output_color = "#586e75",                -- Base01 (muted green/gray) - often used for status/output
		tool_error_color = "#dc322f",                 -- Red
		tool_warning_color = "#cb4b16",               -- Orange
		assistant_output_color = "#6c71c4",           -- Violet
		completion_menu_color = "#657b83",            -- Base00 (default text color)
		completion_menu_bg_color = "#fdf6e3",         -- Base3 (background)
		completion_menu_current_color = "#586e75",    -- Base01 (highlighted text)
		completion_menu_current_bg_color = "#eee8d5", -- Base2 (slightly darker background for selection)
	},
	dependencies = {
		"folke/snacks.nvim",
		--- The below dependencies are optional
		"catppuccin/nvim",
		"nvim-tree/nvim-tree.lua",
		--- Neo-tree integration
		{
			"nvim-neo-tree/neo-tree.nvim",
			opts = function (_, opts)
				-- Example mapping configuration (already set by default)
				-- opts.window = {
				--   mappings = {
				--     ["+"] = { "nvim_aider_add", desc = "add to aider" },
				--     ["-"] = { "nvim_aider_drop", desc = "drop from aider" }
				--     ["="] = { "nvim_aider_add_read_only", desc = "add read-only to aider" }
				--   }
				-- }
				require("nvim_aider.neo_tree").setup(opts)
			end,
		},
	},
	config = true,
}
