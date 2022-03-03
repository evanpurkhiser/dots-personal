local M = {}

function M.setup()
  local lualine = safe_require("lualine")
  if not lualine then
    return
  end

  local config = {
    options = {
      theme = "gruvbox-flat",

      disabled_filetypes = { "NvimTree", "dashboard", "Outline" },
      component_separators = "",
      section_separators = "",
    },
  }

  lualine.setup(config)
end

return M
