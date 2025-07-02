return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>lf",
			function ()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Conform: [f]ormat buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			-- lua = { "stylua" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettier", stop_after_first = true },
			yaml = { "yamlfmt", stop_after_first = true },
			zsh = { "shfmt" },
			sshconfig = { "ssh_config_fmt" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = { timeout_ms = 500 },
		-- Customize formatters
		formatters = {
			ssh_config_fmt = {
				command = "awk",
				args = {
					'BEGIN{OFS=""} /^[[:space:]]*#/ {print; next} /^[[:space:]]*$/ {print; next} /^[A-Za-z]/ {print; next} {gsub(/^[[:space:]]+/, "    "); print}'
				},
				stdin = true,
			},
			shfmt = {
				args = {
					"-i", "0", -- Use tabs, not spaces
					"-ci", -- indent switch cases
					"-bn", -- binary ops get space
					"-sr", -- spaces around redirects
				},
			}
		},
	},
	init = function ()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
