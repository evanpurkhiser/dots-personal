local P = {
  "windwp/nvim-ts-autotag",
  dependency = { "nvim-treesitter" },
  event = "BufRead",
}

function P.config()
  require("nvim-ts-autotag").setup()
end

return P
