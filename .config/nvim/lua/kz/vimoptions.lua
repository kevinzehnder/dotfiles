-- Layout Options
vim.o.termguicolors = true

-- Indentation
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- general settings
vim.opt.mouse = "a"

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- ide stuff
vim.opt.pumheight = 10
vim.opt.showtabline = 0
vim.opt.timeoutlen = 300
vim.opt.writebackup = false
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.fillchars.eob=" "
vim.opt.shortmess:append "c"
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.encoding = "utf8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
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

-- lsp
vim.diagnostic.config({
  virtual_text = true,

})

