local P = {
  "windwp/nvim-ts-autotag",
  dependency = { "nvim-treesitter" },
  event = "BufRead",
}

function P.config()
  require("nvim-ts-autotag").setup()

  -- Ensure we attach to the buffer which loaded the plugin
  require("nvim-ts-autotag.internal").attach()
end

return P
