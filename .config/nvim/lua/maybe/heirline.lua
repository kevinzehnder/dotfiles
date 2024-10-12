return {
	"rebelot/heirline.nvim",
	lazy = false,
	opts = {
		statusline = { -- statusline
			hl = { fg = "fg", bg = "bg" },
		},
		winbar = { -- winbar
			init = function(self)
				self.bufnr = vim.api.nvim_get_current_buf()
			end,
			fallthrough = false,
			{ -- inactive winbar
				file_icon = {
					padding = { left = 0 },
				},
				filename = {},
				filetype = false,
				file_read_only = false,
				surround = false,
				update = "BufEnter",
			},
		},

		tabline = { -- tabline
			{ -- file tree padding
				condition = function(self)
					self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
					self.winwidth = vim.api.nvim_win_get_width(self.winid)
					return self.winwidth ~= vim.o.columns -- only apply to sidebars
						and not require("astrocore.buffer").is_valid(vim.api.nvim_win_get_buf(self.winid)) -- if buffer is not in tabline
				end,
				provider = function(self)
					return (" "):rep(self.winwidth + 1)
				end,
				hl = { bg = "tabline_bg" },
			},
			{ -- tab list
				{ -- close button for current tab
					on_click = {
						callback = function()
							require("astrocore.buffer").close_tab()
						end,
						name = "heirline_tabline_close_tab_callback",
					},
				},
			},
		},

		statuscolumn = { -- statuscolumn
			init = function(self)
				self.bufnr = vim.api.nvim_get_current_buf()
			end,
		},
	},
}
