local P = {
  "ibhagwan/fzf-lua",
}

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

function grep_ignored.toString(self)
  local str = ""
  for _, pattern in ipairs(self) do
    str = str .. string.format('-g "!%s" ', pattern)
  end
  return str
end

-- Exported for use in other configs
local winopts_bottom = {
  height = 0.3,
  width = 1,
  row = 1,
  col = 0,
  border = { "", "─", "", "", "", "", "", "" },
  preview = { horizontal = "right:50%" },
}

function P.config()
  local fzf = require("fzf-lua")

  fzf.setup({
    winopts = {
      height = 0.6,
      width = 0.8,
      border = { " ", " ", " ", " ", " ", " ", " ", " " },

      preview = {
        title = false,
        scrollbar = false,
        horizontal = "right:40%",
      },
      hl = {
        normal = "NormalFloat",
        border = "NormalFloat",
      },
    },

    fzf_opts = {
      ["--prompt"] = "›",
      ["--pointer"] = "›",
      ["--marker"] = "›",
    },

    actions = {
      files = {
        ["default"] = fzf.actions.file_edit,
        ["ctrl-s"] = fzf.actions.file_split,
        ["ctrl-v"] = fzf.actions.file_vsplit,
        ["alt-q"] = fzf.actions.file_sel_to_qf,
      },
    },

    files = {
      previewer = false,
      prompt = "files › ",
    },

    git = {
      files = {
        previewer = false,
        prompt = "tree › ",
        cmd = "git ls-files --exclude-standard --cached --other",
      },
    },

    grep = {
      prompt = "lines › ",
      winopts = {
        height = 0.95,
        width = 0.98,
        preview = { layout = "vertical", vertical = "up:30%" },
      },
      rg_opts = grep_ignored:toString() .. " " .. fzf.config.globals.grep.rg_opts,
    },

    nvim = {
      command_history = {
        prompt = "command history › ",
        winopts = winopts_bottom,
        fzf_opts = {
          ["--tiebreak"] = "index",
          ["--layout"] = "default",
        },
      },
    },
  })

  -- Load fzf mappings
  require("my.mappings").fzf_mapping(fzf)
end

return P
