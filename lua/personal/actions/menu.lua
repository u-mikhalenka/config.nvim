local M = {}

local H = {}
local closing = false
local ns = vim.api.nvim_create_namespace("personal_action_menu")
local state = {
  view = nil,
  stack = {},
  current = nil,
  source_buf = nil,
  win = nil,
}

H.save_view = function(entry)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    entry.view = vim.api.nvim_win_call(state.win, vim.fn.winsaveview)
  end
end

H.restore_view = function(entry)
  if entry.view then
    vim.api.nvim_win_call(state.win, function()
      vim.fn.winrestview(entry.view)
    end)
  end
end

H.apply_win_options = function(win)
  vim.wo[win].cursorline = true
  vim.wo[win].cursorlineopt = "line"
  vim.wo[win].cursorcolumn = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].wrap = false
end

H.get_menu_width = function(menu)
  local len = string.len(H.filter_title())
  for _, item in ipairs(menu) do
    len = math.max(len, string.len(item.desc))
  end
  return math.max(len + 2, 32)
end

H.filter_title = function()
  local current = state.current
  if current == nil or current.filter == nil or current.filter == "" then
    return ""
  end

  return "Filter: " .. current.filter
end

H.get_win_config = function(menu)
  local width = H.get_menu_width(menu)
  local height = math.max(#menu, 1)
  return {
    focusable = true,
    relative = "editor",
    col = math.floor((vim.o.columns - width) / 2),
    row = 10, -- math.floor((vim.o.lines - height) / 2),
    width = width,
    height = height,
    style = "minimal",
    border = "single",
    title = H.filter_title(),
    title_pos = "center",
    zindex = 99,
  }
end

H.filtered_menu = function(menu, filter)
  if filter == nil or filter == "" then
    return menu
  end

  local filtered = {}
  local lower_filter = string.lower(filter)
  for _, item in ipairs(menu) do
    if string.find(string.lower(item.desc), lower_filter, 1, true) then
      table.insert(filtered, item)
    end
  end

  return filtered
end

H.render_buf = function(buf, menu)
  vim.bo[buf].modifiable = true

  local lines = {}
  if #menu == 0 then
    lines = { "(no matches)" }
  else
    for _, item in ipairs(menu) do
      table.insert(lines, " " .. item.desc)
    end
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for i, item in ipairs(menu) do
    if item.menu ~= nil then
      vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
        virt_text = { { "", "Special" } },
        virt_text_pos = "right_align",
      })
    end
  end

  vim.bo[buf].modifiable = false
end

H.refresh_current = function()
  local current = state.current
  if current == nil then
    return
  end

  current.menu = H.filtered_menu(current.source_menu, current.filter)
  H.render_buf(current.buf, current.menu)
  current.config = H.get_win_config(current.menu)

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_config(state.win, current.config)
    vim.api.nvim_win_set_cursor(state.win, { 1, 0 })
  end
end

H.set_filter = function(filter)
  if state.current == nil then
    return
  end

  state.current.filter = filter
  H.refresh_current()
end

H.append_filter = function(char)
  if state.current == nil then
    return
  end

  H.set_filter((state.current.filter or "") .. char)
end

H.delete_filter_char = function()
  if state.current == nil then
    return false
  end

  local filter = state.current.filter or ""
  if filter == "" then
    return false
  end

  H.set_filter(string.sub(filter, 1, -2))
  return true
end

H.prompt_filter = function()
  if state.current == nil then
    return
  end

  require("personal.actions.ui").input("Filter: ", state.current.filter or "", function(value)
    H.set_filter(value)
  end)
end

H.push_menu = function(menu)
  H.save_view(state.current)
  table.insert(state.stack, state.current)

  local buf = H.create_buf()

  state.current = {
    source_menu = menu,
    menu = menu,
    filter = "",
    buf = buf,
    config = nil,
    view = nil,
  }

  vim.api.nvim_win_set_buf(state.win, buf)
  H.refresh_current()
  H.apply_win_options(state.win)
  H.restore_view(state.current)
end

H.try_open_submenu = function()
  local current = H.current_item()
  if current.menu ~= nil then
    H.push_menu(current.menu())
  end
end

H.pop_menu = function()
  if #state.stack == 0 then
    return
  end

  H.save_view(state.current)

  local previous = table.remove(state.stack)
  state.current = previous

  vim.api.nvim_win_set_buf(state.win, previous.buf)
  vim.api.nvim_win_set_config(state.win, previous.config)
  H.apply_win_options(state.win)
  H.restore_view(previous)
end

H.current_item = function()
  local row = vim.api.nvim_win_get_cursor(state.win)[1]
  return state.current.menu[row]
end

H.move = function(delta)
  local current = state.current
  if current == nil or #current.menu == 0 then
    return
  end

  local row = vim.api.nvim_win_get_cursor(state.win)[1] + delta
  if row < 1 then
    row = #current.menu
  elseif row > #current.menu then
    row = 1
  end

  vim.api.nvim_win_set_cursor(state.win, { row, 0 })
end

H.create_buf = function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"

  vim.keymap.set("n", "<CR>", function()
    local item = H.current_item()
    if item == nil then
      return
    end

    if item.menu then
      H.push_menu(item.menu())
    elseif item.action then
      H.close_menu()
      item.action()
    end
  end, { buffer = buf })

  vim.keymap.set("n", "<Up>", function()
    H.move(-1)
  end, { buffer = buf, desc = "Previous item" })
  vim.keymap.set("n", "<Down>", function()
    H.move(1)
  end, { buffer = buf, desc = "Next item" })
  vim.keymap.set("n", "<Left>", H.pop_menu, { buffer = buf, desc = "Parent menu" })
  vim.keymap.set("n", "<Right>", H.try_open_submenu, { buffer = buf, desc = "Open submenu" })
  vim.keymap.set("n", "<BS>", function()
    if not H.delete_filter_char() then
      H.pop_menu()
    end
  end, { buffer = buf })
  vim.keymap.set("n", "<C-f>", H.prompt_filter, { buffer = buf, desc = "Set filter" })

  for char in string.gmatch("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._/-", ".") do
    vim.keymap.set("n", char, function()
      H.append_filter(char)
    end, { buffer = buf, nowait = true, desc = "Filter menu" })
  end

  vim.keymap.set("n", "<Esc>", H.close_menu, { buffer = buf, desc = "Close menu" })

  return buf
end

H.close_menu = function()
  if closing then
    return
  end

  closing = true
  local win = state.win
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end

  for _, entry in ipairs(state.stack) do
    if entry.buf and vim.api.nvim_buf_is_valid(entry.buf) then
      vim.api.nvim_buf_delete(entry.buf, { force = true })
    end
  end

  local current = state.current
  if current and current.buf and vim.api.nvim_buf_is_valid(current.buf) then
    vim.api.nvim_buf_delete(current.buf, { force = true })
  end

  state.stack = {}
  state.current = nil
  state.source_buf = nil
  state.win = nil
  closing = false
end

H.open_menu = function(menu)
  state.source_buf = vim.api.nvim_get_current_buf()

  local buf = H.create_buf()
  state.current = {
    source_menu = menu,
    menu = menu,
    filter = "",
    buf = buf,
    config = nil,
    view = nil,
  }

  H.refresh_current()
  local config = state.current.config

  ---@diagnostic disable-next-line: param-type-mismatch
  local win = vim.api.nvim_open_win(buf, true, config)

  H.apply_win_options(win)

  state.win = win

  local augroup = vim.api.nvim_create_augroup("PersonalMenu", { clear = false })
  vim.api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    pattern = tostring(win),
    once = true,
    callback = function()
      H.close_menu()
    end,
  })
end

H.is_open = function()
  return state.win ~= nil and vim.api.nvim_win_is_valid(state.win)
end

M.source_buf = function()
  if state.source_buf and vim.api.nvim_buf_is_valid(state.source_buf) then
    return state.source_buf
  end

  return vim.api.nvim_get_current_buf()
end

M.open_menu = function(menu)
  if H.is_open() then
    H.close_menu()
  end
  H.open_menu(menu)
end

return M
