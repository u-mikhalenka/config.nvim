local M = {}

M.setup = function()
  local function update_terminal_title()
    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    if cwd == "" then
      cwd = vim.fn.getcwd()
    end

    vim.opt.titlestring = string.format("%s", cwd)
  end

  local title_group = vim.api.nvim_create_augroup("personal_terminal_title", { clear = true })

  vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    group = title_group,
    callback = update_terminal_title,
  })

  update_terminal_title()
end

return M
