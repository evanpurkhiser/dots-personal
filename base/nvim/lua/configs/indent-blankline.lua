M = {}

local g = vim.g

function M.setup()
  local status_ok, indentBlankline = pcall(require, "indent_blankline")
  if not status_ok then
    return
  end

  g.indentLine_enabled = 1
  g.indent_blankline_show_trailing_blankline_indent = false
  g.indent_blankline_show_first_indent_level = false
  g.indent_blankline_use_treesitter = true
  g.indent_blankline_show_current_context = true

  indentBlankline.setup({
    show_current_context = true,
    show_current_context_start = false,
  })
end

return M
