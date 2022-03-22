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

-- completion in command mode
vim.api.nvim_set_keymap('c', '<C-j>', '<C-n>', {})
vim.api.nvim_set_keymap('c', '<C-k>', '<C-p>', {})

-- nvim-tree
nmap("<C-n>", ":NvimTreeToggle<CR>")

-- FZF
-- nmap("<Leader>f", ":Files<CR>")
nmap("<C-p>", ":Files<CR>")
nmap("<C-f>", ":BLines<CR>")
nmap("<C-b>", ":Buffers<CR>")
nmap("<C-g>", ":RG<CR>")

-- telescope
-- nmap("<C-p>", ":Telescope find_files<CR>")
-- nmap("<C-b>", ":Telescope buffers<CR>")
-- nmap("<C-g>", ":Telescope live_grep<CR>")

-- Remap arrow keys to resize window
nmap("<A-down>", ":resize -2<CR>")
nmap("<A-up>", ":resize +2<CR>")
nmap("<A-right>", ":vertical resize -2<CR>")
nmap("<A-left>", ":vertical resize +2<CR>")

-- vim fugitive
nmap("<Leader>gs", ":G<CR>")
nmap("<Leader>gl", ":G log<CR>")

-- gitgutter
-- vim.g.gitgutter_map_keys = 0
-- nmap("<Leader>gn", ":GitGutterNextHunk<CR>")
-- nmap("<Leader>gp", ":GitGutterPrevHunk<CR>")

-- Buffer handling
nmap("<Leader>h", ":bprevious<cr>")
nmap("<Leader>l", ":bnext<cr>")
nmap("<leader>bq", ":bp <BAR> confirm bd #<cr>")
nmap("<leader>o", ":Buffers<cr>")

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

-- Custom Shortcuts
imap("jk", "<Esc>")
