vim.opt.directory = vim.fn.expand("$XDG_CACHE_HOME/nvim")

function _G.safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify(string.format("Error requiring: %s", module), vim.log.levels.ERROR)
    return ok
  end
  return result
end

require("my.plugins")
require("my.general")
require("my.mappings")
