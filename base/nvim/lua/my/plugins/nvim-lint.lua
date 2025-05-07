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
