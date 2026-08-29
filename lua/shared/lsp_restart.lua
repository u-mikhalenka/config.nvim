local M = {}

M.setup = function()
  -- Force-restart every active LSP client and reattach LSPs for listed file buffers.
  local function restart_all_lsp()
    local clients = vim.lsp.get_clients()
    if #clients == 0 then
      vim.notify("No active LSP clients", vim.log.levels.INFO)
      return
    end

    for _, client in ipairs(clients) do
      client:stop(true)
    end

    local attempts = 0
    local function restart_when_stopped()
      attempts = attempts + 1

      if #vim.lsp.get_clients() > 0 and attempts < 10 then
        vim.defer_fn(restart_when_stopped, 100)
        return
      end

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if
          vim.api.nvim_buf_is_valid(buf)
          and vim.api.nvim_buf_is_loaded(buf)
          and vim.bo[buf].buflisted
          and vim.bo[buf].buftype == ""
          and vim.bo[buf].filetype ~= ""
        then
          vim.api.nvim_exec_autocmds("FileType", {
            buffer = buf,
            modeline = false,
          })
        end
      end

      vim.notify("Restarted all LSP clients", vim.log.levels.INFO)
    end

    restart_when_stopped()
  end
  vim.api.nvim_create_user_command("LspRestartAll", restart_all_lsp, {
    desc = "Restart all LSP clients for all listed buffers",
    force = true,
  })
end

return M
