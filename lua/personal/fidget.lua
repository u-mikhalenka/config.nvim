local cfg = require("personal.utils.config")
cfg.pack_add({
  enabled = false,
  src = "https://github.com/j-hui/fidget.nvim",
  setup = function()
    require("fidget").setup({})
  end,
})
