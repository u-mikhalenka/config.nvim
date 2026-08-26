local cfg = require('personal.utils.config')

cfg.pack_add({
    src = "https://github.com/L3MON4D3/LuaSnip",
    on_pack_changed = function(ev)
        if ev.data.kind == "install" or ev.data.kind == "update" then
            vim.system({ "make", "install_jsregexp" }, {
                cwd = ev.data.path,
            })
        end
    end,
    setup = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("shared.snippets").setup()
    end,
})

cfg.pack_add({
    src = "https://github.com/rafamadriz/friendly-snippets",
})
