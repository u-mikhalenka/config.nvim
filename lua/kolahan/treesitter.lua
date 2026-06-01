vim.api.nvim_create_autocmd("PackChanged", {

    callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind
        if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})

vim.pack.add {
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
}

require("nvim-treesitter").install { "lua",
    "vim",
    "vimdoc",
    "javascript",
    "typescript",
    "html",
    "css",
    "bash",
    "diff",
    "jsdoc",
    "markdown",
    "regex",
    "toml",
    "xml",
    "yaml"
}

require("nvim-ts-autotag").setup()

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local ft = vim.bo.filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if not lang then
            return
        end

        local ok = pcall(vim.treesitter.start, 0, lang)
        if not ok then
            return
        end

        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.wo.foldlevel = 99
    end,
})
