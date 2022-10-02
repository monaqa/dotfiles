---@param text string
local function equals_cmdline(text)
    return vim.fn.getcmdtype() .. vim.fn.getcmdline() == text
end

vim.cmd [==[
    cnoreabbrev <expr> w (getcmdtype() .. getcmdline() ==# ":'<,'>w") ? "\<C-u>w" : "w"
    cnoreabbrev <expr> w2 (getcmdtype() .. getcmdline() ==# ":w2") ? "w" : "w2"
    cnoreabbrev <expr> w] (getcmdtype() .. getcmdline() ==# ":w]") ? "w" : "w]"
]==]

---@alias abbrrule {from: string, to: string, prepose?: string, prepose_nospace?: string}

---@param rules abbrrule[]
local function make_abbrev(rules)
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

    for key, rules_with_key in pairs(abbr_dict_rule) do
        ---コマンドラインが特定の内容だったら、それに対応する値を返す。
        ---@type table<string, string>
        local d = {}

        for _, rule in ipairs(rules_with_key) do
            local required_pattern = rule.from
            if rule.prepose_nospace ~= nil then
                required_pattern = rule.prepose_nospace .. required_pattern
            elseif rule.prepose ~= nil then
                required_pattern = rule.prepose .. " " .. required_pattern
            end
            d[required_pattern] = rule.to
        end

        vim.cmd(([[
        cnoreabbrev <expr> %s (getcmdtype()==# ":") ? get(%s, getcmdline(), %s) : %s
        ]]):format(key, vim.fn.string(d), vim.fn.string(key), vim.fn.string(key)))
    end
end

make_abbrev {
    { from = "c", to = "CocCommand" },
    { from = "cc", to = "CocConfig" },
    { from = "cl", to = "CocList" },
    { from = "clc", to = "CocLocalConfig" },
    { from = "cq", to = "CocQuickfix" },
    { from = "cr", to = "CocRestart" },
    { from = "dia", to = "ObsidianOpenDiary" },
    { from = "em", to = "Emmet" },
    { from = "fmt", to = 'call CocActionAsync("format")' },
    { from = "gbl", to = "Gina blame" },
    { from = "gbr", to = "GinaBrowseYank" },
    { from = "gby", to = "GinaBrowseYank" },
    { from = "gc", to = "Gina commit" },
    { from = "gl", to = "Gina log --all --graph" },
    { from = "gp", to = "Gina push" },
    { from = "gs", to = "Gina status -s --opener=split" },
    { from = "git", to = "Gina" },
    { from = "gina", to = "Gina" },
    { from = "mn", to = "MemoNew" },
    { from = "mf", to = "MemoFind" },
    { from = "mg", to = "MemoLiveGrep" },
    { from = "open", to = "!open" },
    { from = "obs", to = "ObsidianList" },
    { from = "rg", to = "silent grep" },
    { from = "rs", to = "RemoveUnwantedSpaces" },
    { from = "t", to = "Telescope" },
    { from = "tc", to = "Telescope coc" },
    { from = "tcc", to = "Telescope coc commands" },
    { from = "tcd", to = "Telescope coc diagnostics" },
    { from = "tcw", to = "Telescope coc workspace_diagnostics" },
    { from = "tf", to = "Telescope find_files" },
    { from = "tg", to = "Telescope live_grep" },
    { from = "tmp", to = "Template" },
    { from = "ssf", to = "syntax sync fromstart" },
    { from = "sfs", to = "setfiletype satysfi" },
    { prepose = "CocCommand", from = "s", to = "snippets.editSnippets" },
    { prepose = "CocCommand", from = "r", to = "rust-analyzer.reload" },
    { prepose = "CocList", from = "e", to = "extensions" },
    { prepose = "Gina", from = "lag", to = "log --all --graph" },
    { prepose = "Gina commit", from = "a", to = "--amend" },
    { prepose = "Gina commit", from = "e", to = "--allow-empty" },
    { prepose = "Gina log", from = "a", to = "--all" },
    { prepose = "Telescope find_files", from = "m", to = "cwd=~/memo" },
    { prepose = "Telescope live_grep", from = "m", to = "cwd=~/memo" },
    { prepose = "Telescope find_files", from = "l", to = "cwd=.local_ignore*" },
    { prepose = "Telescope live_grep", from = "l", to = "cwd=.local_ignore*" },
    { prepose_nospace = "'<,'>", from = "m", to = "MakeTable" },
    { prepose_nospace = "'<,'>", from = "gbr", to = "GinaBrowseYank" },
    { prepose_nospace = "'<,'>", from = "gby", to = "GinaBrowseYank" },
    { prepose_nospace = "'<,'>", from = "p", to = "Partedit" },
    { prepose_nospace = "'<,'>", from = "pc", to = "ParteditCodeblock" },

    { from = "isort", to = "!isort --profile black %" },
}
