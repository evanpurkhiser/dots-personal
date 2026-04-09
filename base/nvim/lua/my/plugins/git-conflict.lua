---@module "lazy"

---@type LazySpec
local P = {
  "evanpurkhiser/git-conflict.nvim",
  commit = "3df003abb53fc684ffe5d38da7370cc451f48462",
}

function P.config()
  require("git-conflict").setup({})
end

return P
