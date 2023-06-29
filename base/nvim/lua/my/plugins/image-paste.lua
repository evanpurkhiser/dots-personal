local P = {
  "evanpurkhiser/image-paste.nvim",
}

function P.config()
  local imagePaste = require("image-paste")

  imagePaste.setup({ imgur_client_id = "77748a048c5f8ce" })

  require("my.mappings").image_paste_mapping(imagePaste)
end

return P
