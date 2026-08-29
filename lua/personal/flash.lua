local cfg = require("personal.utils.config")

cfg.pack_add({
  src = "https://github.com/folke/flash.nvim",
  setup = function()
    local flash = require("flash")
    flash.setup({})
  end,
  keys = {
    {
      "<leader>ls",
      function()
        require("flash").jump()
      end,
      desc = "Flash",
      mode = { "n", "x", "o" },
    },
    {
      "<leader>lS",
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
      mode = { "n", "x", "o" },
    },
    {
      "<leader>lr",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
      mode = "o",
    },
    {
      "<leader>lR",
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
      mode = { "o", "x" },
    },
    {
      "<C-s>",
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
      mode = "c",
    },
    {
      "<C-Space>",
      function()
        require("flash").treesitter({
          actions = {
            ["<C-Space>"] = "next",
            ["<BS>"] = "prev",
          },
        })
      end,
      desc = "Treesitter Incremental Selection",
      mode = { "n", "o", "x" },
    },
  },
})
