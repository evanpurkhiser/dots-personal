local M = {}

---@type vim.api.keyset.keymap
local default_make_map_opts = {
  noremap = true,
  silent = false,
}

---@class KeybindConfig
---@field [1] string lhs keybinding
---@field [2] function | string The function or rhs to trigger
---@field bufnr? number The buffer number to attach the binding to
---@field desc? number The buffer number to attach the binding to
---@field otps? vim.api.keyset.keymap Additional options

---@alias KeybindMap fun(conf: KeybindConfig)

--- Produces a function which defines key maps.
---@param mode string
---@return KeybindMap
local make_map = function(mode)
  return function(conf)
    local keybind = conf[1]
    local cmd = conf[2]

    ---@type vim.api.keyset.keymap
    local options = conf[3] or default_make_map_opts

    if conf.desc then
      options = vim.tbl_extend("force", options, { desc = conf.desc })
    end

    -- A lua function passed as the cmd argument goes into the callback
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
  omap = make_map("o"),
  bmap = make_map(""),
}

---Get's the currently visually selected text
---@return string
function M.get_visual_selection()
  local curr_vreg = vim.fn.getreg("v")
  local curr_vreg_type = vim.fn.getregtype("v")
  vim.cmd('noau normal! "vy')

  local selection = vim.fn.getreg("v")
  vim.fn.setreg("v", curr_vreg, curr_vreg_type)

  return selection
end

function M.get_buffer_list()
  local buffers = {}

  for buffer = 1, vim.fn.bufnr("$") do
    local is_listed = vim.fn.buflisted(buffer) == 1
    if is_listed then
      table.insert(buffers, buffer)
    end
  end

  return buffers
end

---Removes leading whitespace from the array of lines. Ignores lines that are
---only whitespace. Does not handle mixed tabs / spaces.
---@param lines string[]
---@return string[]
function M.trim_leading_whitespace(lines)
  local min_indent = math.huge
  for _, line in ipairs(lines) do
    -- Ignore blank lines
    if line:match("^%s*$") == nil then
      min_indent = math.min(min_indent, #line:match("^%s*"))
    end
  end

  local trimmed = {}
  for _, line in ipairs(lines) do
    table.insert(trimmed, line:sub(min_indent + 1))
  end

  return trimmed
end

return M
