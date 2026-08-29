local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("personal_angular_filetype", { clear = true })

  -- smarter detection of filetype for angular templates
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = group,
    pattern = { "*.html" },
    callback = function(args)
      local path = vim.api.nvim_buf_get_name(args.buf)
      if path == "" then
        return
      end

      local root = vim.fs.find({ "angular.json", "nx.json" }, {
        path = vim.fs.dirname(path),
        upward = true,
        stop = vim.uv.os_homedir(),
      })[1]

      if root then
        vim.bo[args.buf].filetype = "htmlangular"
      end
    end,
  })
end

return M
