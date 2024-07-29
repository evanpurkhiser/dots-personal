---@type LazySpec
local P = {
  "folke/lazydev.nvim",
  ft = "lua",
}

function P.config()
  require("lazydev").setup()
end

return P
