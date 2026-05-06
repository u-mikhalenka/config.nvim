vim.pack.add({
    { src = 'https://github.com/folke/which-key.nvim' },
})

local wk = require("which-key")
wk.setup({ preset = "modern" })
wk.add({
    { "<leader>t", group = "Toggles" },
    { "<leader>c", group = "Code" },
    { "<leader>f", group = "File/find" },
    { "<leader>s", group = "Search" },
    { "<leader>g", group = "Git" },
    { "<leader>p", group = "Project" },
    { "<leader>b", group = "Buffers" },
    { "<leader>u", group = "UI" },
    { "<leader>w", group = "Windows" },
})
