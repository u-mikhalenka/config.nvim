local M = {}

function M.setup()
  local ls = require("luasnip")

  for _, filetype in ipairs({
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "html",
    "htmlangular",
  }) do
    ls.filetype_extend(filetype, { "angular" })
  end

  require("luasnip.loaders.from_vscode").lazy_load({
    paths = {
      vim.fn.stdpath("config") .. "/snippets",
    },
  })

  local function is_anki_markdown()
    return vim.api.nvim_buf_get_name(0):match("%.anki%.md$") ~= nil
  end

  ls.add_snippets("markdown", {
    ls.snippet({
      trig = "a-word",
      name = "English note",
      condition = is_anki_markdown,
      show_condition = is_anki_markdown,
    }, {
      ls.text_node("## "),
      ls.insert_node(1),
      ls.text_node({ "", "", "- **English:** " }),
      ls.insert_node(2),
      ls.insert_node(0),
    }),
  }, { key = "personal-markdown" })
end

return M
