local M = {}
local pending_pack_configs = {}
local did_pack_sync = false
local wrapper_keys = {
    enabled = true,
    keys = true,
    on_pack_changed = true,
    setup = true,
}

local function run_with_error_notification(plugin, hook, fn)
    local ok, traceback = xpcall(fn, debug.traceback)
    if ok then
        return
    end

    vim.schedule(function()
        vim.notify(
            string.format("[pack_add] %s failed for %s\n%s", hook, plugin, traceback),
            vim.log.levels.ERROR,
            { title = "Plugin setup error" }
        )
    end)
end

M.map = function(config)
    local mode = config.mode or "n"
    local lhs = config[1]
    local rhs = config[2]
    local opts = {}

    if config[3] ~= nil and config.mode == nil then
        mode = config[1]
        lhs = config[2]
        rhs = config[3]
    end

    for key, value in pairs(config) do
        if type(key) ~= "number" and key ~= "mode" then
            opts[key] = value
        end
    end

    vim.keymap.set(mode, lhs, rhs, opts)
end

local function get_pack_name(config)
    local name = config.name or config.src:match("/([^/]+)$") or config.src
    return name:gsub("%.git$", "")
end

local function get_pack_spec(config)
    local spec = {}
    local spec_keys = 0

    for key, value in pairs(config) do
        if not wrapper_keys[key] then
            spec[key] = value
            spec_keys = spec_keys + 1
        end
    end

    if spec_keys == 1 and spec.src ~= nil then
        return spec.src
    end

    return spec
end

local function setup_pack_changed_hook(config)
    if not config.on_pack_changed then
        return
    end

    local name = get_pack_name(config)

    vim.api.nvim_create_autocmd("PackChanged", {
        callback = function(ev)
            if ev.data.spec.name ~= name then
                return
            end

            local plugin = string.format("%s (%s)", name, config.src)
            run_with_error_notification(plugin, "on_pack_changed", function()
                config.on_pack_changed(ev)
            end)
        end,
    })
end

local function setup_keys(keys)
    for _, key in ipairs(keys) do
        if key.enabled == nil or key.enabled then
            M.map(key)
        end
    end
end

local function run_pack_setup(config)
    if config.setup then
        local plugin = string.format("%s (%s)", get_pack_name(config), config.src)
        run_with_error_notification(plugin, "setup", config.setup)
    end

    if config.keys then
        setup_keys(config.keys)
    end
end

local function install_pack_config(config)
    vim.pack.add({ get_pack_spec(config) })
    run_pack_setup(config)
end

M.pack_add = function(config)
    if config.enabled ~= nil and not config.enabled then
        return
    end

    setup_pack_changed_hook(config)

    if did_pack_sync then
        install_pack_config(config)
        return
    end

    table.insert(pending_pack_configs, config)
end

M.pack_sync = function()
    if did_pack_sync then
        return
    end

    did_pack_sync = true

    if #pending_pack_configs == 0 then
        return
    end

    local specs = {}
    for _, config in ipairs(pending_pack_configs) do
        table.insert(specs, get_pack_spec(config))
    end

    vim.pack.add(specs)

    for _, config in ipairs(pending_pack_configs) do
        run_pack_setup(config)
    end

    pending_pack_configs = {}
end

return M
