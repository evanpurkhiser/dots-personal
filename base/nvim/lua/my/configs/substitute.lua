local M = {}

function M.setup()
  local substitute = require("substitute")

  substitute.setup()

  -- Load mappings
  require("my.mappings").substitue_mapping()
end

return M
