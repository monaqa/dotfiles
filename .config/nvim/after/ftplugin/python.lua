vim.cmd.inoreabbrev { args = { "<buffer>", "imprt", "import" } }
vim.cmd.inoreabbrev { args = { "<buffer>", "improt", "import" } }

vim.opt_local.smartindent = false
vim.opt_local.foldmethod = "indent"

local first_line = vim.fn.getline(1)
if first_line == "# %% [markdown]" or first_line == "# %% streamlit" then
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "HydrogenFoldOnlyCode(v:lnum)"
    vim.opt_local.foldmethod = "HydrogenCustomFoldText()"
end

vim.keymap.set("gq", ":!black - 2>/dev/null<CR>", { buffer = true })

-- すまん。面倒くさくて
vim.cmd [[
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
]]
