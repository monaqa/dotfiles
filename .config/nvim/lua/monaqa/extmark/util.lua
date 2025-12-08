local M = {}

---@class monaqa.extmark.Position
---@field bufnr integer
---@field lnum integer
---@field col integer
---@field offset integer
---@field curswant? integer
local Position = {}

function Position:lnum0()
    return self.lnum - 1
end

function Position:col0()
    return self.col - 1
end

function Position:lnum1()
    return self.lnum
end

function Position:col1()
    return self.col
end

function Position:marker()
    return { self:lnum0(), self:col0() }
end

function Position:marker_linestart()
    return { self:lnum0(), 0 }
end

function Position:marker_lineend()
    local line = vim.fn.getbufline(vim.fn.bufname(self.bufnr), self.lnum)[1]
    return { self:lnum0(), vim.fn.strlen(line) }
end

function M.pos(expr)
    if expr == "." then
        local result = vim.fn.getcurpos()
        return setmetatable({
            bufnr = vim.fn.bufnr(),
            lnum = result[2],
            col = result[3],
            offset = result[4],
            curswant = result[5],
        }, { __index = Position })
    end
    local result = vim.fn.getpos(expr)
    return setmetatable({
        bufnr = result[1],
        lnum = result[2],
        col = result[3],
        offset = result[4],
    }, { __index = Position })
end

return M
