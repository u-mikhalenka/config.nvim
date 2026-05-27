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
        "snacks.nvim",
    },
})

vim.lsp.enable("cssls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("angularls")

local function restart_all_lsp()
    local clients = vim.lsp.get_clients()
    if #clients == 0 then
        vim.notify("No active LSP clients", vim.log.levels.INFO)
        return
    end

    for _, client in ipairs(clients) do
        client:stop(true)
    end

    vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf)
                and vim.bo[buf].buflisted
                and vim.bo[buf].buftype == ""
            then
                vim.api.nvim_exec_autocmds("FileType", {
                    buffer = buf,
                    modeline = false,
                })
            end
        end

        vim.notify("Restarted all LSP clients", vim.log.levels.INFO)
    end, 200)
end

vim.api.nvim_create_user_command("LspRestartAll", restart_all_lsp, {
    desc = "Restart all LSP clients for all listed buffers",
})

-- completion
local cmp = require("blink.cmp")
cmp.build():wait(60000)
cmp.setup({
    snippets = { preset = "luasnip" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    completion = {
        trigger = {
            show_on_keyword = true,
        },
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
