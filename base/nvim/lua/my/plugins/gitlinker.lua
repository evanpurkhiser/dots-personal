local P = {
  "ruifm/gitlinker.nvim",
  event = "BufRead",
  dependencies = { "nvim-lua/plenary.nvim" },
}

function P.config()
  local gitlinker = require("gitlinker")

  gitlinker.setup({
    opts = { add_current_line_on_normal_mode = false },
  })

  require("my.mappings").gitlinker_mappings(gitlinker)
end

return P
