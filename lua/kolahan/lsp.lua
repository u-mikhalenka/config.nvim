-- lazydev.nvim: better LuaLS support for Neovim config/plugins
vim.pack.add({
    { src = "https://github.com/folke/lazydev.nvim" },
    { src = "https://github.com/Saghen/blink.cmp" },
    { src = "https://github.com/saghen/blink.lib" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
})

require("mason").setup()
require("lazydev").setup({
    library = {

        -- Optional: always load Snacks types if you use Snacks a lot
        -- "snacks.nvim",
    },
})

vim.lsp.enable("cssls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("angularls")
vim.o.winborder = "single"

-- completion
local cmp = require("blink.cmp")
cmp.build():wait(60000)
cmp.setup({
    fuzzy = { implementation = "prefer_rust_with_warning" },
    completion = {
        menu = {
            draw = {
                columns = {
                    { "label",      "label_description", gap = 1 },
                    { "kind_icon",  "kind",              gap = 1 },
                    { "source_name" }
                },
                treesitter = { 'lsp' }
            }
        }
    },
})
