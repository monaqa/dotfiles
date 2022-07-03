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

vim.cmd[[
    inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u" . lexima#expand('<LT>CR>', 'i')
]]

-- §§1 Plugin settings for machakann/vim-sandwich

vim.fn["operator#sandwich#set"]('all', 'all', 'highlight', 0)

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
    {filetype = {"markdown"}, input = {"l"}, buns = {"[", "]()"}, nesting = 0},
    {filetype = {"markdown"}, input = {"L"}, buns = {"[](", ")"}, nesting = 0},
}

function vim.g.SandwichMarkdownCodeSnippet()
    local lang_name = vim.fn.input("language: ", "")
    return "```" .. lang_name
end

local recipe_codeblock = {
    {
        filetype = {"markdown"},
        input = {"c"},
        buns = {"```", "```"},
        kind = {"add"},
        linewise = 1,
        command = { [[']s/^\s*//]] },
    },
    {
        filetype = {"markdown"},
        input = {"C"},
        buns = {"SandwichMarkdownCodeSnippet()", [["```"]]},
        expr = 1,
        kind = {"add"},
        linewise = 1,
        command = { [[']s/^\s*//]] },
    },
}

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

vim.cmd[[
    function! SandwichGenericsName() abort
      let genericsname = input('generics name: ', '')
      if genericsname ==# ''
        throw 'OperatorSandwichCancel'
      endif
      return genericsname . '<'
    endfunction
]]

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

vim.g["sandwich#recipes"] = util.list_concat{
    default_recipes,
    recipe_general,
    recipe_japanese,
    recipe_escaped,
    recipe_lua,
    recipe_link,
    recipe_codeblock,
    recipe_generics,
}

vim.cmd[[
let g:sandwich#recipes += [
\ {
\   'buns': ['InlineCommandName()', '"}"'],
\   'expr': 1,
\   'cursor': 'inner_tail',
\   'kind': ['add', 'replace'],
\   'action': ['add'],
\   'input': ['c'],
\   'filetype': ['satysfi']
\ },
\ {
\   'buns': ['BlockCommandName()', '">"'],
\   'expr': 1,
\   'linewise' : 1,
\   'cursor': 'inner_tail',
\   'kind': ['add', 'replace'],
\   'action': ['add'],
\   'input': ['+'],
\   'filetype': ['satysfi']
\ },
\ ]

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

vim.keymap.set({"x", "o"}, "m", "<Plug>(textobj-sandwich-literal-query-i)", {remap = true})
vim.keymap.set({"x", "o"}, "M", "<Plug>(textobj-sandwich-literal-query-a)", {remap = true})

-- §§1 Plugin settings for machakann/vim-textobj-functioncall
vim.g["textobj_functioncall_no_default_key_mappings"] = 1

-- §§1 Plugin settings for matchup
vim.g["matchup_matchparen_offscreen"] = {}
