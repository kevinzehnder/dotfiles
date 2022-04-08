-- bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- load plugins
require('packer').startup(function(use)

  -- packer
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
  use "sainnhe/gruvbox-material"

  -- treesitter
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }

  -- git
  use {
  'lewis6991/gitsigns.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'kdheepak/lazygit.nvim'

  -- commentary
  use 'tpope/vim-commentary'


  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
        require("null-ls").setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
  })

  -- nvim tree
  use 'kyazdani42/nvim-web-devicons'
  use { 'kyazdani42/nvim-tree.lua' }

  -- fzf
  use { "junegunn/fzf", run = ":call fzf#install()" }
  use "junegunn/fzf.vim"

  -- telescope
  use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- toggleterm
  use {"akinsho/toggleterm.nvim"}

  -- lsp and completion
  use 'neovim/nvim-lspconfig' -- collection of configurations for built-in LSP client
  use 'williamboman/nvim-lsp-installer' -- automatically install LSP Servers
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/nvim-cmp' -- autocompletion
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'onsails/lspkind-nvim' -- icons for completion
  use 'saadparwaiz1/cmp_luasnip' -- snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- snippets plugin
  use { "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }

  if packer_bootstrap then
    require('packer').sync()
  end

end)

