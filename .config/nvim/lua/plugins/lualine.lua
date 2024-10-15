local function show_macro_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register ~= "" then
		return "Recording @" .. recording_register
	else
		return ""
	end
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	opts = {
		winbar = {
			lualine_a = {
				{
					"filename",
					file_status = true, -- Displays file status (readonly status, modified status)
					newfile_status = false, -- Display new file status (new file means no write after created)
					path = 1,
					shorting_target = 40, -- Shortens path to leave 40 spaces in the window
				},
			},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},

			lualine_y = {},
			lualine_z = {},
		},
		inactive_winbar = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},

		options = {
			component_separators = "|",
			section_separators = "",
			-- component_separators = { left = "", right = "" },
			-- section_separators = { left = "", right = "" },
			disabled_filetypes = {
				"packer",
				"neo-tree",
				"NvimTree",
				"nvim-tree",
				"alpha",
				"trouble",
				"dapui_watches",
				"dapui_breakpoints",
				"dapui_scopes",
				"dapui_console",
				"dapui_stacks",
				"dap-repl",
				"trouble",
			},
			ignore_focus = {
				"dapui_watches",
				"dapui_breakpoints",
				"dapui_scopes",
				"dapui_console",
				"dapui_stacks",
				"dap-repl",
			},
			globalstatus = true,
		},

		sections = {
			lualine_a = {
				{
					"mode",
					fmt = function (str)
						return str:sub(1, 1)
					end,
				},
			},
			lualine_b = { "branch", "diff", "diagnostics", { show_macro_recording } },
			lualine_c = {},

			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_z = { "location" },
		}
	}
}
