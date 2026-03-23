---@module "lazy"

---@type LazySpec
local P = {
  "mfussenegger/nvim-lint",
}

function P.config()
  local lint = require("lint")

  local function available_linters(names)
    return vim.tbl_filter(function(name)
      local linter = lint.linters[name]
      if not linter then
        return false
      end

      local cmd = linter.cmd
      if type(cmd) == "function" then
        cmd = cmd()
      end

      return type(cmd) == "string" and vim.fn.executable(cmd) == 1
    end, names)
  end

  local jslint = available_linters({
    "oxlint",
  })

  local pylint = available_linters({
    "ruff",
    "mypy",
  })

  local bashlint = available_linters({
    "shellcheck",
  })

  local jsonlint = available_linters({
    "jsonlint",
  })

  lint.linters_by_ft = {
    javascript = jslint,
    javascriptreact = jslint,
    typescript = jslint,
    typescriptreact = jslint,
    bash = bashlint,
    python = pylint,
    json = jsonlint,
  }

  -- Add config mapping for codespell
  local codespell_config = vim.fn.expand("$XDG_CONFIG_HOME/codespell/")
  lint.linters.codespell.args = vim.list_extend({
    "--config=" .. codespell_config .. "config.cfg",
    "--ignore-words=" .. codespell_config .. "ignore.txt",
  }, lint.linters.codespell.args)

  vim.api.nvim_create_autocmd(
    { "BufEnter", "BufWritePost", "InsertLeave", "TextChanged", "TextChangedI" },
    {
      callback = function()
        lint.try_lint()
        lint.try_lint("codespell")
      end,
    }
  )
end

return P
