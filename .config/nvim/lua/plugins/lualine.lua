local function show_macro_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register ~= "" then
		return "Recording @" .. recording_register
	else
		return ""
	end
end

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed
		}
	end
end

return {
	"nvim-lualine/lualine.nvim",
	enabled = true,
	lazy = false,
	opts = {
		theme = "auto",
		icons_enabled = true,

		winbar = {
			lualine_a = {
				{
					"filetype",
					colored = true, -- Displays filetype icon in color if set to true
					icon_only = true, -- Display only an icon for filetype
					icon = { align = "left" }, -- Display filetype icon on the right hand side
					padding = { left = 1, right = 0 },
					-- icon =    {'X', align='right'}
					-- Icon string ^ in table is ignored in filetype component
				},
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
			lualine_a = {
				{
					"filetype",
					colored = true, -- Displays filetype icon in color if set to true
					icon_only = true, -- Display only an icon for filetype
					icon = { align = "left" }, -- Display filetype icon on the right hand side
					padding = { left = 1, right = 0 },
					-- Icon string ^ in table is ignored in filetype component
				},
				{
					"filename",
					file_status = true,
					path = 1,
					shorting_target = 40,
				},
			},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
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
			lualine_b = { { "b:gitsigns_head", icon = "" }, { "diff", source = diff_source }, "diagnostics", { show_macro_recording }, },
			lualine_c = {},
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = {},
			lualine_z = { "location" },
		},

		options = {
			component_separators = "|",
			section_separators = "",
			-- component_separators = { left = "", right = "" },
			-- section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {
					"packer", "neo-tree", "NvimTree", "nvim-tree", "alpha",
					"trouble", "dapui_watches", "dapui_breakpoints",
					"dapui_scopes", "dapui_console", "dapui_stacks",
					"dap-repl", "trouble",
				},
				winbar = {
					"help", "startify", "dashboard", "packer", "neogitstatus",
					"NvimTree", "Trouble", "alpha", "lir", "Outline", "spectre_panel",
					"toggleterm", "dapui_console", "dapui_watches", "dapui_stacks",
					"dapui_breakpoints", "dapui_scopes", "DiffviewFiles"
				},
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


	}
}
