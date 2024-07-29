---@type LazySpec
local P = {
  "nvim-lualine/lualine.nvim",
}

function P.config()
  local lualine = require("lualine")

  local function repoName()
    return " " .. vim.fn.getcwd():match("[^/]*$")
  end

  local config = {
    options = {
      theme = "gruvbox_dark",

      globalstatus = true,
      disabled_filetypes = {},
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
          padding = 1,
        },
        {
          "filename",
          path = 1,
          shorting_target = 50,
          symbols = {
            modified = "⏺",
            readonly = "◯",
          },
        },
      },
      lualine_x = {
        {
          "diagnostics",
          padding = 1,
          symbols = {
            error = "[⏺] ",
            warn = "[⏺] ",
            info = "[⏺] ",
            hint = "[⏺] ",
          },
        },
      },
      lualine_y = {
        "encoding",
        { "fileformat", padding = { right = 1 } },
      },
      lualine_z = {},
    },
  }

  lualine.setup(config)
end

return P
