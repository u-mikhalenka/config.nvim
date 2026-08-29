vim.o.background = "dark"

local hues = require("mini.hues")
local colors = require("mini.colors")

hues.setup({
  background = "#1f2428",
  foreground = "#c9d1d9",
  n_hues = 8,
  saturation = "high",
  accent = "bg",
  plugins = {
    default = true,
  },
  autoadjust = true,
})

local palette = hues.get_palette()
palette.red = "#f85149"
palette.orange = "#d29922"
palette.yellow = "#e3b341"
palette.green = "#3fb950"
palette.cyan = "#39c5cf"
palette.azure = "#79c0ff"
palette.blue = "#58a6ff"
palette.purple = "#bc8cff"
hues.apply_palette(palette)

local function hl(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

local words_bg = colors.modify_channel(palette.bg, "lightness", function(l)
  return l + 6
end)

-- stylua: ignore start
hl("@variable.member", { fg = palette.purple })
hl("@keyword.return", { fg = palette.purple, bold = true })
hl("Identifier", { fg = palette.purple })
hl("Special", { fg = palette.red, bold = true })
hl("Delimiter", { fg = palette.red })

hl("LspReferenceText", { bg = words_bg })
hl("LspReferenceRead", { bg = words_bg })
hl("LspReferenceWrite", { bg = words_bg, bold = true })

-- hl("MiniTablineCurrent", {
--     fg = palette.fg,
--     bg = palette.bg_mid,
--     bold = true,
-- })
--
-- hl("MiniTablineModifiedCurrent", {
--     link = "MiniTablineCurrent",
-- })
--
-- hl("MiniTablineModifiedVisible", {
--     link = "MiniTablineVisible",
-- })
--
-- hl("MiniTablineModifiedHidden", {
--     link = "MiniTablineHidden",
-- })

hl("BlinkCmpMenu", { link = "FloatBorder" })
hl("BlinkCmpMenuBorder", { link = "FloatBorder" })
-- stylua: ignore end

vim.g.colors_name = "personal-dark"
