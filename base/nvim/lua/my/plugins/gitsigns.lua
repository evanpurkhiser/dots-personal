P = {
  "lewis6991/gitsigns.nvim",
}

function P.config()
  require("gitsigns").setup({
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "┇" },
      untracked = { text = "┃" },
    },
  })
end

return P
