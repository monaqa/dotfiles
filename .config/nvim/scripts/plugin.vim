" vim:fdm=marker:fmr=§§,■■

" Package を load した後に設定するもの．

" §§1 Plugin settings for cohama/lexima.vim

call lexima#add_rule({'at': '\%#[-0-9a-zA-Z_]', 'char': '{', 'input': '{'})
call lexima#add_rule({'at': '\%#\\', 'char': '{', 'input': '{', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'at': '\%#\$', 'leave': 1, 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': '$', 'input': '${', 'input_after': '}', 'filetype': ['satysfi']})
call lexima#add_rule({'char': '$', 'at': '\\\%#', 'leave': 1, 'filetype': ['satysfi']})
call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': ['latex', 'tex']})
call lexima#add_rule({'char': "'", 'input':  "'", 'filetype': ['latex', 'tex', 'satysfi']})
call lexima#add_rule({'char': '``', 'input_after': '``', 'filetype': ['rst']})

inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u" . lexima#expand('<LT>CR>', 'i')

" §§1 Plugin settings for habamax/vim-gruvbit

" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_material_background = 'hard'

augroup vimrc_colorscheme
  autocmd!
  autocmd ColorScheme gruvbit call s:setting_gruvbit()
augroup END

function! s:setting_gruvbit() abort
  hi! FoldColumn guibg=#303030
  hi! NonText guifg=#496da9
  hi! CocHintFloat guibg=#444444 guifg=#45daef
  hi! link CocRustChainingHint CocHintFloat
  " Diff に関しては前のバージョン
  " (https://github.com/habamax/vim-gruvbit/commit/a19259a1f02bbfff37d72eebef6b5d5d22f22248)
  " のほうが好みだったので。
  hi! DiffChange guifg=NONE guibg=#314a5c gui=NONE cterm=NONE
  hi! DiffDelete guifg=#968772 guibg=#5c3728 gui=NONE cterm=NONE
endfunction

" §§1 Plugin settings for kana/vim-altr

nmap <CR>^ <Plug>(altr-forward)

" §§1 Plugin settings for kana/vim-textobj-user

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
  autocmd filetype satysfi call textobj#user#plugin('satyblock', {
        \   'block': {
        \     'pattern': ['<%', '>%'],
        \     'select-a': 'a>', 'select-i': 'i>',
        \   },
        \ })
augroup END

" §§1 Plugin settings for lambdalisue/fern.vim

let g:fern#renderer = 'nerdfont'
nnoremap sf <Cmd>Fern . -reveal=%<CR>
nnoremap sz <Cmd>Fern . -drawer -toggle<CR>

augroup rc_fern
  autocmd!
  autocmd FileType fern setlocal nonumber
  autocmd FileType fern setlocal signcolumn=no
  autocmd FileType fern setlocal foldcolumn=0
  autocmd FileType fern call s:fern_settings()
augroup END

function s:fern_settings()
  nmap <buffer><expr>
  \ <Plug>(fern-expand-or-enter)
  \ fern#smart#drawer(
  \   "\<Plug>(fern-action-expand)",
  \   "\<Plug>(fern-action-enter)",
  \ )
  nmap <buffer><expr>
  \ <Plug>(fern-open-or-enter)
  \ fern#smart#leaf(
  \   "\<Plug>(fern-action-open)",
  \   "\<Plug>(fern-action-enter)",
  \ )
  nmap <buffer><expr>
  \ <Plug>(fern-open-or-expand)
  \ fern#smart#leaf(
  \   "\<Plug>(fern-action-open)",
  \   "\<Plug>(fern-action-expand)",
  \ )
  nmap <silent><buffer><expr> <Plug>(fern-expand-or-collapse)
  \ fern#smart#leaf(
  \   "\<Plug>(fern-action-collapse)",
  \   "\<Plug>(fern-action-expand)",
  \   "\<Plug>(fern-action-collapse)",
  \ )

  " move cwd, open file
  nmap <buffer> l <Plug>(fern-open-or-expand)
  nmap <buffer> <C-h> <Plug>(fern-action-leave)
  nmap <nowait><buffer> <CR> <Plug>(fern-open-or-enter)
  nmap <buffer> e <Plug>(fern-action-open)
  nmap <buffer> <BS> <Plug>(fern-action-leave)

  " expand/collapse tree
  nmap <nowait><buffer> t <Plug>(fern-expand-or-collapse)
  nmap <nowait><buffer> T <Plug>(fern-action-collapse)

  " new
  nmap <buffer> o <Plug>(fern-action-new-file)
  nmap <buffer> O <Plug>(fern-action-new-dir)

  " move, remove, copy...
  nmap <nowait><buffer> d <Plug>(fern-action-trash)
  nmap <nowait><buffer> r <Plug>(fern-action-rename)
  nmap <nowait><buffer> c <Plug>(fern-action-copy)
  nmap <nowait><buffer> m <Plug>(fern-action-move)

  " other
  nmap <nowait><buffer> ! <Plug>(fern-action-hidden-toggle)
  nmap <buffer> <C-l> <Plug>(fern-action-redraw)
endfunction

augroup my-fern-hijack
  autocmd!
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END

function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction

" §§1 Plugin settings for lambdalisue/gina.vim

let s:gina_custom_translation_patterns = [
\   [
\     '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
\     '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
\     '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
\     '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
\   ], {
\     'root':  'https://\1/\2/\3/tree/%r1/',
\     '_':     'https://\1/\2/\3/blob/%r1/%pt%{#L|}ls%{-L}le',
\     'exact': 'https://\1/\2/\3/blob/%h1/%pt%{#L|}ls%{-L}le',
\   },
\ ]

nnoremap <Space>gs :<C-u>Gina status -s --opener=split<CR>
nnoremap <Space>gb :Gina browse --exact --yank :<CR>:let @+=@"<CR>:echo @+<CR>
vnoremap <Space>gb :Gina browse --exact --yank :<CR>:let @+=@"<CR>:echo @+<CR>

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
call SetupCommandAbbrs('Gc', 'Gina commit')
call SetupCommandAbbrs('Gp', 'Gina push')

" §§1 Plugin settings for lervag/vimtex

let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:tex_flavor = "latex"
let g:vimtex_fold_enabled = 1
let g:vimtex_indent_ignored_envs = ['document', 'frame']
let g:vimtex_imaps_leader = "@"


" §§1 Plugin settings for liuchengxu/vista.vim

nnoremap <silent> sm :<C-u>Vista!!<CR>

" §§1 Plugin settings for machakann/vim-textobj-functioncall

" ジェネリクスも関数呼び出しとして扱う
let g:textobj_functioncall_patterns = [
  \ {
  \   'header' : '\<\%(\h\k*\.\)*\h\k*',
  \   'bra'    : '(',
  \   'ket'    : ')',
  \   'footer' : '',
  \ },
  \ {
  \   'header' : '\<\h\k*',
  \   'bra'    : '<',
  \   'ket'    : '>',
  \   'footer' : '',
  \ },
  \ ]

" §§1 Plugin settings for machakann/vim-sandwich

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
\   {'buns': ['[', ']()'], 'nesting': 0, 'input': ['l'], 'filetype': ['markdown']},
\   {'buns': ['[](', ')'], 'nesting': 0, 'input': ['L'], 'filetype': ['markdown']},
\ ]

let g:sandwich#recipes += [
\   {
\     'filetype'    : ['markdown'],
\     'buns'        : ['```', '```' ],
\     'input'       : ['c', ],
\     'kind'        : ['add'],
\     'linewise'    : 1,
\   },
\ ]

let g:sandwich#recipes += [
\ {
\   'buns': ['GenericsName()', '">"'],
\   'expr': 1,
\   'cursor': 'inner_tail',
\   'kind': ['add', 'replace'],
\   'action': ['add'],
\   'input': ['g']
\ },
\ {
\   'external': ['i<', "\<Plug>(textobj-functioncall-a)"],
\   'noremap': 0,
\   'kind': ['delete', 'replace', 'query'],
\   'input': ['g']
\ },
\ ]

function! GenericsName() abort
  let genericsname = input('generics name: ', '')
  if genericsname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return genericsname . '<'
endfunction

let g:sandwich#recipes += [
\ {
\   'buns': ['InlineCommandName()', '"}"'],
\   'expr': 1,
\   'cursor': 'inner_tail',
\   'kind': ['add', 'replace'],
\   'action': ['add'],
\   'input': ['c'],
\   'filetype': ['satysfi']
\ },
\ {
\   'buns': ['BlockCommandName()', '">"'],
\   'expr': 1,
\   'cursor': 'inner_tail',
\   'kind': ['add', 'replace'],
\   'action': ['add'],
\   'input': ['+'],
\   'filetype': ['satysfi']
\ },
\ ]

function! InlineCommandName() abort
  let cmdname = input('inline-cmd name: ', '')
  if cmdname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return '\' . cmdname . '{'
endfunction

function! BlockCommandName() abort
  let cmdname = input('block-cmd name: ', '')
  if cmdname ==# ''
    throw 'OperatorSandwichCancel'
  endif
  return '+' . cmdname . '<'
endfunction

" §§2 between mappings
omap m <Plug>(textobj-sandwich-literal-query-i)
vmap m <Plug>(textobj-sandwich-literal-query-i)
omap M <Plug>(textobj-sandwich-literal-query-a)
vmap M <Plug>(textobj-sandwich-literal-query-a)

" §§1 Plugin settings for machakann/vim-swap

omap i, <Plug>(swap-textobject-i)
xmap i, <Plug>(swap-textobject-i)
omap a, <Plug>(swap-textobject-a)
xmap a, <Plug>(swap-textobject-a)

" §§1 Plugin settings for mbbill/undotree

nnoremap U :<C-u>UndotreeToggle<CR>

" §§1 Plugin settings for monaqa/smooth-scroll.vim

let g:smooth_scroll_no_default_key_mappings = 1
let g:smooth_scroll_interval = 1000.0 / 40
let g:smooth_scroll_scrollkind = "quintic"
nnoremap <silent> <C-d> :<C-u>call smooth_scroll#flick(v:count1 * winheight(0) / 2, 15,  1)<CR>
nnoremap <silent> <C-u> :<C-u>call smooth_scroll#flick(v:count1 * winheight(0) / 2, 15, -1)<CR>
nnoremap <silent> <C-f> :<C-u>call smooth_scroll#flick(v:count1 * winheight(0)    , 25,  1)<CR>
nnoremap <silent> <C-b> :<C-u>call smooth_scroll#flick(v:count1 * winheight(0)    , 25, -1)<CR>

" §§1 Plugin settings for monaqa/vim-edgemotion

map <C-n> <Plug>(edgemotion-j)
map <C-p> <Plug>(edgemotion-k)

" §§1 Plugin settings for neoclide/coc.nvim

nnoremap m <Nop>
" m を prefix にする
nmap <silent> md <Plug>(coc-definition)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> mi <Plug>(coc-implementation)
nmap <silent> my <Plug>(coc-type-definition)
nmap <silent> mr <Plug>(coc-references)
nmap <silent> mn <Plug>(coc-rename)
nnoremap <silent> K :call CocAction('doHover')<CR>
nnoremap <silent> <Space>j :call CocAction('diagnosticNext')<CR>
nnoremap <silent> <Space>k :call CocAction('diagnosticPrevious')<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
" let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

augroup rc_coc
  autocmd!
  autocmd Filetype rust nnoremap <cr>r :CocCommand rust-analyzer.reload<CR>
augroup END

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<C-g><C-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<C-g><C-k>'

" Remap for do codeAction of selected region
" function! s:cocActionsOpenFromSelected(type) abort
"   execute 'CocCommand actions.open ' . a:type
" endfunction
" xnoremap <silent> ma :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
" nnoremap <silent> ma :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@l
xmap <silent> ma <Plug>(coc-codeaction-selected)
nmap <silent> ma <Plug>(coc-codeaction-selected)l


" §§2 fzf-preview
let g:fzf_preview_floating_window_rate = 0.8
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=never --hidden'
nnoremap sb :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap sg :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
nnoremap so :<C-u>CocCommand fzf-preview.DirectoryFiles <CR>
" ■■

" §§1 Plugin settings for previm/previm

let g:previm_open_cmd = "open -a 'Google Chrome'"
let g:previm_custom_css_path = "~/.config/nvim/scripts/template/markdown.css"

" §§1 Plugin settings for rhysd/rust-doc.vim

let g:rust_doc#define_map_K = 0

" §§1 Plugin settings for sheerun/vim-polyglot

let g:rst_fold_enabled = 1

" §§1 Plugin settings for thinca/vim-quickrun

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
  " autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>q :QuickRun satysfi -args %{expand("%")}<CR>
  " autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>Q :QuickRun satysfi-debug -args %{expand("%")}<CR>
  autocmd FileType python nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
augroup END

" §§1 Plugin settings for thinca/vim-submode

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

call submode#enter_with('vertjmp', 'n', '', '<Space>;', ':LineSameSearch<CR>')
call submode#enter_with('vertjmp', 'n', '', '<Space>,', ':LineBackSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ';', ':LineSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ',', ':LineBackSameSearch<CR>')
call submode#leave_with('vertjmp', 'n', '', '<Space>')

" §§1 Plugin settings for tpope/vim-capslock

inoremap <C-l> <Nop>

" §§1 Plugin settings for tyru/caw.vim
" toggle comment を t に割り当てる。
nmap t <Plug>(caw:hatpos:toggle:operator)
vmap t <Plug>(caw:hatpos:toggle)
nmap tt <Plug>(caw:hatpos:toggle)

" §§1 Plugin settings for xolox/vim-session

let s:local_session_directory = xolox#misc#path#merge(getcwd(), '.vimsessions')
" 存在すれば
if isdirectory(s:local_session_directory)
  " session保存ディレクトリをそのディレクトリの設定
  let g:session_directory = s:local_session_directory
  " vimを辞める時に自動保存
  let g:session_autosave = 'yes'
  " 引数なしでvimを起動した時にsession保存ディレクトリのdefault.vimを開く
  let g:session_autoload = 'yes'
  " 1分間に1回自動保存
  " let g:session_autosave_periodic = 1
else
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
endif
unlet s:local_session_directory
