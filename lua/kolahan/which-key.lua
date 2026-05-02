vim.pack.add({
    { src = 'https://github.com/folke/which-key.nvim' },
})

local wk = require("which-key")
wk.setup({})
wk.add({
    { "<leader>c", group = "Code" },
    { "<leader>f", group = "Find" },
    { "<leader>s", group = "Search" },
    { "<leader>g", group = "Git" },
    { "<leader>p", group = "Project" },
    { "<leader>b", group = "Buffers" },
    { "<leader>u", group = "UI" },
})
