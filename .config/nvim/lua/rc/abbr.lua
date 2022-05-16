---@param text string
local function equals_cmdline(text)
    return vim.fn.getcmdtype() .. vim.fn.getcmdline() == text
end

vim.cmd[==[
    cnoreabbrev <expr> w (getcmdtype() .. getcmdline() ==# ":'<,'>w") ? "\<C-u>w" : "w"
    cnoreabbrev <expr> w2 (getcmdtype() .. getcmdline() ==# ":w2") ? "w" : "w2"
    cnoreabbrev <expr> w] (getcmdtype() .. getcmdline() ==# ":w]") ? "w" : "w]"
]==]

_G.vimrc.abbr = {}

---@alias abbrrule {from: string, to: string, prepose?: string, prepose_nospace?: string}

---@param rules abbrrule[]
local function make_abbr_table(rules)
    -- 文字列のキーに対して常に0のvalue を格納することで、文字列の hashset を実現。
    ---@type table<string, abbrrule[]>
    local abbr_dict_rule = {}

    for _, rule in ipairs(rules) do
        local key = rule.from
        if abbr_dict_rule[key] == nil then
            abbr_dict_rule[key] = {}
        end
        table.insert(abbr_dict_rule[key], rule)
    end

    for key, rule in pairs(abbr_dict_rule) do
        ---コマンドラインが特定の内容だったら、それに対応する値を返す。
        ---@type table<string, string>
        local d = {}

        -- _G.vimrc.abbr[key] = function (cmdtype, cmdline)
        --     if cmdtype ~= ":" then
        --         return key
        --     end
        --     return key
        -- end
        -- 
        -- vim.cmd(
        --     ([[
        --         cnoreabbrev <expr> %s v:lua.vimrc.abbr["%s"](getcmdtype(), getcmdline())
        --     ]]):format()
        -- )
    end
end

make_abbr_table{
    {from = "bod", to = "BufferOrderByDirectory"},
}
