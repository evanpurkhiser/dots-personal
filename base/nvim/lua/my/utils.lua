local M = {}

local default_make_map_opts = { noremap = true, silent = false }

-- Produces a function which defines key maps.
local make_map = function(mode)
  return function(conf)
    local keybind = conf[1]
    local cmd = conf[2]

    local options = conf[3] or default_make_map_opts

    if conf.desc then
      options = vim.tbl_extend("force", options, { desc = conf.desc })
    end

    -- A lua funciton passed as the cmd argument goes into the callback
    if type(cmd) == "function" then
      options = vim.tbl_extend("force", options, { callback = cmd })
      cmd = ""
    end

    if conf.bufnr ~= nil then
      vim.api.nvim_buf_set_keymap(conf.bufnr, mode, keybind, cmd, options)
    else
      vim.api.nvim_set_keymap(mode, keybind, cmd, options)
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

function M.get_visual_selection()
  local curr_vreg = vim.fn.getreg("v")
  local curr_vreg_type = vim.fn.getregtype("v")
  vim.cmd('noau normal! "vy')

  local selection = vim.fn.getreg("v")
  vim.fn.setreg("v", curr_vreg, curr_vreg_type)

  return selection
end

return M
