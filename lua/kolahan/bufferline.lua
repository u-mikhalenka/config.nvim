vim.pack.add({
    { src = "https://github.com/akinsho/bufferline.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

local bufferline_enabled = false

vim.keymap.set("n", "<leader>ub", function()
    if not bufferline_enabled then
        vim.cmd("packadd bufferline")
        require("bufferline").setup({
            options = {
                mode = "buffers",
                diagnostics = "nvim_lsp",
                show_buffer_close_icons = false,
                show_close_icon = false,
                always_show_bufferline = true,
            },
        })
        bufferline_enabled = true
    else
        print("Bufferline already enabled (restart to disable)")
    end
end, { desc = "Show bufferline" })
