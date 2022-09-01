-- helper functions
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end


-- Leeraste als <leader>
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- edit vimrc files
nmap("<Leader>vc", ":lua require('kz.telescope').search_dotfiles()<CR>")

-- completion in command mode
vim.api.nvim_set_keymap('c', '<C-j>', '<C-n>', {})
vim.api.nvim_set_keymap('c', '<C-k>', '<C-p>', {})

-- trouble
nmap("<Leader>t", ":TroubleToggle<CR>")
nmap("<C-A-m>", ":TroubleToggle<CR>")

-- nvim-tree
nmap("<C-n>", ":NvimTreeToggle<CR>")
nmap("<C-A-h>", ":NvimTreeFocus<CR>")

-- FZF
-- nmap("<Leader>p", ":Files<CR>")

-- telescope
nmap("<Leader>p", ":Telescope projects<CR>")
nmap("<C-p>", ":lua require('kz.telescope').project_files()<CR>")
nmap("<C-b>", ":Telescope buffers<CR>")
nmap("<C-f>", ":Telescope current_buffer_fuzzy_find<CR>")
nmap("<C-g>", ":Telescope live_grep<CR>")
nmap("<Leader>T", ":Telescope <CR>")
nmap("<Leader>m", ":Telescope marks<CR>")
nmap("<Leader>d", ":Telescope treesitter<CR>")

-- toggleterm
-- nmap("<C-A-j>", ":ToggleTerm<CR>")
function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
end

-- DAP
map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>")
map("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>")
map("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>")
map("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
map("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
map("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>")
map("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>")

-- Comment
map("n", "<leader>/", "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>")
map("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>')

-- Remap arrow keys to resize window
nmap("<A-down>", ":resize -2<CR>")
nmap("<A-up>", ":resize +2<CR>")
nmap("<A-right>", ":vertical resize -2<CR>")
nmap("<A-left>", ":vertical resize +2<CR>")

-- LazyGit
nmap("<Leader>gs", ":LazyGit<CR>")
nmap("<C-A-l>", ":LazyGit<CR>")

-- Buffer handling
nmap("<S-h>", ":bprevious<cr>")
nmap("<S-l>", ":bnext<cr>")
nmap("<leader>bq", ":bp <BAR> confirm bd #<cr>")
nmap("<leader>bQ", ":%bd|e#|confirm bd #<cr>")
nmap("<leader>o", ":Telescope buffers<cr>")

-- Better window navigation
map("n", "<C-h>", "<C-w>h" )
map("n", "<C-j>", "<C-w>j" )
map("n", "<C-k>", "<C-w>k" )
map("n", "<C-l>", "<C-w>l" )
--
-- Clear highlights
map("n", "<Leader>h", "<cmd>nohlsearch<CR>")

-- Visual --
-- Move text up and down
map("v", "<A-k>", ":m .-2<CR>==" )
map("v", "<A-j>", ":m .+1<cr>==" )

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv" )
map("x", "K", ":move '<-2<CR>gv-gv" )
map("x", "<A-j>", ":move '>+1<CR>gv-gv" )
map("x", "<A-k>", ":move '<-2<CR>gv-gv" )

-- Custom Leader Shortcuts
nmap("<Leader>?", ":WhichKey<cr>")
nmap("<Leader>x", ":q!<cr>")
nmap("<Leader>w", ":w<cr>")
nmap("<Leader>q", ":q<cr>")
nmap("<Leader>vs", ":silent !code %:p<cr>") -- open current file in vscode

-- Custom Shortcuts
imap("jk", "<Esc>")