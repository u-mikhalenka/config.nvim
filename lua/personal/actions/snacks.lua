local M = {}

M.snacks_menu = function()
  if Snacks == nil then
    return
  end

  return {
    {
      desc = "Autocmd",
      action = function()
        Snacks.picker.autocmds()
      end,
    },
    {
      desc = "Command History",
      action = function()
        Snacks.picker.command_history()
      end,
    },
    {
      action = function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      action = function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      action = function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      action = function()
        Snacks.picker.icons()
      end,
      desc = "Icons",
    },
    {
      action = function()
        Snacks.picker.highlights()
      end,
      desc = "Highlights",
    },
    {
      action = function()
        Snacks.picker.man()
      end,
      desc = "Man Pages",
    },
  }
end
return M
