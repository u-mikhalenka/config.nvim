local M = {}

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

    vim.keymap.set(mode, lhs, rhs, opts);
end

M.pack_add = function(config)
    if config.enabled ~= nil and not config.enabled then
        return
    end

    vim.pack.add({ config.src })

    if config.setup then
        config.setup()
    end
end

return M
