-- leader keymaps
vim.keymap.set("n", "<leader>x", "<cmd>qa<CR>", { desc = "Quit All" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save Buffer" })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "No Highlight" })
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
vim.keymap.set("n", "<leader>c", "<cmd>bdelete<CR>", { desc = "Close Buffer" })

-- panels keymaps
vim.keymap.set("n", "<A-H>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
vim.keymap.set("n", "<A-M>", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Toggle NvimTree" })

-- telescope
vim.keymap.set("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in Buffer" })
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- diagnostic keymaps

-- git keymaps
vim.keymap.set("n", "<leader>gD", "<cmd>Gitsigns diffthis<CR>", { desc = "Git Diff This" })
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Git Stage Hunk" })
vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Git Undo Stage Hunk" })
vim.keymap.set("n", "<leader>gj", "<cmd>Gitsigns next_hunk<CR>", { desc = "Git Next Hunk" })
vim.keymap.set("n", "<leader>gk", "<cmd>Gitsigns previous_hunk<CR>", { desc = "Git Previous Hunk" })
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Git Preview Hunk Inline" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Git Reset Hunk" })
vim.keymap.set("n", "<leader>gh", "<cmd>Gitsigns toggle_deleted<CR><cmd>Gitsigns toggle_linehl<CR><cmd>Gitsigns toggle_word_diff<CR>", { desc = "Git Highlight Changes" })
vim.keymap.set("n", "<leader>gd", function ()
	if next(require("diffview.lib").views) == nil then
		vim.cmd("DiffviewOpen")
	else
		vim.cmd("DiffviewClose")
	end
end, { desc = "Git Toggle Diffview" })
vim.keymap.set("n", "<leader>gF", "<cmd>DiffviewFileHistory %<CR>", { desc = "Git File History" })
vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

-- layout keymaps
vim.keymap.set("n", "<C-down>", ":resize -2<CR>", { desc = "Resize Window" })
vim.keymap.set("n", "<C-up>", ":resize +2<CR>", { desc = "Resize Window" })
vim.keymap.set("n", "<C-right>", ":vertical resize -2<CR>", { desc = "Resize Window" })
vim.keymap.set("n", "<C-left>", ":vertical resize +2<CR>", { desc = "Resize Window" })

-- harpoon
vim.keymap.set("n", "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = "Menu" })
vim.keymap.set("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "Add File" })
vim.keymap.set("n", "<A-f>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", { desc = "File 1" })
vim.keymap.set("n", "<A-d>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", { desc = "File 2" })
vim.keymap.set("n", "<A-s>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", { desc = "File 3" })
vim.keymap.set("n", "<A-a>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", { desc = "File 4" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- primeagen remaps
-- vim.keymap.set("x", "<Leader>p", '"_dP')
-- vim.keymap.set("n", "<leader>P", "<cmd>:put +<CR>", { desc = "paste without overwriting register" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "n", "nzz")
-- vim.keymap.set("n", "N", "Nzz")
-- vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<Leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Change word under cursor" })

-- Remap arrow keys to resize window
vim.keymap.set("n", "<A-down>", ":resize -2<CR>")
vim.keymap.set("n", "<A-up>", ":resize +2<CR>")
vim.keymap.set("n", "<A-right>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<A-left>", ":vertical resize +2<CR>")

-- insert mode mappings
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-k>", "<Up>")

-- diffview remaps
local actions = require("diffview.actions")
vim.keymap.set("n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose the OURS version of a conflict" })
vim.keymap.set("n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose the THEIRS version of a conflict" })
vim.keymap.set("n", "<leader>ob", actions.conflict_choose("base"), { desc = "Choose the BASE version of a conflict" })
vim.keymap.set("n", "<leader>oa", actions.conflict_choose("all"), { desc = "Choose all the versions of a conflict" })
vim.keymap.set("n", "ox", actions.conflict_choose("none"), { desc = "Delete the conflict region" })
vim.keymap.set("n", "<leader>oO", actions.conflict_choose_all("ours"), { desc = "Choose the OURS version of a conflict for the whole file" })
vim.keymap.set("n", "<leader>oT", actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" })
vim.keymap.set("n", "<leader>oB", actions.conflict_choose_all("base"), { desc = "Choose the BASE version of a conflict for the whole file" })
vim.keymap.set("n", "<leader>oA", actions.conflict_choose_all("all"), { desc = "Choose all the versions of a conflict for the whole file" })
