-- Layout Options
vim.o.termguicolors = true

-- Indentation
vim.opt.autoindent=true
vim.opt.smartindent = true
-- vim.g.indentLine_char = '⦙'
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true


vim.diagnostic.config({
  virtual_text = false,

})

-- YAML fix
-- vim.cmd([[autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab]])

-- general settings
vim.opt.mouse = "a"

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.encoding = "utf8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = false
vim.opt.textwidth = 120
vim.opt.signcolumn = "auto:2"
vim.cmd([[ highlight Comment cterm=italic ]])
vim.opt.colorcolumn = "+1"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 300

-- undo
vim.opt.undofile = true

-- Scrolling
vim.o.scrolloff = 12  -- Start scrolling when we're 12 lines away from margins
vim.o.sidescrolloff = 15
vim.o.sidescroll = 1

