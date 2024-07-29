---@module "lazy"

---@type LazySpec
local P = {
  "j-hui/fidget.nvim",
  tag = "legacy",
  dependencies = { "mason-lspconfig.nvim" },
  event = "LspAttach",
}

function P.config()
  local fidget = require("fidget")

  fidget.setup({ text = { spinner = "dots" } })
end

return P
