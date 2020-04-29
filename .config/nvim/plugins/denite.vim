nnoremap sb :Denite buffer -sorters=sorter/word<CR>
nnoremap sg :Denite grep -buffer-name=search-buffer-denite<CR>
nnoremap sG :Denite -resume -buffer-name=search-buffer-denite<CR>
nnoremap s] :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=+1 -immediately<CR>
nnoremap s[ :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=-1 -immediately<CR>
nnoremap so :Denite file/rec -buffer-name=search-file-denite<CR>
nnoremap sO :Denite file/rec -resume -buffer-name=search-file-denite<CR>

autocmd FileType rust nnoremap <buffer> sr :Denite rust/doc<CR>

" floating window の設定
let s:denite_win_width_percent = 0.85
let s:denite_win_height_percent = 0.7

function! MgmResizeDeniteFloatingWindow()
  call denite#custom#option('_', {
        \ 'split': 'floating',
        \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
        \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
        \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
        \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
        \ 'prompt': "❯"
        \ })
endfunction

call MgmResizeDeniteFloatingWindow()

let s:ignore_globs = [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/',
      \   '*.aux', '*.bbl', '*.blg', '*.dvi', '*.fdb_latexmk', '*.fls', '*.synctex.gz', '*.toc',
      \   '*.out', '*.snm', '*.nav',
      \   '*.pdf', '*.eps', '*.svg',
      \   '*.png', '*.jpg', '*.jpeg', '*.bmp',
      \   'searchindex.js',
      \   '*.ipynb',
      \   ]

" そもそも ag のレベルで検索対象からはずす
call denite#custom#var('file/rec', 'command', [
      \ 'pt',
      \ '--follow',
      \ ] + map(deepcopy(s:ignore_globs), { k, v -> '--ignore=' . v }) + [
      \ '--nocolor',
      \ '--nogroup',
      \ '--hidden',
      \ '-g',
      \ ''
      \ ])

" call denite#custom#var('buffer', 'exclude_unlisted', '0')

call denite#custom#var('grep', 'command', ['pt'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--nogroup', '--nocolor', '--smart-case', '--hidden'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" matcher/ignore_globs 以外のお好みの matcher を指定する
call denite#custom#source('file/rec', 'matchers', ['matcher/substring'])

" 他のソース向けに ignore_globs 自体は初期化
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs', s:ignore_globs)

call denite#custom#source('grep',
  \ 'matchers', ['converter/abbr_word', 'matcher_fuzzy', 'matcher/ignore_globs'],
  \ )
call denite#custom#source('file/rec',
  \ 'matchers', ['matcher_fuzzy', 'matcher/ignore_globs'])
call denite#custom#var('buffer', 'date_format', '')
call denite#custom#source('buffer', 'matchers', ['converter/abbr_word', 'matcher/substring'])

augroup rc_denite
  autocmd!
  autocmd FileType denite call s:denite_my_settings()
augroup END
function! s:denite_my_settings() abort
  nnoremap <nowait><silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><nowait><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><nowait><buffer><expr> t
  \ denite#do_map('toggle_select')
  nnoremap <silent><nowait><buffer><expr> <Space>
  \ denite#do_map('toggle_select') . "j"
  nnoremap <silent><nowait><buffer><expr> yy
  \ denite#do_map('do_action', 'yank')
endfunction

