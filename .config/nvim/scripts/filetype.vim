" vim:fdm=marker:fmr=§§,■■

" §§1 SATySFi
augroup vimrc
  autocmd BufRead,BufNewFile *.satyg setfiletype satysfi
  autocmd BufRead,BufNewFile Satyristes setfiletype lisp
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> @o :!open %:r.pdf<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> @q :!satysfi %<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> @Q :!satysfi --debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space --debug-show-overfull %<CR>
augroup END

" §§1 fish
augroup vimrc
  autocmd BufRead,BufNewFile *.fish setfiletype fish
augroup END

" §§1 todo6
augroup vimrc
  autocmd BufRead,BufNewFile .todo6,*.td6 setfiletype todo6
  " autocmd FileType todo6 setlocal noexpandtab
  " autocmd FileType todo6 setlocal shiftwidth=4
  " autocmd FileType todo6 setlocal tabstop=4
  " autocmd FileType todo6 setlocal foldmethod=indent
augroup END

" §§1 hydrogen
function HydrogenFoldOnlyCode(lnum) abort
  if getline(a:lnum + 1) =~ '^# %%'
    return '0'
  endif
  if getline(a:lnum) =~ '^# %%$'
    return '1'
  endif
  return '='
endfunction

function HydrogenCustomFoldText()
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

" §§1 Quickfix
augroup vimrc
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
  autocmd FileType qf nnoremap <buffer> j j
  autocmd FileType qf nnoremap <buffer> k k
augroup END

" §§1 todome
augroup vimrc
  autocmd BufRead,BufNewFile *.todome setfiletype todome
augroup END
