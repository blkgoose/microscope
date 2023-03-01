local stream = require("yaff.stream")
local files_lists = require("yaff.files.lists")
local lists = require("yaff.lists")
local highlight = require("yaff.files.highlight")

local files = {}

function files.open(data, win, _)
  vim.cmd("e " .. data.text)
  if data.row and data.col then
    local cursor = { data.row, data.col }
    vim.api.nvim_win_set_cursor(win, cursor)
  end
end

function files.preview(data, win, buf)
  local cursor
  if data.col and data.row then
    cursor = { data.row, data.col }
  else
    cursor = { 1, 0 }
  end
  stream
    .chain({
      files_lists.cat(data.text),
      lists.head(5000),
    }, function(lines)
      vim.schedule(function()
        vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
        highlight(data.text, buf)
        vim.api.nvim_win_set_cursor(win, cursor)
      end)
    end)
    :start()
end

files.lists = require("yaff.files.lists")

return files
