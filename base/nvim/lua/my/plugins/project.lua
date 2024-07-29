---@type LazySpec
local P = {
  "ahmedkhalf/project.nvim",
}

function P.config()
  local project = require("project_nvim")

  project.setup({
    -- LSP detection seems buggy
    detection_methods = { "pattern" },
    -- Scope path the window of the file
    scope_chdir = "win",
  })
end

return P
