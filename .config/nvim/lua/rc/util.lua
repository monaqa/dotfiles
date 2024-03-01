local M = {}

local monaqa = require "monaqa"

M.trim = monaqa.str.trim
M.cmdcr = monaqa.str.cmdcr
M.esc = monaqa.str.esc
M.to_bool = monaqa.logic.to_bool
M.ifexpr = monaqa.logic.ifexpr
M.unwrap_or = monaqa.logic.unwrap_or
M.autocmd_vimrc = monaqa.shorthand.autocmd_vimrc
M.create_cmd = monaqa.shorthand.create_cmd
M.link_filetype = monaqa.shorthand.link_filetype
M.sethl = monaqa.shorthand.sethl
M.load_cwd_as_plugin = monaqa.shorthand.load_cwd_as_plugin

---エラーとしてメッセージを出力する。
---@param message string
---@param hl string?
function M.print_error(message, hl)
    if hl == nil then
        hl = "Error"
    end
    vim.api.nvim_echo({ { message, hl } }, true, {})
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

---横に広いウィンドウか、縦に広いウィンドウか判定する。
---ただし判定基準は割と適当。
---@param window_number number | string
---@return boolean
function M.is_wide_window(window_number)
    local wd = vim.fn.winwidth(window_number)
    local ht = vim.fn.winheight(window_number)
    return wd > 2.2 * ht
end

---横に広ければ鉛直に、縦に広ければ水平に分割する。
function M.split_window()
    if M.is_wide_window "." then
        vim.cmd [[vsplit]]
    else
        vim.cmd [[split]]
    end
end

---モーションに優先順位をつけ、高いものから順に実行する。
---ただしカーソルが動いたらその時点で処理を止める。つまり、
---`motion_autoselect {motion1, motion2, motion3}` を実行すると、
---1. motion1 を実行
---2. motion1 の結果カーソルが動いたら処理を止める。そうでなければ motion2 を実行
---3. motion2 の結果カーソルが動いたら処理を止める。そうでなければ motion3 を実行
---のように動作する。
---@param motion_seq fun()[]
function M.motion_autoselect(motion_seq)
    local init_line = vim.fn.line "."
    local init_col = vim.fn.col "."
    for _, motion in ipairs(motion_seq) do
        motion()
        local line = vim.fn.line "."
        local col = vim.fn.col "."
        if not (line == init_line and col == init_col) then
            return
        end
    end
end

return M
