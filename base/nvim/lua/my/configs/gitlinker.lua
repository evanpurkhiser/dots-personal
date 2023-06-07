local M = {}

function M.setup()
  local gitlinker = require("gitlinker")

  gitlinker.setup({
    opts = { add_current_line_on_normal_mode = false },
  })
end

function M.normal()
  require("gitlinker").get_buf_range_url("n")
end

function M.visual()
  require("gitlinker").get_buf_range_url("v")
end

return M
