local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local packer_bootstrap = false

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

local packer = require("packer")

return packer.startup(function(use)
  use({ "wbthomason/packer.nvim" })

  use({ "nvim-lua/plenary.nvim" })

  use({ "tpope/vim-rsi" })
  use({ "tpope/vim-sleuth" })
  use({ "tpope/vim-surround" })
  use({ "tpope/vim-commentary" })
  use({ "tpope/vim-unimpaired" })
  use({ "tpope/vim-fugitive" })
  use({ "tpope/vim-rhubarb" })

  -- Improve boot-time performance by replacing filetype.vim
  use({ "nathom/filetype.nvim" })

  -- Automatically set the root directory
  use({ "ygm2/rooter.nvim" })

  -- Directory browsing
  use({ "justinmk/vim-dirvish" })

  -- Sudo write
  use({ "lambdalisue/suda.vim" })

  -- Fuzzy file / buffer / mru finder
  use({
    "ibhagwan/fzf-lua",
    requires = { "kyazdani42/nvim-web-devicons" },
  })

  -- Syntax aware
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    event = "BufRead",
    cmd = {
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSDisableAll",
      "TSEnableAll",
    },
    config = function()
      require("configs.treesitter").setup()
    end,
  })

  -- Colors
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("configs.colorizer").setup()
    end,
  })

  -- Icons
  use({
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("configs.icons").setup()
    end,
  })

  -- Status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("configs.lualine").setup()
    end,
  })

  -- Buffer line
  use({
    "akinsho/bufferline.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("configs.bufferline").setup()
    end,
  })

  -- Show vertical lines for tab alignment
  use({
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require("configs.indent-blankline").setup()
    end,
  })

  -- Snippet engine
  use({ "L3MON4D3/LuaSnip" })

  -- Utilities for better configuration of the neovim LSP
  use({
    "neovim/nvim-lspconfig",
    event = "BufRead",
    config = function()
      require("configs.lsp").setup()
    end,
  })

  -- Helper plugin to handle installing LSP servers
  use({
    "williamboman/nvim-lsp-installer",
    event = "BufRead",
  })

  -- Null language server, provides many formatting built-ins
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("configs.null-ls").setup()
    end,
  })

  -- Autocompletion
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("configs.cmp").setup()
    end,
  })

  -- Completion source: buffer
  use({
    "hrsh7th/cmp-nvim-lsp",
    after = "nvim-cmp",
  })

  -- Completion source: buffer
  use({
    "hrsh7th/cmp-buffer",
    after = "nvim-cmp",
  })

  -- Completion source: snippet
  use({
    "saadparwaiz1/cmp_luasnip",
    after = "nvim-cmp",
  })

  -- Adds a range command for swapping with the yanked text
  use({
    "gbprod/substitute.nvim",
    config = function()
      require("configs.substitute").setup()
    end,
  })

  -- Helper for closing a buffer without closing the split
  use({ "moll/vim-bbye" })

  -- Adds argument text objects
  use({ "b4winckler/vim-angry" })

  -- Color schemes
  use({ "eddyekofo94/gruvbox-flat.nvim" })

  -- Styled compoennt syntax highlighting
  use({ "styled-components/vim-styled-components", branch = "main" })

  if packer_bootstrap then
    packer.sync()
  end
end)
