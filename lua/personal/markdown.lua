local cfg = require("personal.utils.config")

cfg.pack_add({
  src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  setup = function()
    require("render-markdown").setup({})
  end,
})
