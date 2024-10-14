return {
	"sindrets/diffview.nvim",
	lazy = false,

	config = function ()
		local actions = require("diffview.actions")
		local opts = {
			view = {
				-- Configure the layout and behavior of different types of views.
				-- Available layouts:
				--  'diff1_plain'
				--    |'diff2_horizontal'
				--    |'diff2_vertical'
				--    |'diff3_horizontal'
				--    |'diff3_vertical'
				--    |'diff3_mixed'
				--    |'diff4_mixed'
				-- For more info, see ':h diffview-config-view.x.layout'.
				default = {
					-- Config for changed files, and staged files in diff views.
					layout = "diff2_horizontal",
					winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
				},
				merge_tool = {
					-- Config for conflicted files in diff views during a merge or rebase.
					layout = "diff4_mixed",
					disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
					winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
				},
				file_history = {
					-- Config for changed files in file history views.
					layout = "diff2_horizontal",
					winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
				},
				keymaps = {
					disable_defaults = false, -- Disable the default keymaps
					diff4 = {
						-- Mappings in 4-way diff layouts
						{ { "n", "x" }, "1do",        actions.diffget("base"),           { desc = "Obtain the diff hunk from the BASE version of the file" } },
						{ { "n", "x" }, "<leader>ob", actions.diffget("base"),           { desc = "Obtain the diff hunk from the BASE version of the file" } },
						{ { "n", "x" }, "2do",        actions.diffget("ours"),           { desc = "Obtain the diff hunk from the OURS version of the file" } },
						{ { "n", "x" }, "<leader>oo", actions.diffget("ours"),           { desc = "Obtain the diff hunk from the OURS version of the file" } },
						{ { "n", "x" }, "3do",        actions.diffget("theirs"),         { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
						{ { "n", "x" }, "<leader>ot", actions.diffget("theirs"),         { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
						{ "n",          "g?",         actions.help({ "view", "diff4" }), { desc = "Open the help panel" } },
					},
				}
			},
		}
		require("diffview").setup(opts)
	end,
}
