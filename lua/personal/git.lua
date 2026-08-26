local cfg = require('personal.utils.config')

cfg.pack_add({
    enabled = true,
    src = "https://github.com/sindrets/diffview.nvim",
    setup = function()
        local diffview_actions = require("diffview.actions")
        local diffview_fold_descriptions = {
            za = "Toggle fold",
            zA = "Toggle folds recursively",
            ze = "Scroll cursor to screen end",
            zE = "Eliminate all folds",
            zo = "Open fold",
            zc = "Close fold",
            zO = "Open folds recursively",
            zC = "Close folds recursively",
            zr = "Reduce fold level",
            zm = "Increase fold level",
            zR = "Open all folds",
            zM = "Close all folds",
            zv = "Open folds for cursor line",
            zx = "Update folds",
            zX = "Update folds and close",
            zn = "Disable folding",
            zN = "Enable folding",
            zi = "Toggle folding",
        }

        local diffview_fold_keymaps = vim.tbl_map(function(mapping)
            return {
                mapping[1],
                mapping[2],
                mapping[3],
                { desc = diffview_fold_descriptions[mapping[2]] },
            }
        end, diffview_actions.compat.fold_cmds)

        require("diffview").setup({
            hooks = {
                diff_buf_win_enter = function()
                    vim.cmd("normal! zR")
                end,
            },
            keymaps = {
                view = diffview_fold_keymaps,
            },
        })
    end,
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>",              desc = "Git diff working tree" },
        { "<leader>gD", "<cmd>DiffviewOpen HEAD~1..HEAD<cr>", desc = "Git diff last commit" },
        { "<leader>gm", "<cmd>DiffviewOpen main<cr>",         desc = "Git diff against main" },
        { "<leader>gM", "<cmd>DiffviewOpen master<cr>",       desc = "Git diff against master" },
        { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>",     desc = "Git file history" },
        { "<leader>gR", "<cmd>DiffviewFileHistory<cr>",       desc = "Git repo history" },
        { "<leader>gq", "<cmd>DiffviewClose<cr>",             desc = "Close diff view" },
    }
})

cfg.pack_add({
    enabled = false,
    src = "https://github.com/esmuellert/codediff.nvim",
    keys = {
        { "<leader>gd", "<cmd>CodeDiff<cr>",              desc = "Git diff working tree" },
        { "<leader>gD", "<cmd>CodeDiff HEAD~1..HEAD<cr>", desc = "Git diff last commit" },
        { "<leader>gm", "<cmd>CodeDiff master<cr>",       desc = "Git diff against master" },
        { "<leader>gM", "<cmd>CodeDiff main<cr>",         desc = "Git diff against main" },
    }
})

cfg.pack_add({
    src = "https://github.com/nvim-lua/plenary.nvim",
})

-- gitsigns
cfg.pack_add({
    src = "https://github.com/lewis6991/gitsigns.nvim",
    setup = function()
        require('gitsigns').setup({
            on_attach = function(bufnr)
                local ok, wk = pcall(require, "which-key")
                if ok then
                    wk.add({
                        { "<leader>gh", group = "Hunks", buffer = bufnr },
                    })
                end

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
    end,
})

-- neogit
cfg.pack_add({
    src = "https://github.com/neogitorg/neogit",
    setup = function()
        require("neogit").setup({})
    end,
    keys = {
        { "<leader>gg", function() require("neogit").open() end, desc = "Open Neogit UI" },
    },
})
