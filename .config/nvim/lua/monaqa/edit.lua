local M = {}

---モーションに優先順位をつけ、高いものから順に実行する。
---ただしカーソルが動いたらその時点で処理を止める。つまり、
---`motion_autoselect {motion1, motion2, motion3}` を実行すると、
---1. motion1 を実行
---2. motion1 の結果カーソルが動いたら処理を止める。そうでなければ motion2 を実行
---3. motion2 の結果カーソルが動いたら処理を止める。そうでなければ motion3 を実行
---のように動作する。
---@param motion_seq fun()[]
function M.motion_autoselect(motion_seq)
    local init_line = vim.fn.line(".")
    local init_col = vim.fn.col(".")
    for _, motion in ipairs(motion_seq) do
        motion()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        if not (line == init_line and col == init_col) then
            return
        end
    end
end

--- 一時的にオプションの値を差し替えて callback を実行する。
--- もとの値は callback 実行後にリストアされる。
function M.with_opt(t)
    return function(callback)
        local backup = {}
        for key, value in pairs(t) do
            backup[key] = vim.opt[key]:get()
            vim.opt[key] = value
        end
        local succeeded, result = pcall(callback)
        for key, value in pairs(backup) do
            vim.opt[key] = value
        end
        if succeeded then
            return result
        else
            error(result)
        end
    end
end

--- 一時的に環境変数の値を差し替えて callback を実行する。
--- もとの値は callback 実行後にリストアされる。
function M.with_env(t)
    return function(callback)
        local backup = {}
        for key, value in pairs(t) do
            -- もし backup[key] = vim.env[key] のように直接値を入れると
            -- vim.env[key] が nil のとき backup に何も入らなくなってしまう。
            backup[key] = { origin = vim.env[key] }
            vim.env[key] = value
        end
        local succeeded, result = pcall(callback)
        for key, tbl in pairs(backup) do
            vim.env[key] = tbl.origin
        end
        if succeeded then
            return result
        else
            error(result)
        end
    end
end

--- レジスタを一時的に借りる。もとの値は callback 実行後にリストアされる。
function M.borrow_register(t)
    return function(callback)
        local backup = {}
        for _, reg in ipairs(t) do
            backup[reg] = vim.fn.getreginfo(reg)
        end
        local succeeded, result = pcall(callback)
        for reg, value in pairs(backup) do
            vim.fn.setreg(reg, value)
        end
        if succeeded then
            return result
        else
            error(result)
        end
    end
end

--- vim.ui.input と vim.ui.select を一時的に同期的な UI にして callback を実行する。
function M.with_sync_ui(callback)
    local original_input = vim.ui.input
    local original_select = vim.ui.select
    vim.ui.input = function(opts, on_confirm)
        local result = vim.fn.input(opts)
        on_confirm(result)
    end
    vim.ui.select = function(items, opts, on_choice)
        local prompt = opts.prompt or "Select one of:"
        local format_item = opts.format_item or tostring
        local t = { prompt }
        for idx, item in ipairs(items) do
            t[#t + 1] = tostring(idx) .. ". " .. format_item(item)
        end
        local result = vim.fn.inputlist(t)
        on_choice(items[result])
    end
    local succeeded, result = pcall(callback)
    vim.ui.input = original_input
    vim.ui.select = original_select
    if succeeded then
        return result
    else
        error(result)
    end
end

return M
