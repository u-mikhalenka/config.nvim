vim.o.background = "light"

local hues = require("mini.hues")
local colors = require("mini.colors")

hues.setup({
    background = "#f7f7f7",
    foreground = "#303846",
    n_hues = 8,
    saturation = "high",
    accent = "bg",
    plugins = {
        default = true,
    },
    autoadjust = true,
})

local palette = hues.get_palette()
palette.red = "#aa3731"
palette.orange = "#f2af50"
palette.yellow = "#cb9000"
palette.green = "#448c27"
palette.cyan = "#00aacb"
palette.azure = "#007acc"
palette.blue = "#325cc0"
palette.purple = "#7a3e9d"
hues.apply_palette(palette)

local function hl(name, val)
    vim.api.nvim_set_hl(0, name, val)
end

local words_bg = colors.modify_channel(palette.bg, "lightness", function(l)
    return l - 6
end)
--
-- stylua: ignore start
hl("@variable.member", { fg = palette.purple })
hl("@keyword.return", { fg = palette.purple, bold = true })
hl("Identifier", { fg = palette.purple })
hl("Special", { fg = palette.red, bold = true })
hl("Delimiter", { fg = palette.red })

hl("LspReferenceText", { bg = words_bg })
hl("LspReferenceRead", { bg = words_bg })
hl("LspReferenceWrite", { bg = words_bg, bold = true })

-- Strong background for the active buffer.
hl("MiniTablineCurrent", {
    fg = palette.fg,
    bg = palette.bg_mid,
    bold = true,
})

-- A modified active buffer keeps the same active appearance.
hl("MiniTablineModifiedCurrent", {
    link = "MiniTablineCurrent",
})

-- Modification does not change inactive-buffer backgrounds.
hl("MiniTablineModifiedVisible", {
    link = "MiniTablineVisible",
})

hl("MiniTablineModifiedHidden", {
    link = "MiniTablineHidden",
})

hl("BlinkCmpMenu", { link = 'FloatBorder' })
hl("BlinkCmpMenuBorder", { link = 'FloatBorder' })


-- stylua: ignore end

vim.g.colors_name = "personal-light"
