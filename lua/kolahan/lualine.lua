vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim'
})
local function clients_lsp()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if next(clients) == nil then
        return ''
    end

    local c = {}
    for _, client in pairs(clients) do
        table.insert(c, client.name)
    end
    return '\u{f085} ' .. table.concat(c, '|')
end

require('lualine').setup({
    -- tabline = {
    --     lualine_a = { 'buffers' },
    --     lualine_b = {},
    --     lualine_c = {},
    --     lualine_x = {},
    --     lualine_y = {},
    --     lualine_z = { 'tabs' }
    -- },
    sections = {
        lualine_c = {},
        lualine_b = { { "filename", path = 1 } },
        lualine_x = { 'diagnostics', clients_lsp, 'encoding', 'fileformat', 'filetype', 'branch' }
    }
})
