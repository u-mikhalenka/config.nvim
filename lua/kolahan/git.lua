vim.pack.add({
    { src = "https://github.com/sindrets/diffview.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" }
})

vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", {
    desc = "Git diff working tree",
})

vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen HEAD~1..HEAD<cr>", {
    desc = "Git diff last commit",
})

vim.keymap.set("n", "<leader>gm", "<cmd>DiffviewOpen origin/main...HEAD<cr>", {
    desc = "Git diff against main",
})

vim.keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", {
    desc = "Git file history",
})

vim.keymap.set("n", "<leader>gR", "<cmd>DiffviewFileHistory<cr>", {
    desc = "Git repo history",
})

vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", {
    desc = "Close diff view",
})


-- gitsigns
require('gitsigns').setup({
    on_attach = function(bufnr)
        require("which-key").add({
            { "<leader>gh", group = "Hunks", buffer = bufnr },
        })

        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gitsigns.nav_hunk('next')
            end
        end, { desc = "Next git hunk" })

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gitsigns.nav_hunk('prev')
            end
        end, { desc = "Previous git hunk" })

        -- Actions
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = "Stage hunk" })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = "Reset hunk" })

        map('v', '<leader>ghs', function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "Stage selected hunk" })

        map('v', '<leader>ghr', function()
            gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "Reset selected hunk" })

        map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = "Stage buffer" })
        map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = "Reset buffer" })
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = "Preview hunk" })
        map('n', '<leader>ghi', gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

        map('n', '<leader>ghb', function()
            gitsigns.blame_line({ full = true })
        end, { desc = "Blame line" })

        map('n', '<leader>ghB', gitsigns.blame, { desc = "Git blame buffer" })


        map('n', '<leader>ghd', gitsigns.diffthis, { desc = "Diff this file" })

        map('n', '<leader>ghD', function()
            gitsigns.diffthis('~')
        end, { desc = "Diff this file against HEAD" })

        map('n', '<leader>ghQ', function() gitsigns.setqflist('all') end, { desc = "Send all hunks to quickfix" })
        map('n', '<leader>ghq', gitsigns.setqflist, { desc = "Send hunks to quickfix" })

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Toggle git blame line" })
        map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "Toggle git word diff" })

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = "Select git hunk" })
    end
})
