local M = {}

function M.setup()
  local cmp = require("luasnip")

  require("luasnip.loaders.from_vscode").lazy_load()
end

return M
