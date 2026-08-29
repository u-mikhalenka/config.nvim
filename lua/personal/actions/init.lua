local M = {}

function gitsigns_menu()
  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then
    return {}
  end

  return {
    {
      action = gitsigns.toggle_current_line_blame,
      desc = "Toggle git blame line",
    },
    {
      action = gitsigns.toggle_word_diff,
      desc = "Toggle git word diff",
    },
  }
  -- map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle git blame line" })
  -- map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle git word diff" })
end

local function open_empty_diff_split()
  vim.cmd("tabnew")
  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_name(0, "diff-left")
  vim.wo.winfixbuf = true
  vim.cmd("diffthis")

  vim.cmd("vnew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_name(0, "diff-right")
  vim.wo.winfixbuf = true
  vim.cmd("diffthis")
end

M.setup = function()
  local cfg = require("personal.utils.config")
  local git = require("personal.actions.git")
  local lsp = require("personal.actions.lsp")
  local menu = require("personal.actions.menu")
  local snacks = require("personal.actions.snacks")

  local actions_menu = function()
    local menu = {
      {
        desc = "Git",
        menu = git.git_menu,
      },
      {
        desc = "LSP",
        menu = lsp.lsp_menu,
      },
      {
        desc = "Open Empty Diff Split",
        action = open_empty_diff_split,
      },
    }
    vim.list_extend(menu, snacks.snacks_menu() or {})
    vim.list_extend(menu, gitsigns_menu())

    return menu
  end

  cfg.map({
    "<leader>ua",
    function()
      menu.open_menu(actions_menu())
    end,
    desc = "Show actions menu",
  })

  vim.keymap.set("n", "<leader>ru", "<cmd>luafile %<CR>")
end

return M
