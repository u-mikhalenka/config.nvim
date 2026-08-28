require('vim._core.ui2').enable()
require("shared.term_title").setup()
require("shared.autoread").setup()
require("shared.lsp_restart").setup()
require("shared.angular").setup()
require("shared.markdown").setup()
require("shared.quickfix").setup()

vim.opt.splitright = true -- split :vnew to the right

-- use system clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.foldtext = ""
vim.opt.fillchars:append({
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = " ",
    eob = " ",
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"

vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.showcmd = false

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.colorcolumn = "100"

vim.g.mapleader = ' '
vim.opt.timeoutlen = 300

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.diffopt = "internal,filler,closeoff,indent-heuristic,inline:char,linematch:60,algorithm:myers,iwhite"

vim.o.winborder = "single"
vim.diagnostic.config({
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float({
                bufnr = bufnr,
                scope = "cursor",
                focus = false,
            })
        end,
    },
})

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.title = true
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer

local autocmd_group = vim.api.nvim_create_augroup("personal_auto_mkdir", { clear = true })

vim.api.nvim_create_user_command("PackClean", function()
    local inactive = {}

    for _, plugin in ipairs(vim.pack.get()) do
        if not plugin.active then
            table.insert(inactive, plugin.spec.name)
        end
    end

    if #inactive == 0 then
        vim.notify("No inactive vim.pack plugins to remove", vim.log.levels.INFO, {
            title = "PackClean",
        })
        return
    end

    vim.pack.del(inactive)
    vim.notify(
        string.format("Removed %d inactive vim.pack plugin(s): %s", #inactive, table.concat(inactive, ", ")),
        vim.log.levels.INFO,
        { title = "PackClean" }
    )
end, {
    desc = "Remove inactive vim.pack plugins from disk",
})

-- create missing directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = autocmd_group,
    callback = function(args)
        local path = vim.api.nvim_buf_get_name(args.buf)
        if path == "" then
            return
        end

        local dir = vim.fn.fnamemodify(path, ":p:h")
        if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- use q to close some buffers
vim.api.nvim_create_autocmd("FileType", {
    group = autocmd_group,
    callback = function(args)
        local ft = vim.bo[args.buf].filetype

        if vim.tbl_contains({
                "help",
                "qf",
                "lspinfo",
                "man",
                "git",
                "gitcommit",
                "Trouble",
                "lazy",
                "notify",
                "checkhealth",
            }, ft) then
            vim.keymap.set("n", "q", "<cmd>close<cr>", {
                buffer = args.buf,
                silent = true,
                desc = "Close utility window",
            })
        end
    end,
})
