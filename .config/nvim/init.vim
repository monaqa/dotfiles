" vim:foldmethod=marker:

" エディタ全般の設定{{{
""""""""""""""""""""""""

" まず最初に dein.vim でプラグインを読み込む
source ~/.config/nvim/plugins/dein.vim

" Syntax, mouse などの有効化{{{
filetype plugin indent on
syntax enable


set mouse=a
if &shell =~# 'fish$'
    set shell=sh
endif

let g:python3_host_prog = '/Users/shinichi/.local/share/virtualenvs/nvim-mnzZ7QHz/bin/python'

if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

" Path 関連？不要？
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath

" }}}

" タブ文字/不可視文字/インデントの設定{{{
set expandtab
set tabstop=4
set shiftwidth=4
set breakindent

" indent 幅のデフォルト
autocmd filetype vim set shiftwidth=2
autocmd filetype xml,html set shiftwidth=2
autocmd filetype tex set shiftwidth=2
" }}}
" }}}


" Theme/colorscheme/表示設定 {{{
"""""""""""""""""""""""""""""""""

" 表示設定 {{{
set number
set cursorline
set cursorcolumn
set colorcolumn=80
set virtualedit=onemore  " 行末の1文字先までカーソルを移動したい
set visualbell
set noerrorbells
" set showmatch " 対応カッコを表示
set laststatus=2 " ステータスラインを常に表示
set scrolloff=10
set ambiwidth=single  "全角文字幅
set showcmd

set modeline
set modelines=3

set list
set listchars=tab:▸▹┊,trail:⌑
set lazyredraw
set ttyfast

set statusline^=%{coc#status()}
set signcolumn=yes
" }}}

" 全角スペース強調 {{{
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776
augroup MyVimrc
    autocmd!
augroup END

augroup MyVimrc
    autocmd ColorScheme * highlight link UnicodeSpaces Error
    autocmd VimEnter,WinEnter * match UnicodeSpaces /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/
augroup END
" }}}

" Theme {{{
" augroup の設定の後に読み込む必要がある
let g:gruvbox_contrast_dark = 'hard'
set background=dark
colorscheme gruvbox

hi! link SpecialKey GruvboxBg4
hi! NonText ctermfg=103
hi! MatchParen ctermbg=0
hi! ColorColumn ctermbg=238
hi! CursorColumn ctermbg=236
hi! CursorLine ctermbg=236
hi! link Folded GruvboxPurpleBold
hi! link VertSplit GruvboxFg1
hi! link HighlightedyankRegion DiffChange
autocmd filetype help hi! Ignore ctermfg=66
" }}}

" .vimrc.local {{{
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction
" }}}
" }}}


" エディタの機能に関する設定 {{{
"""""""""""""""""""""""""""""""""

set backupskip=/tmp/*,/private/tmp/*
set nobackup
set noswapfile
set autoread
set hidden

set spelllang=en,cjk

set virtualedit=block
set backspace=indent,eol,start
set history=10000

" 検索機能{{{
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set inccommand=split
nnoremap g/ /\v
nnoremap * *N
nnoremap g* g*N

nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" VISUAL モードから簡単に検索
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <CR> "my/\V<C-R><C-R>=substitute(
  \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>N
vnoremap <S-CR> "sy:set hlsearch<CR>/\V<C-R><C-R>=substitute(
  \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \:,$s/\V<C-R><C-R>=substitute(
  \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR>
  \/<C-R><C-R>=escape(@s, '/\&~')<CR>
  \/gce<Bar>1,''-&&<CR>

" }}}

" Terminal 機能 {{{
tnoremap <Esc><Esc> <C-\><C-n>

function! s:bufnew()
   " 幸いにも 'buftype' は設定されているのでそれを基準とする
    if &buftype == "terminal" && &filetype == ""
        set filetype=terminal
    endif
endfunction

function! s:terminal_init()
   " ここに :terminal のバッファ固有の設定を記述する
   " nnoremap <buffer> a i<Up><CR><C-\><C-n>
   nnoremap <buffer> <CR> i<CR><C-\><C-n>
   nnoremap <expr><buffer> a "i" . repeat("<Up>", v:count1) . "<C-\><C-n>"
   nnoremap <expr><buffer> A "i" . repeat("<Down>", v:count1) . "<C-\><C-n>"
   nnoremap <buffer> q :bd!<CR>
   nnoremap <buffer> t :let g:active_terminal_id = b:terminal_job_id<Bar>let g:slime_default_config = {"jobid": b:terminal_job_id}<CR>
   nnoremap <buffer> c i<C-u>
   nnoremap <buffer> dd i<C-u><C-\><C-n>
   nnoremap <buffer> o :set scrolloff=0<CR>
   nnoremap <buffer> O :set scrolloff=10<CR>
endfunction

augroup my-terminal
    autocmd!
   " BufNew の時点では 'buftype' が設定されていないので timer イベントでごまかすなど…
    autocmd BufNew,BufEnter * call timer_start(0, { -> s:bufnew() })
    autocmd FileType terminal call s:terminal_init()
    autocmd FileType terminal set nonumber
    autocmd FileType terminal set signcolumn=no
augroup END

function! MgmOpenTerminal()
    let ft = &filetype
  if (winwidth(".") >= 125)
    vsplit
  else
    split
  endif
    edit term://fish
    if (ft == "python")
        call chansend(b:terminal_job_id, "ipython\n%autoindent\n")
    elseif (ft == "julia")
        call chansend(b:terminal_job_id, "julia\nBase.active_repl.options.auto_indent = false\n")
    endif
    let g:slime_default_config = {"jobid": b:terminal_job_id}
    let g:active_terminal_id = b:terminal_job_id
endfunction

nnoremap sT :call MgmOpenTerminal()<CR>
nnoremap <Space>b<CR> :call chansend(g:active_terminal_id, "\n")<CR>

nnoremap st :call MgmOpenTermWindow()<CR>

function! MgmOpenTermWindow()
  sbuffer term
  if (winwidth(".") >= 125)
    normal sL
  endif
endfunction

" }}}
" }}}


" 日本語に関する設定{{{
""""""""""""""""""""""""

set matchpairs+=「:」,（:）,【:】,『:』

noremap <silent> f, :<C-u>call MgmNumSearchLine('[，、,]', v:count1, '' )<CR>
noremap <silent> f. :<C-u>call MgmNumSearchLine('[．。.]', v:count1, '' )<CR>
noremap <silent> F, :<C-u>call MgmNumSearchLine('[，、,]', v:count1, 'b')<CR>
noremap <silent> F. :<C-u>call MgmNumSearchLine('[．。.]', v:count1, 'b')<CR>

" }}}


" Window/buffer の設定{{{
""""""""""""""""""""""""""

" https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
nnoremap s <Nop>
" バッファ作成と削除
nnoremap s_ :<C-u>sp<CR>
nnoremap s<Bar> :<C-u>vs<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sn :<C-u>bn<CR>
nnoremap sp :<C-u>bp<CR>
nnoremap sq :<C-u>bd<CR>
nnoremap sw :<C-u>q<CR>
" バッファ間移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
" バッファの移動（位置関係変更）
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
" 各ウィンドウの大きさ変更
" submode も参照
nnoremap s= <C-w>=
" タブページ
nnoremap sN gt
nnoremap sP gT
" Scroll bind

nnoremap s<Space> :<C-u>execute "buffer" v:count<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

set splitbelow
set splitright

" }}}


" Operator {{{
""""""""""""""

" D や C との一貫性
map Y y$

" x の結果はバッファに入れない．dx でも同様に扱う
nnoremap x "_x
nnoremap X "_X
nnoremap dx "_d
nnoremap cx "_c

" よく使うレジスタは挿入モードでも挿入しやすく
inoremap <C-r><C-r> <C-r>"
cnoremap <C-r><C-r> <C-r>"
inoremap <C-r><CR> <C-r>0
cnoremap <C-r><CR> <C-r>0
inoremap <C-r><Space> <C-r>+
cnoremap <C-r><Space> <C-r>+

" set clipboard+=unnamed
set clipboard=
" noremap <Space>y "+y
noremap <Space>p "+p
noremap <Space>y "+y
if exists('##TextYankPost')
  autocmd TextYankPost *   call MgmCopyUnnamedToPlus(v:event.operator)
endif

function! MgmCopyUnnamedToPlus(opr)
  " yank 操作のときのみ， + レジスタに内容を移す（delete のときはしない）
  if a:opr == "y"
    let @+ = @"
  endif
endfunction

" 指定 text object/motion を指定レジスタの中身に入れ替える
" （要は delete と put を同時にやる）
nmap <silent> <Space>r :<C-u>let w:replace_buffer = v:register <Bar> set opfunc=MgmReplace<CR>g@
nmap <silent> <Space>rr :<C-u>let w:replace_buffer = v:register <Bar> call MgmReplaceALine(v:count1)<CR>
nmap <silent> <Space>rx :<C-u>let w:replace_buffer = v:register <Bar> set opfunc=MgmReplaceX<CR>g@

function! MgmReplace(type)
  let sel_save = &selection
  let &selection = "inclusive"
  let m_reg = @m
  exe "let @m = @" . w:replace_buffer

  if a:type == 'line'
    exe "normal! '[V']d"
  else
    exe "normal! `[v`]d"
  endif

  exe "normal! " . '"' . "mP"

  let &selection = sel_save
  let @m=m_reg
endfunction

function! MgmReplaceX(type)
  let sel_save = &selection
  let &selection = "inclusive"
  let m_reg = @m
  exe "let @m = @" . w:replace_buffer

  if a:type == 'line'
    exe "normal! '[V']" . '"_d'
  else
    exe "normal! `[v`]" . '"_d'
  endif

  exe "normal! " . '"' . "mP"

  let &selection = sel_save
  let @m=m_reg
endfunction

function! MgmReplaceALine(nline)
  let sel_save = &selection
  let &selection = "inclusive"
  " let m_reg = @m
  exe "let @m = @" . w:replace_buffer

  exe "normal! " . a:nline . "dd"
  exe "normal! " . '"' . "mP"

  let &selection = sel_save
  " let @m=m_reg
endfunction

" }}}


" Motion {{{
""""""""""""

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
" 上記移動を行っていると <C-Space> で <C-@> が動作してしまうのが不便．
" imap <Nul> <Nop>
" としてもうまくいかないので，苦肉の策で <C-@> を潰す
imap <C-Space> <Space>

noremap <Space>h ^
noremap <Space>l $

" f 移動をさらに便利に
noremap <silent> f<CR> :<C-u>call MgmNumSearchLine('[A-Z]', v:count1, '')<CR>
noremap <silent> F✠ :<C-u>call MgmNumSearchLine('[A-Z]', v:count1, 'b')<CR>
vnoremap <silent> f<CR> :<C-u>call MgmNumSearchLine('[A-Z]', v:count1, '')<CR>v`'o
vnoremap <silent> F✠ :<C-u>call MgmNumSearchLine('[A-Z]', v:count1, 'b')<CR>v`'o

function! MgmNumSearchLine(ptn, num, opt)
  for i in range(a:num)
    call search(a:ptn, a:opt, line("."))
  endfor
endfunction

" 整合性のとれた括弧に移動するための motion {{{

vnoremap m) mzi)o`zo
vnoremap m( mzi)`zo
vnoremap m] mzi]o`zo
vnoremap m[ mzi]`zo
vnoremap m} mzi}o`zo
vnoremap m{ mzi}`zo

nnoremap dm) vmzi)o`zod
nnoremap dm( vmzi)`zod
nnoremap dm] vmzi]o`zod
nnoremap dm[ vmzi]`zod
nnoremap dm} vmzi}o`zod
nnoremap dm{ vmzi}`zod

nnoremap cm) vmzi)o`zoc
nnoremap cm( vmzi)`zoc
nnoremap cm] vmzi]o`zoc
nnoremap cm[ vmzi]`zoc
nnoremap cm} vmzi}o`zoc
nnoremap cm{ vmzi}`zoc

" }}}

" Vertical f-motion {{{
command! -nargs=1 MgmLineSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m)
command! -nargs=1 MgmVisualLineSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 's') | normal v`'o
command! MgmLineSameSearch call search('^\s*\V'. @m)
command! -nargs=1 MgmLineBackSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 'b')
command! -nargs=1 MgmVisualLineBackSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 'bs') | normal v`'o
command! MgmLineBackSameSearch call search('^\s*\V'. @m, 'b')
nnoremap <Space>f :MgmLineSearch<Space>
nnoremap <Space>F :MgmLineBackSearch<Space>
onoremap <Space>f :MgmLineSearch<Space>
onoremap <Space>F :MgmLineBackSearch<Space>
vnoremap <Space>f :<C-u>MgmVisualLineSearch<Space>
vnoremap <Space>F :<C-u>MgmVisualLineBackSearch<Space>
nnoremap <Space>; :MgmLineSameSearch<CR>
nnoremap <Space>, :MgmLineBackSameSearch<CR>

call submode#enter_with('vertjmp', 'n', '', '<Space>;', ':MgmLineSameSearch<CR>')
call submode#enter_with('vertjmp', 'n', '', '<Space>,', ':MgmLineBackSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ';', ':MgmLineSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ',', ':MgmLineBackSameSearch<CR>')
call submode#leave_with('vertjmp', 'n', '', '<Space>')

" function! MgmVertSearch(opt)
"   let posnow = getcurpos()
"   let lspaces = posnow[2] - 1
"   let @m = nr2char(getchar())
"   let pos = searchpos('^.\{' . lspaces . '}\zs' . @m, a:opt)
"   call cursor(pos)
" endfunction

" function! MgmVisualVertSearch(opt)
"   let posnow = getpos("'>")
"   let lspaces = posnow[2] - 1
"   let @m = nr2char(getchar())
"   let pos = searchpos('^.\{' . lspaces . '}\zs' . @m, a:opt)
"   call cursor(pos)
"   normal v`'o
" endfunction

" 改訂版縦方向 f 移動（だけど使いにくい）
" nnoremap <silent> <Space>f :<C-u>call MgmVertSearch('')<CR>
" nnoremap <silent> <Space>F :<C-u>call MgmVertSearch('b')<CR>
" onoremap <silent> <Space>f :<C-u>call MgmVertSearch('')<CR>
" onoremap <silent> <Space>F :<C-u>call MgmVertSearch('b')<CR>
" vnoremap <silent> <Space>f :<C-u>call MgmVisualVertSearch('s')<CR>
" vnoremap <silent> <Space>F :<C-u>call MgmVisualVertSearch('bs')<CR>

" }}}
" }}}


" その他の特殊キーマップ{{{
""""""""""""""""""""""""""""

" function key 無効化 {{{
nnoremap <F1>  <Nop>
inoremap <F1>  <Nop>
inoremap <F2>  <Nop>
inoremap <F3>  <Nop>
inoremap <F4>  <Nop>
inoremap <F5>  <Nop>
inoremap <F6>  <Nop>
inoremap <F7>  <Nop>
inoremap <F8>  <Nop>
inoremap <F9>  <Nop>
inoremap <F10> <Nop>
inoremap <F12> <Nop>
" }}}

" 行の操作/空行追加 {{{
"
inoremap <S-CR> <End><CR>
inoremap <C-S-CR> <Up><End><CR>
nnoremap <S-CR> mzo<ESC>`z
nnoremap <C-S-CR> mzO<ESC>`z

if !has('gui_running')
  " CUIで入力された<S-CR>,<C-S-CR>が拾えないので
  " iTerm2のキー設定を利用して特定の文字入力をmapする
  " Map ✠ (U+2720) to <Esc> as <S-CR> is mapped to ✠ in iTerm2.
  map ✠ <S-CR>
  imap ✠ <S-CR>
  map ✢ <C-S-CR>
  imap ✢ <C-S-CR>
  map ➿ <C-CR>
  imap ➿ <C-CR>
endif

" 長い文の改行をノーマルモードから楽に行う
" try: f.<Space><CR> or f,<Space><CR>
nnoremap <silent> <Space><CR> a<CR><Esc>

" }}}
" }}}


" 特定の種類のファイルに対する設定{{{

" netrw {{{
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    noremap <buffer> i h
    noremap <buffer> s <Nop>
endfunction

" https://www.tomcky.net/entry/2018/03/18/005927
" 上部に表示される情報を非表示
let g:netrw_banner = 0
" 表示形式をTreeViewに変更
let g:netrw_liststyle = 3
" 左右分割を右側に開く
let g:netrw_altv = 1
" 分割で開いたときに85%のサイズで開く
let g:netrw_winsize = 85
" }}}

" TeX/LaTeX {{{
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '@line @pdf @tex'

let g:tex_flavor = 'latex'
" \cs を一単語に
autocmd Filetype tex set iskeyword+=92
" }}}

" SATySFi {{{

command! MgmSatyCompile :call chansend(g:active_terminal_id, "satysfi " . expand("%") . "\n")
command! MgmSatyShowPDF silent !open %:r.pdf

autocmd filetype satysfi nnoremap <Space>m :MgmSatyCompile<CR>
autocmd filetype satysfi nnoremap <Space>M :MgmSatyShowPDF<CR>

autocmd filetype satysfi set path+=/usr/local/share/satysfi/dist/packages,$HOME/.satysfi/dist/packages
autocmd filetype satysfi set suffixesadd+=.saty,.satyh,.satyg
autocmd BufRead,BufNewFile *.satyg setlocal filetype=satysfi
autocmd filetype satysfi let b:caw_oneline_comment = "%"

" autocmd filetype satysfi set foldmethod=

" }}}

" reST {{{
autocmd filetype rst set suffixesadd+=.rst
function! MgmReSTTitle(punc)
  let line = getline(".")
  sil! exe row 'foldopen!'
  call append(".", repeat(a:punc, strdisplaywidth(line)))
endfunction
autocmd filetype rst nnoremap <Space>s0 :call MgmReSTTitle("#")<CR>jo<Esc>
autocmd filetype rst nnoremap <Space>s1 :call MgmReSTTitle("=")<CR>jo<Esc>
autocmd filetype rst nnoremap <Space>s2 :call MgmReSTTitle("-")<CR>jo<Esc>
autocmd filetype rst nnoremap <Space>s3 :call MgmReSTTitle("~")<CR>jo<Esc>
autocmd filetype rst nnoremap <Space>s4 :call MgmReSTTitle('"')<CR>jo<Esc>
autocmd filetype rst nnoremap <Space>s5 :call MgmReSTTitle("'")<CR>jo<Esc>
" }}}

" HTML/XML {{{
  augroup MyXML
    autocmd!
    autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
    autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
  augroup END
" }}}

" Julia {{{
"
autocmd filetype julia set shiftwidth=4
autocmd filetype julia set path+=/Applications/Julia-1.1.app/Contents/Resources/julia/share/julia/base

" }}}

" todome {{{
"
autocmd fileType todo call s:todome_my_settings()
function! s:todome_my_settings() abort
  nnoremap <buffer><nowait> <Space>x :call TodomeToggleDone()<CR>
  nnoremap <buffer><nowait> <Space>a :call TodomeAddPriority('A')<CR>
  nnoremap <buffer><nowait> <Space>b :call TodomeAddPriority('B')<CR>
  nnoremap <buffer><nowait> <Space>c :call TodomeAddPriority('C')<CR>
  nnoremap <buffer><nowait> <Space>d :call TodomeAddPriority('D')<CR>
  nnoremap <buffer><nowait> <Space>e :call TodomeAddPriority('E')<CR>
  nnoremap <buffer><nowait> <Space>s :TodomeSort done priority due_date projects<CR>:TodomeFilter<Space>
endfunction

" }}}

" go {{{

autocmd FileType go call s:go_my_settings()
function! s:go_my_settings() abort
  noremap <buffer> s] :cnext<CR>
  noremap <buffer> s[ :cprev<CR>
  noremap <buffer> <Space>bb :GoBuild<CR>
  noremap <buffer> <Space>br :GoRun<CR>
endfunction

" }}}

" }}}
