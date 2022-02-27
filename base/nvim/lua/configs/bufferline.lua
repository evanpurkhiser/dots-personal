local M = {}

function M.setup()
  local bufferline = safe_require("bufferline")
  if not bufferline then
    return
  end

  bufferline.setup({
    options = {
      modified_icon = "",
      show_close_icon = false,
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 24,
      max_prefix_length = 13,
      tab_size = 0,
      show_tab_indicators = false,
      enforce_regular_tabs = false,
      view = "multiwindow",
      show_buffer_close_icons = false,
      separator_style = { "", "" },
      always_show_bufferline = true,
      diagnostics = false,
    },
  })
end

return M
