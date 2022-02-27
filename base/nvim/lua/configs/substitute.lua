local M = {}

function M.setup()
  local status_ok, substitute = pcall(require, "substitute")
  if not status_ok then
    return
  end

  substitute.setup()
end

return M
