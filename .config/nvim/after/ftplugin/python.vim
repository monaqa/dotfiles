inoreabbrev <buffer> imprt import
inoreabbrev <buffer> improt import

setlocal nosmartindent
setlocal foldmethod=indent

if getline(1) ==# "# %% [markdown]"
  setlocal fdm=expr
  setlocal foldexpr=HydrogenFoldOnlyCode(v:lnum)
  setlocal foldtext=HydrogenCustomFoldText()
  nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
endif

let quickrun_config['jupytext'] = {
      \ 'command': 'jupytext',
      \ 'exec': '%c %o %a',
      \ 'cmdopt': '--update --to notebook',
      \ 'outputter/error/success': 'null',
      \ 'outputter/error/error': 'null',
      \ }

" sandwich.vim

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

let b:partedit_prefix = ' '
let b:partedit_filetype = 'markdown'
