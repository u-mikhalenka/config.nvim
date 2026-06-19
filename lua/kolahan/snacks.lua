local cfg = require('kolahan.utils.config');
local map = cfg.map

local function lsp_root(bufnr)
    bufnr = bufnr or 0

    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
        if client.root_dir then
            return client.root_dir
        end

        local folders = client.workspace_folders
        if folders and folders[1] then
            return vim.uri_to_fname(folders[1].uri)
        end
    end

    local file = vim.api.nvim_buf_get_name(bufnr)
    if file == "" then
        return vim.uv.cwd()
    end

    return vim.fs.root(file, {
        "package.json",
        ".git",
        "pyproject.toml",
        "Cargo.toml",
        "go.mod",
    }) or vim.fs.dirname(file)
end

local function resume_picker(command, opts)
    local resume = require("snacks.picker.resume")

    if resume.state[command] then
        Snacks.picker.resume(command)
    else
        Snacks.picker[command](vim.tbl_deep_extend("force", { cwd = lsp_root(), matcher = { frecency = true } },
            opts or {}))
    end
end

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
    explorer = { enabled = false },
    notifier = { enabled = true },
    indent = { enabled = false, animate = { enabled = false } },
    input = { enabled = true },
    quickfile = { enabled = true },
    bigfile = { enabled = true },
    statuscolumn = { enabled = true },
    image = { enabled = true },
    words = { enabled = true },
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
    },
    sources = {
        explorer = {
            actions = {
                explorer_add = function(picker)
                    local ExplorerActions = require("snacks.explorer.actions")
                    local Tree = require("snacks.explorer.tree")
                    local uv = vim.uv or vim.loop

                    Snacks.input({
                        prompt = 'Add a new file or directory (directories end with a "/")',
                    }, function(value)
                        if not value or value:find("^%s*$") then
                            return
                        end

                        local dir = picker:dir()
                        local paths = vim.tbl_map(function(path)
                            return {
                                path = svim.fs.normalize(path),
                                is_file = path:sub(-1) ~= "/",
                            }
                        end, vim.split(vim.fn.expand(dir .. "/" .. value), "\n", { trimempty = true }))

                        for _, item in ipairs(paths) do
                            if item.is_file and uv.fs_stat(item.path) then
                                Snacks.notify.warn("File already exists:\n- `" .. item.path .. "`")
                                return
                            end
                        end

                        for _, item in ipairs(paths) do
                            local target_dir = item.is_file and vim.fs.dirname(item.path) or item.path
                            vim.fn.mkdir(target_dir, "p")
                            if item.is_file then
                                io.open(item.path, "w"):close()
                            end
                        end

                        Tree:refresh(dir)
                        ExplorerActions.update(picker, { target = paths[1].path, refresh = true })
                    end)
                end,
            },
        },
    },

})

map({ "<leader><space>", function() Snacks.picker.files({ cwd = lsp_root(0) }) end, desc = "Find Files (Root Dir)", })
map({ "<leader>/", function() Snacks.picker.grep({ cwd = lsp_root(0) }) end, desc = "Grep (Root Dir)", })
map({ "<leader>E", function() Snacks.explorer() end, desc = "File Explorer" })
map({ "<leader>ff", function() Snacks.picker.files({ cwd = lsp_root(0) }) end, desc = "Find Files (Root Dir)", })
map({ "<leader>fF", function() Snacks.picker.files() end, desc = "Find Files (cwd)", })
map({ "<leader>sg", function() Snacks.picker.grep({ cwd = lsp_root(0) }) end, desc = "Grep (Root Dir)", })
map({ "<leader>sG", function() Snacks.picker.grep() end, desc = "Grep (cwd)", })
map({ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" })
map({ "<leader>S", function() Snacks.picker.scratch() end, desc = "Select Scratch Buffer" })
map({ "<leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers" })
map({ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" })
map({ "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" })
map({ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" })
map({ "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" })
map({ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" })

local last_terminal_count = 1

local function toggle_terminal_count(count)
    last_terminal_count = count
    Snacks.terminal(nil, { count = count })
end

vim.keymap.set({ "n", "t" }, "<c-/>", function()
    if vim.v.count > 0 then
        last_terminal_count = vim.v.count
    elseif type(vim.b.snacks_terminal) == "table" and vim.b.snacks_terminal.id then
        last_terminal_count = vim.b.snacks_terminal.id
    end

    Snacks.terminal(nil, { count = last_terminal_count })
end, { desc = "Toggle Terminal" })

vim.keymap.set({ "n", "t" }, "<A-f>", function()
    Snacks.terminal(nil, {
        count = 99,
        win = {
            position = "float",
        },
    })
end, { desc = "Toggle Floating Terminal" })

for i = 1, 5 do
    vim.keymap.set({ "n", "t" }, "<A-" .. i .. ">", function()
        toggle_terminal_count(i)
    end, { desc = "Toggle Terminal " .. i })
end

-- lsp mappings
map({ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" })

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

map({ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" })
map({ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" })
map({ "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" })
map({ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymap" })

-- search

map({ "<leader>sh", function() Snacks.picker.help() end, desc = "Help" })
map({ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" })
map({ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" })

vim.keymap.set({ "n", "x" }, "<leader>sw", function()
    Snacks.picker.grep_word()
end, { desc = "Search Word" })

map({ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" })
map({ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" })
map({ "<leader>fR", function() Snacks.picker.resume() end, desc = "Resume Picker" })
