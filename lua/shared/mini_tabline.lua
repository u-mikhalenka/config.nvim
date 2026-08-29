local M = {}

M.get_options = function()
  return {
    show_icons = true,
    tabpage_section = "right",
    format = function(buf_id, label)
      local text = require("mini.tabline").default_format(buf_id, label)

      -- Remove trailing padding before adding the indicator.
      text = text:gsub("%s+$", "")

      local modified = vim.bo[buf_id].modified and " ●" or ""
      return text .. modified .. " "
    end,
  }
end

return M
