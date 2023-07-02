vim.opt.directory = vim.fn.expand("$XDG_CACHE_HOME/nvim")

require("my.general").setup()
require("my.mappings").setup()
require("my.styles").setup()

require("my.lazy")
