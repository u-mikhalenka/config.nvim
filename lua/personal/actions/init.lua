local M = {}

M.setup = function()
    local cfg = require('personal.utils.config')
    local git = require("personal.actions.git")
    local lsp = require("personal.actions.lsp")
    local menu = require("personal.actions.menu")

    local actions_menu = function()
        return {
            {
                name = "Git",
                menu = git.git_menu,
            },
            {
                name = "LSP",
                menu = lsp.lsp_menu,
            },
        }
    end

    cfg.map({ "<leader>gu", function() menu.open_menu(actions_menu()) end, desc = "Show actions menu" })

    vim.keymap.set("n", "<leader>ru", "<cmd>luafile %<CR>")
end

return M
