local M = {}

function M.setup()
  local project = require("project_nvim")

  config = {
    -- LSP detection seems buggy
    detection_methods = { "pattern" },

    -- Scope path the window of the file
    scope_chdir = "win",
  }

  project.setup(config)
end

return M
