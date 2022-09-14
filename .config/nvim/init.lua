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
require('kz.nvimtree')
require('kz.autopairs')
require('kz.commentary')
require('kz.impatient')

require("harpoon").setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
    }
})

require('kz.fzf')
require('kz.telescope')

require('kz.lualine')
require('kz.gitsigns')
require('kz.trouble')

require('kz.toggleterm')
require('kz.treesitter')
require('kz.completion')

require('kz.null-ls')
require('kz.lsp')

require('kz.indentline')
require('kz.dap')

require('kz.project')

