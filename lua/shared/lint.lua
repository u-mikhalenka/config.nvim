local M = {}

local linters_by_ft = {
  css = { "typos" },
  html = { "typos" },
  javascript = { "typos" },
  javascriptreact = { "typos" },
  lua = { "typos" },
  markdown = {},
  scss = { "typos" },
  text = { "typos" },
  typescript = { "typos" },
  typescriptreact = { "typos" },
}

function M.extend_options(opts)
  opts = opts or {}
  opts.linters_by_ft = opts.linters_by_ft or {}
  opts.linters = opts.linters or {}

  for filetype, linters in pairs(linters_by_ft) do
    opts.linters_by_ft[filetype] = vim.deepcopy(linters)
  end

  opts.linters.typos = vim.tbl_deep_extend("force", opts.linters.typos or {}, {
    condition = function()
      return vim.fn.executable("typos") == 1
    end,
  })

  return opts
end

function M.setup()
  local lint = require("lint")
  local opts = M.extend_options({})
  lint.linters_by_ft = opts.linters_by_ft

  local group = vim.api.nvim_create_augroup("personal_lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = group,
    callback = function(args)
      if vim.b[args.buf].bigfile_guard or vim.bo[args.buf].filetype == "bigfile" then
        return
      end
      lint.try_lint()
    end,
  })
end

return M
