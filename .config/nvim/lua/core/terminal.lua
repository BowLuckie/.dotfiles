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

--- sets the current buffer to the next lowest buffer id of a terminal buffer
function M.cycle_terminal_buffer()
  local terminals = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      table.insert(terminals, buf)
    end
  end

  if #terminals == 0 then
    vim.notify("No terminal buffers open", vim.log.levels.WARN)
    return
  end

  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_idx = 1
  for i, buf in ipairs(terminals) do
    if buf == cur_buf then
      cur_idx = i
      break
    end
  end

  vim.api.nvim_set_current_buf(terminals[(cur_idx % #terminals) + 1])
end

return M
