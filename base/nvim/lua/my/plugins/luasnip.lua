---@type LazySpec
local P = {
  "L3MON4D3/luasnip",
  event = "BufRead",
  dependencies = { "rafamadriz/friendly-snippets" },
}

function P.config()
  require("luasnip.loaders.from_vscode").lazy_load()
end

return P
