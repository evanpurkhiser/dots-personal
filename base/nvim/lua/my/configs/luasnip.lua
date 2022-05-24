local M = {}

function M.setup()
  local cmp = safe_require("luasnip")
  if not cmp then
    return
  end

  require("luasnip.loaders.from_vscode").lazy_load()
end

return M
