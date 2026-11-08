---@class BuildEntry
---@field name string file name
---@field tool string command used eg `just` or `make`

---@class BuildFile
---@field path string
---@field tool string

--- Quick build module
---@class BuildModule
local M = {}

local terminal = require("core.terminal")

local PREFIX = "<leader>j"

--- first match per tool wins
---@type BuildEntry[]
local BUILD_FILES = {
  { name = "GNUmakefile", tool = "make" },
  { name = "makefile", tool = "make" },
  { name = "Makefile", tool = "make" },
  { name = "justfile", tool = "just" },
  { name = "Justfile", tool = "just" },
  { name = ".justfile", tool = "just" },
}

-- ([%w_%.%-]+) capture group: [%w_%.%-]+ captures the first word
-- %s* whitespace (0 or more)
-- (:.*) capture group: :.* captures a colon, and then everything else
local TARGET_PATTERN = "^([%w_%.%-]+)%s*(:.*)$"

---@type string[]
local registered = {}

---@return BuildFile[]
local function find_build_files()
  local found, seen_tools = {}, {}

  for _, entry in ipairs(BUILD_FILES) do
    if not seen_tools[entry.tool] then
      local path = vim.fs.find(entry.name, { upward = true, type = "file" })[1]
      if path then
        seen_tools[entry.tool] = true
        table.insert(found, { path = path, tool = entry.tool })
      end
    end
  end

  return found
end

---@param path string
---@return string[]
local function get_targets(path)
  local targets, seen = {}, {}

  for _, line in ipairs(vim.fn.readfile(path)) do
    local target, rest = line:match(TARGET_PATTERN)
    if
      target
      and not rest:match("^:+=") -- assignment operators `:= v...`
      and not target:match("^%.") -- .PHONY .DEFAULT...
      and not seen[target]
    then
      seen[target] = true
      table.insert(targets, target)
    end
  end

  return targets
end

---@param target string
---@param used table<string, boolean>
---@return string?
local function assign_key(target, used)
  for char in target:lower():gmatch("%a") do
    if not used[char] then
      used[char] = true
      return char
    end
  end
  vim.notify(("build: no free key for target '%s'"):format(target), vim.log.levels.WARN)
end

---@param build BuildFile
---@param target string
local function run(build, target)
  if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
    vim.cmd("update")
  end

  local tbuf = terminal.get_or_create_terminal()
  local job_id = vim.b[tbuf].terminal_job_id

  if job_id then
    vim.api.nvim_chan_send(job_id, build.tool .. " " .. target .. "\r")
  end
end

local function clear_keymaps()
  for _, lhs in ipairs(registered) do
    pcall(vim.keymap.del, "n", lhs)
  end
  registered = {}
end

function M.reload()
  clear_keymaps()

  local used = { j = true }
  local default_taken = false

  for _, build in ipairs(find_build_files()) do
    for _, target in ipairs(get_targets(build.path)) do
      local key

      if (target == "default" or target == "all") and not default_taken then
        key = "j"
        default_taken = true
      else
        key = assign_key(target, used)
      end

      if key then
        local lhs = PREFIX .. key
        vim.keymap.set("n", lhs, function()
          run(build, target)
        end, { desc = build.tool .. " " .. target })
        table.insert(registered, lhs)
      end
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("BuildKeymaps", { clear = true })

  local names = vim.tbl_map(function(entry)
    return entry.name
  end, BUILD_FILES)

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = names,
    callback = M.reload,
  })

  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = M.reload,
  })

  vim.api.nvim_create_user_command("BuildKeymapsReload", M.reload, {})
  vim.keymap.set("n", PREFIX .. "R", "<cmd>BuildKeymapsReload<CR>", { desc = "reload build keymaps" })

  M.reload()
end

return M
