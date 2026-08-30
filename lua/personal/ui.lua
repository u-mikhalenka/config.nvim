local cfg = require("personal.utils.config")

cfg.pack_add({
  src = "https://github.com/nvim-tree/nvim-web-devicons",
  setup = function()
    require("nvim-web-devicons").setup()
  end,
})
cfg.pack_add({ src = "https://github.com/catppuccin/nvim" })
cfg.pack_add({ src = "https://github.com/folke/tokyonight.nvim" })
cfg.pack_add({
  src = "https://github.com/projekt0n/github-nvim-theme",
  setup = function()
    require("github-theme").setup({
      palettes = {
        github_light_default = {
          canvas = { default = "#f7f7f7" },
          fg = { default = "#303846" },
        },
      },
      specs = {
        github_light_default = {
          syntax = {
            string = "#448c27",
          },
        },
      },
    })

    vim.cmd("colorscheme github_light_default")
  end,
})

cfg.pack_add({
  src = "https://github.com/nvim-lualine/lualine.nvim",
  setup = function()
    require("lualine").setup({
      sections = {
        lualine_c = {},
        lualine_b = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "lsp_status", "encoding", "fileformat", "filetype" },
        lualine_y = {},
        lualine_z = { "location" },
      },
      extensions = { "quickfix", "trouble" },
    })
  end,
})

cfg.pack_add({
  src = "https://github.com/akinsho/bufferline.nvim",
  setup = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        close_command = function(n)
          Snacks.bufdelete(n)
        end,
      },
    })
  end,
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
  },
})
