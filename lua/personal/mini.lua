local cfg = require('personal.utils.config');

local function setup_clue()
    if true then return end

    local miniclue = require('mini.clue')
    miniclue.enable_all_triggers()
    miniclue.setup({
        window = {
            delay = 200,
            config = {
                width = 'auto',
            },
        },
        triggers = {
            -- Leader triggers
            { mode = { 'n', 'x' }, keys = '<Leader>' },

            -- `[` and `]` keys
            { mode = 'n',          keys = '[' },
            { mode = 'n',          keys = ']' },

            -- Built-in completion
            { mode = 'i',          keys = '<C-x>' },

            -- `g` key
            { mode = { 'n', 'x' }, keys = 'g' },

            -- Marks
            { mode = { 'n', 'x' }, keys = "'" },
            { mode = { 'n', 'x' }, keys = '`' },

            -- Registers
            { mode = { 'n', 'x' }, keys = '"' },
            { mode = { 'i', 'c' }, keys = '<C-r>' },

            -- Window commands
            { mode = 'n',          keys = '<C-w>' },

            -- `z` key
            { mode = { 'n', 'x' }, keys = 'z' },
        },

        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
            miniclue.gen_clues.square_brackets(),
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows({
                submode_move = true,
                submode_navigate = true,
                submode_resize = true,
            }),
            miniclue.gen_clues.z(),

            -- { mode = "n", keys = "gs",            desc = "Surround" },
            { mode = "n", keys = "<leader>t",     desc = "Toggles" },
            { mode = "n", keys = "<leader>c",     desc = "Code" },
            { mode = "n", keys = "<leader>f",     desc = "File/find" },
            { mode = "n", keys = "<leader>s",     desc = "Search" },
            { mode = "n", keys = "<leader>d",     desc = "Git" },
            { mode = "n", keys = "<leader>p",     desc = "Project" },
            { mode = "n", keys = "<leader>b",     desc = "Buffers" },
            { mode = "n", keys = "<leader>u",     desc = "UI" },
            { mode = "n", keys = "<leader>w",     desc = "Windows" },
            { mode = "n", keys = "<leader><Tab>", desc = "Tabs" },
            { mode = "n", keys = "<leader>y",     desc = "Yank" },
            { mode = "n", keys = "<leader>a",     desc = "FFF" },
            { mode = "n", keys = "<leader>q",     desc = "Sessions" },
            { mode = "n", keys = "<leader>g",     desc = "Git" },
            { mode = "n", keys = "<leader>gh",    desc = "Hunks" },
            { mode = "n", keys = "<leader>h",     desc = "Harpoon" },
            { mode = "n", keys = "<leader>x",     desc = "Trouble" },
        },
    })
end

cfg.pack_add({
    src = "https://github.com/nvim-mini/mini.nvim",
    setup = function()
        require("mini.ai").setup()
        require("mini.align").setup({
            mappings = {
                start              = '<leader>cl',
                start_with_preview = '<leader>cL',
            },
        })
        require("mini.pairs").setup()
        require('mini.icons').setup()
        require("mini.files").setup(require("shared.mini_files").get_options())
        require("mini.pick").setup()
        require("mini.extra").setup()
        if false then
            require("mini.tabline").setup(require("shared.mini_tabline").get_options())
        end


        if false then
            local sl = require("shared.mini_statusline")
            require("mini.statusline").setup(sl.get_options())
            sl.init()
        end

        setup_clue()
    end,
    keys = {
        {
            "<leader>e",
            function()
                local path = vim.api.nvim_buf_get_name(0)

                if path == "" then
                    path = vim.uv.cwd() or ""
                end

                require("mini.files").open(path)
            end,
            desc = "Open files"
        }
    }
})
