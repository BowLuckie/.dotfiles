---@class TerminalModule
local M = {}

--- focuses the first terminal window if one exists, otherwise creates a new one
---@return integer term_bufid The buffer id of the focused terminal buffer
function M.get_or_create_terminal()
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

  if terminal_buf then
    vim.api.nvim_set_current_buf(terminal_buf)
  else
    vim.cmd("enew")
    vim.cmd("term")
  end

  vim.cmd("startinsert")
  return vim.api.nvim_get_current_buf()
end

return M
