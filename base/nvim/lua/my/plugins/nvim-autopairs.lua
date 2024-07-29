---@type LazySpec
local P = {
  "windwp/nvim-autopairs",
}

function P.config()
  require("nvim-autopairs").setup()
end

return P
