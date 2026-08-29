local M = {}

local required_tools = {
  "angular-language-server",
  "css-lsp",
  "harper-ls",
  "json-lsp",
  "lua-language-server",
  "markdown-toc",
  "markdownlint-cli2",
  "marksman",
  "prettier",
  "shfmt",
  "stylua",
  "tailwindcss-language-server",
  "tree-sitter-cli",
  "typescript-language-server",
  "typos",
  "vtsls",
}

function M.extend_options(opts)
  opts = opts or {}
  opts.ensure_installed = opts.ensure_installed or {}

  for _, tool in ipairs(required_tools) do
    if not vim.tbl_contains(opts.ensure_installed, tool) then
      table.insert(opts.ensure_installed, tool)
    end
  end

  return opts
end

function M.setup()
  require("mason").setup()

  local registry = require("mason-registry")
  registry.refresh(function()
    for _, name in ipairs(M.extend_options({}).ensure_installed) do
      local package = registry.get_package(name)
      if not package:is_installed() then
        package:install()
      end
    end
  end)
end

return M
