-- Layout Options
vim.o.termguicolors = true
vim.g["airline_theme"] = "atomic"
vim.g["airline_powerline_fonts"] = 1
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#buffer_nr_show"] = 0
vim.g["airline#extensions#whitespace#enabled"] = 0

-- Indentation
vim.opt.autoindent=true
vim.opt.smartindent = true
vim.g.indentLine_char = '⦙'
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- YAML fix
-- vim.cmd([[autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab]])

-- general settings
-- vim.opt.mouse = "a"
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.encoding = "utf8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.textwidth = 120
vim.cmd([[ highlight Comment cterm=italic ]])
vim.opt.colorcolumn = "+1"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard = unnamedplus

-- undo
vim.opt.undofile = true

-- Scrolling
vim.o.scrolloff = 8  -- Start scrolling when we're 8 lines away from margins
vim.o.sidescrolloff = 15
vim.o.sidescroll = 1

