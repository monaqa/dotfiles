local M = {}

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
