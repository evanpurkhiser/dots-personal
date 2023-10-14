local P = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufRead",
}

function P.config()
  local ibl = require("ibl")

  ibl.setup({
    indent = { char = "|" },
    scope = { enabled = false },
  })
end

return P
