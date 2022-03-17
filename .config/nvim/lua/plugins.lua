-- Plugins
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'

-- themes
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'
Plug 'lifepillar/vim-solarized8'
Plug 'yggdroot/indentline'

-- git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

-- file handling
Plug 'scrooloose/nerdtree'
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
Plug 'junegunn/fzf.vim'

-- treesitter
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ":TSUpdate"})

-- lsp
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer' -- collection of configurations for built-in LSP client
Plug 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
Plug 'hrsh7th/nvim-cmp' -- autocompletion
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip' -- snippets source for nvim-cmp
Plug 'L3MON4D3/LuaSnip' -- snippets plugin
-- Plug 'w0rp/ale'

vim.call('plug#end')
