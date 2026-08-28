local M = {}

local function source_buf()
    return require("personal.actions.menu").source_buf()
end

local function restart_clients(names)
    local name_set = {}
    for _, name in ipairs(names) do
        name_set[name] = true
    end

    local stopped = {}
    for _, client in ipairs(vim.lsp.get_clients()) do
        if name_set[client.name] then
            stopped[client.name] = true
            client:stop(true)
        end
    end

    if vim.tbl_isempty(stopped) then
        vim.notify("No matching LSP clients running: " .. table.concat(names, ", "), vim.log.levels.INFO)
        return
    end

    vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if
                vim.api.nvim_buf_is_valid(buf)
                and vim.api.nvim_buf_is_loaded(buf)
                and vim.bo[buf].buflisted
                and vim.bo[buf].buftype == ""
                and vim.bo[buf].filetype ~= ""
            then
                vim.api.nvim_exec_autocmds("FileType", {
                    buffer = buf,
                    modeline = false,
                })
            end
        end

        vim.notify("Restarted LSP: " .. table.concat(vim.tbl_keys(stopped), ", "), vim.log.levels.INFO)
    end, 100)
end

local function has_client(client_name)
    local clients = vim.lsp.get_clients({ name = client_name })
    return #clients ~= 0
end

local function exec_command(client_name, command, arguments)
    local clients = vim.lsp.get_clients({ name = client_name, bufnr = source_buf() })
    if #clients == 0 then
        vim.notify("No " .. client_name .. " client attached to source buffer", vim.log.levels.INFO)
        return
    end

    for _, client in ipairs(clients) do
        client:exec_cmd({
            title = command,
            command = command,
            arguments = arguments or {},
        })
    end
end

local function scratch(name, lines)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "lua"

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.cmd("botright split")
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_name(buf, name)
end

local function inspect_value(name, value)
    scratch(name, vim.split(vim.inspect(value), "\n"))
end

local function current_clients()
    return vim.lsp.get_clients({ bufnr = source_buf() })
end

local function debug_menu()
    return {
        {
            name = "Attached Clients",
            action = function()
                inspect_value("LSP attached clients", vim.tbl_map(function(client)
                    return {
                        id = client.id,
                        name = client.name,
                        root_dir = client.root_dir,
                    }
                end, current_clients()))
            end,
        },
        {
            name = "Execute Commands",
            action = function()
                local commands = {}
                for _, client in ipairs(current_clients()) do
                    local provider = client.server_capabilities.executeCommandProvider
                    commands[client.name] = provider and provider.commands or {}
                end

                inspect_value("LSP execute commands", commands)
            end,
        },
        {
            name = "Client Commands",
            action = function()
                local commands = {}
                for _, client in ipairs(current_clients()) do
                    commands[client.name] = client.commands or {}
                end

                inspect_value("LSP client commands", commands)
            end,
        },
        {
            name = "Server Capabilities",
            action = function()
                local capabilities = {}
                for _, client in ipairs(current_clients()) do
                    capabilities[client.name] = client.server_capabilities
                end

                inspect_value("LSP server capabilities", capabilities)
            end,
        },
        {
            name = "All Active Clients",
            action = function()
                inspect_value("LSP active clients", vim.tbl_map(function(client)
                    return {
                        id = client.id,
                        name = client.name,
                        root_dir = client.root_dir,
                        attached_buffers = vim.tbl_keys(client.attached_buffers or {}),
                    }
                end, vim.lsp.get_clients()))
            end,
        },
        {
            name = "LSP Info",
            action = function()
                inspect_value("LSP info", {
                    source_buffer = source_buf(),
                    source_filetype = vim.bo[source_buf()].filetype,
                    log_level = vim.lsp.log.get_level(),
                    log_path = vim.lsp.log.get_filename(),
                    attached_clients = vim.tbl_map(function(client)
                        return {
                            id = client.id,
                            name = client.name,
                            root_dir = client.root_dir,
                        }
                    end, current_clients()),
                })
            end,
        },
        {
            name = "Open LSP Log",
            action = function()
                vim.cmd.edit(vim.fn.fnameescape(vim.lsp.log.get_filename()))
            end,
        },
    }
end

M.lsp_menu = function()
    local menu = {}

    if has_client("vtsls") or has_client("angularls") then
        table.insert(menu, {
            name = "Restart TS Server",
            action = function()
                exec_command("vtsls", "typescript.restartTsServer")
            end,
        })
        table.insert(menu, {
            name = "Hard Restart TS Server",
            action = function()
                restart_clients({ "vtsls" })
            end,
        })
        table.insert(menu, {
            name = "Hard Restart Angular Server",
            action = function()
                restart_clients({ "angularls" })
            end,
        })
        table.insert(menu, {
            name = "Hard Restart TS + Angular Servers",
            action = function()
                restart_clients({ "vtsls", "angularls" })
            end,
        })

        table.insert(menu, {
            name = "Hard Restart All LSP Servers",
            action = function()
                vim.cmd("LspRestartAll")
            end,
        })
    end

    table.insert(menu, {
        name = "Debug",
        menu = debug_menu,
    })

    return menu
end

return M
