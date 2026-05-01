---@module "lazy"

---@type LazySpec
local P = {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
}

function P.config()
  require("todo-comments").setup({
    keywords = {
      REVIEW = { icon = "", color = "error" },
    },
  })
end

return P
