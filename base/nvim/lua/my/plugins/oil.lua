---@module "lazy"

---@type LazySpec
local P = {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

function P.config()
  require("oil").setup()
end

return P
