local M = {}

local opts = { noremap = true, silent = false }

-- Produces a function which defines key maps.
local make_map = function(mode)
  return function(conf)
    local cmd = conf[2]

    -- Support specifying a lua function
    if conf.fn then
      cmd = string.format('<cmd>lua require("my.mappings").fn.%s()<CR>', conf.fn)
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
  bmap = make_map(""),
}

return M
