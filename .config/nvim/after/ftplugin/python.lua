require("lazy").load { plugins = "vim-sandwich" }

vim.cmd.inoreabbrev { args = { "<buffer>", "imprt", "import" } }
vim.cmd.inoreabbrev { args = { "<buffer>", "improt", "import" } }

vim.opt_local.smartindent = false
-- octo で PR レビューするとき邪魔になっちゃうっぽい
-- vim.opt_local.foldmethod = "indent"

local first_line = vim.fn.getline(1)
if vim.startswith(first_line, "# %%") then
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "HydrogenFoldOnlyCode(v:lnum)"
else
    vim.opt_local.foldmethod = "manual"
end

vim.keymap.set("x", "gq", ":!black - 2>/dev/null<CR>", { buffer = true })

-- すまん。面倒くさくて
vim.cmd([[
    let g:textobj_functioncall_python_generics_patterns = [
    \ {
    \   'header' : '\<\%(\h\k*\.\)*\h\k*',
    \   'bra'    : '\[',
    \   'ket'    : '\]',
    \   'footer' : '',
    \ },
    \ ]

    onoremap <silent> <Plug>(textobj-functioncall-python-generics-a) :<C-u>call textobj#functioncall#i('o', g:textobj_functioncall_python_generics_patterns)<CR>
    xnoremap <silent> <Plug>(textobj-functioncall-python-generics-a) :<C-u>call textobj#functioncall#i('x', g:textobj_functioncall_python_generics_patterns)<CR>

    xmap <buffer> af <Plug>(textobj-functioncall-python-generics-a)

    let b:sandwich_recipes = g:sandwich#recipes + [
    \ {
    \   'buns': ['SandwichPythonGenericsName()', '"]"'],
    \   'expr': 1,
    \   'cursor': 'inner_tail',
    \   'kind': ['add', 'replace'],
    \   'action': ['add'],
    \   'input': ['g']
    \ },
    \ {
    \   'external': ['i[', "\<Plug>(textobj-functioncall-python-generics-a)"],
    \   'noremap': 0,
    \   'kind': ['delete', 'replace', 'query'],
    \   'input': ['g']
    \ },
    \ ]

    function! SandwichPythonGenericsName() abort
      let genericsname = input('generics name: ', '')
      if genericsname ==# ''
        throw 'OperatorSandwichCancel'
      endif
      return genericsname . '['
    endfunction
]])

-- §§1 hydrogen
vim.cmd([[
function! HydrogenFoldOnlyCode(lnum) abort
  if getline(a:lnum + 1) =~ '^\s*# %%'
    return '0'
  endif
  if getline(a:lnum - 1) =~ '^\s*# %% \[markdown\]'
    return '0'
  endif
  if getline(a:lnum - 1) =~ '^\s*# %%'
    return '1'
  endif
  return '='
endfunction
]])

require("lazy").load { plugins = { "vim-altr" } }

vim.fn["altr#define"] {
    "src/*/%.py",
    "tests/*/test_%.py",
}
