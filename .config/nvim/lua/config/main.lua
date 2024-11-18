-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

-- options
vim.opt.number = true
vim.opt.confirm = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.cmdheight = 0

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function ()
    vim.opt.clipboard = "unnamedplus"
end)

-- indentation
vim.opt.smartindent = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.breakindent = true

-- ide stuff
vim.opt.showtabline = 0
-- vim.opt.pumheight = 10
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


-- Disable builtin plugins
local disabled_built_ins = {
    "2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
    "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
    "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
    "synmenu", "optwin", "compiler", "bugreport", "ftplugin"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end
