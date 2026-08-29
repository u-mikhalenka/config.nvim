local M = {}

local function escape_pattern(value)
  return value:gsub("([^%w])", "%%%1")
end

local function get_component_base(path)
  return path:match("^(.*)%.html$")
    or path:match("^(.*)%.scss$")
    or path:match("^(.*)%.css$")
    or path:match("^(.*)%.ts$")
end

local function references_template(ts_path, template_name)
  local ok, lines = pcall(vim.fn.readfile, ts_path, "", 200)
  if not ok then
    return false
  end

  local content = table.concat(lines, "\n")
  local quote = "[\"'`]"
  local template = escape_pattern(template_name)

  return content:find("templateUrl%s*:%s*" .. quote .. "%./" .. template .. quote) ~= nil
    or content:find("templateUrl%s*:%s*" .. quote .. template .. quote) ~= nil
end

local function get_sibling_ts_files(path)
  local dir = vim.fs.dirname(path)
  local base = path:gsub("%.html$", "")
  local files = {}
  local preferred = base .. ".ts"

  if vim.uv.fs_stat(preferred) then
    table.insert(files, preferred)
  end

  local scanner = vim.uv.fs_scandir(dir)
  if not scanner then
    return files
  end

  while true do
    local name, type = vim.uv.fs_scandir_next(scanner)
    if not name then
      break
    end

    local ts_path = dir .. "/" .. name
    if type == "file" and name:match("%.ts$") and ts_path ~= preferred then
      table.insert(files, ts_path)
    end
  end

  return files
end

local function is_referenced_angular_template(path)
  if not path:match("%.html$") then
    return false
  end

  local template_name = vim.fs.basename(path)
  for _, ts_path in ipairs(get_sibling_ts_files(path)) do
    if references_template(ts_path, template_name) then
      return true
    end
  end

  return false
end

local function switch_to(exts)
  return function()
    local path = vim.api.nvim_buf_get_name(0)
    local base = get_component_base(path)
    local targets = {}

    if not base then
      vim.notify("Current file is not html, scss, css, or ts", vim.log.levels.WARN)
      return
    end

    for _, ext in ipairs(exts) do
      local target = base .. ext
      table.insert(targets, vim.fs.basename(target))
      if target ~= path and vim.uv.fs_stat(target) then
        vim.cmd.edit(vim.fn.fnameescape(target))
        return
      end
    end

    if vim.tbl_contains(targets, vim.fs.basename(path)) then
      return
    end

    vim.notify("No matching file found: " .. table.concat(targets, ", "), vim.log.levels.WARN)
  end
end

M.setup = function()
  local group = vim.api.nvim_create_augroup("personal_angular_filetype", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "html",
    callback = function(args)
      local path = vim.api.nvim_buf_get_name(args.buf)
      if path ~= "" and is_referenced_angular_template(path) then
        vim.bo[args.buf].filetype = "htmlangular"
      end
    end,
  })

  vim.keymap.set("n", "<leader>at", switch_to({ ".ts" }), { desc = "Angular component TS" })
  vim.keymap.set("n", "<leader>ah", switch_to({ ".html" }), { desc = "Angular component HTML" })
  vim.keymap.set("n", "<leader>as", switch_to({ ".scss", ".css" }), { desc = "Angular component style" })
end

return M
