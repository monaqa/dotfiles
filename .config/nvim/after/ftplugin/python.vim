function PythonFoldOnlyCode(lnum) abort
  if getline(a:lnum + 1) =~ '^# %%'
    return '0'
  endif
  if getline(a:lnum) =~ '^# %%$'
    return '1'
  endif
  return '='
endfunction

function PythonCustomFoldText()
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

inoreabbrev <buffer> imprt import
inoreabbrev <buffer> improt import

augroup vimrc
  autocmd FileType python setlocal nosmartindent
  autocmd FileType python setlocal foldmethod=indent
  " hydrogen-like python file
  autocmd FileType python if getline(1) ==# "# %% [markdown]"
  autocmd FileType python   setlocal fdm=expr
  autocmd FileType python   setlocal foldexpr=PythonFoldOnlyCode(v:lnum)
  autocmd FileType python   setlocal foldtext=PythonCustomFoldText()
  autocmd FileType python   nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
  autocmd FileType python endif
augroup END

let quickrun_config['jupytext'] = {
      \ 'command': 'jupytext',
      \ 'exec': '%c %o %a',
      \ 'cmdopt': '--update --to notebook',
      \ 'outputter/error/success': 'null',
      \ 'outputter/error/error': 'null',
      \ }
