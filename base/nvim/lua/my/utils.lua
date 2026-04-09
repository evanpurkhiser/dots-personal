local M = {}

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
