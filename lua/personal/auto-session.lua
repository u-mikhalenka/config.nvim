local cfg = require('personal.utils.config')

cfg.pack_add({
    src = "https://github.com/rmagatti/auto-session",
    setup = function()
        require("auto-session").setup({
            auto_restore = true,
            git_use_branch_name = true,
            purge_after_minutes = 14400,
        })
    end,
    keys = {
        { "<leader>qs", "<cmd>AutoSession search<CR>", desc = "Select session" },
        { "<leader>qS", "<cmd>AutoSession save<CR>",   desc = "Save session" },
        { "<leader>qA", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
    },
})
