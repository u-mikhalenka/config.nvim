vim.keymap.set("n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>", {
    desc = "Redraw / Clear hlsearch / Diff Update",
})

vim.keymap.set({ "i", "n", "s" }, "<Esc>", function()
    vim.cmd("nohlsearch")
    return "<Esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "Directory listing" })
vim.keymap.set("n", "<leader>uu", "<cmd>Undotree<cr>", { desc = "Undo tree" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without overwriting clipboard" })

local yank = require("kolahan.utils.yank")
vim.keymap.set('n', '<leader>ya', function()
    yank.yank_path(yank.get_buffer_absolute(), 'absolute')
end, { desc = '[Y]ank [A]bsolute path to clipboard' })

vim.keymap.set('n', '<leader>yr', function()
    yank.yank_path(yank.get_buffer_cwd_relative(), 'relative')
end, { desc = '[Y]ank [R]elative path to clipboard' })

vim.keymap.set('v', '<leader>ya', function()
    yank.yank_visual_with_path(yank.get_buffer_absolute(), 'absolute')
end, { desc = '[Y]ank selection with [A]bsolute path' })

vim.keymap.set('v', '<leader>yr', function()
    yank.yank_visual_with_path(yank.get_buffer_cwd_relative(), 'relative')
end, { desc = '[Y]ank selection with [R]elative path' })

vim.keymap.set("n", "<leader>yy", "\"+y", { desc = "[Y]ank to s[y]stem clipboard" })
vim.keymap.set("v", "<leader>yy", "\"+y", { desc = "[Y]ank to s[y]stem clipboard" })
vim.keymap.set("n", "<leader>YY", "\"+Y", { desc = "[Y]ank to s[y]stem clipboard" })

vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
    })
end, { desc = "Format" })

vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
    desc = "Code Action",
})

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {
    desc = "Rename",
})

-- Buffer navigation
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })

vim.keymap.set("i", "<C-Space>", function()
    local ok, blink = pcall(require, "blink.cmp")

    if ok then
        blink.show()
    else
        -- fallback to native LSP completion
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true),
            "n",
            true
        )
    end
end, { desc = "Trigger completion" })

vim.keymap.set("n", "<leader>ch", vim.lsp.buf.signature_help, {
    desc = "Signature Help",
})

-- Windows
vim.keymap.set("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go down window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go up window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go right window" })

-- Tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
