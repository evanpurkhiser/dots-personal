local M = {}

function M.setup()
  local imagePaste = require("substitute")

  imagePaste.setup({ imgur_client_id = "77748a048c5f8ce" })

  -- Load mappings
  require("my.mappings").image_paste_mapping()
end

return M
