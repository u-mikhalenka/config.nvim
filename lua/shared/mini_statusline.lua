local M = {}

local function lsp_clients()
    local statusline = require("mini.statusline")
    if statusline.is_truncated(100) then
        return ""
    end

    local win = tonumber(vim.g.statusline_winid) or 0
    local buf = win > 0 and vim.api.nvim_win_get_buf(win) or vim.api.nvim_get_current_buf()
    local names = {}

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
        names[client.name] = true
    end

    local clients = vim.tbl_keys(names)
    table.sort(clients)

    return #clients > 0 and " " .. table.concat(clients, "|") or ""
end

local function section_fileinfo(args)
    local statusline = require("mini.statusline")
    local filetype = vim.bo.filetype

    if filetype ~= "" then
        local icon = require("mini.icons").get("filetype", filetype)
        filetype = icon .. " " .. filetype
    end

    if statusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= "" then
        return filetype
    end

    local encoding = vim.bo.fileencoding or vim.bo.encoding
    local format = ({
        unix = "",
        dos = "",
        mac = "",
    })[vim.bo.fileformat] or vim.bo.fileformat

    return string.format("%s%s%s %s", filetype, filetype == "" and "" or " ", encoding, format)
end

M.active_statusline = function()
    local statusline = require("mini.statusline")
    local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
    local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
    local filename = statusline.section_filename({ trunc_width = 140 })
    local fileinfo = section_fileinfo({ trunc_width = 120 })
    local location = "%3l│%3v"
    local search = statusline.section_searchcount({ trunc_width = 75 })

    return statusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        -- { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { hl = "MiniStatuslineDevinfo",  strings = { diagnostics, lsp_clients() } },
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
    })
end

M.get_options = function()
    return {
        use_icons = true,
        content = {
            active = M.active_statusline,
        },
    }
end

M.init = function()
    local group = vim.api.nvim_create_augroup("personal_mini_statusline", { clear = true })

    vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
        group = group,
        callback = function()
            vim.cmd.redrawstatus()
        end,
        desc = "Refresh Mini Statusline LSP clients",
    })
end

return M
