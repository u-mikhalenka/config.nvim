local cfg = require('kolahan.utils.config');
local map = cfg.map;

vim.pack.add({
    { src = "https://github.com/rmagatti/auto-session" }
})

require("auto-session").setup({
    auto_restore = true,
    git_use_branch_name = true,
    purge_after_minutes = 14400
})

map({ "<leader>qs", "<cmd>AutoSession search<CR>", desc = "Select session" })
map({ "<leader>qS", "<cmd>AutoSession save<CR>", desc = "Save session" })
map({ "<leader>qA", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" })
