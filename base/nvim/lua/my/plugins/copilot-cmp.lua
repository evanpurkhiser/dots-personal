---@type LazySpec
local P = {
  "zbirenbaum/copilot-cmp",
}

function P.config()
  require("copilot_cmp").setup()
end

return P
