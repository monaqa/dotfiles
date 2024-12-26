-- Vim の組み込み API などのショートハンド。
local M = {}

local logic = require("monaqa.logic")

--- group が vimrc の autocmd を作成する。
---@param event string | string[]
---@return fun(opts: vim.api.keyset.create_autocmd):(fun():nil)
function M.autocmd_vimrc(event)
    ---@param opts vim.api.keyset.create_autocmd
    return function(opts)
        opts["group"] = "vimrc"
        local id = vim.api.nvim_create_autocmd(event, opts)
        return function()
            vim.api.nvim_del_autocmd(id)
        end
    end
end

--- @class monaqa.cmd_args
--- @field buffer? boolean | number
--- @field addr? any
--- @field bang? boolean
--- @field bar? boolean
--- @field complete? any
--- @field count? any
--- @field desc? any
--- @field force? boolean
--- @field keepscript? boolean
--- @field nargs? any
--- @field preview? any
--- @field range? any
--- @field register? boolean

--- nvim_create_user_command って長ったらしいしオプション省略できないっぽいので。
---@param name string
---@return fun(t: monaqa.cmd_args)
function M.create_cmd(name)
    ---@param t monaqa.cmd_args
    return function(t)
        local body = t[1]
        t[1] = nil
        if t.buffer ~= nil then
            local buffer = logic.ifexpr(t.buffer == true, 0, t.buffer)
            t.buffer = nil
            vim.api.nvim_buf_create_user_command(buffer, name, body, t)
        else
            vim.api.nvim_create_user_command(name, body, t)
        end
    end
end

--- nvim_create_user_command って長ったらしいしオプション省略できないっぽいので。
---@param name string
---@return fun(t: monaqa.cmd_args)
function M.create_cmd_local(name)
    ---@param t monaqa.cmd_args
    return function(t)
        local body = t[1]
        t[1] = nil
        if t.buffer ~= nil then
            local buffer = logic.ifexpr(t.buffer == true, 0, t.buffer)
            t.buffer = nil
            vim.api.nvim_buf_create_user_command(buffer, name, body, t)
        else
            vim.api.nvim_buf_create_user_command(0, name, body, t)
        end
    end
end

---@alias ftypegetter fun(): string

---特定のバッファに対して特定のfiletypeを紐づける。
---@param opts {filetype: string | ftypegetter, pattern?: string | string[], extension?: string | string[], weak?: boolean}
function M.link_filetype(opts)
    local pattern = opts.pattern

    if opts.pattern == nil then
        if type(opts.extension) == "string" then
            pattern = "*." .. opts.extension
        elseif type(opts.extension) == "table" then
            pattern = vim.tbl_map(function(e)
                return "*." .. e
            end, opts.extension)
        end
    end

    local get_ftype = opts.filetype
    local desc
    if type(get_ftype) == "string" then
        desc = "Set filetype to " .. get_ftype
        get_ftype = function()
            return opts.filetype --[[@as string]]
        end
    else
        desc = "Set filetype using function, which returns " .. get_ftype() .. " in some case"
    end

    if opts.weak then
        M.autocmd_vimrc { "BufRead", "BufNewFile" } {
            pattern = pattern,
            callback = function()
                vim.cmd.setfiletype(get_ftype())
            end,
            desc = desc,
        }
    else
        M.autocmd_vimrc { "BufRead", "BufNewFile" } {
            pattern = pattern,
            callback = function()
                vim.opt_local.filetype = get_ftype()
            end,
            desc = desc,
        }
    end
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

---@class mapset_opts: vim.keymap.set.Opts
---@field [1] fun() | string
---@alias mapset_inner fun(t: mapset_opts):nil

--- キーマップ定義のショートハンド。
---@param mode string | string[]
---@param buffer_local boolean?
---@return fun(string): mapset_inner
local function mapset_with_mode(mode, buffer_local)
    ---@param lhs string
    ---@return mapset_inner
    return function(lhs)
        ---@param t mapset_opts
        return function(t)
            local body = t[1]
            t[1] = nil
            if t.buffer == nil then
                t.buffer = buffer_local
            end
            vim.keymap.set(mode, lhs, body, t)
        end
    end
end

M.mapset = {
    --- NORMAL mode のキーマップを定義する。
    n = mapset_with_mode("n"),
    --- VISUAL mode のキーマップを定義する。
    x = mapset_with_mode("x"),
    --- OPERATOR-PENDING mode のキーマップを定義する。
    o = mapset_with_mode("o"),
    --- INSERT mode のキーマップを定義する。
    i = mapset_with_mode("i"),
    --- COMMAND-LINE mode のキーマップを定義する。
    c = mapset_with_mode("c"),
    --- SELECT mode のキーマップを定義する。
    s = mapset_with_mode("x"),
    --- TERMINAL mode のキーマップを定義する。
    t = mapset_with_mode("t"),

    --- NORMAL / VISUAL キーマップ（オペレータ/モーションなど）
    nx = mapset_with_mode { "n", "x" },
    --- VISUAL / SELECT キーマップ（制御文字を用いた VISUAL キーマップなど）
    xs = mapset_with_mode { "x", "s" },
    --- VISUAL / OPERATOR-PENDING キーマップ（モーション、text object など）
    xo = mapset_with_mode { "x", "o" },

    --- NORMAL-like mode のキーマップ（モーションなど）
    nxo = mapset_with_mode { "n", "x", "o" },
    --- INSERT-like mode のキーマップ（文字入力など）
    ic = mapset_with_mode { "i", "c" },

    --- iabbrev を定義する。
    ia = mapset_with_mode("ia"),
    --- cabbrev を定義する。
    ca = mapset_with_mode("ca"),

    --- モードを文字列で指定してキーマップを定義する。
    with_mode = mapset_with_mode,
}

M.mapset_local = {
    --- NORMAL mode の buffer-local キーマップを定義する。
    n = mapset_with_mode("n", true),
    --- VISUAL mode の buffer-local キーマップを定義する。
    x = mapset_with_mode("x", true),
    --- OPERATOR-PENDING mode の buffer-local キーマップを定義する。
    o = mapset_with_mode("o", true),
    --- INSERT mode の buffer-local キーマップを定義する。
    i = mapset_with_mode("i", true),
    --- COMMAND-LINE mode の buffer-local キーマップを定義する。
    c = mapset_with_mode("c", true),
    --- SELECT mode の buffer-local キーマップを定義する。
    s = mapset_with_mode("s", true),
    --- TERMINAL mode の buffer-local キーマップを定義する。
    t = mapset_with_mode("t", true),

    --- NORMAL / VISUAL の buffer-local キーマップ。
    nx = mapset_with_mode({ "n", "x" }, true),
    --- VISUAL / SELECT の buffer-local キーマップ。
    xs = mapset_with_mode({ "x", "s" }, true),
    --- VISUAL / OPERATOR-PENDING の buffer-local キーマップ。
    xo = mapset_with_mode({ "x", "o" }, true),

    --- NORMAL-like モードの buffer-local キーマップ。
    nxo = mapset_with_mode({ "n", "x", "o" }, true),
    --- INSERT-like モードの buffer-local キーマップ。
    ic = mapset_with_mode({ "i", "c" }, true),

    --- buffer-local iabbrev を定義する。
    ia = mapset_with_mode("ia", true),
    --- buffer-local cabbrev を定義する。
    ca = mapset_with_mode("ca", true),
}

return M
