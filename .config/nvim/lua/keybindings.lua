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
nmap("<Leader>vc", ":lua require('c_telescope').search_dotfiles()<CR>")

-- completion in command mode
vim.api.nvim_set_keymap('c', '<C-j>', '<C-n>', {})
vim.api.nvim_set_keymap('c', '<C-k>', '<C-p>', {})

-- trouble
nmap("<Leader>t", ":TroubleToggle<CR>")
nmap("<C-A-m>", ":TroubleToggle<CR>")

-- nvim-tree
nmap("<C-n>", ":NvimTreeToggle<CR>")
nmap("<C-A-h>", ":NvimTreeToggle<CR>")

-- FZF
nmap("<Leader>p", ":Files<CR>")
-- nmap("<Leader>f", ":Files<CR>")
-- nmap("<C-f>", ":BLines<CR>")
-- nmap("<C-b>", ":Buffers<CR>")
-- nmap("<C-g>", ":RG<CR>")

-- telescope
nmap("<C-p>", ":Telescope find_files<CR>")
nmap("<C-b>", ":Telescope buffers<CR>")
nmap("<C-f>", ":Telescope current_buffer_fuzzy_find<CR>")
nmap("<C-g>", ":Telescope live_grep<CR>")
nmap("<Leader>T", ":Telescope <CR>")
nmap("<Leader>m", ":Telescope marks<CR>")

-- toggleterm
-- nmap("<C-A-j>", ":ToggleTerm<CR>")
function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
end

-- Remap arrow keys to resize window
nmap("<A-down>", ":resize -2<CR>")
nmap("<A-up>", ":resize +2<CR>")
nmap("<A-right>", ":vertical resize -2<CR>")
nmap("<A-left>", ":vertical resize +2<CR>")

-- LazyGit
nmap("<Leader>gs", ":LazyGit<CR>")
nmap("<C-A-l>", ":LazyGit<CR>")

-- Buffer handling
nmap("<Leader>h", ":bprevious<cr>")
nmap("<Leader>l", ":bnext<cr>")
nmap("<leader>bq", ":bp <BAR> confirm bd #<cr>")
nmap("<leader>o", ":Telescope buffers<cr>")

-- Better window navigation
map("n", "<C-h>", "<C-w>h" )
map("n", "<C-j>", "<C-w>j" )
map("n", "<C-k>", "<C-w>k" )
map("n", "<C-l>", "<C-w>l" )

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
nmap("<Leader>x", ":q!<cr>")
nmap("<Leader>w", ":w<cr>")
nmap("<Leader>q", ":q<cr>")
nmap("<Leader>vs", ":silent !code %:p<cr>") -- open current file in vscode

-- Custom Shortcuts
imap("jk", "<Esc>")
