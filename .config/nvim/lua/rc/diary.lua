local util = require "rc.util"
local uv = vim.loop

local M = {}

local root_dir = "/Users/monaqa/ghq/github.com/monaqa/diary/"

function M.is_diary_file()
    local path = vim.fn.bufname()
    return vim.startswith(path, root_dir)
end

function M.preview_file()
    local path = vim.fn.bufname()
    return vim.fn.fnamemodify(path, ":h") .. "/preview.typ"
end

function M.compile(file)
    uv.spawn("typst", {
        args = {
            "compile",
            file,
        },
    }, function(code, signal)
        vim.schedule(function()
            if code == 0 then
                util.print_error("Compile succeeded", "Normal")
            else
                util.print_error(("Compile failed (return code: %s)"):format(code), "Warning")
            end
        end)
    end)
end

function M.setup()
    util.create_cmd("Diary", function()
        local ym = vim.fn.strftime "%Y/%m/"
        local content_file = root_dir .. "content/" .. ym .. "diary.typ"
        vim.cmd.edit(content_file)
    end)
end

return M
