local cfg = require("personal.utils.config")

vim.g.fff = vim.tbl_deep_extend("force", vim.g.fff or {}, {
  lazy_sync = true,
})

cfg.pack_add({
  src = "https://github.com/dmtrKovalenko/fff",
  on_pack_changed = function(ev)
    if ev.data.kind == "install" or ev.data.kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("fff")
      end
      require("fff.download").download_or_build_binary()
    end
  end,
  setup = function()
    require("fff").setup(vim.g.fff)
    require("fff.download").ensure_downloaded({}, function(success, err)
      if success then
        return
      end

      vim.schedule(function()
        vim.notify(
          "Failed to ensure fff.nvim binary: " .. (err or "unknown error"),
          vim.log.levels.ERROR,
          { title = "fff.nvim" }
        )
      end)
    end)
  end,
  keys = {
    {
      "<leader>Ff",
      function()
        require("fff").find_files({ resume = true })
      end,
      desc = "FFFind files",
    },
    {
      "<leader>Fg",
      function()
        require("fff").live_grep({ resume = true })
      end,
      desc = "LiFFFe grep",
    },
    {
      "<leader>Fz",
      function()
        require("fff").live_grep({ resume = true, grep = { modes = { "fuzzy", "plain" } } })
      end,
      desc = "Live fffuzy grep",
    },
  },
})
