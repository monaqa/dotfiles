let g:go_fmt_autosave = 0
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_highlight_types = 1
let g:go_doc_popup_window = 1
" let g:go_auto_type_info = 1
" let g:go_auto_sameids = 1

augroup rc_go
  autocmd!
  autocmd FileType go call s:go_my_settings()
augroup END

function! s:go_my_settings() abort
  noremap <buffer> s] :cnext<CR>
  noremap <buffer> s[ :cprev<CR>
  nmap <buffer> <CR>b :<C-u>call <SID>build_go_files()<CR>
  noremap <buffer> <CR>r :GoRun<CR>
  noremap <buffer> <CR>t :GoTest<CR>
  noremap <buffer> <CR>f :GoTestFunc<CR>
  noremap <buffer> <CR>g :GoFmt<CR>
  noremap <buffer> <CR>i :GoImports<CR>
  nmap <CR>c <Plug>(go-coverage-toggle):set list!<CR>
  " nnoremap <CR>d :Denite decls<CR>
  nnoremap <CR>d :GoDebugStart<CR>
endfunction

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

