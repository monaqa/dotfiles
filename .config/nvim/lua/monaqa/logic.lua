local M = {}

---数値、文字列を Vim script 流スタイルで boolean に変換する。
---@param num number | string | boolean | nil
---@return boolean
function M.to_bool(num)
    if num == 0 or num == "" or num == false or num == nil then
        return false
    end
    return true
end

--- Rust でいう "if cond {A} else {B}" の代替。
--- よく代替扱いされる "cond and A or B" は A が falsy なとき不適切な値となる。
--- たとえば (cond, A, B) == (true, false, 1) のとき、 cond は truen なのに 1 を返す。
--- よって A の型が実行時に決まる Lua ではトラブルのもとになる懸念がある。
---@generic T
---@param condition boolean
---@param true_clause T
---@param false_clause T
---@return T
function M.ifexpr(condition, true_clause, false_clause)
    if condition then
        return true_clause
    else
        return false_clause
    end
end

--- Rust の ".unwrap_or(default_value)" の代替。
--- A or B は A が false のとき不適切な値となる。
--- (A, B) == (false, 1) では、 A が nil ではないのに 1 を返す。
--- よって A の型が実行時に決まる Lua ではトラブルのもとになる懸念がある。
---@generic T
---@param value T | nil
---@param default T
---@return T
function M.unwrap_or(value, default)
    if value == nil then
        return default
    else
        return value
    end
end

return M
