vim.pack.add({
    { src = "https://github.com/akinsho/bufferline.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

-- local bufferline_enabled = false
--
-- vim.keymap.set("n", "<leader>ub", function()
--     if not bufferline_enabled then
--         vim.cmd("packadd bufferline")
--         require("bufferline").setup({
--             options = {
--                 mode = "buffers",
--                 diagnostics = "nvim_lsp",
--                 show_buffer_close_icons = false,
--                 show_close_icon = false,
--                 always_show_bufferline = true,
--             },
--         })
--         bufferline_enabled = true
--     else
--         print("Bufferline already enabled (restart to disable)")
--     end
-- end, { desc = "Show bufferline" })

require("bufferline").setup({
    options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        close_command = function(n) Snacks.bufdelete(n) end,
    },
})

vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
vim.keymap.set("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right" })
vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[B", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer prev" })
vim.keymap.set("n", "]B", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer next" })
vim.keymap.set("n", "<leader>bj", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })
