local P = {
  "akinsho/bufferline.nvim",
}

function P.config()
  local bufferline = require("bufferline")

  bufferline.setup({
    options = {
      style_preset = bufferline.style_preset.no_italic,
      always_show_bufferline = true,

      -- No focus indicator, simply rely on colors
      indicator = { style = "none" },
      separator_style = { "", "" },

      -- No close icons
      show_close_icon = false,
      show_buffer_close_icons = false,

      modified_icon = "",
      left_trunc_marker = "󰁍",
      right_trunc_marker = "󰁔",

      -- Sizing
      max_name_length = 24,
      max_prefix_length = 13,
      tab_size = 0,

      -- No tabs
      show_tab_indicators = false,
      enforce_regular_tabs = false,

      diagnostics = false,
    },
  })

  require("my.mappings").bufferline_mappings(bufferline)
end

return P
