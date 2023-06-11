local M = {}

---text の前後の空白を取り除く。
---@param text string
---@return string
function M.trim(text)
    return text:gsub("^%s*(.-)%s*$", "%1")
end

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

---数値、文字列を Vim script 流スタイルで boolean に変換する。
---@param num number | string | boolean | nil
---@return boolean
function M.to_bool(num)
    if num == 0 or num == "" or num == false or num == nil then
        return false
    end
    return true
end

function M.autocmd_vimrc(event)
    return function(opts)
        opts["group"] = "vimrc"
        vim.api.nvim_create_autocmd(event, opts)
    end
end

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

---escape sequence を付与する。
function M.esc(text)
    return "\u{1b}" .. text
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

function M.cmdcr(text)
    return "<Cmd>" .. text .. "<CR>"
end

--- nvim_create_user_command って長ったらしいしオプション省略できないっぽいので。
function M.create_cmd(name, impl, options)
    if options == nil then
        options = {}
    end
    vim.api.nvim_create_user_command(name, impl, options)
end

--- グローバルに set_hl する。
function M.sethl(name)
    return function(t)
        if t.default == nil then
            t.default = false
        end
        vim.api.nvim_set_hl(0, name, t)
    end
end

function M.load_cwd_as_plugin(source_file_name)
    local cwd = vim.fn.getcwd()
    vim.opt.runtimepath:append(cwd)
    if source_file_name ~= nil then
        vim.cmd.source(([[%s/%s]]):format(cwd, source_file_name))
    end
end

return M
