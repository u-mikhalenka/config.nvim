local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("personal_quickfix", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "qf",
    callback = function(args)
      local function delete_qf_range(first, last)
        local items = vim.fn.getqflist()
        if #items == 0 then
          return
        end

        first = math.max(first, 1)
        last = math.min(last, #items)

        if first > last then
          return
        end

        for i = last, first, -1 do
          table.remove(items, i)
        end

        vim.fn.setqflist({}, "r", { items = items })

        if #items == 0 then
          vim.cmd.cclose()
          return
        end

        local target = math.min(math.max(first - 1, 1), #items)
        vim.api.nvim_win_set_cursor(0, { target, 0 })
      end

      vim.api.nvim_buf_create_user_command(args.buf, "QfDelete", function(opts)
        delete_qf_range(opts.line1, opts.line2)
      end, {
        range = true,
        force = true,
      })

      vim.keymap.set("n", "dd", function()
        delete_qf_range(vim.fn.line("."), vim.fn.line("."))
      end, {
        buffer = args.buf,
        desc = "Delete quickfix item",
      })

      vim.keymap.set("x", "d", ":QfDelete<CR>", {
        buffer = args.buf,
        desc = "Delete quickfix items",
        silent = true,
      })
    end,
  })
end
return M
