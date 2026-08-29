local M = {}

M.setup = function()
  vim.opt.autoread = true
  vim.opt.updatetime = 1000

  vim.api.nvim_create_autocmd({
    "FocusGained",
    "BufEnter",
    "CursorHold",
    "CursorHoldI",
    "TermClose",
    "TermLeave",
  }, {
    group = vim.api.nvim_create_augroup("personal_autoread", { clear = true }),
    callback = function()
      if vim.fn.mode() ~= "c" then
        vim.cmd("checktime")
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = vim.api.nvim_create_augroup("personal_file_changed", { clear = true }),
    callback = function()
      vim.notify("File reloaded from disk", vim.log.levels.INFO)
    end,
  })
end

return M
