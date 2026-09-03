local cfg = require("personal.utils.config")

cfg.pack_add({
  src = "https://github.com/folke/lazydev.nvim",
  setup = function()
    require("lazydev").setup({
      library = {
        "snacks.nvim",
      },
    })
  end,
})

cfg.pack_add({
  src = "https://github.com/saghen/blink.lib",
})

cfg.pack_add({
  src = "https://github.com/Saghen/blink.cmp",
  setup = function()
    local cmp = require("blink.cmp")
    cmp.build():wait(60000)
    cmp.setup({
      snippets = { preset = "luasnip" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      cmdline = {
        enabled = true,
        keymap = { preset = "inherit" },
        completion = {
          menu = {
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ":"
              -- enable for inputs as well, with:
              -- or vim.fn.getcmdtype() == '@'
            end,
          },
        },
      },
      completion = {
        accept = { auto_brackets = { enabled = false } },
        ghost_text = { enabled = false },
        trigger = {
          show_on_keyword = true,
        },
        menu = {
          auto_show = true,
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
            },
            treesitter = { "lsp" },
          },
        },
      },
    })
  end,
})

cfg.pack_add({
  src = "https://github.com/mason-org/mason.nvim",
  setup = function()
    require("shared.mason").setup()
  end,
})

cfg.pack_add({
  src = "https://github.com/neovim/nvim-lspconfig",
  setup = function()
    local typescript_settings = {
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
      preferences = {
        importModuleSpecifier = "non-relative",
      },
      suggest = {
        completeFunctionCalls = true,
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
    }

    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    vim.lsp.config("vtsls", {
      settings = {
        complete_function_calls = true,
        javascript = vim.deepcopy(typescript_settings),
        typescript = typescript_settings,
        vtsls = {
          autoUseWorkspaceTsdk = true,
          enableMoveToFileCodeAction = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
            maxInlayHintLength = 30,
          },
          tsserver = {
            globalPlugins = {
              {
                name = "@angular/language-server",
                location = vim.fn.stdpath("data")
                  .. "/mason/packages/angular-language-server/node_modules/@angular/language-server",
                enableForWorkspaceTypeScriptVersions = false,
              },
            },
          },
        },
      },
      on_attach = function(client)
        client.commands["_typescript.didOrganizeImports"] = function() end
      end,
    })

    vim.lsp.config("angularls", {
      on_attach = function(client)
        -- HACK: Angular LS can trigger a duplicate rename popup.
        client.server_capabilities.renameProvider = false
      end,
    })

    vim.lsp.enable("cssls")
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("vtsls")
    vim.lsp.enable("angularls")
    vim.lsp.config("cspell_ls", {
      filetypes = {
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "html",
        "css",
        "scss",
        "lua",
        "markdown",
      },
    })
    -- vim.lsp.enable("cspell_ls")
  end,
})
