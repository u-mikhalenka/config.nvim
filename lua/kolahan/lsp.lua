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

vim.lsp.config("angularls", {
    on_attach = function(client)
        -- HACK: Angular LS can trigger a duplicate rename popup.
        client.server_capabilities.renameProvider = false
    end,
})

vim.lsp.enable("cssls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("angularls")
vim.lsp.config("cspell_ls", {
    filetypes = {
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "html",
        "css",
        "scss",
        "lua",
        "markdown",
    },
})

-- vim.lsp.enable("cspell_ls")

-- Force-restart every active LSP client and reattach LSPs for listed file buffers.
local function restart_all_lsp()
    local clients = vim.lsp.get_clients()
    if #clients == 0 then
        vim.notify("No active LSP clients", vim.log.levels.INFO)
        return
    end

    for _, client in ipairs(clients) do
        client:stop(true)
    end

    local attempts = 0
    local function restart_when_stopped()
        attempts = attempts + 1

        if #vim.lsp.get_clients() > 0 and attempts < 10 then
            vim.defer_fn(restart_when_stopped, 100)
            return
        end

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if
                vim.api.nvim_buf_is_valid(buf)
                and vim.api.nvim_buf_is_loaded(buf)
                and vim.bo[buf].buflisted
                and vim.bo[buf].buftype == ""
                and vim.bo[buf].filetype ~= ""
            then
                vim.api.nvim_exec_autocmds("FileType", {
                    buffer = buf,
                    modeline = false,
                })
            end
        end

        vim.notify("Restarted all LSP clients", vim.log.levels.INFO)
    end

    restart_when_stopped()
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
        ghost_text = { enabled = true },
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
