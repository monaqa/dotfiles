function FoldOnlyCode(lnum) abort
  if getline(a:lnum + 1) =~ '^# %%'
    return '0'
  endif
  if getline(a:lnum) =~ '^# %%$'
    return '1'
  endif
  return '='
endfunction

function MyFoldText()
  let line_fstart = getline(v:foldstart)
  if line_fstart =~ '^# %% \[markdown\]'
    let kind = '[M]'
    let line_content = getline(v:foldstart + 2)
  else
    let kind = '[ ]'
    let line_content = getline(v:foldstart + 1)
  endif
  " let line_content = getline(v:foldstart + 2)
  " let sub = substitute(line, '', '', 'g')
  return kind . ' ' . line_content . ' '
endfunction

setlocal nosmartindent
setlocal foldmethod=indent
inoreabbrev <buffer> imprt import
inoreabbrev <buffer> improt import

" hydrogen-like python file
if getline(1) ==# "# %% [markdown]"
  setlocal fdm=expr
  setlocal foldexpr=FoldOnlyCode(v:lnum)
  setlocal foldtext=MyFoldText()
  nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
endif

let quickrun_config['jupytext'] = {
      \ 'command': 'jupytext',
      \ 'exec': '%c %o %a',
      \ 'cmdopt': '--update --to notebook',
      \ 'outputter/error/success': 'null',
      \ 'outputter/error/error': 'null',
      \ }
