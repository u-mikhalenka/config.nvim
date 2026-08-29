local M = {}

M.input = function(prompt, default, callback)
  vim.ui.input({ prompt = prompt, default = default }, function(value)
    if not value or value == "" then
      return
    end

    callback(value)
  end)
end

M.confirm = function(prompt, callback)
  vim.ui.select({ "No", "Yes" }, { prompt = prompt }, function(choice)
    if choice == "Yes" then
      callback()
    end
  end)
end

return M
