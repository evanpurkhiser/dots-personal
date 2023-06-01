local M = {}

function M.setup()
  local autotag = safe_require("nvim-autopairs")
  if not autotag then
    return
  end

  autotag.setup()
end

return M
