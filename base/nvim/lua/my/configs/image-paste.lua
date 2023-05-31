local M = {}

function M.setup()
  local imagePaste = safe_require("substitute")
  if not imagePaste then
    return
  end

  imagePaste.setup({ imgur_client_id = "77748a048c5f8ce" })

  -- Load mappings
  require("my.mappings").image_paste_mapping()
end

return M
