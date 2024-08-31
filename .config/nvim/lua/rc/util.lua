local M = {}

local monaqa = require("monaqa")

M.trim = monaqa.str.trim
M.cmdcr = monaqa.str.cmdcr
M.esc = monaqa.str.esc
M.to_bool = monaqa.logic.to_bool
M.ifexpr = monaqa.logic.ifexpr
M.unwrap_or = monaqa.logic.unwrap_or
M.autocmd_vimrc = monaqa.shorthand.autocmd_vimrc
M.link_filetype = monaqa.shorthand.link_filetype
M.sethl = monaqa.shorthand.sethl
M.load_cwd_as_plugin = monaqa.shorthand.load_cwd_as_plugin
M.is_wide_window = monaqa.window.is_wide
M.split_window = monaqa.window.wise_split

---エラーとしてメッセージを出力する。
---@param message string
---@param hl string?
function M.print_error(message, hl)
    if hl == nil then
        hl = "Error"
    end
    vim.api.nvim_echo({ { message, hl } }, true, {})
end

--- nvim_create_user_command って長ったらしいしオプション省略できないっぽいので。
function M.create_cmd(name, impl, options)
    if options == nil then
        options = {}
    end
    vim.api.nvim_create_user_command(name, impl, options)
end

---ある要素を n 回繰り返した array を返す。
---@generic T
---@param x T
---@param n integer
---@return T[]
function M.rep_elem(x, n)
    local tbl = {}
    for _ = 1, n, 1 do
        table.insert(tbl, x)
    end
    return tbl
end

---複数の array を concat した array を返す。
---@generic T
---@param arys T[][]
---@return T[]
function M.list_concat(arys)
    local tbl = {}
    for _, ary in ipairs(arys) do
        vim.list_extend(tbl, ary)
    end
    return tbl
end

-- ---各要素を変換する高階関数を返す。
-- ---@generic T
-- ---@generic U
-- ---@param func fun(x: T): U
-- ---@return fun(xs: T[]): U[]
-- function M.map(func)
--     return function(xs)
--         vim.tbl_map(func, xs)
--     end
-- end

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

return M
