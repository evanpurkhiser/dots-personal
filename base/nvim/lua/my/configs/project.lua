local M = {}

function M.setup()
  local project = safe_require("project_nvim")
  if not project then
    return
  end

  config = {
    -- LSP detection seems buggy
    detection_methods = { "pattern" },

    -- Scope path the window of the file
    scope_chdir = "win",
  }

  project.setup(config)
end

return M
