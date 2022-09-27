local M = {}

---text の前後の空白を取り除く。
---@param text string
---@return string
function M.trim(text)
    return text:gsub("^%s*(.-)%s*$", "%1")
end

---エラーとしてメッセージを出力する。
---@param message any
function M.print_error(message)
    vim.api.nvim_echo({{message, "Error"}}, true, {})
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

---各要素を変換する高階関数を返す。
---@generic T
---@generic U
---@param func fun(x: T): U
---@return fun(xs: T[]): U[]
function M.map(func)
    return function (xs)
        vim.tbl_map(func, xs)
    end
end

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
    return function (opts)
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
    if M.is_wide_window(".") then
        vim.cmd[[vsplit]]
    else
        vim.cmd[[split]]
    end
end

---escape sequence を付与する。
function M.esc(text)
    return "\u{1b}" .. text
end


--- Lua には三項演算子が "無い" ので。
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

function M.cmdcr(text)
    return "<Cmd>" .. text .. "<CR>"
end

return M
