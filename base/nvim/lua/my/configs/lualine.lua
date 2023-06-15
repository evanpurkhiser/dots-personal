local M = {}

function M.setup()
  local lualine = require("lualine")

  local function repoName()
    return " " .. vim.fn.getcwd():match("[^/]*$")
  end

  local config = {
    options = {
      theme = "gruvbox_dark",

      globalstatus = true,
      disabled_filetypes = { "NvimTree", "dashboard", "Outline" },
      component_separators = "",
      section_separators = "",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { { repoName } },
      lualine_c = {
        {
          "filetype",
          colored = true,
          icon_only = true,
          padding = { left = 1, right = 0 },
        },
        {
          "filename",
          path = 1,
          shorting_target = 50,
        },
      },
      lualine_x = { "encoding", "fileformat", "diagnostics" },
      lualine_y = {},
      lualine_z = {},
    },
  }

  lualine.setup(config)
end

return M
