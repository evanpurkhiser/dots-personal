---@module "lazy"

---@type LazySpec
local P = {
  "akinsho/git-conflict.nvim",
}

function P.config()
  require("git-conflict").setup({})
end

return P
