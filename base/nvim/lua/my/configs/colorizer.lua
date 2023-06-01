M = {}

function M.setup()
  local colorizer = require("colorizer")

  colorizer.setup({ "*" }, {
    RRGGBB = true,
    RGB = false,
    names = false,
    RRGGBBAA = false,
  })
end

return M
