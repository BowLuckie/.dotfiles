---@class TerminalModule
local M = {}

local utils = require("core.utils")

--- focuses the first buffer focused window. if no window exists, makes one with `get_main_win`
--- if no terminal buffer exists, makes a new one.
---@return integer term_bufid The buffer id of the focused terminal buffer
function M.get_or_create_terminal()
  ---@type integer
  local terminal_buf

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      terminal_buf = buf
      break
    end
  end

  if terminal_buf then
    local win = vim.fn.bufwinid(terminal_buf)
    if win ~= -1 then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      return terminal_buf
    end
  end

  --- if no window exists, just put it in the main window
  vim.api.nvim_set_current_win(utils.get_main_win())

  if terminal_buf then
    vim.api.nvim_set_current_buf(terminal_buf)
  else
    vim.cmd("term")
  end

  vim.cmd("startinsert")
  return vim.api.nvim_get_current_buf()
end

--- toggles between normal and insert in the terminal. gets/creates a terminal if not already on one.
function M.toggle_terminal_focus()
  if vim.bo.buftype == "terminal" then
    vim.cmd("stopinsert")
    if vim.api.nvim_get_mode().mode == "nt" then -- normal terminal
      vim.cmd("startinsert")
    end
  else
    M.get_or_create_terminal() --- will start insert
  end
end

return M
