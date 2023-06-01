M = {}

local g = vim.g

function M.setup()
  local indent_blankline = require("indent_blankline")

  g.indent_blankline_show_trailing_blankline_indent = false
  g.indent_blankline_show_first_indent_level = false
  g.indent_blankline_use_treesitter = true
  g.indent_blankline_show_current_context = true

  indent_blankline.setup({
    show_current_context = true,
    show_current_context_start = false,
  })
end

return M
