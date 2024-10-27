return {
	"rebelot/heirline.nvim",
	enabled = false,
	lazy = false,
	config = function ()
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		-- Define colors using the active colorscheme
		local colors = {
			bg = utils.get_highlight("Normal").bg,
			fg = utils.get_highlight("Normal").fg,
			red = utils.get_highlight("DiagnosticError").fg,
			green = utils.get_highlight("String").fg,
			blue = utils.get_highlight("Function").fg,
			gray = utils.get_highlight("NonText").fg,
			orange = utils.get_highlight("Constant").fg,
			purple = utils.get_highlight("Statement").fg,
			cyan = utils.get_highlight("Special").fg,
			diag_warn = utils.get_highlight("DiagnosticWarn").fg,
			diag_error = utils.get_highlight("DiagnosticError").fg,
			diag_hint = utils.get_highlight("DiagnosticHint").fg,
			diag_info = utils.get_highlight("DiagnosticInfo").fg,
			git_del = utils.get_highlight("DiffDelete").fg,
			git_add = utils.get_highlight("DiffAdd").fg,
			git_change = utils.get_highlight("DiffChange").fg,
		}

		-- ViMode component
		local ViMode = {
			init = function (self)
				self.mode = vim.fn.mode(1)
			end,
			static = {
				mode_names = {
					n = "NORMAL",
					i = "INSERT",
					v = "VISUAL",
					V = "V-LINE",
					["\22"] = "V-BLOCK",
					c = "COMMAND",
					R = "REPLACE",
					t = "TERMINAL"
				},
				mode_colors = {
					n = colors.blue,
					i = colors.green,
					v = colors.purple,
					V = colors.purple,
					["\22"] = colors.purple,
					c = colors.orange,
					R = colors.red,
					t = colors.red
				}
			},
			provider = function (self)
				return " %2(" .. self.mode_names[self.mode:sub(1, 1)] .. "%) "
			end,
			hl = function (self)
				local mode = self.mode:sub(1, 1)
				return { fg = self.mode_colors[mode], bold = true }
			end,
			update = { "ModeChanged" },
		}


		local FileNameBlock = {
			-- let's first set up some attributes needed by this component and its children
			init = function (self)
				self.filename = vim.api.nvim_buf_get_name(0)
			end,
		}
		-- We can now define some children separately and add them later

		local FileIcon = {
			init = function (self)
				local filename = self.filename
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function (self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function (self)
				return { fg = self.icon_color }
			end
		}

		local FileName = {
			provider = function (self)
				-- first, trim the pattern relative to the current directory. For other
				-- options, see :h filename-modifers
				local filename = vim.fn.fnamemodify(self.filename, ":.")
				if filename == "" then return "[No Name]" end
				-- now, if the filename would occupy more than 1/4th of the available
				-- space, we trim the file path to its initials
				-- See Flexible Components section below for dynamic truncation
				if not conditions.width_percent_below(#filename, 0.25) then
					filename = vim.fn.pathshorten(filename)
				end
				return filename
			end,
			hl = { fg = utils.get_highlight("Directory").fg },
		}

		local FileFlags = {
			{
				condition = function ()
					return vim.bo.modified
				end,
				provider = "[+]",
				hl = { fg = "green" },
			},
			{
				condition = function ()
					return not vim.bo.modifiable or vim.bo.readonly
				end,
				provider = "",
				hl = { fg = "orange" },
			},
		}

		-- Now, let's say that we want the filename color to change if the buffer is
		-- modified. Of course, we could do that directly using the FileName.hl field,
		-- but we'll see how easy it is to alter existing components using a "modifier"
		-- component

		local FileNameModifer = {
			hl = function ()
				if vim.bo.modified then
					-- use `force` because we need to override the child's hl foreground
					return { fg = "cyan", bold = true, force = true }
				end
			end,
		}

		-- let's add the children to our FileNameBlock component
		FileNameBlock = utils.insert(FileNameBlock,
			FileIcon,
			utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
			FileFlags,
			{ provider = "%<" }             -- this means that the statusline is cut here when there's not enough space
		)

		-- Git component
		local Git = {
			condition = conditions.is_git_repo,
			init = function (self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
			end,
			hl = { fg = colors.orange, bg = colors.bg_dark },
			{
				provider = function (self)
					return " " .. self.status_dict.head
				end,
				hl = { bold = true }
			},
			{
				condition = function (self)
					return self.has_changes
				end,
				provider = "(",
			},
			{
				provider = function (self)
					local count = self.status_dict.added or 0
					return count > 0 and ("+" .. count)
				end,
				hl = { fg = colors.git_add },
			},
			{
				provider = function (self)
					local count = self.status_dict.removed or 0
					return count > 0 and ("-" .. count)
				end,
				hl = { fg = colors.git_del },
			},
			{
				provider = function (self)
					local count = self.status_dict.changed or 0
					return count > 0 and ("~" .. count)
				end,
				hl = { fg = colors.git_change },
			},
			{
				condition = function (self)
					return self.has_changes
				end,
				provider = ")",
			},
		}

		-- Diagnostics component
		local Diagnostics = {
			condition = conditions.has_diagnostics,
			static = {
				error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
				warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
				info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
				hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
			},
			init = function (self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,
			update = { "DiagnosticChanged", "BufEnter" },
			{
				provider = "![",
			},
			{
				provider = function (self)
					return self.errors > 0 and (self.error_icon .. self.errors .. " ")
				end,
				hl = { fg = colors.diag_error },
			},
			{
				provider = function (self)
					return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
				end,
				hl = { fg = colors.diag_warn },
			},
			{
				provider = function (self)
					return self.info > 0 and (self.info_icon .. self.info .. " ")
				end,
				hl = { fg = colors.diag_info },
			},
			{
				provider = function (self)
					return self.hints > 0 and (self.hint_icon .. self.hints)
				end,
				hl = { fg = colors.diag_hint },
			},
			{
				provider = "]",
			},
		}

		-- LSP component
		local LSPActive = {
			condition = conditions.lsp_attached,
			update = { "LspAttach", "LspDetach" },
			provider = function ()
				local names = {}
				for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
					table.insert(names, server.name)
				end
				return " [" .. table.concat(names, " ") .. "]"
			end,
			hl = { fg = colors.green, bold = true },
		}

		-- Align and Space components
		local Align = { provider = "%=" }
		local Space = { provider = " " }

		local MacroRec = {
			condition = function ()
				return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
			end,
			provider = " ",
			hl = { fg = "orange", bold = true },
			utils.surround({ "[", "]" }, nil, {
				provider = function ()
					return vim.fn.reg_recording()
				end,
				hl = { fg = "green", bold = true },
			}),
			update = {
				"RecordingEnter",
				"RecordingLeave",
			}
		}
		ViMode = utils.surround({ "", "" }, colors.bg, { ViMode })

		local DefaultStatusline = {
			ViMode, Space, FileNameBlock, Space, Git, Space, Diagnostics, Align,
			Navic, DAPMessages, Align,
			LSPActive, Space, LSPMessages, Space, UltTest, Space, FileType, Space, Ruler, Space, ScrollBar
		}

		local StatusLines = {

			hl = function ()
				if conditions.is_active() then
					return "DefaultStatusline"
				else
					return "StatusLineNC"
				end
			end,

			-- the first statusline with no condition, or which condition returns true is used.
			-- think of it as a switch case with breaks to stop fallthrough.
			fallthrough = false,

			-- SpecialStatusline,
			-- TerminalStatusline,
			-- InactiveStatusline,
			DefaultStatusline,
		}

		-- WinBars definition
		local WinBars = {
			fallthrough = false,
			{ -- A special winbar for terminals
				condition = function ()
					return conditions.buffer_matches({ buftype = { "terminal" } })
				end,
				utils.surround({ "", "" }, colors.bg_dark, {
					FileNameBlock,
				}),
			},
			{ -- An inactive winbar for regular files
				condition = function ()
					return not conditions.is_active()
				end,
				utils.surround({ "", "" }, colors.bg, { hl = { fg = "gray", force = true }, FileNameBlock }),
			},
			-- A winbar for regular files
			utils.surround({ "", "" }, colors.bg, FileNameBlock),
		}

		require("heirline").setup({ statusline = StatusLines, winbar = WinBars })

		-- Setup Heirline
		require("heirline").setup({
			statusline = StatusLines,
			winbar = WinBars,
			opts = {
				colors = colors,
				disable_winbar_cb = function (args)
					return conditions.buffer_matches({
						buftype = { "nofile", "prompt", "help", "quickfix" },
						filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
					}, args.buf)
				end,
			}
		})
	end,
}
