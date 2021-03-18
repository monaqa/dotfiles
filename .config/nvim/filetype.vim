" vim:fdm=marker:fmr=§§,■■

" §§1 SATySFi
augroup vimrc
  autocmd BufRead,BufNewFile *.satyg setfiletype satysfi
  autocmd BufRead,BufNewFile Satyristes setfiletype lisp
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>o :!open %:r.pdf<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>q :!satysfi %<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>Q :!satysfi --debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space --debug-show-overfull %<CR>
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