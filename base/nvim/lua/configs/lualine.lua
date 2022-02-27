local M = {}

function M.setup()
  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
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
