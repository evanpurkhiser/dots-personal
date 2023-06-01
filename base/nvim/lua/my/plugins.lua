local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    vim.cmd([[packadd packer.nvim]])
    return true
  end

  return false
end

local should_bootstrap = ensure_packer()
local packer = require("packer")

return packer.startup(function(use)
  use({ "wbthomason/packer.nvim" })

  -- Color schemes
  use({
    "eddyekofo94/gruvbox-flat.nvim",
    config = function()
      -- colorscheme
      vim.g.gruvbox_flat_style = "dark"
      vim.cmd("colorscheme gruvbox-flat")
    end,
  })

  use({ "nvim-lua/plenary.nvim" })

  use({ "tpope/vim-rsi" })
  use({ "tpope/vim-sleuth" })
  use({ "tpope/vim-surround" })
  use({ "tpope/vim-commentary" })
  use({ "tpope/vim-unimpaired" })
  use({ "tpope/vim-fugitive" })
  use({ "tpope/vim-rhubarb" })

  -- Automatic pairs
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("my.configs.autopairs").setup()
    end,
  })

  -- Automatically set the root directory
  use({
    "ahmedkhalf/project.nvim",
    config = function()
      require("my.configs.project").setup()
    end,
  })

  -- Directory browsing
  use({ "justinmk/vim-dirvish" })

  -- Sudo write
  use({ "lambdalisue/suda.vim" })

  -- Icons
  use({
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("my.configs.icons").setup()
    end,
  })

  -- Fuzzy file / buffer / mru finder
  use({
    "ibhagwan/fzf-lua",
    config = function()
      require("my.configs.fzf").setup()
    end,
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
      require("my.configs.treesitter").setup()
    end,
  })

  -- Colors
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("my.configs.colorizer").setup()
    end,
  })

  -- Status line
  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("my.configs.lualine").setup()
    end,
  })

  -- Buffer line
  use({
    "akinsho/bufferline.nvim",
    tag = "*",
    config = function()
      require("my.configs.bufferline").setup()
    end,
  })

  -- Show vertical lines for tab alignment
  use({
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require("my.configs.indent-blankline").setup()
    end,
  })

  -- Snippet engine
  use({
    "L3MON4D3/LuaSnip",
    config = function()
      require("my.configs.luasnip").setup()
    end,
  })

  -- vscode snippets
  use({ "rafamadriz/friendly-snippets" })

  -- Helper plugins to handle installing LSP servers
  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })

  -- Utilities for better configuration of the neovim LSP
  use({
    "neovim/nvim-lspconfig",
    after = { "mason.nvim", "mason-lspconfig.nvim" },
    config = function()
      require("my.configs.lsp").setup()
    end,
  })

  -- LSP status lines
  use({
    "j-hui/fidget.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("my.configs.fidget").setup()
    end,
  })

  -- Null language server, provides many formatting built-ins
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("my.configs.null-ls").setup()
    end,
  })

  -- Autocompletion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("my.configs.cmp").setup()
    end,
  })

  -- Adds a range command for swapping with the yanked text
  use({
    "gbprod/substitute.nvim",
    config = function()
      require("my.configs.substitute").setup()
    end,
  })

  -- Helper for pasting images from the clipboard
  use({
    "evanpurkhiser/image-paste.nvim",
    config = function()
      require("my.configs.image-paste").setup()
    end,
  })

  -- Helper for closing a buffer without closing the split
  use({ "famiu/bufdelete.nvim" })

  -- Adds argument text objects
  use({ "b4winckler/vim-angry" })

  -- Styled compoennt syntax highlighting
  use({ "styled-components/vim-styled-components", branch = "main" })

  if should_bootstrap then
    packer.sync()
  end
end)
