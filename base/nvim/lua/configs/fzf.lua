local M = {}

local grep_ignored = {
  "static/dist/**/*",
  "CHANGES",
  "stats.json",
  "static/images/*",
  "static/images/**/*",
  "static/app/icons/*",
  "static/less/debugger*",
  "**/vendor/*",
  "**/migrations/*",
  "src/sentry/static/sentry/dist/**/*",
  "src/sentry/static/sentry/images/*",
  "src/sentry/static/sentry/images/**/*",
  "src/sentry/static/sentry/app/icons/*",
  "src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl",
  "src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl",
  "tests/js/**/*.snap",
  "tests/fixtures/*",
  "tests/fixtures/**/*",
  "tests/*/fixtures/*",
  "tests/**/fixtures/*",
  "tests/**/snapshots/**/*",
  "tests/sentry/lang/*/fixtures/*",
  "tests/sentry/lang/**/*.map",
  "tests/sentry/grouping/**/*",
  "tests/sentry/db/*",
  "src/sentry/locale/**/*",
  "src/sentry/data/**/*",
}

grep_ignored.toString = function(self)
  local str = ""
  for _, pattern in ipairs(self) do
    str = str .. string.format('-g "!%s" ', pattern)
  end
  return str
end

function M.setup()
  local fzf = safe_require("fzf-lua")
  if not fzf then
    return
  end

  fzf.setup({
    winopts = {
      height = 0.6,
      width = 0.95,

      preview = {
        title = false,
        scrollbar = false,
        horizontal = "right:40%",
      },
      hl = {
        border = "FloatBorder",
      },
    },

    fzf_opts = {
      ["--prompt"] = "›",
      ["--pointer"] = "›",
      ["--marker"] = "›",
    },

    files = { prompt = "files › " },

    git = {
      files = { prompt = "tree › " },
    },

    grep = {
      prompt = "lines › ",
      winopts = {
        height = 0.95,
        width = 0.98,
        preview = { layout = "vertical", vertical = "up:30%" },
      },
      rg_opts = fzf.config.globals.grep.rg_opts .. " " .. grep_ignored:toString(),
    },
  })
end

return M
