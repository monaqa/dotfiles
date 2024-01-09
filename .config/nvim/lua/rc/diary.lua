local util = require "rc.util"
local uv = vim.loop

local M = {}

local root_dir = "/Users/monaqa/ghq/github.com/monaqa/diary/"

function M.setup()
    util.create_cmd("Diary", function()
        local ym = vim.fn.strftime "%Y/%m/"
        local content_file = root_dir .. "content/" .. ym .. "diary.typ"
        vim.cmd.edit(content_file)
    end)
end

return M
