local M = {}

function M.setup()
  local substitute = safe_require("substitute")
  if not substitute then
    return
  end

  substitute.setup()

  -- Load mappings
  require("my.mappings").substitue_mapping()
end

return M
