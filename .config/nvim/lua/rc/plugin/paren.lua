-- vim:fdm=marker:fmr=§§,■■
local util = require("rc.util")

-- §§1 Plugin settings for cohama/lexima.vim

vim.g["lexima_no_default_rules"] = 1
vim.fn["lexima#set_default_rules"]()

-- シングルクォート補完の無効化
vim.fn["lexima#add_rule"]{
filetype = {"latex", "tex", "satysfi"},
    char = "'",
    input = "'",
}

vim.fn["lexima#add_rule"]{
    char = "{",
    at = [=[\%#[-0-9a-zA-Z_]]=],
    input = "{",
}

-- TeX/LaTeX
vim.fn["lexima#add_rule"]{
    filetype = {"latex", "tex"},
    char = "{",
    input = "{",
    at = [[\%#\\]]
}
vim.fn["lexima#add_rule"]{
    filetype = {"latex", "tex"},
    char = "$",
    input_after = "$",
}
vim.fn["lexima#add_rule"]{
    filetype = {"latex", "tex"},
    char = "$",
    at = [[$\%#\$]],
    leave = 1,
}
vim.fn["lexima#add_rule"]{
    filetype = {"latex", "tex"},
    char = "<BS>",
    at = [[\$\%#\$]],
    leave = 1,
}

-- SATySFi
vim.fn["lexima#add_rule"]{
    filetype = {"satysfi"},
    char = "$",
    input = "${",
    input_after = "}",
}
vim.fn["lexima#add_rule"]{
    filetype = {"satysfi"},
    char = "$",
    at = [[\\\%#]],
    leave = 1,
}

-- reST
vim.fn["lexima#add_rule"]{
    filetype = {"rst"},
    char = "``",
    input_after = "``",
}

-- なぜかうまくいかない
-- vim.keymap.set("i", "<CR>", function ()
--     if vim.fn.pumvisible() ~= 0 then
--         return [[<C-y>]]
--     else
--         return [[<C-g>u]] .. vim.fn["lexima#expand"]("<CR>", "i")
--     end
-- end, {expr = true, silent = true})

-- coc.lua に移動
-- vim.cmd[[
--     inoremap <expr> <CR> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u" . lexima#expand('<LT>CR>', 'i')
-- ]]

-- §§1 Plugin settings for machakann/vim-textobj-functioncall
vim.g["textobj_functioncall_no_default_key_mappings"] = 1
vim.g["textobj_functioncall_generics_patterns"] = {
    {
        header = [[\<\%(\h\k*\.\)*\h\k*]],
        bra = "<",
        ket = ">",
        footer = "",
    }
}
vim.keymap.set("o", "<Plug>(textobj-functioncall-generics-i)", ":<C-u>call textobj#functioncall#ip('o', g:textobj_functioncall_generics_patterns)<CR>", {silent = true})
vim.keymap.set("x", "<Plug>(textobj-functioncall-generics-i)", ":<C-u>call textobj#functioncall#ip('x', g:textobj_functioncall_generics_patterns)<CR>", {silent = true})
vim.keymap.set("o", "<Plug>(textobj-functioncall-generics-a)", ":<C-u>call textobj#functioncall#i('o', g:textobj_functioncall_generics_patterns)<CR>", {silent = true})
vim.keymap.set("x", "<Plug>(textobj-functioncall-generics-a)", ":<C-u>call textobj#functioncall#i('x', g:textobj_functioncall_generics_patterns)<CR>", {silent = true})

-- §§1 Plugin settings for machakann/vim-sandwich

-- §§2 全体設定
vim.fn["operator#sandwich#set"]('all', 'all', 'highlight', 0)

-- §§2 sandwich.vim を使うためのマッピング
vim.keymap.set("n", "ds",
    "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
    {remap = true}
)
vim.keymap.set("n", "dsb",
    "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
    {remap = true}
)
vim.keymap.set("n", "cs",
    "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
    {remap = true}
)
vim.keymap.set("n", "csb",
    "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
    {remap = true}
)

-- textobj-between と同じことを sandwich.vim でやる
vim.keymap.set({"x", "o"}, "m", "<Plug>(textobj-sandwich-literal-query-i)", {remap = true})
vim.keymap.set({"x", "o"}, "M", "<Plug>(textobj-sandwich-literal-query-a)", {remap = true})

-- §§2 レシピを作るための関数群
function vim.g.SandwichMarkdownCodeSnippet()
    local lang_name = vim.fn.input("language: ", "")
    return "```" .. lang_name
end

-- 例外を throw する方法が分からないので Lua 化はお蔵入り
-- function vim.g.SandwichGenericsName()
--     -- local generics_name = vim.fn.input("generics name: ", "")
--     local generics_name = vim.fn.input("generics name: ", "")
--     if generics_name ~= "" then
--         vim.cmd[[throw "OperatorSandwichCancel"]]
--     end
--     return generics_name .. "<"
-- end
-- 
-- function vim.g.SandwichInlineCmdName()
--     local cmd_name = vim.fn.input("inline-cmd name: ", "")
--     if cmd_name ~= "" then
--         vim.cmd[[throw "OperatorSandwichCancel"]]
--     end
--     return [[\]] .. cmd_name .. "{"
-- end
-- 
-- function vim.g.SandwichBlockCmdName()
--     local cmd_name = vim.fn.input("block-cmd name: ", "")
--     if cmd_name ~= "" then
--         vim.cmd[[throw "OperatorSandwichCancel"]]
--     end
--     return "+" .. cmd_name .. "<"
-- end

vim.cmd[[
function! SandwichGenericsName() abort
  let genericsname = input('generics name: ', '')
  if genericsname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return genericsname . '<'
endfunction

function! InlineCommandName() abort
  let cmdname = input('inline-cmd name: ', '')
  if cmdname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return '\' . cmdname . '{'
endfunction

function! BlockCommandName() abort
  let cmdname = input('block-cmd name: ', '')
  if cmdname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return '+' . cmdname . '<'
endfunction
]]

-- §§2 レシピ集
local default_recipes = vim.g["sandwich#default_recipes"]

local recipe_general = {
    {input = {"("}, buns = {"(", ")"}, nesting = 1, match_syntax = 1, kind = {"add", "replace"}, action = {"add"}},
    {input = {"["}, buns = {"[", "]"}, nesting = 1, match_syntax = 1, kind = {"add", "replace"}, action = {"add"}},
    {buns = {"{", "}"}, input = {"{"}, nesting = 1, match_syntax = 1, kind = {"add", "replace"}, action = {"add"}},
    {input = {"("}, buns = {[=[\s*[]=], [=[]\s*]=]}, regex = 1, nesting = 1, match_syntax = 1, kind = {"delete", "replace", "textobj"}, action = {"delete"}},
    {input = {"["}, buns = {[[\s*(]], [[)\s*]]}, regex = 1, nesting = 1, match_syntax = 1, kind = {"delete", "replace", "textobj"}, action = {"delete"}},
    {input = {"{"}, buns = {[[\s*{]], [[}\s*]]}, regex = 1, nesting = 1, match_syntax = 1, kind = {"delete", "replace", "textobj"}, action = {"delete"}},
}

local recipe_japanese = {
    {input = { "j(", "j)", "jp" }, buns = {"（", "）"}, nesting = 1},
    {input = { "j[", "j]", "jb" }, buns = {"「", "」"}, nesting = 1},
    {input = { "j{", "j}", "jB" }, buns = {"『", "』"}, nesting = 1},
    {input = { "j<", "j>", "jk" }, buns = {"【", "】"}, nesting = 1},
    {input = { [[j"]] }, buns = {"“", "”"}, nesting = 1},
    {input = { [[j']] }, buns = {"‘", "’"}, nesting = 1},
}

local recipe_escaped = {
    {input = { [[\(]], [[\)]] }, buns = {[[\(]], [[\)]]}, nesting = 1},
    {input = { [=[\[]=], [=[\]]=] }, buns = {[=[\[]=], [=[\]]=]}, nesting = 1},
    {input = { [[\{]], [[\}]] }, buns = {[[\{]], [[\}]]}, nesting = 1},
}

local recipe_link = {
    {filetype = {"rst"}, input = {"l"}, buns = {"`", " <>`_"}, nesting = 0},
    {filetype = {"rst"}, input = {"L"}, buns = {"` <", ">`_"}, nesting = 0},
    {filetype = {"markdown", "obsidian"}, input = {"l"}, buns = {"[", "]()"}, nesting = 0},
    {filetype = {"markdown", "obsidian"}, input = {"L"}, buns = {"[](", ")"}, nesting = 0},
}

local recipe_codeblock = {
    {
        filetype = {"markdown", "obsidian"},
        input = {"c"},
        buns = {"```", "```"},
        kind = {"add"},
        linewise = 1,
        command = { [[']s/^\s*//]] },
    },
    {
        filetype = {"markdown", "obsidian"},
        input = {"C"},
        buns = {"SandwichMarkdownCodeSnippet()", [["```"]]},
        expr = 1,
        kind = {"add"},
        linewise = 1,
        command = { [[']s/^\s*//]] },
    },
}

local recipe_generics = {
    {
        input = {"g"},
        buns = {"SandwichGenericsName()", [[">"]]},
        expr = 1,
        cursor = "inner_tail",
        kind = {"add", "replace"},
        action = {"add"},
    },
    {
        input = {"g"},
        external = {"i<", vim.api.nvim_eval[["\<Plug>(textobj-functioncall-generics-a)"]]},
        noremap = 0,
        kind = {"delete", "replace", "query"},
    }
}

local recipe_lua = {
    {filetype = {"lua"}, buns = {"[[", "]]"}, nesting = 0, input = { "s" } },
    {filetype = {"lua"}, buns = {"[=[", "]=]"}, nesting = 0, input = { "S" } },
}

local recipe_satysfi_cmd = {
    {
        filetype = {"satysfi", "satysfi_v0_1_0"},
        input = {"c"},
        buns = {"SandwichInlineCmdName()", [["}"]]},
        expr = 1,
        cursor = "inner_tail",
        kind = {"add", "replace"},
        action = {"add"},
    },
    {
        filetype = {"satysfi", "satysfi_v0_1_0"},
        input = {"+"},
        buns = {"SandwichBlockCmdName()", [[">"]]},
        expr = 1,
        cursor = "inner_tail",
        kind = {"add", "replace"},
        action = {"add"},
    },
}

vim.g["sandwich#recipes"] = util.list_concat{
    default_recipes,
    recipe_general,
    recipe_japanese,
    recipe_escaped,
    recipe_lua,
    recipe_link,
    recipe_codeblock,
    recipe_generics,
    recipe_satysfi_cmd,
}


-- §§1 Plugin settings for matchup
vim.g["matchup_matchparen_offscreen"] = {}
