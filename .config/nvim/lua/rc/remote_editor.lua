local create_cmd_local = require("monaqa.shorthand").create_cmd_local

local M = {}
local pending = {}

---@class monaqa.remote_editor.session
---@field window integer
---@field terminal_window integer
---@field terminal integer
---@field status_file string

function M.before()
    local win = vim.api.nvim_get_current_win()
    local terminal = vim.api.nvim_win_get_buf(win)
    if vim.bo[terminal].buftype ~= "terminal" then
        error("remote editor must be opend from a terminal window")
    end
    vim.cmd("belowright split")
    local editor_win = vim.api.nvim_get_current_win()
    pending[editor_win] = { window = win, terminal = terminal }
end

function M.attach(status_file)
    local win = vim.api.nvim_get_current_win()
    local origin = pending[win]
    pending[win] = nil
    if not origin or not vim.api.nvim_win_is_valid(origin.window) or not vim.api.nvim_buf_is_valid(origin.terminal) then
        error("remote editor lost its terminal window")
    end

    local buf = vim.api.nvim_get_current_buf()
    ---@type monaqa.remote_editor.session
    vim.b[buf].remote_editor = {
        window = win,
        terminal_window = origin.window,
        terminal = origin.terminal,
        status_file = status_file,
    }

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
    if
        not vim.api.nvim_win_is_valid(session.window)
        or not vim.api.nvim_win_is_valid(session.terminal_window)
        or not vim.api.nvim_buf_is_valid(session.terminal)
    then
        error("remote editor lost its terminal window")
    end

    if save then
        local file = assert(io.open(session.status_file, "w"))
        file:write("ok\n")
        file:close()
    end

    -- ウィンドウを閉じることで BufDelete が発生する場合もあるため、成功通知を先に書く。
    vim.api.nvim_win_close(session.window, true)
    vim.api.nvim_win_set_buf(session.terminal_window, session.terminal)
    vim.api.nvim_set_current_win(session.terminal_window)
    if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
    end
    vim.schedule(function()
        if
            vim.api.nvim_win_is_valid(session.terminal_window)
            and vim.api.nvim_get_current_win() == session.terminal_window
            and vim.api.nvim_get_current_buf() == session.terminal
        then
            vim.cmd.startinsert()
        end
    end)
end

return M
