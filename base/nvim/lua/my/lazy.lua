-- Ensure lazy plugin manager is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin specs
require("lazy").setup("my.plugins", {
  change_detection = {
    -- Don't use change detection, it doesn't do a great job reloading the
    -- plugin config.
    enabled = false,
  },
})
