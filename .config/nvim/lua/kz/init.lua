-- plugins with packer 
require('kz.plugins')

--dashboard
require('kz.alpha')

-- general vim settings
require('kz.vimoptions')
require('kz.colors')
require('kz.keymap')
require('kz.keybindings')

-- plugin settings
require('kz.autopairs')
require('kz.commentary')
require('kz.impatient')

require('kz.fzf')
require('kz.telescope')
require('kz.harpoon')
require('kz.project')

require('kz.lualine')
require('kz.indentline')
require('kz.gitsigns')
require('kz.toggleterm')

require('kz.trouble')
require('kz.treesitter')
require('kz.completion')
require('kz.null-ls')
require('kz.lsp')

require('kz.dap')
require("mason").setup()
