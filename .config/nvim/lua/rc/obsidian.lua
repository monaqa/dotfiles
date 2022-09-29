-- Obsidian の編集に関する設定
local M = {}

local util = require "rc.util"
local ts_utils = require 'nvim-treesitter.ts_utils'
local query    = require 'vim.treesitter.query'

M.root_dir = vim.fn.getenv("HOME") .. "/Documents/obsidian/mogamemo/"
M.diary_dir = M.root_dir .. "diary/"
M.note_dir = M.root_dir .. "note/"

M.file_pattern = {
        "*/*.md",
        "*/*/*.md",
}

function M.diary_template()
    local template = [[
---
tags: ["diary", ]
alias: []
---

# To Do

# Log
]]
    return vim.split(template.gsub("^%s*(.-)%s*$", "%1"), "\n", true)
end

---@return string[]
function M.get_fnames()
    ---@type string[]
    local fnamelstlst = {}
    for _, ptn in ipairs(M.file_pattern) do
        local glob = M.root_dir .. ptn
        local paths = vim.fn.glob(glob, false, true)
        table.insert(fnamelstlst, paths)
    end
    local fnames = vim.tbl_flatten(fnamelstlst)
    local relpaths = vim.tbl_map(function (s)
        return s:sub(#M.root_dir + 1)
    end, fnames)
    return relpaths
end

---@return string[]
function M.get_omni_cands()
    ---@type string[]
    local relpaths = M.get_fnames()
    local cands = vim.tbl_map(
        ---@param s string
        ---@return string
        function (s)
            local idx = s:find("/")
            return s:sub(idx + 1)
        end,
        relpaths
    )
    return cands
end

function M.open_diary(arg)
    local fname
    if arg == "" then
        fname = vim.fn.strftime("%Y-%m-%d")
    else
        fname = arg
    end
    local diary_path = M.diary_dir .. fname .. ".md"
    vim.cmd("e " .. diary_path)
    if not util.to_bool(vim.fn.filereadable(diary_path)) then
        vim.fn.setline(1, {
            "---",
            "tags: []",
            "alias: []",
            "---",
            "",
            "# To Do",
            "",
            "# Log",
        })
    end
end

function M.open_diary_complete(arglead, cmdline, cursorpos)
    local paths = vim.split(vim.fn.globpath(M.diary_dir, "*.md"), "\n", true)
    local cands = vim.tbl_map(function (path)
        local stem = vim.fn.fnamemodify(path, ":t:r")
        if stem == vim.fn.strftime("%Y-%m-%d") then
            return nil
        end
        return stem
    end, paths)
    cands = vim.fn.reverse(cands)
    return cands
end

function M.open_fern()
    vim.cmd("Fern " .. M.root_dir .. " -reveal=note")
end

function M.get_cursor_shortcut_link()
    local node = ts_utils.get_node_at_cursor()
    if node:type() == "link_text" then
        local parent = node:parent()
        if parent:type() == "shortcut_link" then
            return query.get_node_text(node, 0)
        end
    end
    return nil
end

function M.grep_keyword(kwd)
    vim.cmd(
        [[silent grep ]] .. vim.fn.string(kwd) .. " " .. M.root_dir
    )
end

function M.omnifunc(findstart, base)
    if util.to_bool(findstart) then
        ---@type string
        local line = vim.fn.getline(".")
        local start = vim.fn.col(".")
        vim.pretty_print{line = line, start = start, sub = line:sub(start, start)}
        while start > 0 do
            start = start - 1
            if line:sub(start, start) == "[" then
                return start
            end
        end
        return vim.fn.col(".") - 1
    end

    ---@type string[]
    local fnames = M.get_omni_cands()
    local resp = vim.tbl_map(function (s)
        return vim.split(s, ".", {plain = true})[1]
    end, fnames)
    local filtered = vim.tbl_filter(function (s)
        return vim.regex("^" .. base):match_str(s) ~= nil
    end, resp)
    return filtered
end

return M
