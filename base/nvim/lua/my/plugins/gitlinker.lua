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

  local function normal()
    gitlinker.get_buf_range_url("n")
  end

  local function visual()
    gitlinker.get_buf_range_url("v")
  end

  require("my.mappings").gitlinker_mappings({ normal = normal, visual = visual })
end

return P
