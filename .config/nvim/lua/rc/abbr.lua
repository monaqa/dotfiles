vim.cmd([==[
    cnoreabbrev <expr> w (getcmdtype() .. getcmdline() ==# ":'<,'>w") ? "\<C-u>w" : "w"
    cnoreabbrev <expr> w2 (getcmdtype() .. getcmdline() ==# ":w2") ? "w" : "w2"
    cnoreabbrev <expr> w] (getcmdtype() .. getcmdline() ==# ":w]") ? "w" : "w]"
]==])

vim.cmd([[
function! RemoveAbbrTrigger(arg)
  if a:arg
    call getchar()
  endif
  return ""
endfunction
]])

---@alias abbrrule {from: string, to: string, prepose?: string, prepose_nospace?: string, remove_trigger?: boolean}

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
        local d_str = {}
        local d_remove = {}

        for _, rule in ipairs(rules_with_key) do
            local required_pattern = rule.from
            if rule.prepose_nospace ~= nil then
                required_pattern = rule.prepose_nospace .. required_pattern
            elseif rule.prepose ~= nil then
                required_pattern = rule.prepose .. " " .. required_pattern
            end
            d_str[required_pattern] = rule.to
            if rule.remove_trigger then
                d_remove[required_pattern] = true
            else
                d_remove[required_pattern] = false
            end
        end

        vim.cmd(
            ([[
        cnoreabbrev <expr> %s (getcmdtype()==# ":" && has_key(%s, getcmdline())) ? get(%s, getcmdline()) .. RemoveAbbrTrigger(get(%s, getcmdline())) : %s
        ]]):format(
                key,
                vim.fn.string(d_str),
                vim.fn.string(d_str),
                vim.fn.string(d_remove),
                vim.fn.string(key)
            )
        )
    end
end

make_abbrev {
    { from = "c", to = "CocCommand" },
    { from = "cc", to = "CocConfig" },
    { from = "cl", to = "CocList" },
    { from = "clc", to = "CocLocalConfig" },
    { from = "cm", to = "Capture messages" },
    { from = "cq", to = "CocQuickfix" },
    { from = "cr", to = "CocRestart" },
    { from = "dia", to = "Typscrap" },
    -- { from = "em", to = "Emmet" },
    { from = "fmt", to = 'call CocActionAsync("format")' },
    -- { from = "gbl", to = "Gina blame" },
    -- { from = "gbr", to = "GinaBrowseYank" },
    { from = "gby", to = "GinaBrowseYank" },
    { from = "gc", to = "Gina commit" },
    -- { from = "gcb", to = "GitsignsChangeBase" },
    { from = "gl", to = "Gina log --all --graph" },
    -- { from = "gps", to = "Gina push" },
    { from = "gpc", to = "GinaPrChanges" },
    { from = "gs", to = "Gina status -s --opener=split" },
    { from = "git", to = "Gina" },
    { from = "gina", to = "Gina" },
    -- { from = "gop", to = "OctoOpenPr" },
    { from = "it", to = "InspectTree" },
    { from = "l", to = "Lazy" },
    -- { from = "mn", to = "MemoNew" },
    -- { from = "mf", to = "MemoFind" },
    -- { from = "mg", to = "MemoLiveGrep" },
    { from = "open", to = "!open" },
    -- { from = "obs", to = "ObsidianList" },
    { from = "rg", to = "silent grep" },
    -- { from = "rs", to = "RemoveUnwantedSpaces" },
    { from = "t", to = "Telescope" },
    { from = "tc", to = "Telescope coc" },
    { from = "tcc", to = "Telescope coc commands" },
    { from = "tcd", to = "Telescope coc diagnostics" },
    { from = "tf", to = "Telescope find_files" },
    { from = "tg", to = "Telescope live_grep" },
    { from = "ty", to = "Typscrap" },
    { from = "tod", to = "TodomeOpen" },
    -- { from = "tmp", to = "Template" },
    { from = "s", to = "%s///g<Left><Left>", remove_trigger = true },
    { from = "ssf", to = "syntax sync fromstart" },
    { from = "sfs", to = "setfiletype satysfi" },
    { from = "vims", to = "vimgrep // %" },
    { from = "wd", to = "Telescope coc workspace_diagnostics" },
    { from = "gd", to = "g//d" },
    { from = "vd", to = "v//d" },
    { prepose = "CocCommand", from = "s", to = "snippets.editSnippets" },
    { prepose = "CocCommand", from = "r", to = "rust-analyzer.reload" },
    { prepose = "CocList", from = "e", to = "extensions" },
    { prepose = "Gina", from = "lag", to = "log --all --graph" },
    { prepose = "Gina commit", from = "a", to = "--amend" },
    { prepose = "Gina commit", from = "e", to = "--allow-empty" },
    { prepose = "Gina log", from = "a", to = "--all" },
    { prepose = "Telescope", from = "m", to = "find_files cwd=~/notes/home/ search_file=*.norg" },
    { prepose = "Telescope", from = "g", to = "live_grep cwd=~/notes/home/ glob_pattern=*.norg" },
    { prepose = "Telescope", from = "j", to = "find_files cwd=~/notes/home/journal/" },
    { prepose = "Telescope", from = "n", to = "neorg find_linkable" },
    { prepose = "Telescope find_files", from = "m", to = "cwd=~/memo" },
    { prepose = "Telescope live_grep", from = "m", to = "cwd=~/memo" },
    { prepose = "Telescope find_files", from = "l", to = "cwd=.local_ignore*" },
    { prepose = "Telescope live_grep", from = "l", to = "cwd=.local_ignore*" },
    { prepose_nospace = "'<,'>", from = "m", to = "MakeTable" },
    { prepose_nospace = "'<,'>", from = "gbr", to = "GinaBrowseYank" },
    { prepose_nospace = "'<,'>", from = "gby", to = "GinaBrowseYank" },
    { prepose_nospace = "'<,'>", from = "p", to = "Partedit" },
    { prepose_nospace = "'<,'>", from = "pc", to = "ParteditCodeblock" },
    { prepose_nospace = "'<,'>", from = "s", to = "s///g<Left><Left>", remove_trigger = true },
    { prepose_nospace = "'<,'>", from = "gd", to = "g//d" },
    { prepose_nospace = "'<,'>", from = "vd", to = "v//d" },

    { from = "isort", to = "!isort --profile black %" },
}
