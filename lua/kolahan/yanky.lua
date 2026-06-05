local cfg = require('kolahan.utils.config');
local map = cfg.map;
cfg.pack_add({
    src = "https://github.com/gbprod/yanky.nvim",
    setup = function()
        require('yanky').setup({
            highlight = { timer = 250 },
        })
        map({ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" })
        map({ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" })
        map({ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" })
        map({ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" })
        map({ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" })
        map({ "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" })
        map({ "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" })
        map({ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" })
        map({ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" })
        map({ "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" })
        map({ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" })
        map({ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" })
        map({ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" })
        map({ ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" })
        map({ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" })
        map({ "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" })
        map({ "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" })


        map({ "n", "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Previous yank" })
        map({ "n", "<c-n>", "<Plug>(YankyNextEntry)", desc = "Next yank" })

        map({
            "<leader>p",
            function()
                Snacks.picker.yanky()
            end,
            mode = { "n", "x" },
            desc = "Open Yank History",

        })
    end
})
