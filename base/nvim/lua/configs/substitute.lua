local M = {}

function M.setup()
  local substitute = safe_require("substitute")
  if not substitute then
    return
  end

  substitute.setup()
end

return M
