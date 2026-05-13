vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "LuaSnip"
            and (ev.data.kind == "install" or ev.data.kind == "update") then
            vim.system({ "make", "install_jsregexp" }, {
                cwd = ev.data.path,
            })
        end
    end,
})

vim.pack.add({
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" }
})

local ls = require("luasnip")

for _, filetype in ipairs({
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "html",
    "htmlangular",
}) do
    ls.filetype_extend(filetype, { "angular" })
end

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
