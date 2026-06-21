local cfg = require("kolahan.utils.config")
local map = cfg.map

cfg.pack_add({
    src = 'https://github.com/folke/which-key.nvim',
    enabled = true,
    setup = function()
        local wk = require("which-key")
        wk.setup({ preset = "helix" })
        wk.add({
            { "<leader>t",     group = "Toggles" },
            { "<leader>c",     group = "Code" },
            { "<leader>f",     group = "File/find" },
            { "<leader>s",     group = "Search" },
            { "<leader>g",     group = "Git" },
            { "<leader>b",     group = "Buffers" },
            { "<leader>u",     group = "UI" },
            { "<leader>w",     group = "Windows" },
            { "<leader>y",     group = "Yank" },
            { "<leader>a",     group = "FFF" },
            { "<leader><Tab>", group = "Tabs" },
            { "<leader>h",     group = "Harpoon" },
        })
        map({
            "<c-w><space>",
            function()
                require("which-key").show({ keys = "<c-w>", loop = true })
            end,
            desc = "Window Hydra Mode (which-key)",
        })
    end
})
