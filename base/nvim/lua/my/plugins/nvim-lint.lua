---@module "lazy"

---@type LazySpec
local P = {
  "mfussenegger/nvim-lint",
}

function P.config()
  local lint = require("lint")

  local jslint = {
    "eslint_d",
    "stylelint",
  }

  lint.linters_by_ft = {
    javascript = jslint,
    javascriptreact = jslint,
    typescript = jslint,
    typescriptreact = jslint,
    bash = { "shellcheck" },
    python = { "mypy", "flake8" },
    json = { "jsonlint" },
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
