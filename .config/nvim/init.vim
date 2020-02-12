" vim:foldmethod=marker:

set encoding=utf-8
scriptencoding utf-8

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

let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim/bin/python'

if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

" Path 関連？不要？
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath

augroup vimrc_general
  autocmd!
  " 他のどの augroup にも入れられそうにない余り物の autocmd を入れる augroup
augroup END

" }}}

" タブ文字/不可視文字/インデントの設定{{{
set expandtab
set tabstop=4
set shiftwidth=4
set breakindent
set smartindent

" indent 幅のデフォルト
augroup vimrc_indent
  autocmd filetype vim set shiftwidth=2
  autocmd filetype xml,html set shiftwidth=2
  autocmd filetype tex set shiftwidth=2
  autocmd filetype satysfi set shiftwidth=2
  autocmd filetype markdown,rst set shiftwidth=2
augroup END
" }}}
" }}}


" Theme/colorscheme/表示設定 {{{
"""""""""""""""""""""""""""""""""

" 表示設定 {{{
set number
set relativenumber
set cursorline
set cursorcolumn
set colorcolumn=80
set visualbell
set noerrorbells
" set showmatch " 対応カッコを表示
set laststatus=2 " ステータスラインを常に表示
set scrolloff=10
" set sidescrolloff=10
set ambiwidth=single  "全角文字幅
set showcmd

set modeline
set modelines=3

set list
set listchars=tab:▸▹┊,trail:⌑,extends:>,precedes:<
set nowrap

set lazyredraw
set ttyfast

set statusline^=%{coc#status()}
set signcolumn=yes
" }}}

" 全角スペース強調 {{{
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776

augroup vimrc_color
  autocmd!
  autocmd ColorScheme * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * match UnicodeSpaces
  \ /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/
augroup END

" }}}

" Theme {{{
" augroup の設定の後に読み込む必要がある
let g:gruvbox_contrast_dark = 'hard'
set background=dark
colorscheme gruvbox

hi! link SpecialKey GruvboxBg4
hi! NonText ctermfg=103
hi! MatchParen ctermbg=66 ctermfg=223
hi! ColorColumn ctermbg=238
hi! CursorColumn ctermbg=236
hi! CursorLine ctermbg=236
hi! link Folded GruvboxPurpleBold
hi! link VertSplit GruvboxFg1
hi! link HighlightedyankRegion DiffChange
autocmd vimrc_color FileType help hi! Ignore ctermfg=66
" }}}

" .vimrc.local {{{
augroup vimrc_local
  autocmd!
  autocmd VimEnter * call s:vimrc_local(expand('<afile>:p:h'))
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
set confirm

set spelllang=en,cjk

set virtualedit=block
set backspace=indent,eol,start
set history=10000
" set formatoptions=jcrqlnB
autocmd vimrc_general FileType * set formatoptions-=o formatoptions+=nB

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

" redraw 時にハイライトを消す
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap <silent> <Space><Space> :<C-u>nohlsearch<CR><C-l>ze

" VISUAL モードから簡単に検索
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap * "my/\V<C-R><C-R>=substitute(
\escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>N
vnoremap S "my:set hlsearch<CR>
\:,$s//<C-R><C-R>=escape(@m, '/\&~')<CR>
\/gce<Bar>1,''-&&<CR>
" }}}

" Terminal 機能 {{{
tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap <C-r><C-r> <C-\><C-N>""pi
tnoremap <C-r><CR> <C-\><C-N>"0pi
tnoremap <C-r><Space> <C-\><C-N>"+pi
" 苦肉の策
tnoremap <C-r><Esc> <C-r>

function! s:bufnew()
  " 幸いにも 'buftype' は設定されているのでそれを基準とする
  if &buftype ==# 'terminal' && &filetype ==# ''
    set filetype=terminal
  endif
endfunction

function! s:terminal_init()
  " ここに :terminal のバッファ固有の設定を記述する
  " nnoremap <buffer> a i<Up><CR><C-\><C-n>
  nnoremap <buffer> <CR> i<CR><C-\><C-n>
  nnoremap <expr><buffer> u "i" . repeat("<Up>", v:count1) . "<C-\><C-n>"
  nnoremap <expr><buffer> <C-r> "i" . repeat("<Down>", v:count1) . "<C-\><C-n>"
  nnoremap <buffer> sq :bd!<CR>
  nnoremap <buffer> t :let g:slime_default_config = {"jobid": b:terminal_job_id}<CR>
  nnoremap <buffer> dd i<C-u><C-\><C-n>
  " nnoremap <buffer> I i<C-a>
  nnoremap <buffer> A i<C-e>
  nnoremap <buffer><expr> I "i\<C-a>" . repeat("\<Right>", MgmCalcCursorRightNum())
endfunction

function! MgmCalcCursorRightNum() abort
  " normal "my0
  " let strlen = strchars(@m)
  let cpos = getcurpos()
  return cpos[2] - 5
endfunction

augroup vimrc_terminal
  autocmd!
  " BufNew の時点では 'buftype' が設定されていないので timer イベントでごまかすなど…
  autocmd BufNew,BufEnter * call timer_start(0, { -> s:bufnew() })
  autocmd FileType terminal call s:terminal_init()
  autocmd FileType terminal setlocal wrap
  autocmd FileType terminal setlocal nonumber
  autocmd FileType terminal setlocal norelativenumber
  autocmd FileType terminal setlocal signcolumn=no
augroup END

" なぜか augroup の中に入れると動かない
" （Terminal から別バッファに移動しても scrolloff が戻らない）ので
" 外に出しておく
autocmd TermOpen,TermEnter * set scrolloff=0
autocmd TermLeave,TermClose * set scrolloff=10

function! s:openTerminal()
  let ft = &filetype
  if (s:isWideWindow('.'))
    vsplit
  else
    split
  endif
  edit term://fish
  if (ft ==# 'python')
    call chansend(b:terminal_job_id, "ipython\n%autoindent\n")
  elseif (ft ==# 'julia')
    call chansend(b:terminal_job_id, "julia\nBase.active_repl.options.auto_indent = false\n")
  endif
  let g:slime_default_config = {'jobid': b:terminal_job_id}
endfunction

nnoremap <silent> sT :call <SID>openTerminal()<CR>

nnoremap <silent> st :call <SID>openTermWindow()<CR>

function! s:openTermWindow() abort
  if (bufname('term') ==# '')
    call s:openTerminal()
  elseif (s:isWideWindow('.'))
    vsplit
    buffer term
  else
    split
    buffer term
  endif
endfunction

" }}}

" Command-line window {{{
augroup vimrc_cmdwin
  autocmd!
  autocmd CmdwinEnter [:/\?=] setlocal nonumber
  autocmd CmdwinEnter [:/\?=] setlocal norelativenumber
  autocmd CmdwinEnter [:/\?=] setlocal signcolumn=no
  autocmd CmdwinEnter [:/\?=] nnoremap <buffer> <C-f> <C-f>
  autocmd CmdwinEnter [:/\?=] nnoremap <buffer> <C-u> <C-u>
  autocmd CmdwinEnter [:/\?=] nnoremap <buffer> <C-b> <C-b>
  autocmd CmdwinEnter [:/\?=] nnoremap <buffer> <C-d> <C-d>
  autocmd CmdwinEnter [:/\?=] nnoremap <buffer><nowait> <CR> <CR>
  autocmd CmdwinEnter : g/^qa\?!\?$/d _
  autocmd CmdwinEnter : g/^wq\?a\?!\?$/d _
augroup END
" }}}

" }}}


" 日本語に関する設定{{{
""""""""""""""""""""""""

set matchpairs+=（:）,「:」,『:』,【:】

" Japanese Characters
" 記号追加時のヒント：追加したい記号の上で ga と押せば...

" カッコ
digraphs j( 65288  " （
digraphs j) 65289  " ）
digraphs j[ 12300  " 「
digraphs j] 12301  " 」
digraphs j{ 12302  " 『
digraphs j} 12303  " 』
digraphs j< 12304  " 【
digraphs j> 12305  " 】

" 句読点
digraphs j, 65292  " ，
digraphs j. 65294  " ．
digraphs j! 65281  " ！
digraphs j? 65311  " ？
digraphs j: 65306  " ：

" 数字
digraphs j0 65296  " ０
digraphs j1 65297  " １
digraphs j2 65298  " ２
digraphs j3 65299  " ３
digraphs j4 65300  " ４
digraphs j5 65301  " ５
digraphs j6 65302  " ６
digraphs j7 65303  " ７
digraphs j8 65304  " ８
digraphs j9 65305  " ９

" その他の記号
digraphs j~ 12316  " 〜
digraphs j/ 12539  " ・
digraphs js 12288  " 　

" ちょっと j くんには悪いけど，fj は予約したほうが便利．
" これで「fj.」 と押せば全角ピリオドを検索できる
noremap fj f<C-k>j
noremap Fj F<C-k>j
noremap tj t<C-k>j
noremap Tj T<C-k>j

" これを設定することで， fjj を本来の fj と同じ効果にできる．
digraphs jj 106  " j
" }}}


" Window/buffer の設定{{{
""""""""""""""""""""""""""

" https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
nnoremap s <Nop>
" バッファ作成と削除
nnoremap s_ :<C-u>sp<CR>
nnoremap s<Bar> :<C-u>vs<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>bd<CR>
nnoremap sw :<C-u>q<CR>
" nnoremap s<Space> :<C-u>execute "buffer" v:count<CR>
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
" Command-line window
nnoremap s: q:G
nnoremap s? q?G
nnoremap s/ q/G

" Sandwich.vim のデフォルトキーバインドを上書きする
nnoremap <nowait> srb <Nop>
nnoremap <nowait> sr <C-^>

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

function! s:isWideWindow(nr)
  let wd = winwidth(a:nr)
  let ht = winheight(a:nr)
  if (wd > 2.2 * ht)
    return 1
  else
    return 0
  endif
endfunction

augroup vimrc_resized
  autocmd!
  autocmd VimResized * call <SID>resizeFloatingWindow()
  autocmd VimResized * exe "normal \<c-w>="
augroup END

function s:resizeFloatingWindow()
  if exists('*MgmResizeDefxFloatingWindow')
    call MgmResizeDefxFloatingWindow()
  endif
  if exists('*MgmResizeDeniteFloatingWindow')
    call MgmResizeDeniteFloatingWindow()
  endif
endfunction

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
noremap <Space>p "+]p
noremap <Space>y "+y

augroup vimrc_yank
  autocmd!
  if exists('##TextYankPost')
    autocmd TextYankPost * call <SID>copyUnnamedToPlus(v:event.operator)
  endif
augroup END

function! s:copyUnnamedToPlus(opr)
  " yank 操作のときのみ， + レジスタに内容を移す（delete のときはしない）
  if a:opr ==# 'y'
    let @+ = @"
  endif
endfunction

" }}}


" Motion/text object {{{
""""""""""""""""""""""""

" nnoremap j gj
" nnoremap k gk
" nnoremap gj j
" nnoremap gk k

inoremap <C-h> <Left>
inoremap <C-l> <Right>
" 上記移動を行っていると <C-Space> で <C-@> が動作してしまうのが不便．
" imap <Nul> <Nop>
" としてもうまくいかないので，苦肉の策で <C-@> を潰す
inoremap <C-Space> <Space>

noremap <Space>h ^
noremap <Space>l $

" f 移動をさらに便利に
noremap <silent> f<CR> :<C-u>call <SID>numSearchLine('[A-Z]', v:count1, '')<CR>
noremap <silent> F✠ :<C-u>call <SID>numSearchLine('[A-Z]', v:count1, 'b')<CR>
vnoremap <silent> f<CR> :<C-u>call <SID>numSearchLine('[A-Z]', v:count1, '')<CR>v`'o
vnoremap <silent> F✠ :<C-u>call <SID>numSearchLine('[A-Z]', v:count1, 'b')<CR>v`'o

function! s:numSearchLine(ptn, num, opt)
  for i in range(a:num)
    call search(a:ptn, a:opt, line('.'))
  endfor
endfunction

" 整合性のとれた括弧に移動するための motion {{{

" 一部標準で用意されているキーマップもあるが，
" そうでないものは頑張って実装．

noremap m) ])
noremap m} ]}

vnoremap m] mzi]o`z
vnoremap m( mzi)`z
vnoremap m{ mzi}`z
vnoremap m[ mzi]`z

nnoremap dm] mzvi]o`zod
nnoremap dm( mzvi)`zod
nnoremap dm{ mzvi}`zod
nnoremap dm[ mzvi]`zod

nnoremap cm] mzvi]o`zoc
nnoremap cm( mzvi)`zoc
nnoremap cm{ mzvi}`zoc
nnoremap cm[ mzvi]`zoc

" }}}

" クオート系テキストオブジェクトを自分好みに {{{
vnoremap a' 2i'
vnoremap a" 2i"
vnoremap a` 2i`
onoremap a' 2i'
onoremap a" 2i"
onoremap a` 2i`
vnoremap m' a'
vnoremap m" a"
vnoremap m` a`
onoremap m' a'
onoremap m" a"
onoremap m` a`
" }}}

" Vertical WORD (vWORD) 単位での移動 {{{

" <C-n>: 水平方向の  E 移動を鉛直方向にしたものに相当
" <C-p>: 水平方向の  B 移動を鉛直方向にしたものに相当
nnoremap <silent> <C-n> :<C-u>call <SID>movePerVerticalWordNcount(1, 0, -1, v:count1)<CR>
nnoremap <silent> <C-p> :<C-u>call <SID>movePerVerticalWordNcount(0, 1,  1, v:count1)<CR>

" omap では， inclusive な挙動が求められているとき
" <C-n> でいい感じに inclusive っぽくなるようにする．
" たとえば d<C-n> とするとその vWORD の最後まで消える
" （その下の空行は消えない）．
onoremap <silent> <C-n> :<C-u>call <SID>movePerVerticalWordNcount(1, 0,  0, v:count1)<CR>
onoremap <silent> <C-p> :<C-u>call <SID>movePerVerticalWordNcount(0, 1,  1, v:count1)<CR>

" 矩形選択のときなどに有用
" TODO: visual モード中に v:count をとってモーションを繰り返したい
vnoremap <silent> <C-n> <Esc>:call <SID>movePerVerticalWordNcount(1, 0, -1, 1)<CR>mzgv`z
vnoremap <silent> <C-p> <Esc>:call <SID>movePerVerticalWordNcount(0, 1,  1, 1)<CR>mzgv`z

" 上の map の挙動の実装．
" 空行で区切られた行の塊を vWORD とみなし，vWORD の頭や最後に移動する．
" ただし，カーソルが何列目にあるかの情報はできる限り保持する．
" V-BLOCK で動くときにこの挙動があるのとないのとでは天と地の差がある．
" function! s:movePerVerticalWord(direction, whichend, offset)
"   direction: 進行方向 (0: backward, 1: forward)
"   whichend: 空行に移動するとき「どちらの端」を基準に飛ぶか
"             (0: 最初の行, 1: 最後の行 + 1)
"   offset: whichend で指定した行を基準にずらす行数 (int)
function! s:movePerVerticalWord(direction, whichend, numoff)
  let curpos = getcurpos()
  if a:direction is 0
    let flag = 'nWb'
  else
    let flag = 'nW'
  endif
  if a:whichend is 0
    " 1つ以上連続する空行の，最初の行にのみマッチ
    let regexp = '^.\+$\n^\zs$'
  else
    " 1つ以上連続する空行の，最後の行にのみマッチ
    let regexp = '^\zs\ze$\n^.\+$'
  endif
  let lnum = search(regexp, flag)

  " e や b を複数回繰り返したときに止まってしまうのを防ぐ
  if (a:whichend is 0 && lnum - curpos[1] is 1) || (a:whichend is 1 && lnum - curpos[1] is -1)
    " もし検索結果が今の1行上だったらカーソルを上にずらし再度検索し直す．
    " もし検索結果が今の1行下だったらカーソルを下にずらし再度検索し直す，
    call cursor(lnum, curpos[2])
    let lnum = search(regexp, flag)
  endif

  if a:direction is 1 && a:numoff is -1 && lnum is getpos('$')[1]
    " <C-n> で最終行に飛べるようにする
    let lnum = lnum + 1
  endif
  if a:direction is 1 && a:numoff is 1 && lnum is 0
    return
  endif

  call cursor(lnum + a:numoff, curpos[2])
endfunction

" 単純に s:movePerVerticalWord を n 回繰り返す． count に対応するため
function! s:movePerVerticalWordNcount(direction, whichend, numoff, count)
  for i in range(a:count)
    call s:movePerVerticalWord(a:direction, a:whichend, a:numoff)
  endfor
endfunction

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

" }}}
" }}}


" その他の特殊キーマップ{{{
""""""""""""""""""""""""""""

" 無効化 {{{
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

" prefix とするため
noremap <Space> <Nop>
noremap <CR> <Nop>
" }}}

" 行の操作/空行追加 {{{

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

" マクロの活用 {{{
nnoremap q qq<Esc>
nnoremap Q q
nnoremap , @q
" JIS キーボードなので
nnoremap + ,
" }}}

" Transform with Lambda function {{{

" 選択した数値を任意の関数で変換する．
" たとえば 300pt の 300 を選択して <Space>s とし，
" x -> x * 3/2 と指定すれば 450pt になる．
" 計算式は g:mgm_lambda_func に格納されるので <Space>r で使い回せる．
" 小数のインクリメントや css での長さ調整等に便利？マクロと組み合わせてもいい．
" 中で eval を用いているので悪用厳禁．基本的に数値にのみ用いるようにする
vnoremap <Space>s :<C-u>call <SID>applyLambdaToSelectedArea()<CR>
vnoremap <Space>r :<C-u>call <SID>repeatLambdaToSelectedArea()<CR>

let g:mgm_lambda_func = 'x'

function s:applyLambdaToSelectedArea() abort
  let tmp = @@
  silent normal gvy
  let visual_area = @@

  let lambda_body = input('Lambda: x -> ', g:mgm_lambda_func)
  let g:mgm_lambda_func = lambda_body
  let lambda_expr = '{ x -> ' . lambda_body . ' }'
  let Lambda = eval(lambda_expr)
  let retval = Lambda(eval(visual_area))
  let return_str = string(retval)

  let @@ = return_str
  silent normal gvp
  let @@ = tmp
endfunction

function s:repeatLambdaToSelectedArea() abort
  let tmp = @@
  silent normal gvy
  let visual_area = @@

  let lambda_body = g:mgm_lambda_func
  let lambda_expr = '{ x -> ' . lambda_body . ' }'
  let Lambda = eval(lambda_expr)
  let retval = Lambda(eval(visual_area))
  let return_str = string(retval)

  let @@ = return_str
  silent normal gvp
  let @@ = tmp
endfunction

" }}}

" }}}


" 特定の種類のファイルに対する設定{{{

" Vimscript {{{
let g:vim_indent_cont = 0
" }}}

" netrw {{{
augroup vimrc_netrw
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
augroup vimrc_tex
  autocmd!
  autocmd Filetype tex set iskeyword+=92
augroup END
" }}}

" SATySFi {{{

augroup vimrc_satysfi
  autocmd!
  autocmd filetype satysfi set path+=/usr/local/share/satysfi/dist/packages,$HOME/.satysfi/dist/packages
  autocmd filetype satysfi set suffixesadd+=.saty,.satyh,.satyg
  autocmd BufRead,BufNewFile *.satyg setlocal filetype=satysfi
  autocmd filetype satysfi let b:caw_oneline_comment = "%"
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>p :!open %:r.pdf<CR>
  autocmd filetype satysfi set foldmethod=marker
  autocmd BufRead,BufNewFile Satyristes setlocal filetype=lisp
augroup END

" }}}

" reST {{{

function! s:reSTTitle(punc)
  let line = getline('.')
  sil! exe row 'foldopen!'
  call append('.', repeat(a:punc, strdisplaywidth(line)))
endfunction
augroup vimrc_rst
  autocmd!
  autocmd filetype rst set suffixesadd+=.rst
  autocmd filetype rst nnoremap <Space>s0 :call <SID>reSTTitle("#")<CR>jo<Esc>
  autocmd filetype rst nnoremap <Space>s1 :call <SID>reSTTitle("=")<CR>jo<Esc>
  autocmd filetype rst nnoremap <Space>s2 :call <SID>reSTTitle("-")<CR>jo<Esc>
  autocmd filetype rst nnoremap <Space>s3 :call <SID>reSTTitle("~")<CR>jo<Esc>
  autocmd filetype rst nnoremap <Space>s4 :call <SID>reSTTitle('"')<CR>jo<Esc>
  autocmd filetype rst nnoremap <Space>s5 :call <SID>reSTTitle("'")<CR>jo<Esc>
augroup END

" }}}

" HTML/XML {{{
augroup vimrc_xml
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END
" }}}

" Julia {{{
"
augroup vimrc_julia
  autocmd!
  autocmd filetype julia set shiftwidth=4
  autocmd filetype julia set path+=/Applications/Julia-1.1.app/Contents/Resources/julia/share/julia/base
augroup END

" }}}

" todome {{{
"
augroup vimrc_todome
  autocmd!
  autocmd fileType todo call s:todome_my_settings()
augroup END

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

" tmux conf {{{

augroup vimrc_tmux
  autocmd!
  autocmd FileType tmux  nnoremap <buffer> <CR>s :!tmux source ~/.tmux.conf<CR>
augroup END

" }}}

" }}}
