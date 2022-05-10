local M = {}

local opts = { noremap = true, silent = false }

local map_fn_index = 0
M.map_fns = {}

-- Produces a function which defines key maps.
local make_map = function(mode)
  return function(conf)
    local cmd = conf[2]

    -- the `fn` conf may be used
    if conf.fn then
      cmd = conf.fn
    end

    -- Support specifying a lua function
    if type(cmd) == "function" then
      M.map_fns[map_fn_index] = cmd

      cmd = string.format('<cmd>lua require("my.utils").map_fns[%s]()<CR>', map_fn_index)
      map_fn_index = map_fn_index + 1
    end

    if conf.bufnr ~= nil then
      vim.api.nvim_buf_set_keymap(conf.bufnr, mode, conf[1], cmd, conf[3] or opts)
    else
      vim.api.nvim_set_keymap(mode, conf[1], cmd, conf[3] or opts)
    end
  end
end

M.map = {
  nmap = make_map("n"),
  imap = make_map("i"),
  vmap = make_map("v"),
  cmap = make_map("c"),
  bmap = make_map(""),
}

return M
