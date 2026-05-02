vim.pack.add({
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
})

vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", {
  desc = "Git diff working tree",
})

vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen HEAD~1..HEAD<cr>", {
  desc = "Git diff last commit",
})

vim.keymap.set("n", "<leader>gm", "<cmd>DiffviewOpen origin/main...HEAD<cr>", {
  desc = "Git diff against main",
})

vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", {
  desc = "Git file history",
})

vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", {
  desc = "Git repo history",
})

vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", {
  desc = "Close diff view",
})
