local M = {}

function M.setup()
  local fidget = require("fidget")

  fidget.setup({ text = { spinner = "dots" } })
end

return M
