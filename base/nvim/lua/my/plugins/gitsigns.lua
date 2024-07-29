local P = {
  "lewis6991/gitsigns.nvim",
}

function P.config()
  local gitsigns = require("gitsigns")

  gitsigns.setup({
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "┇" },
      untracked = { text = "┃" },
    },
    on_attach = function(bufnr)
      require("my.mappings").gitsigns_mappings(gitsigns, bufnr)
    end,
  })
end

return P
