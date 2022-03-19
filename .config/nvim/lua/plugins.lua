-- vim.cmd [[packadd packer.nvim]]

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'

  -- status line
  use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- appearance
  use 'ishan9299/nvim-solarized-lua'
  use 'morhetz/gruvbox'
  use "lukas-reineke/indent-blankline.nvim"
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }

  -- git
  use "tpope/vim-fugitive"
  use 'airblade/vim-gitgutter'

  use 'tpope/vim-commentary'

  -- file handling
  use 'kyazdani42/nvim-web-devicons'
  use { 'kyazdani42/nvim-tree.lua' }

  use { "junegunn/fzf", run = ":call fzf#install()" }
  use "junegunn/fzf.vim"

  -- use {
  -- 'nvim-telescope/telescope.nvim',
  -- requires = { {'nvim-lua/plenary.nvim'} }
  -- }

  --
  -- lsp and completion
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer' -- collection of configurations for built-in LSP client
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/nvim-cmp' -- autocompletion
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  -- use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'onsails/lspkind-nvim'
  -- use 'saadparwaiz1/cmp_luasnip' -- snippets source for nvim-cmp
  -- use 'L3MON4D3/LuaSnip' -- snippets plugin

  if packer_bootstrap then
    require('packer').sync()
  end

end)
