-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

-- options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.cmdheight = 0

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- indentation
vim.opt.smartindent = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.breakindent = true

-- ide stuff
-- vim.opt.pumheight = 10
-- vim.opt.showtabline = 0
-- vim.opt.timeoutlen = 300
-- vim.opt.writebackup = false
-- vim.opt.laststatus = 3
-- vim.opt.showcmd = false
-- vim.opt.ruler = false
-- vim.opt.fillchars.eob = " "
-- vim.opt.shortmess:append "c"
-- vim.opt.whichwrap:append("<,>,[,],h,l")
-- vim.opt.iskeyword:append("-")

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "⟩", precedes = "⟨", space = "·" }

vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.o.sidescrolloff = 15
vim.o.sidescroll = 1

vim.opt.diffopt = "internal,filler,closeoff,vertical,iwhiteall"

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

-- leader keymaps
-- vim.keymap.set("n", "<leader>x", "<cmd>qa!<CR>", { desc = "Quit (Force)" })
vim.keymap.set("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save Buffer" })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "No Highlight" })
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
vim.keymap.set("n", "<leader>c", "<cmd>bdelete<CR>", { desc = "Close Buffer" })

-- telescope
vim.keymap.set("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in Buffer" })
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- diagnostic keymaps

-- git keymaps
vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Git Diff This" })
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Git Stage Hunk" })
vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Git Undo Stage Hunk" })
vim.keymap.set("n", "<leader>gj", "<cmd>Gitsigns next_hunk<CR>", { desc = "Git Next Hunk" })
vim.keymap.set("n", "<leader>gk", "<cmd>Gitsigns previous_hunk<CR>", { desc = "Git Previous Hunk" })
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Git Preview Hunk Inline" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Git Reset Hunk" })
vim.keymap.set(
	"n",
	"<leader>gh",
	"<cmd>Gitsigns toggle_deleted<CR><cmd>Gitsigns toggle_linehl<CR><cmd>Gitsigns toggle_word_diff<CR>",
	{ desc = "Git Highlight Changes" }
)
vim.keymap.set("n", "<leader>gD", function()
	if next(require("diffview.lib").views) == nil then
		vim.cmd("DiffviewOpen")
	else
		vim.cmd("DiffviewClose")
	end
end, { desc = "Git Toggle Diffview" })
vim.keymap.set("n", "<leader>gF", "<cmd>DiffviewFileHistory %<CR>", { desc = "Git File History" })
--  map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
--  map('n', '<leader>hd', gitsigns.diffthis)
--  map('n', '<leader>td', gitsigns.toggle_deleted)
--

vim.keymap.set("n", "<C-down>", ":resize -2<CR>", { desc = "Resize Window" })
vim.keymap.set("n", "<C-up>", ":resize +2<CR>", { desc = "Resize Window" })
vim.keymap.set("n", "<C-right>", ":vertical resize -2<CR>", { desc = "Resize Window" })
vim.keymap.set("n", "<C-left>", ":vertical resize +2<CR>", { desc = "Resize Window" })

-- ["<leader>s"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "replace word under cursor" },
-- ["<leader>P"] = { "<cmd>:put +<CR>" , desc = "paste without overwriting buffer" },
-- harpoon
-- ["<leader>j"] = { name = "Harpoon" },
-- ["<leader>jj"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Quick Menu" },
-- ["<leader>ja"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add File" },
-- ["<leader>jf"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = " File 1" },
-- ["<leader>jd"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "File 2" },
-- ["<leader>js"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "File 3" },
-- ["<leader>je"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "File 4" },
-- ["<leader>jr"] = { "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", desc = "File 5" },

-- git

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- primeagen remaps
vim.keymap.set("x", "<Leader>p", '"_dP')
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "n", "nzz")
-- vim.keymap.set("n", "N", "Nzz")
-- vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set(
	"n",
	"<Leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Change word under cursor" }
)

-- Remap arrow keys to resize window
vim.keymap.set("n", "<A-down>", ":resize -2<CR>")
vim.keymap.set("n", "<A-up>", ":resize +2<CR>")
vim.keymap.set("n", "<A-right>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<A-left>", ":vertical resize +2<CR>")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
