---@class UtilsModule
local M = {}

--- checks if the window is not floating and if its buftype is `""`
---@param win integer taget window id
---@return boolean is_main_win true if window is main window, otherwise false
function M.is_main_win(win)
  if vim.api.nvim_win_get_config(win).relative ~= "" then
    return false
  end
  return vim.bo[vim.api.nvim_win_get_buf(win)].buftype == ""
end

--- focuses the main window. uses `is_main_win`
--- when the main window is not found, runs `enew` which will take over all other windows
---@return integer main_win_id the id of the main window
function M.get_main_win()
  local cur = vim.api.nvim_get_current_win()
  if M.is_main_win(cur) then
    return cur
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if M.is_main_win(win) then
      return win
    end
  end
  vim.cmd("enew")
  return vim.api.nvim_get_current_win()
end

--- returns the id of the next non-floating window available
---@return integer window_id
function M.next_normal_win()
  local cur = vim.api.nvim_get_current_win()
  local wins = vim.tbl_filter(function(w)
    return vim.api.nvim_win_get_config(w).relative == ""
  end, vim.api.nvim_tabpage_list_wins(0))

  if #wins == 0 then
    return 0
  end

  local idx
  for i, w in ipairs(wins) do
    if w == cur then
      idx = i
      break
    end
  end

  return wins[(idx or 0) % #wins + 1]
end

--- creates a function that moves either forward or backward through diagnostics of a specified severity
---@param next boolean wether to move forward or backward
---@param severity string? the diagnostic name eg WARN or ERROR
---@return function jumper function a function that when run will preform the movement
function M.diagnostic_goto(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

return M
