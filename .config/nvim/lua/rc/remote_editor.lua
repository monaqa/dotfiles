local create_cmd_local = require("monaqa.shorthand").create_cmd_local

local M = {}
local pending = {}

---@class monaqa.remote_editor.session
---@field window integer
---@field terminal integer
---@field status_file string

function M.before()
    local win = vim.api.nvim_get_current_win()
    local terminal = vim.api.nvim_win_get_buf(win)
    if vim.bo[terminal].buftype ~= "terminal" then
        error("remote editor must be opend from a terminal window")
    end
    pending[win] = terminal
end

function M.attach(status_file)
    local win = vim.api.nvim_get_current_win()
    local terminal = pending[win]
    pending[win] = nil
    if not terminal or not vim.api.nvim_buf_is_valid(terminal) then
        error("remote editor lost its terminal window")
    end

    local buf = vim.api.nvim_get_current_buf()
    ---@type monaqa.remote_editor.session
    vim.b[buf].remote_editor = { window = win, terminal = terminal, status_file = status_file }

    create_cmd_local("RemoteEditorFinish") {
        buffer = buf,
        function()
            M.finish(true)
        end
    }

    -- ユーザが `:q!` を押したときの展開先。 `!` は消えないためそのまま。
    create_cmd_local("RemoteEditorAbort") {
        bang = true,
        buffer = buf,
        function()
            M.finish(false)
        end
    }
end

function M.finish(save)
    local buf = vim.api.nvim_get_current_buf()
    ---@type monaqa.remote_editor.session
    local session = vim.b[buf].remote_editor
    if not session then
        return
    end

    if save then
        vim.cmd.write()
    end
    if not vim.api.nvim_win_is_valid(session.window) or not vim.api.nvim_buf_is_valid(session.terminal) then
        error("remote editor lost its terminal window")
    end

    vim.api.nvim_win_set_buf(session.window, session.terminal)

    if save then
        local file = assert(io.open(session.status_file, "w"))
        file:write("ok\n")
        file:close()
    end

    vim.api.nvim_buf_delete(buf, { force = true })
    vim.schedule(function()
        if vim.api.nvim_get_current_win() == session.window then
            vim.cmd.startinsert()
        end
    end)
end

return M
