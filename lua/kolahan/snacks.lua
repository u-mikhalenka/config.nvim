vim.pack.add({
    { src = 'https://github.com/folke/snacks.nvim' }
})

local function term_nav(dir)
    ---@param self snacks.terminal
    return function(self)
        return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
            vim.cmd.wincmd(dir)
        end)
    end
end

require('snacks').setup({
    animate = { enabled = false },
    picker = { enabled = true },
    explorer = { enabled = true },
    notifier = { enabled = true },
    indent = { enabled = false, animate = { enabled = false } },
    input = { enabled = true },
    quickfile = { enabled = true },
    bigfile = { enabled = true },
    statuscolumn = { enabled = true },
    image = { enabled = true },
    terminal = {
        enabled = true,
        win = {
            keys = {
                nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
                nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
                nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
                nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
            }
        }
    }
})

vim.keymap.set("n", "<leader>.", function()
    Snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })

vim.keymap.set("n", "<leader>S", function()
    Snacks.picker.scratch()
end, { desc = "Select Scratch Buffer" })

vim.keymap.set("n", "<leader><space>", function()
    Snacks.picker.smart({
        filter = { cwd = true }
    })
end, { desc = "Smart Find Files" })

vim.keymap.set("n", "<leader>bb", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>/", function()
    Snacks.picker.grep()
end, { desc = "Grep" })

vim.keymap.set("n", "<leader>e", function()
    Snacks.explorer()
end, { desc = "File Explorer" })

vim.keymap.set("n", "<leader>ff", function()
    Snacks.picker.files()
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fg", function()
    Snacks.picker.git_files()
end, { desc = "Find Git Files" })

vim.keymap.set("n", "<leader>n", function()
    Snacks.notifier.show_history()
end, { desc = "Notification History" })

vim.keymap.set("n", "<leader>bd", function()
    Snacks.bufdelete()
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<leader>bo", function()
    Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })

vim.keymap.set({ "n", "t" }, "<c-/>", function()
    Snacks.terminal()
end, { desc = "Toggle Terminal" })

-- lsp mappings
vim.keymap.set("n", "gd", function()
    Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })

vim.keymap.set("n", "gr", function()
    Snacks.picker.lsp_references({
        unique_lines = true,
        focus = "list",
        transform = function(item, ctx)
            ctx.meta.seen = ctx.meta.seen or {}

            local id = table.concat({
                item.file or "",
                item.pos and item.pos[1] or 0,
                item.pos and item.pos[2] or 0,
                item.end_pos and item.end_pos[1] or 0,
                item.end_pos and item.end_pos[2] or 0,
            }, ":")

            if ctx.meta.seen[id] then
                return false
            end
            ctx.meta.seen[id] = true
            return item
        end,
    })
end, { desc = "References", nowait = true })

vim.keymap.set("n", "gI", function()
    Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })

vim.keymap.set("n", "gy", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Goto Type Definition" })

vim.keymap.set("n", "<leader>uC", function()
    Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })

vim.keymap.set("n", "<leader>sk", function()
    Snacks.picker.keymaps()
end, { desc = "Keymap" })

-- search/search

vim.keymap.set("n", "<leader>sh", function()
    Snacks.picker.help()
end, { desc = "Help" })

vim.keymap.set("n", "<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "Recent Files" })

vim.keymap.set("n", "<leader>fp", function()
    Snacks.picker.projects()
end, { desc = "Projects" })

vim.keymap.set({ "n", "x" }, "<leader>sw", function()
    Snacks.picker.grep_word()
end, { desc = "Search Word" })

vim.keymap.set("n", "<leader>ss", function()
    Snacks.picker.lsp_symbols()
end, { desc = "Document Symbols" })

vim.keymap.set("n", "<leader>sS", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })

vim.keymap.set("n", "<leader>fR", function()
    Snacks.picker.resume()
end, { desc = "Resume Picker" })
