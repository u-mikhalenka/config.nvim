vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim" },
})

vim.g.disable_autoformat = false

require("conform").setup({
    formatters_by_ft = {
        html = { "prettier" },
        htmlangular = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
    },

    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end

        return {
            timeout_ms = 3000,
            lsp_format = "fallback",
        }
    end,
})

vim.keymap.set("n", "<leader>tf", function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat

    vim.notify(
        "Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled")
    )
end, {
    desc = "Toggle Format on Save",
})

vim.keymap.set("n", "<leader>tF", function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat

    vim.notify(
        "Format on save for buffer "
        .. (vim.b.disable_autoformat and "disabled" or "enabled")
    )
end, {
    desc = "Toggle Format on Save Buffer",
})
