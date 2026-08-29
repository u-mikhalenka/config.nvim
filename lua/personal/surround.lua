local cfg = require("personal.utils.config")

cfg.pack_add({
  src = "https://github.com/kylechui/nvim-surround",
  setup = function()
    require("nvim-surround").setup({})
  end,
})
