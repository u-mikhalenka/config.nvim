local cfg = require("personal.utils.config")
local function lsp_root(bufnr)
  local function clamp_to_cwd(path)
    path = path and vim.fs.normalize(path) or vim.uv.cwd()

    local cwd = vim.fs.normalize(vim.uv.cwd())
    if path == cwd or path:sub(1, #cwd + 1) == cwd .. "/" then
      return path
    end

    return cwd
  end

  bufnr = bufnr or 0

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.root_dir then
      return clamp_to_cwd(client.root_dir)
    end

    local folders = client.workspace_folders
    if folders and folders[1] then
      return clamp_to_cwd(vim.uri_to_fname(folders[1].uri))
    end
  end

  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" then
    return vim.uv.cwd()
  end

  local root = vim.fs.root(file, {
    "package.json",
    ".git",
    "pyproject.toml",
    "Cargo.toml",
    "go.mod",
  }) or vim.fs.dirname(file)

  return clamp_to_cwd(root)
end

local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

local last_terminal_count = 1

local function toggle_terminal_count(count)
  last_terminal_count = count
  Snacks.terminal(nil, { count = count })
end

local function toggle_last_terminal()
  if vim.v.count > 0 then
    last_terminal_count = vim.v.count
  elseif type(vim.b.snacks_terminal) == "table" and vim.b.snacks_terminal.id then
    last_terminal_count = vim.b.snacks_terminal.id
  end

  Snacks.terminal(nil, { count = last_terminal_count })
end

local function toggle_float_terminal()
  Snacks.terminal(nil, {
    count = 99,
    win = {
      position = "float",
    },
  })
end

local function pick_lsp_references()
  Snacks.picker.lsp_references({
    unique_lines = true,
    focus = "list",
    transform = function(item, ctx)
      ctx.meta.seen = ctx.meta.seen or {}

      local id = table.concat({
        item.file or "",
        item.pos and item.pos[1] or 0,
        item.pos and item.pos[2] or 0,
        item.end_pos and item.end_pos[1] or 0,
        item.end_pos and item.end_pos[2] or 0,
      }, ":")

      if ctx.meta.seen[id] then
        return false
      end
      ctx.meta.seen[id] = true
      return item
    end,
  })
end

cfg.pack_add({
  src = "https://github.com/folke/snacks.nvim",
  setup = function()
    local picker_actions = vim.tbl_extend("force", {}, require("trouble.sources.snacks").actions, {
      flash = function(picker)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
              end,
            },
          },
          action = function(match)
            local idx = picker.list:row2idx(match.pos[1])
            picker.list:_move(idx, true, true)
          end,
        })
      end,
    })

    require("snacks").setup({
      animate = { enabled = false },
      picker = {
        actions = picker_actions,
        win = {
          input = {
            keys = {
              ["<c-t>"] = {
                "trouble_open",
                mode = { "n", "i" },
              },
              ["<a-s>"] = { "flash", mode = { "n", "i" } },
              ["s"] = { "flash", mode = { "n" } },
            },
          },
        },
        enabled = true,
        layout = {
          preset = "vertical",
        },
        sources = {
          files = {
            hidden = true,
          },
          smart = {
            filter = { cwd = true },
            on_show = function(picker)
              vim.schedule(function()
                if picker.closed or not picker.input.win:valid() or picker.input:get() == "" then
                  return
                end

                vim.api.nvim_set_current_win(picker.input.win.win)
                vim.cmd("normal! 0v$")
                vim.api.nvim_feedkeys(vim.keycode("<C-g>"), "n", false)
              end)
            end,
            win = {
              input = {
                keys = {
                  ["<CR>"] = { "confirm", mode = { "i", "n", "s" } },
                  ["<Down>"] = { "list_down", mode = { "i", "n", "s" } },
                  ["<Up>"] = { "list_up", mode = { "i", "n", "s" } },
                },
              },
            },
          },
          explorer = {
            hidden = true,
            actions = {
              explorer_add = function(picker)
                local ExplorerActions = require("snacks.explorer.actions")
                local Tree = require("snacks.explorer.tree")
                local uv = vim.uv or vim.loop

                Snacks.input({
                  prompt = "Add a new file or directory (directories end with a \"/\")",
                }, function(value)
                  if not value or value:find("^%s*$") then
                    return
                  end

                  local dir = picker:dir()
                  local paths = vim.tbl_map(function(path)
                    return {
                      path = vim.fs.normalize(path),
                      is_file = path:sub(-1) ~= "/",
                    }
                  end, vim.split(vim.fn.expand(dir .. "/" .. value), "\n", { trimempty = true }))

                  for _, item in ipairs(paths) do
                    if item.is_file and uv.fs_stat(item.path) then
                      Snacks.notify.warn("File already exists:\n- `" .. item.path .. "`")
                      return
                    end
                  end

                  for _, item in ipairs(paths) do
                    local target_dir = item.is_file and vim.fs.dirname(item.path) or item.path
                    vim.fn.mkdir(target_dir, "p")
                    if item.is_file then
                      io.open(item.path, "w"):close()
                    end
                  end

                  Tree:refresh(dir)
                  ExplorerActions.update(picker, { target = paths[1].path, refresh = true })
                end)
              end,
            },
          },
        },
      },

      explorer = { enabled = false },
      notifier = { enabled = true },
      indent = { enabled = false, animate = { enabled = false } },
      input = { enabled = true },
      quickfile = { enabled = true },
      bigfile = { enabled = true },
      statuscolumn = { enabled = true },
      image = { enabled = true },
      words = { enabled = true },
      toggle = { enabled = true },
      terminal = {
        enabled = true,
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          },
        },
      },
    })

    local snacks_image = require("snacks.image")
    local supports_file = snacks_image.supports_file
    snacks_image.supports_file = function(file)
      return vim.fn.fnamemodify(file, ":e"):lower() == "svg" or supports_file(file)
    end
    -- toggle
    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.line_number():map("<leader>ul")
    Snacks.toggle
      .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
      :map("<leader>uc")
    Snacks.toggle
      .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
      :map("<leader>uA")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.dim():map("<leader>uD")
    Snacks.toggle.indent():map("<leader>ug")
    Snacks.toggle.scroll():map("<leader>uS")
    Snacks.toggle.profiler():map("<leader>dpp")
    Snacks.toggle.profiler_highlights():map("<leader>dph")

    if vim.lsp.inlay_hint then
      Snacks.toggle.inlay_hints():map("<leader>uh")
    end
  end,
  keys = {
    {
      "<leader><space>",
      function()
        Snacks.picker.resume({ source = "smart" })
      end,
      desc = "Smart Files (cwd)",
    },

    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.picker.scratch()
      end,
      desc = "Select Scratch Buffer",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep({ cwd = lsp_root(0) })
      end,
      desc = "Grep (Root Dir)",
    },
    {
      "<leader>E",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files({ cwd = lsp_root(0) })
      end,
      desc = "Find Files (Root Dir)",
    },
    {
      "<leader>fF",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files (cwd)",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Git Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },
    {
      "<leader>fR",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume Picker",
    },

    -- git
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches({ all = true })
      end,
      desc = "Git Branches",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Log Line",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gS",
      function()
        Snacks.picker.git_stash()
      end,
      desc = "Git Stash",
    },
    {
      "<leader>gi",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git Diff (Hunks)",
    },
    {
      "<leader>ge",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git Log File",
    },

    -- search
    {
      "<leader>sg",
      function()
        Snacks.picker.grep({ cwd = lsp_root(0) })
      end,
      desc = "Grep (Root Dir)",
    },
    {
      "<leader>sG",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep (cwd)",
    },
    {
      "<leader>sB",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Open Buffers",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Visual selection or word",
      mode = { "n", "x" },
    },
    {
      "<leader>s\"",
      function()
        Snacks.picker.registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search History",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>sj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jumps",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sl",
      function()
        Snacks.picker.loclist()
      end,
      desc = "Location List",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>sq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },
    {
      "<leader>bb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Delete Other Buffers",
    },
    {
      "<c-/>",
      toggle_last_terminal,
      desc = "Toggle Terminal",
      mode = { "n", "t" },
    },
    {
      "<A-f>",
      toggle_float_terminal,
      desc = "Toggle Floating Terminal",
      mode = { "n", "t" },
    },
    {
      "<A-1>",
      function()
        toggle_terminal_count(1)
      end,
      desc = "Toggle Terminal 1",
      mode = { "n", "t" },
    },
    {
      "<A-2>",
      function()
        toggle_terminal_count(2)
      end,
      desc = "Toggle Terminal 2",
      mode = { "n", "t" },
    },
    {
      "<A-3>",
      function()
        toggle_terminal_count(3)
      end,
      desc = "Toggle Terminal 3",
      mode = { "n", "t" },
    },
    {
      "<A-4>",
      function()
        toggle_terminal_count(4)
      end,
      desc = "Toggle Terminal 4",
      mode = { "n", "t" },
    },
    {
      "<A-5>",
      function()
        toggle_terminal_count(5)
      end,
      desc = "Toggle Terminal 5",
      mode = { "n", "t" },
    },

    -- LSP
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = "Goto Declaration",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Goto T[y]pe Definition",
    },
    {
      "gai",
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = "C[a]lls Incoming",
    },
    {
      "gao",
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = "C[a]lls Outgoing",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "LSP Workspace Symbols",
    },
    {
      "glr",
      pick_lsp_references,
      desc = "References",
      nowait = true,
    },
  },
})
