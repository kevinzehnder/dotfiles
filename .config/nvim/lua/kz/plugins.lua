local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- load plugins
require('packer').startup(function(use)

  -- packer
  use 'wbthomason/packer.nvim'
  use 'dstein64/vim-startuptime'

  -- dashboard
  use { "goolord/alpha-nvim", commit = "ef27a59e5b4d7b1c2fe1950da3fe5b1c5f3b4c94" }

  -- status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- appearance
  use 'ishan9299/nvim-solarized-lua'
  use 'morhetz/gruvbox'
  use "sainnhe/gruvbox-material"
  use "lukas-reineke/indent-blankline.nvim"
  -- Colorschemes
  use { "folke/tokyonight.nvim", commit = "8223c970677e4d88c9b6b6d81bda23daf11062bb" }
  use 'nvim-tree/nvim-web-devicons'

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-context'

  -- git
  use {
    'lewis6991/gitsigns.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use 'kdheepak/lazygit.nvim'

  -- commentary
  use { "numToStr/Comment.nvim" }
  use { "JoosepAlviste/nvim-ts-context-commentstring" }
  use { "lewis6991/impatient.nvim", commit = "969f2c5c90457612c09cf2a13fee1adaa986d350" }

  -- surround
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  })

  -- null-ls
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
  })

  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }


  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- harpoon
  use 'ThePrimeagen/harpoon'

  -- toggleterm
  use { "akinsho/toggleterm.nvim" }

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
  use { "rafamadriz/friendly-snippets" }
  use { "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }
  use { "windwp/nvim-autopairs" }

  -- which key
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use { "ahmedkhalf/project.nvim", commit = "541115e762764bc44d7d3bf501b6e367842d3d4f" }

  -- DAP
  use { "mfussenegger/nvim-dap", commit = "014ebd53612cfd42ac8c131e6cec7c194572f21d" }
  use 'mfussenegger/nvim-dap-python'
  use { "rcarriga/nvim-dap-ui", commit = "d76d6594374fb54abf2d94d6a320f3fd6e9bb2f7" }
  use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }
  use { "theHamsta/nvim-dap-virtual-text"}

  --require('packer').update()

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end

end)
