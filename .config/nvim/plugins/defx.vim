" もし作成してなかったら ~/.defxsessions を作成する
" そして defx を開く際にセッションファイルを指定する
"
let g:defx_sessions_file = $HOME . '/.defxsessions'

" floating window の設定
let s:denite_win_width_percent = 0.7
let s:denite_win_height_percent = 0.7

" Change denite default options
call defx#custom#option('_', {
    \ 'split': 'floating',
    \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
    \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
    \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
    \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
    \ })

call defx#custom#column('filename', {
      \ 'min_width': float2nr(&columns * s:denite_win_width_percent - 30),
      \ 'max_width': float2nr(&columns * s:denite_win_width_percent - 30),
      \ })

nnoremap <expr><silent> sz ":Defx " . "-columns=git:indent:icons:filename "
  \ . "-buffer-name=leftw "
  \ . "-session-file=" . g:defx_sessions_file . " "
  \ . "-show-ignored-files "
  \ . "-toggle -split=vertical -winwidth=30 -direction=topleft<CR>"

nnoremap <expr><silent> ss ":Defx " . "-columns=git:indent:icons:filename:type:size:time "
  \ . "-buffer-name=float "
  \ . "-session-file=" . g:defx_sessions_file . " "
  \ . "-show-ignored-files "
  \ . "-toggle <CR>"

if getftype(g:defx_sessions_file) != "file"
  call writefile(["{}"], g:defx_sessions_file)
  echo "Created .defxsessions file to home directory."
endif

autocmd FileType defx call s:defx_my_settings()
autocmd FileType defx set nonumber
autocmd FileType defx set signcolumn=no
function! s:defx_my_settings() abort

  let bufkind = strpart(bufname(""), 7, 5)

  if (bufkind == "float")
    nnoremap <silent><buffer><expr> <CR>
    \ defx#do_action('multi', ['drop', 'quit'])
    nnoremap <silent><buffer><expr> l
    \ defx#do_action('multi', ['drop', 'quit'])
  else
    nnoremap <silent><buffer><expr> <CR>
    \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> l
    \ defx#do_action('drop')
  endif

  " Define mappings
  nnoremap <silent><buffer><expr> cc
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> t
  \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> T
  \ defx#do_action('open_tree_recursive')
  nnoremap <silent><buffer><expr> w
  \ defx#do_action('add_session')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  " nnoremap <silent><buffer><expr> dd
  " \ defx#do_action('remove_trash')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction
call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })
