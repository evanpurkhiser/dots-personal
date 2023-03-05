local M = {}

function M.setup()
  local fidget = safe_require("fidget")
  if not fidget then
    return
  end

  fidget.setup({ text = { spinner = "dots" } })
end

return M
