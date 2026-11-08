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

function M.next_normal_win()
  local cur = vim.api.nvim_get_current_win()
  local wins = vim.tbl_filter(function(w)
    return vim.api.nvim_win_get_config(w).relative == ""
  end, vim.api.nvim_tabpage_list_wins(0))

  if #wins == 0 then
    return
  end

  local idx
  for i, w in ipairs(wins) do
    if w == cur then
      idx = i
      break
    end
  end

  vim.api.nvim_set_current_win(wins[(idx or 0) % #wins + 1])
end

return M
