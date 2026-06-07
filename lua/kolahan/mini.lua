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

cfg.pack_add({
    src = "https://github.com/dmtrKovalenko/fff.nvim",
    setup = function()
        vim.api.nvim_create_autocmd('PackChanged', {
            callback = function(ev)
                local name, kind = ev.data.spec.name, ev.data.kind
                if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
                    if not ev.data.active then vim.cmd.packadd('fff.nvim') end
                    require('fff.download').download_or_build_binary()
                end
            end,
        })

        map({ "<leader>af", function() require('fff').find_files() end, desc = 'FFFind files' })
        map({ "<leader>ag", function() require('fff').live_grep() end, desc = 'LiFFFe grep' })
        map({
            "<leader>az",
            function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end,
            desc = 'Live fffuzy grep',
        })
    end,
})
