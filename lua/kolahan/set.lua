require('vim._core.ui2').enable()
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

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.diffopt = "internal,filler,closeoff,indent-heuristic,inline:char,linematch:60,algorithm:myers,iwhite"

vim.o.winborder = "single"
vim.diagnostic.config({ jump = { float = true } })

vim.opt.title = true

local function update_terminal_title()
    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    if cwd == "" then
        cwd = vim.fn.getcwd()
    end

    vim.opt.titlestring = string.format("%s", cwd)
end

local title_group = vim.api.nvim_create_augroup("kolahan_terminal_title", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    group = title_group,
    callback = update_terminal_title,
})

update_terminal_title()

vim.opt.autoread = true
vim.opt.updatetime = 1000

vim.api.nvim_create_autocmd({
    "FocusGained",
    "BufEnter",
    "CursorHold",
    "CursorHoldI",
    "TermClose",
    "TermLeave",
}, {
    group = vim.api.nvim_create_augroup("kolahan_autoread", { clear = true }),
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = vim.api.nvim_create_augroup("kolahan_file_changed", { clear = true }),
    callback = function()
        vim.notify("File reloaded from disk", vim.log.levels.INFO)
    end,
})
