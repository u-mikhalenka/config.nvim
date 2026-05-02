vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "Directory listing" })
vim.keymap.set("n", "<leader>uu", "<cmd>Undotree<cr>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without overwriting clipboard" })

vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank to system clipboard" })

vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end, { desc = "Format" })

-- Previous buffer
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", {
  desc = "Previous buffer",
})

-- Next buffer
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", {
  desc = "Next buffer",
})

-- Buffer navigation
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })

vim.keymap.set("i", "<C-Space>", function()
  local ok, blink = pcall(require, "blink.cmp")

  if ok then
    blink.show()
  else
    -- fallback to native LSP completion
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true),
      "n",
      true
    )
  end
end, { desc = "Trigger completion" })

