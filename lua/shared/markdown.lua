local M = {}

M.setup = function()
    local group = vim.api.nvim_create_augroup("personal_markdown_spell", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "markdown", "text", "gitcommit" },
        callback = function()
            vim.opt_local.spell = true
            vim.opt_local.spelllang = { "en_us", "pt_pt", "ru" }
        end,
    })
end

return M
