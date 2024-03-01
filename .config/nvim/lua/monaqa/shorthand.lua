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

return M
