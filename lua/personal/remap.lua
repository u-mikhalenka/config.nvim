local cfg = require("personal.utils.config")
local map = cfg.map

map({
    "<leader>ur",
    "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>",
    desc =
    "Redraw / Clear hlsearch / Diff Update"
})


map({ "<F7>", function() vim.cmd.normal({ "]c", bang = true }) end, desc = "Diffview next change", })
map({ "<F19>", function() vim.cmd.normal({ "[c", bang = true }) end, desc = "Diffview previous change" })

map({
    "<Esc>",
    function()
        vim.cmd("nohlsearch")
        return "<Esc>"
    end,
    mode = { "i", "n", "s" },
    expr = true,
    desc = "Escape and Clear hlsearch"
})

map({ "<leader>uu", "<cmd>Undotree<cr>", desc = "Undo tree" })

map({ "J", ":m '>+1<CR>gv=gv", mode = "v", desc = "Move selection down" })
map({ "K", ":m '<-2<CR>gv=gv", mode = "v", desc = "Move selection up" })

map({ "<C-d>", "<C-d>zz" })
map({ "<C-u>", "<C-u>zz" })
map({ "n", "nzzzv" })
map({ "N", "Nzzzv" })

map({ "<leader>p", '"_dP', mode = "x", desc = "Paste without overwriting clipboard" })

local yank = require("shared.yank")
map({
    "<leader>ya",
    function()
        yank.yank_path(yank.get_buffer_absolute(), "absolute")
    end,
    desc = "[Y]ank [A]bsolute path to clipboard"
})

map({
    "<leader>yr",
    function()
        yank.yank_path(yank.get_buffer_cwd_relative(), "relative")
    end,
    desc = "[Y]ank [R]elative path to clipboard"
})

map({
    "<leader>ya",
    function()
        yank.yank_visual_with_path(yank.get_buffer_absolute(), "absolute")
    end,
    mode = "v",
    desc = "[Y]ank selection with [A]bsolute path"
})

map({
    "<leader>yr",
    function()
        yank.yank_visual_with_path(yank.get_buffer_cwd_relative(), "relative")
    end,
    mode = "v",
    desc = "[Y]ank selection with [R]elative path"
})

map({ "<leader>yy", '"+y', desc = "[Y]ank to s[y]stem clipboard" })
map({ "<leader>yy", '"+y', mode = "v", desc = "[Y]ank to s[y]stem clipboard" })

map({ "<leader>d", '"_d', desc = "Delete without yanking" })
map({ "<leader>d", '"_d', mode = "v", desc = "Delete without yanking" })

map({
    "<leader>cf",
    function()
        require("conform").format({
            async = true,
            lsp_format = "fallback",
        })
    end,
    desc = "Format"
})

map({ "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "v" }, desc = "Code Action" })

map({ "<leader>cr", vim.lsp.buf.rename, desc = "Rename" })

local function typescript_source_action(kind)
    return function()
        vim.lsp.buf.code_action({
            apply = true,
            context = {
                only = { kind },
                diagnostics = {},
            },
        })
    end
end

map({ "<leader>cM", typescript_source_action("source.addMissingImports.ts"), desc = "Add Missing Imports" })
map({ "<leader>cu", typescript_source_action("source.removeUnusedImports"), desc = "Remove Unused Imports" })
map({ "<leader>cD", typescript_source_action("source.fixAll.ts"), desc = "Fix All Diagnostics" })
map({ "<leader>co", typescript_source_action("source.organizeImports"), desc = "Organize Imports" })
map({
    "<leader>cV",
    function()
        vim.lsp.buf.execute_command({
            command = "typescript.selectTypeScriptVersion",
            arguments = {},
        })
    end,
    desc = "Select TypeScript Version",
})

-- Buffer navigation
map({ "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous buffer" })
map({ "<leader>bn", "<cmd>bnext<cr>", desc = "Next buffer" })
map({ "H", "<cmd>bprevious<cr>", desc = "Previous buffer" })
map({ "L", "<cmd>bnext<cr>", desc = "Next buffer" })

map({
    "<C-Space>",
    function()
        local ok, blink = pcall(require, "blink.cmp")

        if ok then
            blink.show()
        else
            -- fallback to native LSP completion
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n", true)
        end
    end,
    mode = "i",
    desc = "Trigger completion"
})

map({ "<leader>ch", vim.lsp.buf.signature_help, desc = "Signature Help" })

-- Windows
map({ "<leader>wc", "<C-w>c", desc = "Close window" })
map({ "<C-h>", "<C-w>h", desc = "Go left window" })
map({ "<C-j>", "<C-w>j", desc = "Go down window" })
map({ "<C-k>", "<C-w>k", desc = "Go up window" })
map({ "<C-l>", "<C-w>l", desc = "Go right window" })

-- Tabs
map({ "<leader><tab>l", "<cmd>tablast<cr>", desc = "Last Tab" })
map({ "<leader><tab>o", "<cmd>tabonly<cr>", desc = "Close Other Tabs" })
map({ "<leader><tab>f", "<cmd>tabfirst<cr>", desc = "First Tab" })
map({ "<leader><tab><tab>", "<cmd>tabnew<cr>", desc = "New Tab" })
map({ "<leader><tab>]", "<cmd>tabnext<cr>", desc = "Next Tab" })
map({ "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close Tab" })
map({ "<leader><tab>[", "<cmd>tabprevious<cr>", desc = "Previous Tab" })

-- sessions
map({ "<leader>qr", "<cmd>restart<cr>", desc = "Restart" })
map({ "n", "<leader>ui", vim.show_pos, desc = "Inspect Pos" })
map({
    "n",
    "<leader>uI",
    function()
        vim.treesitter.inspect_tree()
        vim.api.nvim_input("I")
    end,
    desc = "Inspect Tree"
})
