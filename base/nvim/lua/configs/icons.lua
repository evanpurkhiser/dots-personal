local M = {}

function M.setup()
  local icons = safe_require("nvim-web-devicons")
  if not icons then
    return
  end

  icons.set_icon({
    c = {
      icon = "",
      color = "#519aba",
      name = "c",
    },
    css = {
      icon = "",
      color = "#61afef",
      name = "css",
    },
    deb = {
      icon = "",
      color = "#a1b7ee",
      name = "deb",
    },
    Dockerfile = {
      icon = "",
      color = "#384d54",
      name = "Dockerfile",
    },
    html = {
      icon = "",
      color = "#de8c92",
      name = "html",
    },
    js = {
      icon = "",
      color = "#ebcb8b",
      name = "js",
    },
    kt = {
      icon = "󱈙",
      color = "#7bc99c",
      name = "kt",
    },
    lock = {
      icon = "",
      color = "#c4c720",
      name = "lock",
    },
    lua = {
      icon = "",
      color = "#51a0cf",
      name = "lua",
    },
    mp3 = {
      icon = "",
      color = "#d39ede",
      name = "mp3",
    },
    mp4 = {
      icon = "",
      color = "#9ea3de",
      name = "mp4",
    },
    out = {
      icon = "",
      color = "#abb2bf",
      name = "out",
    },
    py = {
      icon = "",
      color = "#a3b8ef",
      name = "py",
    },
    ["robots.txt"] = {
      icon = "ﮧ",
      color = "#abb2bf",
      name = "robots",
    },
    toml = {
      icon = "",
      color = "#39bf39",
      name = "toml",
    },
    ts = {
      icon = "",
      color = "#519aba",
      name = "ts",
    },
    ttf = {
      icon = "",
      color = "#abb2bf",
      name = "TrueTypeFont",
    },
    rb = {
      icon = "",
      color = "#ff75a0",
      name = "rb",
    },
    rpm = {
      icon = "",
      color = "#fca2aa",
      name = "rpm",
    },
    vue = {
      icon = "﵂",
      color = "#7bc99c",
      name = "vue",
    },
    woff = {
      icon = "",
      color = "#abb2bf",
      name = "WebOpenFontFormat",
    },
    woff2 = {
      icon = "",
      color = "#abb2bf",
      name = "WebOpenFontFormat2",
    },
    xz = {
      icon = "",
      color = "#f9d71c",
      name = "xz",
    },
    zip = {
      icon = "",
      color = "#f9d71c",
      name = "zip",
    },
    jsx = {
      icon = "ﰆ",
      color = "#519ab8",
      name = "jsx",
    },
    rust = {
      icon = "",
      color = "#dea584",
      name = "rs",
    },
    jpg = {
      icon = "",
      color = "#c882e7",
      name = "jpg",
    },
    png = {
      icon = "",
      color = "#c882e7",
      name = "png",
    },
    jpeg = {
      icon = "",
      color = "#c882e7",
      name = "jpeg",
    },
  })
end

return M
