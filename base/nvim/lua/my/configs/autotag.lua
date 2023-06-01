local M = {}

function M.setup()
  local autotag = require("nvim-ts-autotag")

  autotag.setup({ autotag = { enabled = true } })

  -- Ensure we attach to the buffer which loaded the plugin
  require("nvim-ts-autotag.internal").attach()
end

return M
