" 別ファイルに置いてた設定たち

" .config/nvim/plugins/airline.vim {{{
" let g:airline_theme = 'gruvbox'
" let g:airline_theme = 'dracula'
let g:airline_theme = 'sol'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
\ '0': '0:',
\ '1': '1:',
\ '2': '2:',
\ '3': '3:',
\ '4': '4:',
\ '5': '5:',
\ '6': '6:',
\ '7': '7:',
\ '8': '8:',
\ '9': '9:'
\}
nmap sp <Plug>AirlineSelectPrevTab
nmap sn <Plug>AirlineSelectNextTab
" 謎のエラーが出る
" nmap <expr> s<Space> "<Plug>AirlineSelectTab" . v:count
nmap 1s<Space> <Plug>AirlineSelectTab1
nmap 2s<Space> <Plug>AirlineSelectTab2
nmap 3s<Space> <Plug>AirlineSelectTab3
nmap 4s<Space> <Plug>AirlineSelectTab4
nmap 5s<Space> <Plug>AirlineSelectTab5
nmap 6s<Space> <Plug>AirlineSelectTab6
nmap 7s<Space> <Plug>AirlineSelectTab7
nmap 8s<Space> <Plug>AirlineSelectTab8
nmap 9s<Space> <Plug>AirlineSelectTab9
" let g:airline#extensions#whitespace#mixed_indent_algo = 1
" let g:airline#extensions#tabline#buffer_nr_show = 1

" }}}

" .config/nvim/plugins/coc-settings.vim {{{
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <Space>r <Plug>(coc-rename)
nmap <silent> K :call CocAction('doHover')<CR>
" nmap <Space><Space>p :CocList -A --normal yank<CR>
nmap <silent> <Space>j :call CocAction('diagnosticNext')<CR>
nmap <silent> <Space>k :call CocAction('diagnosticPrevious')<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" let g:LanguageClient_serverCommands = {
"\   'julia': ['/Applications/Julia-0.6.app/Contents/Resources/julia/bin/julia']}

augroup rc_coc
  autocmd!
  autocmd Filetype java nnoremap <Space>i :CocCommand java.action.organizeImports<CR>
augroup END

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<C-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<C-k>'

imap <C-q> <Plug>(coc-snippets-expand)

" }}}

" .config/nvim/plugins/de_file_xpl.vim {{{
" もし作成してなかったら ~/.defxsessions を作成する
" そして defx を開く際にセッションファイルを指定する
"
let g:defx_sessions_file = $HOME . '/.defxsessions'
let g:defx_ignored_files = '.git,__pycache__,.mypy_cache'

" floating window の設定
let s:denite_win_width_percent = 0.7
let s:denite_win_height_percent = 0.7

" Change denite default options

function! ResizeDefxFloatingWindow()
call defx#custom#option('_', {
    \ 'split': 'floating',
    \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
    \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
    \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
    \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
    \ })
endfunction

call ResizeDefxFloatingWindow()

call defx#custom#column('filename', {
      \ 'min_width': float2nr(&columns * s:denite_win_width_percent - 30),
      \ 'max_width': float2nr(&columns * s:denite_win_width_percent - 30),
      \ })

nnoremap <expr><silent> sz ":Defx " . "-columns=git:indent:icons:filename "
  \ . "-buffer-name=leftw "
  \ . "-session-file=" . g:defx_sessions_file . " "
  \ . "-ignored-files=" . g:defx_ignored_files . " "
  \ . "-resume "
  \ . "-toggle -split=vertical -winwidth=30 -direction=topleft<CR>"

nnoremap <expr><silent> sf ":Defx " . "-columns=git:indent:icons:filename:type:size:time "
  \ . "-buffer-name=float "
  \ . "-session-file=" . g:defx_sessions_file . " "
  \ . "-ignored-files=" . g:defx_ignored_files . " "
  \ . "-resume "
  \ . "-toggle <CR>"

if getftype(g:defx_sessions_file) != "file"
  call writefile(["{}"], g:defx_sessions_file)
  echo "Created .defxsessions file to home directory."
endif

augroup rc_defx
  autocmd!
  autocmd FileType defx call s:defx_my_settings()
  autocmd FileType defx set nonumber
  autocmd FileType defx set signcolumn=no
augroup END

function! s:defx_my_settings() abort

  let bufkind = strpart(bufname(""), 7, 5)
  if (bufkind == "float")
    nnoremap <nowait><silent><buffer><expr> <CR>
    \ defx#is_directory()? defx#do_action('drop') :
    \ defx#do_action('multi', ['drop', 'quit'])
    nnoremap <silent><buffer><expr> l
    \ defx#is_directory()? defx#do_action('drop') :
    \ defx#do_action('multi', ['drop', 'quit'])
  else
    nnoremap <nowait><silent><buffer><expr> <CR>
    \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> l
    \ defx#do_action('drop')
  endif

  " Define mappings
  nnoremap <silent><buffer><expr> cc
  \ defx#do_action('copy')
  nnoremap <silent><nowait><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><nowait><buffer><expr> t
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
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> dd
  \ defx#do_action('remove')
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
  nnoremap <silent><nowait><buffer><expr> <Space>
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

  nnoremap <nowait><buffer> f :DefxLineSearch<Space>
  nnoremap <nowait><buffer> F :DefxLineBackSearch<Space>
endfunction

call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })

command! -nargs=1 DefxLineSearch let @m=escape(<q-args>, '/\') | call search('\v^✹?\s*\S (\*|\|){1,2}\V\zs'. @m)
command! -nargs=1 DefxLineBackSearch let @m=escape(<q-args>, '/\') | call search('\v^✹?\s*\S (\*|\|){1,2}\V\zs'. @m, 'b')

" }}}

" .config/nvim/plugins/dein-firenvim.vim {{{
" vim:fdm=marker:
" Required:
" set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
" https://qiita.com/kawaz/items/ee725f6214f91337b42b
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
" Required:
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')
  " disable plugins
  call dein#disable('vim-airline/vim-airline')
  call dein#disable('vim-airline/vim-airline-themes')
  call dein#disable('monaqa/smooth-scroll')
  call dein#disable('thinca/vim-splash')
  call dein#disable('gruvbox-community/gruvbox')
  call dein#disable('rhysd/rust-doc.vim')
  call dein#disable('thinca/vim-quickrun')
  call dein#disable('Shougo/vimproc.vim')
  call dein#disable('previm/previm')
  call dein#disable('lambdalisue/gina.vim')
  call dein#disable('xolox/vim-session')
  call dein#disable('xolox/vim-misc')
  call dein#disable('tpope/vim-rhubarb')
  call dein#disable('syusui-s/scrapbox-vim')
  call dein#disable('wsdjeg/dein-ui.vim')
  call dein#disable('raghur/vim-ghost')
  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')
  " firenvim
  " call dein#add('glacambre/firenvim',
  "\ {
  "\   'hook_post_update': { _ -> firenvim#install(0) },
  "\   'hook_add': 'source ~/.config/nvim/plugins/firenvim.vim',
  "\   'merged': 0
  "\ })
  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.config/nvim/plugins/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  " Required:
  call dein#end()
  call dein#save_state()
endif
" Required だけど init.vim でやってるから別にいい
" filetype plugin indent on
" syntax enable
" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" }}}

" .config/nvim/plugins/dein.vim {{{
" Required:
" set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

" https://qiita.com/kawaz/items/ee725f6214f91337b42b
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

" プラグイン読み込み＆キャッシュ作成
" Required:
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.config/nvim/plugins/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required だけど init.vim でやってるから別にいい
" filetype plugin indent on
" syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
 call dein#install()
endif

" }}}

" .config/nvim/plugins/denite.vim {{{
nnoremap sb :Denite buffer -sorters=sorter/word<CR>
nnoremap sg :Denite grep -buffer-name=search-buffer-denite<CR>
nnoremap sG :Denite -resume -buffer-name=search-buffer-denite<CR>
nnoremap s] :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=+1 -immediately<CR>
nnoremap s[ :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=-1 -immediately<CR>
nnoremap so :Denite file/rec -buffer-name=search-file-denite<CR>
nnoremap sO :Denite file/rec -resume -buffer-name=search-file-denite<CR>

autocmd FileType rust nnoremap <buffer> <CR>d :Denite rust/doc<CR>

" floating window の設定
let s:denite_win_width_percent = 0.85
let s:denite_win_height_percent = 0.7

function! ResizeDeniteFloatingWindow()
  call denite#custom#option('_', {
        \ 'split': 'floating',
        \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
        \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
        \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
        \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
        \ 'prompt': "❯"
        \ })
endfunction

call ResizeDeniteFloatingWindow()

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


" }}}

" .config/nvim/plugins/fern.vim {{{
let g:fern#disable_default_mappings = 1
let g:fern#default_hidden = 1
nnoremap sf :<C-u>Fern . -drawer -toggle<CR>

augroup rc_fern
  autocmd!
  autocmd FileType fern set nonumber
  autocmd FileType fern set signcolumn=no
  autocmd FileType fern set foldcolumn=0
  autocmd FileType fern call s:fern_settings()
augroup END

function s:fern_settings()
  " move cwd, open file
  nmap <buffer> l <Plug>(fern-action-enter)
  nmap <buffer> <C-h> <Plug>(fern-action-leave)
  nmap <nowait><buffer> <CR> <Plug>(fern-action-open)
  nmap <buffer> e <Plug>(fern-action-open)
  nmap <buffer> <BS> <Plug>(fern-action-leave)

  " expand/collapse tree
  nmap <nowait><buffer> t <Plug>(fern-action-expand)
  nmap <nowait><buffer> T <Plug>(fern-action-collapse)

  " move, remove, copy...
  nmap <buffer> dd <Plug>(fern-action-trash)
endfunction

" }}}

" .config/nvim/plugins/firenvim.vim {{{
let g:firenvim_config = {
\     'globalSettings': {
\         'alt': 'all',
\      },
\     'localSettings': {
\         '.*': {
\             'cmdline': 'neovim',
\             'priority': 0,
\             'selector': 'textarea',
\             'takeover': 'never',
\         },
\     }
\ }

augroup Firenvim
  autocmd!
  autocmd BufEnter play.golang.org_*.txt set filetype=go
  autocmd BufEnter play.rust-lang.org_*.txt set filetype=rust
  autocmd BufEnter github.com_*.txt set filetype=markdown
  autocmd BufEnter localhost_notebooks*.txt set filetype=python
  autocmd BufEnter localhost_notebooks*.txt let b:coc_diagnostic_disable = 1
augroup END

" }}}

" .config/nvim/plugins/fugitive.vim {{{
nnoremap <Space>g :G<CR>

let g:nremap = {'s': '<Nop>'}

augroup rc_fugitive
  autocmd!
  autocmd FileType fugitive call s:fugitive_my_settings()
augroup END

function! s:fugitive_my_settings() abort
  nmap <buffer> u -
endfunction

" }}}

" .config/nvim/plugins/gina.vim {{{
nnoremap <Space>g :<C-u>Gina status -s --opener=split<CR>

" }}}

" .config/nvim/plugins/go.vim {{{
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


" }}}

" .config/nvim/plugins/lexima.vim {{{
call lexima#add_rule({'at': '\%#[-0-9a-zA-Z_]', 'char': '{', 'input': '{'})
call lexima#add_rule({'at': '\%#\\', 'char': '{', 'input': '{', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'at': '\%#\$', 'leave': 1, 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': ['latex', 'tex']})
" call lexima#add_rule({'char': '\{', 'input_after': '\}', 'filetype': ['latex', 'tex']})
" call lexima#add_rule({'char': '}', 'at': '\\\%#}', 'leave': 1, 'filetype': ['latex', 'tex']})
" call lexima#add_rule({'char': '<BS>', 'at': '\\\{\%#\\\}', 'input': '<BS><BS><DEL><DEL>', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': "'", 'input':  "'", 'filetype': ['latex', 'tex', 'satysfi']})
" call lexima#add_rule({'input_after': '>', 'char': '<', 'filetype': ['satysfi']})
" call lexima#add_rule({'char': '<', 'at': '\\\%#', 'filetype': ['satysfi']})
" call lexima#add_rule({'char': '>', 'leave': 1, 'at': '\%#>', 'filetype': ['satysfi']})
" call lexima#add_rule({'char': '<BS>', 'at': '<\%#>', 'delete': 1, 'filetype': ['satysfi']})
call lexima#add_rule({'char': '``', 'input_after': '``', 'filetype': ['rst']})
" call lexima#add_rule({'char': "（", 'input_after': "）"})
" call lexima#add_rule({'char': "）", 'at': "\%#）", 'leave': 1})
" call lexima#add_rule({'char': '<BS>', 'at': '（\%#）', 'delete': 1})

" }}}

" .config/nvim/plugins/quickrun.vim {{{
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
\ 'runner': 'vimproc',
\ 'runner/vimproc/updatetime': 40,
\ 'outputter': 'error',
\ 'outputter/error/success': 'buffer',
\ 'outputter/error/error': 'quickfix',
\ 'hook/close_quickfix/enable_exit': 1
\ }

let quickrun_config['jupytext'] = {
\ 'command': 'jupytext',
\ 'exec': '%c %o %a',
\ 'cmdopt': '--update --to notebook',
\ 'outputter/error/success': 'null',
\ 'outputter/error/error': 'buffer',
\ }

let quickrun_config['satysfi'] = {
\ 'command': 'satysfi',
\ 'exec': '%c %a',
\ 'outputter/error/success': 'null',
\ 'outputter/error/error': 'buffer',
\ }

let quickrun_config['satysfi-debug'] = {
\ 'command': 'satysfi',
\ 'exec': '%c %a %o',
\ 'cmdopt': '--debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space',
\ 'outputter/error/success': 'null',
\ 'outputter/error/error': 'buffer',
\ }

" example; :QuickRun rsync -args /Users/mogami/work/path-of-project remote:work/sync-mac
let g:quickrun_config['rsync'] = {
\ 'command': 'rsync',
\ 'cmdopt': '-C --filter=":- .gitignore" --exclude ".git" -acvz --delete -e ssh',
\ 'exec': '%c %o %a',
\ 'outputter/error/success': 'null',
\ }


augroup rc_quickrun
  autocmd!
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>q :QuickRun satysfi -args %{expand("%")}<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>Q :QuickRun satysfi-debug -args %{expand("%")}<CR>
  autocmd FileType python nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
augroup END

" }}}

" .config/nvim/plugins/sandwich.vim {{{

" 従来のキーマッピングを保存

nmap ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap dsb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
nmap cs <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap csb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
" runtime macros/sandwich/keymap/surround.vim

" 開きカッコを指定したときの挙動を自分好みに
let g:sandwich#recipes += [
\   {'buns': [' {', '} '], 'nesting': 1, 'match_syntax': 1,
\    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
\
\   {'buns': [' [', '] '], 'nesting': 1, 'match_syntax': 1,
\    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
\
\   {'buns': [' (', ') '], 'nesting': 1, 'match_syntax': 1,
\    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
\
\   {'buns': ['\s*{', '}\s*'],   'nesting': 1, 'regex': 1,
\    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
\    'action': ['delete'], 'input': ['{']},
\
\   {'buns': ['\s*\[', '\]\s*'], 'nesting': 1, 'regex': 1,
\    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
\    'action': ['delete'], 'input': ['[']},
\
\   {'buns': ['\s*(', ')\s*'],   'nesting': 1, 'regex': 1,
\    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
\    'action': ['delete'], 'input': ['(']},
\ ]

" 日本語のカッコ
let g:sandwich#recipes += [
\   {'buns': ['（', '）'], 'nesting': 1, 'input': ['j(', 'j)', 'jp']},
\   {'buns': ['「', '」'], 'nesting': 1, 'input': ['j[', 'j]', 'jb']},
\   {'buns': ['『', '』'], 'nesting': 1, 'input': ['j{', 'j}', 'jB']},
\   {'buns': ['【', '】'], 'nesting': 1, 'input': ['j<', 'j>', 'jk']},
\ ]

" Escaped parens
let g:sandwich#recipes += [
\   {'buns': ['\{', '\}'], 'nesting': 1, 'input': ['\{', '\}']},
\   {'buns': ['\(', '\)'], 'nesting': 1, 'input': ['\(', '\)']},
\   {'buns': ['\[', '\]'], 'nesting': 1, 'input': ['\[', '\]']},
\ ]

let g:sandwich#recipes += [
\   {'buns': ['`', ' <>`_'], 'nesting': 0, 'input': ['l'], 'filetype': ['rst']},
\   {'buns': ['` <', '>`_'], 'nesting': 0, 'input': ['L'], 'filetype': ['rst']},
\ ]

" }}}

" .config/nvim/plugins/vim-textobj-user.vim {{{
call textobj#user#plugin('line', {
\   '-': {
\     'select-a-function': 'CurrentLineA',
\     'select-a': 'al',
\     'select-i-function': 'CurrentLineI',
\     'select-i': 'il',
\   },
\ })

function! CurrentLineA()
  normal! 0
  let head_pos = getpos('.')
  normal! $
  let tail_pos = getpos('.')
  return ['v', head_pos, tail_pos]
endfunction

function! CurrentLineI()
  normal! ^
  let head_pos = getpos('.')
  normal! g_
  let tail_pos = getpos('.')
  let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  return
  \ non_blank_char_exists_p
  \ ? ['v', head_pos, tail_pos]
  \ : 0
endfunction

call textobj#user#plugin('jbraces', {
      \   'parens': {
      \       'pattern': ['（', '）'],
      \       'select-a': 'aj)', 'select-i': 'ij)'
      \  },
      \   'braces': {
      \       'pattern': ['「', '」'],
      \       'select-a': 'aj[', 'select-i': 'ij]'
      \  },
      \  'double-braces': {
      \       'pattern': ['『', '』'],
      \       'select-a': 'aj{', 'select-i': 'ij}'
      \  },
      \  'lenticular-bracket': {
      \       'pattern': ['【', '】'],
      \       'select-a': 'aj<', 'select-i': 'ij>'
      \  },
      \})

augroup rc_textobj_user
  autocmd!
  autocmd filetype tex call textobj#user#plugin('texquote', {
        \   'signle': {
        \     'pattern': ['`', "'"],
        \     'select-a': 'aq', 'select-i': 'iq'
        \   },
        \   'double': {
        \     'pattern': ['``', "''"],
        \     'select-a': 'aQ', 'select-i': 'iQ'
        \   },
        \ })
augroup END

" }}}
