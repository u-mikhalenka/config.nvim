vim.pack.add({
    { src = "https://github.com/folke/flash.nvim" },
})

local flash = require("flash")

flash.setup({})

vim.keymap.set({ "n", "x", "o" }, "s", function()
    flash.jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
    flash.treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("o", "r", function()
    flash.remote()
end, { desc = "Remote Flash" })

vim.keymap.set({ "o", "x" }, "R", function()
    flash.treesitter_search()
end, { desc = "Treesitter Search" })

vim.keymap.set("c", "<C-s>", function()
    flash.toggle()
end, { desc = "Toggle Flash Search" })

vim.keymap.set({ "n", "o", "x" }, "<C-Space>", function()
    flash.treesitter({
        actions = {
            ["<C-Space>"] = "next",
            ["<BS>"] = "prev",
        },
    })
end, { desc = "Treesitter Incremental Selection" })
