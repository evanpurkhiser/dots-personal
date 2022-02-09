local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

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
  use({ "tpope/vim-rsi" })
  use({ "tpope/vim-sleuth" })
  use({ "tpope/vim-surround" })
  use({ "tpope/vim-commentary" })
  use({ "tpope/vim-unimpaired" })

  -- Directory browsing
  use({ "justinmk/vim-dirvish" })

  -- Sudo write
  use({ "lambdalisue/suda.vim" })

  -- Automagically root
  use({ "airblade/vim-rooter" })

  -- Automatically enable 'paste' when pasting from a supporting terminal
  -- http://www.xfree86.org/current/ctlseqs.html#Bracketed Paste Mode
  use({ "ConradIrwin/vim-bracketed-paste" })

  -- Fuzzy file / buffer / mru finder
  use({ "junegunn/fzf", dir = "~/.local/lib/fzf", run = "./install --bin" })

  use({ "junegunn/fzf.vim" })

  -- Prettier status line
  use({ "vim-airline/vim-airline" })
  use({ "vim-airline/vim-airline-themes" })

  -- Helper for closing a buffer without closing the split
  use({ "qpkorr/vim-bufkill" })

  -- Adds argument text objects
  use({ "b4winckler/vim-angry" })

  -- Adds a range command for swapping with the yanked text
  use({ "svermeulen/vim-subversive" })

  -- Show vertical lines for tab alignment
  use({ "Yggdroot/indentLine" })

  -- Color schemes
  use({ "morhetz/gruvbox" })

  -- Syntax aware
  use({ "sheerun/vim-polyglot" })
  use({ "alunny/pegjs-vim" })

  -- Colors
  use({ "norcalli/nvim-colorizer.lua" })

  use({ "tpope/vim-fugitive" })
  use({ "tpope/vim-rhubarb" })

  -- Omnicomplete support / diagnostics
  use({ "neoclide/coc.nvim", branch = "release" })

  -- Autosave formatting
  use({ "sbdchd/neoformat" })

  -- Graphql syntax
  use({ "jparise/vim-graphql" })

  -- Styled compoennt syntax highlighting
  use({ "styled-components/vim-styled-components", branch = "main" })

  if packer_bootstrap then
    packer.sync()
  end
end)
