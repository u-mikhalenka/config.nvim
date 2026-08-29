local cfg = require("personal.utils.config")

cfg.pack_add({
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  on_pack_changed = function(ev)
    if ev.data.kind == "install" or ev.data.kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
  setup = function()
    require("nvim-treesitter").install({
      "lua",
      "vim",
      "vimdoc",
      "javascript",
      "typescript",
      "angular",
      "scss",
      "html",
      "css",
      "bash",
      "diff",
      "jsdoc",
      "markdown",
      "markdown_inline",
      "regex",
      "toml",
      "xml",
      "yaml",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local ft = vim.bo.filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if not lang then
          return
        end

        local ok = pcall(vim.treesitter.start, 0, lang)
        if not ok then
          return
        end

        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.wo.foldlevel = 99
      end,
    })
  end,
})

cfg.pack_add({
  src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  setup = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = false,
        selection_modes = {
          ["@parameter.outer"] = "v",
          ["@function.outer"] = "V",
          ["@class.outer"] = "V",
        },
      },
      move = {
        set_jumps = true,
      },
    })

    local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject
    local select_mappings = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
    }

    for keys, query in pairs(select_mappings) do
      vim.keymap.set({ "x", "o" }, keys, function()
        select_textobject(query, "textobjects")
      end, { desc = "Select " .. query })
    end

    local move = require("nvim-treesitter-textobjects.move")
    local move_mappings = {
      ["]f"] = { move.goto_next_start, "@function.outer" },
      ["]c"] = { move.goto_next_start, "@class.outer" },
      ["]a"] = { move.goto_next_start, "@parameter.inner" },
      ["[f"] = { move.goto_previous_start, "@function.outer" },
      ["[c"] = { move.goto_previous_start, "@class.outer" },
      ["[a"] = { move.goto_previous_start, "@parameter.inner" },
    }

    for keys, mapping in pairs(move_mappings) do
      vim.keymap.set({ "n", "x", "o" }, keys, function()
        mapping[1](mapping[2], "textobjects")
      end, { desc = "Move to " .. mapping[2] })
    end
  end,
})

cfg.pack_add({
  src = "https://github.com/windwp/nvim-ts-autotag",
  setup = function()
    require("nvim-ts-autotag").setup()
  end,
})
