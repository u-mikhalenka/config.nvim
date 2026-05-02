vim.pack.add({
	{ src = 'https://github.com/folke/snacks.nvim' }
})

require('snacks').setup({})

vim.keymap.set("n", "<leader><space>", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })

vim.keymap.set("n", "<leader>bl", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>/", function()
  Snacks.picker.grep()
end, { desc = "Grep" })

vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "File Explorer" })

vim.keymap.set("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fg", function()
  Snacks.picker.git_files()
end, { desc = "Find Git Files" })

vim.keymap.set("n", "<leader>n", function()
  Snacks.notifier.show_history()
end, { desc = "Notification History" })

vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

vim.keymap.set({ "n", "v" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse" })

vim.keymap.set("n", "<c-/>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal" })

-- lsp mappings
vim.keymap.set("n", "gd", function()
  Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })

vim.keymap.set("n", "gr", function()
  Snacks.picker.lsp_references()
end, { desc = "References", nowait = true })

vim.keymap.set("n", "gI", function()
  Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })

vim.keymap.set("n", "gy", function()
  Snacks.picker.lsp_type_definitions()
end, { desc = "Goto Type Definition" })

vim.keymap.set("n", "<leader>uk", function()
    Snacks.picker.keymaps()
end, { desc = "Keymap" })

-- search

vim.keymap.set("n", "<leader>sh", function()
    Snacks.picker.help()
end, { desc = "Help" })
