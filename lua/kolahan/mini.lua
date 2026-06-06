local cfg = require('kolahan.utils.config');
local map = cfg.map

cfg.pack_add({
    src = "https://github.com/nvim-mini/mini.nvim",
    setup = function()
        require("mini.pairs").setup({})
        require('mini.icons').setup({})
        require("mini.files").setup({
            windows = {
                preview = true,
                width_preview = 80
            }
        })
        require("mini.pick").setup({})

        map({
            "<leader>e",
            function()
                local path = vim.api.nvim_buf_get_name(0)

                if path == "" then
                    path = vim.uv.cwd() or ""
                end

                require("mini.files").open(path)
            end,
            desc = "Open files"
        });
    end
})
