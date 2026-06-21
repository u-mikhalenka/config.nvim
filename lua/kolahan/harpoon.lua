vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" }
})

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED


vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add" })
vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon list" })

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon next" })
