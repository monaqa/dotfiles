-- Vim の組み込み API などのショートハンド。
local M = {}

--- group が vimrc の autocmd を作成する。
function M.autocmd_vimrc(event)
    return function(opts)
        opts["group"] = "vimrc"
        vim.api.nvim_create_autocmd(event, opts)
    end
end

--- nvim_create_user_command って長ったらしいしオプション省略できないっぽいので。
function M.create_cmd(name, impl, options)
    if options == nil then
        options = {}
    end
    vim.api.nvim_create_user_command(name, impl, options)
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

---@alias mapset_inner fun(t: vim.keymap.set.Opts):nil

--- キーマップ定義のショートハンド。
---@param mode string | string[]
---@param buffer_local boolean?
---@return fun(string): mapset_inner
local function mapset_with_mode(mode, buffer_local)
    ---@param lhs string
    return function(lhs)
        ---@param t vim.keymap.set.Opts
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
    n = mapset_with_mode("n"),
    x = mapset_with_mode("x"),
    o = mapset_with_mode("o"),
    i = mapset_with_mode("i"),
    c = mapset_with_mode("c"),
    t = mapset_with_mode("t"),
    nxo = mapset_with_mode { "n", "x", "o" },
    ic = mapset_with_mode { "i", "c" },
}

M.mapset_local = {
    n = mapset_with_mode("n", true),
    x = mapset_with_mode("x", true),
    o = mapset_with_mode("o", true),
    i = mapset_with_mode("i", true),
    c = mapset_with_mode("c", true),
    t = mapset_with_mode("t", true),
    nxo = mapset_with_mode({ "n", "x", "o" }, true),
    ic = mapset_with_mode({ "i", "c" }, true),
}

return M
