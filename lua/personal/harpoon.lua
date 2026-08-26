local cfg = require('personal.utils.config');

cfg.pack_add({
    src = "https://github.com/nvim-lua/plenary.nvim",
})

cfg.pack_add({
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2",
    setup = function()
        local harpoon = require("harpoon")
        harpoon.setup()
    end,
    keys = {
        { "<leader>ha", function() require("harpoon"):list():add() end,                                                  desc = "Harpoon add" },
        { "<leader>hl", function()
            local harpoon = require("harpoon"); harpoon.ui:toggle_quick_menu(harpoon:list())
        end,                                                                                                             desc = "Harpoon list" },
        { "<leader>h1", function() require("harpoon"):list():select(1) end,                                              desc = "Harpoon 1" },
        { "<leader>h2", function() require("harpoon"):list():select(2) end,                                              desc = "Harpoon 2" },
        { "<leader>h3", function() require("harpoon"):list():select(3) end,                                              desc = "Harpoon 3" },
        { "<leader>h4", function() require("harpoon"):list():select(4) end,                                              desc = "Harpoon 4" },
        { "<leader>hp", function() require("harpoon"):list():prev() end,                                                 desc = "Harpoon prev" },
        { "<leader>hn", function() require("harpoon"):list():next() end,                                                 desc = "Harpoon next" },
    },
})
