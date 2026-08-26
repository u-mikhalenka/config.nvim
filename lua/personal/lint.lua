local cfg = require("personal.utils.config")

cfg.pack_add({
    src = "https://github.com/mfussenegger/nvim-lint",
    setup = function()
        require("shared.lint").setup()
    end,
})
