local util = require "rc.util"
local vec = require "rc.util.vec"

local M = {}

local root_dir = "/Users/monaqa/ghq/github.com/monaqa/diary/"

function M.complete(arglead, cmdline, cursorpos)
    local year = vim.fn.strftime "%Y"
    local content_dir = root_dir .. "content/" .. year .. "/"
    local paths = vec(vim.split(vim.fn.globpath(content_dir, "**/*.typ"), "\n", true))
    local cwd = vim.fn.chdir(content_dir)
    local cands = paths:filter_map(function(path)
        local cand = vim.fn.fnamemodify(path, ":.:r")
        if cand:find(arglead, 1, true) then
            return cand
        end
    end)
    vim.fn.chdir(cwd)
    return cands:collect()
end

function M.setup()
    util.create_cmd("Diary", function(meta)
        local year = vim.fn.strftime "%Y"
        local month = vim.fn.strftime "%m"
        local fname = util.ifexpr(meta.args == "", "diary/" .. month, meta.args)
        local content_file = root_dir .. "content/" .. year .. "/" .. fname .. ".typ"
        vim.cmd.edit(content_file)
    end, { nargs = "?", complete = M.complete })
end

return M
