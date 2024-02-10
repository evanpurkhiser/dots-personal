local P = {
  "numtostr/comment.nvim",
}

function P.config()
  require("Comment").setup()
end

return P
