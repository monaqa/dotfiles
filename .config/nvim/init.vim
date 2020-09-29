" vim:fdm=marker:

set encoding=utf-8
scriptencoding utf-8

" エディタ全般の設定{{{
""""""""""""""""""""""""

let g:tex_flavor = "latex"

source ~/.config/nvim/scripts/minpac.vim
filetype plugin indent on
syntax enable

" mouse などの有効化{{{
set mouse=a
if &shell =~# 'fish$'
  set shell=sh
endif

let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim/bin/python'

if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

augroup vimrc
  autocmd!
augroup END

" }}}

" タブ文字/不可視文字/インデントの設定{{{
set expandtab
set tabstop=4
set shiftwidth=4
set breakindent
set smartindent

" indent 幅のデフォルト
augroup vimrc
  autocmd FileType vim setlocal shiftwidth=2
  autocmd FileType xml,html setlocal shiftwidth=2
  autocmd FileType tex setlocal shiftwidth=2
  autocmd FileType satysfi setlocal shiftwidth=2
  autocmd FileType markdown,rst setlocal shiftwidth=2
augroup END
" }}}
" }}}


" Theme/colorscheme/表示設定 {{{
"""""""""""""""""""""""""""""""""

" 表示設定 {{{
set visualbell
set noerrorbells
" set showmatch " 対応カッコを表示
set ambiwidth=single  "全角文字幅
set showcmd
set modeline
set modelines=3

set list
set listchars=tab:▸▹┊,trail:⌑,extends:❯,precedes:❮
set wrap

set lazyredraw
set ttyfast

set number
set colorcolumn=80
set laststatus=2 " ステータスラインを常に表示
set statusline^=%{coc#status()}
set foldcolumn=0
set signcolumn=yes:2

augroup vimrc
  " 現在編集中のバッファは scrolloff あり
  autocmd BufEnter,FocusGained,InsertLeave * if &buftype ==# ''
  autocmd BufEnter,FocusGained,InsertLeave *   setlocal scrolloff=10
  autocmd BufEnter,FocusGained,InsertLeave * endif
  " 編集中でないバッファは scrolloff なし
  autocmd BufLeave,FocusLost,InsertEnter   * setlocal scrolloff=0
augroup END

nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap <silent><nowait> Z :call <SID>toggle_column()<CR>
nnoremap <silent><nowait> <Space><Space> :call <SID>temporal_attention()<CR>:call <SID>temporal_relnum()<CR>
" 検索系は見失いやすいので
nnoremap <silent> n n:call <SID>temporal_attention()<CR>
nnoremap <silent> N N:call <SID>temporal_attention()<CR>

function! s:toggle_column() abort
  if &signcolumn ==# 'yes:2' && &foldcolumn == 0
    setlocal foldcolumn=4
    setlocal signcolumn=no
  else
    setlocal foldcolumn=0
    setlocal signcolumn=yes:2
  endif
endfunction

function! s:temporal_attention() abort
    set cursorline
    set cursorcolumn
    augroup temporal_attention
        autocmd!
        autocmd CursorMoved * ++once set nocursorline
        autocmd CursorMoved * ++once set nocursorcolumn
    augroup END
endfunction
function! s:temporal_relnum() abort
    set relativenumber
    augroup temporal_relnum
        autocmd!
        autocmd CursorMoved * ++once set norelativenumber
    augroup END
endfunction

" }}}

" 全角スペース強調 {{{
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776

augroup vimrc
  autocmd ColorScheme * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * match UnicodeSpaces
  \ /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/
augroup END

" }}}

" Theme {{{

set termguicolors
" augroup の設定の後に読み込む必要がある

" VimShowHlGroup: Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
" VimShowHlItem: Show highlight item name under a cursor
command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")
" }}}

" .vimrc.local {{{
augroup vimrc
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
autocmd vimrc FileType * set formatoptions-=o formatoptions+=nB
autocmd vimrc InsertLeave * set nopaste

" folding {{{
nnoremap <Space>z zMzv
" }}}

" 文字コード指定 {{{
" フォーマット変えて開き直す系
" thanks to cohama
command! Utf8 edit ++enc=utf-8 %
command! Cp932 edit ++enc=cp932 %
command! Unix edit ++ff=unix %
command! Dos edit ++ff=dos %
command! AsUtf8 set fenc=utf-8|w
" }}}

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

" VISUAL モードから簡単に検索
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap * "my/\V<C-R><C-R>=substitute(
\escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>N
vnoremap S "my:set hlsearch<CR>
\:,$s//<C-R><C-R>=escape(@m, '/\&~')<CR>
\/gce<Bar>1,''-&&<CR>
" }}}

" Automatically create missing directories {{{
" thanks to lambdalisue
function! s:auto_mkdir(dir, force) abort
  if empty(a:dir) || a:dir =~# '^\w\+://' || isdirectory(a:dir) || a:dir =~# '^suda:'
      return
  endif
  if !a:force
    echohl Question
    call inputsave()
    try
      let result = input(
            \ printf('"%s" does not exist. Create? [y/N]', a:dir),
            \ '',
            \)
      if empty(result)
        echohl WarningMsg
        echo 'Canceled'
        return
      endif
    finally
      call inputrestore()
      echohl None
    endtry
  endif
  call mkdir(a:dir, 'p')
endfunction
autocmd vimrc BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
" }}}

" Terminal 機能 {{{
tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap <C-r><C-r> <C-\><C-N>""pi
tnoremap <C-r><CR> <C-\><C-N>"0pi
tnoremap <C-r><Space> <C-\><C-N>"+pi
" 苦肉の策
tnoremap <C-r><Esc> <C-r>

augroup vimrc
  autocmd FileType fzf tnoremap <buffer><nowait> <Esc> <C-g>
augroup END

function! s:terminal_init()
  " ここに :terminal のバッファ固有の設定を記述する
  " nnoremap <buffer> a i<Up><CR><C-\><C-n>
  nnoremap <buffer> <CR> i<CR><C-\><C-n>
  nnoremap <expr><buffer> u "i" . repeat("<Up>", v:count1) . "<C-\><C-n>"
  nnoremap <expr><buffer> <C-r> "i" . repeat("<Down>", v:count1) . "<C-\><C-n>"
  nnoremap <buffer> sw :<C-u>bd!<CR>
  nnoremap <buffer> t :<C-u>let g:current_terminal_job_id = b:terminal_job_id<CR>
  nnoremap <buffer> dd i<C-u><C-\><C-n>
  " nnoremap <buffer> I i<C-a>
  nnoremap <buffer> A i<C-e>
  nnoremap <buffer><expr> I "i\<C-a>" . repeat("\<Right>", <SID>calc_cursor_right_num())
endfunction

function! s:calc_cursor_right_num() abort
  " ad hoc!
  " normal "my0
  " let strlen = strchars(@m)
  let cpos = getcurpos()
  return cpos[2] - 5
endfunction

augroup vimrc
  autocmd TermOpen * call s:terminal_init()
  autocmd TermOpen * setlocal wrap
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal signcolumn=no
  autocmd TermOpen * setlocal foldcolumn=0
augroup END


nnoremap <silent> st :<C-u>call <SID>openTermWindow()<CR>

function! s:openTerminal()
  let ft = &filetype
  if (s:isWideWindow('.'))
    vsplit
  else
    split
  endif
  edit term://fish
  if (ft ==# 'python')
    call chansend(b:terminal_job_id, "ipython -c '%autoindent' -i\n")
  endif
  let g:current_terminal_job_id = b:terminal_job_id
endfunction

function! s:openTermWindow() abort
  if (bufname('term://') ==# '')
    call s:openTerminal()
  elseif (s:isWideWindow('.'))
    vsplit
    buffer term://
  else
    split
    buffer term://
  endif
endfunction

nnoremap <CR>t :<C-u>set opfunc=<SID>op_send_terminal<CR>g@
nnoremap <CR>tp :<C-u>set opfunc=<SID>op_send_terminal<CR>g@ap
nnoremap <nowait> <CR>tt :<C-u>call <SID>send_terminal_line(v:count1)<CR>
vnoremap <CR>t <Esc>:<C-u>call <SID>send_terminal_visual_range()<CR>

function! s:op_send_terminal(type)
  let sel_save = &selection
  let &selection = "inclusive"
  let m_reg = @m

  if a:type == 'line'
    let visual_range = "'[V']"
  else
    let visual_range = '`[v`]'
  endif
  exe "normal! " . visual_range . '"my'
  call chansend(g:current_terminal_job_id, s:reformat_cmdstring(@m))

  let &selection = sel_save
  let @m=m_reg
endfunction

function! s:send_terminal_line(n_line)
  let sel_save = &selection
  let &selection = "inclusive"
  let m_reg = @m

  exe "normal! " . '"m' . a:n_line . 'yy'
  call chansend(g:current_terminal_job_id, s:reformat_cmdstring(@m))

  let &selection = sel_save
  let @m=m_reg
endfunction

function! s:send_terminal_visual_range()
  let sel_save = &selection
  let &selection = "inclusive"
  let m_reg = @m

  exe "normal! gv" . '"my'
  call chansend(g:current_terminal_job_id, s:reformat_cmdstring(@m))

  let &selection = sel_save
  let @m=m_reg
endfunction

function! s:reformat_cmdstring(str)
  " 空行の削除
  let s = substitute(a:str, '\n\n', '\n', 'g')
  " （なければ）最後に改行を付ける
  if s !~# '\n$'
    let s = s .. "\n"
  endif
  return s
endfunction

" }}}

" Command-line window {{{
let &cedit = "\<C-C>"
augroup vimrc
  autocmd CmdwinEnter * setlocal nonumber
  autocmd CmdwinEnter * setlocal norelativenumber
  autocmd CmdwinEnter * setlocal signcolumn=no
  autocmd CmdwinEnter * setlocal foldcolumn=0
  autocmd CmdwinEnter * nnoremap <buffer> <C-f> <C-f>
  autocmd CmdwinEnter * nnoremap <buffer> <C-u> <C-u>
  autocmd CmdwinEnter * nnoremap <buffer> <C-b> <C-b>
  autocmd CmdwinEnter * nnoremap <buffer> <C-d> <C-d>
  autocmd CmdwinEnter * nnoremap <buffer><nowait> <CR> <CR>
  autocmd CmdwinEnter : keeppatterns g/^qa\?!\?$/d _
  autocmd CmdwinEnter : keeppatterns g/^wq\?a\?!\?$/d _
augroup END
" }}}

" diff {{{
" thanks to cohama
command! -nargs=0 DiffThese call s:diff_these()
function! s:diff_these()
  let win_count = winnr('$')
  if win_count == 2
    diffthis
    wincmd w
    diffthis
    wincmd w
  else
    echomsg "Too many windows."
  endif
endfunction
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
nnoremap <silent><expr> ss <SID>isWideWindow('.') ? ':<C-u>vs<CR>' : ':<C-u>sp<CR>'
nnoremap sq :<C-u>q<CR>
nnoremap <expr> sw &buftype ==# '' ? ":\<C-u>bp\<CR>:\<C-u>bd #\<CR>" : ":bd\<CR>"
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
nnoremap <silent> sT :<C-u>tabnew %<CR>
nnoremap sN gt
nnoremap sP gT
nnoremap sQ :<C-u>tabc<CR>
" Command-line window
nnoremap s: q:G
nnoremap s? q?G
nnoremap s/ q/G

" Sandwich.vim のデフォルトキーバインドを上書きする
nnoremap <nowait> srb <Nop>

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

augroup vimrc
  autocmd VimResized * call <SID>resizeFloatingWindow()
  autocmd VimResized * exe "normal \<c-w>="
augroup END

function s:resizeFloatingWindow()
  if exists('*ResizeDefxFloatingWindow')
    call ResizeDefxFloatingWindow()
  endif
  if exists('*ResizeDeniteFloatingWindow')
    call ResizeDeniteFloatingWindow()
  endif
endfunction

" }}}


" Operator {{{
""""""""""""""

" D や C との一貫性
nnoremap Y y$

" x の結果はバッファに入れない．dx でも同様に扱う
" いや，別にバッファに入れてもいい気がしてきた．一旦コメントアウトしておこう
" nnoremap x "_x
" nnoremap X "_X
nnoremap dx "_d
nnoremap cx "_c

" よく使うレジスタは挿入モードでも挿入しやすく
inoremap <C-r><C-r> <C-g>u<C-r>"
inoremap <C-r><CR> <C-g>u<C-r>0
inoremap <C-r><Space> <C-g>u<C-r>+
cnoremap <C-r><C-r> <C-r>"
cnoremap <C-r><CR> <C-r>0
cnoremap <C-r><Space> <C-r>+

" set clipboard+=unnamed
set clipboard=
" noremap <Space>y "+y
noremap <Space>p "+p
noremap <Space>P "+P
noremap <CR>p :<C-u>put +<CR>
noremap <CR>P :<C-u>put! +<CR>
noremap <Space>y "+y

augroup vimrc
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

" INSERT モードの <C-y> をオペレータっぽく扱う．{{{
" a<Bs> を最初に入れるのは，直後の <Esc> 時に
" インデントが消えてしまわないようにするため（もっといい方法がありそう）
inoremap <expr> <C-y> "a<Bs>\<Esc>k" . (getcurpos()[2] == 1 ? '' : 'l') . ":set opfunc=<SID>control_y\<CR>g@"
inoremap <expr> <C-e> "a<Bs>\<Esc>j" . (getcurpos()[2] == 1 ? '' : 'l') . ":set opfunc=<SID>control_e\<CR>g@"
inoremap <expr> <C-y><C-y> "a<Bs>\<Esc>k" . (getcurpos()[2] == 1 ? '' : 'l') . ":set opfunc=<SID>control_y\<CR>g@$"
inoremap <expr> <C-e><C-e> "a<Bs>\<Esc>j" . (getcurpos()[2] == 1 ? '' : 'l') . ":set opfunc=<SID>control_e\<CR>g@$"

function! s:control_y(type)
  " 設定，レジスタの保存
  let sel_save = &selection
  let m_reg = @m

  let &selection = "inclusive"
  normal! `[v`]"my

  if getpos(".")[2] > len(getline(line(".") + 1))
    " 今いるところが次の行の末端よりも長いかどうか．
    " 行末だったら p（末尾に append）
    normal! j"mp
    startinsert!
  else
    " それ以外は P（途中から insert）
    normal! j"mPl
    startinsert
  endif

  " 設定，レジスタの復元
  let &selection = sel_save
  let @m=m_reg
endfunction

function! s:control_e(type)
  let sel_save = &selection
  let m_reg = @m

  let &selection = "inclusive"
  normal! `[v`]"my

  if getpos(".")[2] > len(getline(line(".") - 1))
    normal! k"mp
    startinsert!
  else
    normal! k"mPl
    startinsert
  endif

  let &selection = sel_save
  let @m=m_reg
endfunction
" }}}

" }}}


" Motion/text object {{{
""""""""""""""""""""""""

" smart j/k
" thanks to tyru
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j (v:count == 0 && mode() ==# 'v') ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k (v:count == 0 && mode() ==# 'v') ? 'gk' : 'k'

inoremap <C-b> <C-g>U<Left>
inoremap <C-f> <C-g>U<Right>
" 上記移動を行っていると <C-Space> で <C-@> が動作してしまうのが不便．
" imap <Nul> <Nop>
" としてもうまくいかないので，苦肉の策で <C-@> を潰す
inoremap <C-Space> <Space>

" かしこい Home
" thanks to Shougo
function! SmartHome()
  let str_before_cursor = strpart(getline('.'), 0, col('.') - 1)
  let wrap_prefix = &wrap ? 'g' : ''
  if str_before_cursor !~ '^\s*$'
    return wrap_prefix . '^ze'
  else
    return wrap_prefix . '0'
  endif
endfunction
noremap <expr> <Space>h SmartHome()
" かしこい End
nnoremap <expr> <Space>l &wrap ? 'g$' : '$'
onoremap <expr> <Space>l &wrap ? 'g$' : '$'
xnoremap <expr> <Space>l visualmode() ==# "v" ? '$h' : '$'

" word-in-word motion
onoremap u t_
onoremap U :<C-u>call <SID>numSearchLine('[A-Z]', v:count1, '')<CR>

function! s:numSearchLine(ptn, num, opt)
  for i in range(a:num)
    call search(a:ptn, a:opt, line('.'))
  endfor
endfunction

" 整合性のとれた括弧に移動するための motion {{{

noremap m) ])
noremap m} ]}

vnoremap m] i]o``
vnoremap m( i)``
vnoremap m{ i}``
vnoremap m[ i]``

nnoremap dm] vi]o``d
nnoremap dm( vi)``d
nnoremap dm{ vi}``d
nnoremap dm[ vi]``d

nnoremap cm] vi]o``c
nnoremap cm( vi)``c
nnoremap cm{ vi}``c
nnoremap cm[ vi]``c

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
nnoremap <silent> <C-j> :<C-u>exe "keepjumps normal! " . v:count1 . "}"<CR>
onoremap <C-j> }
vnoremap <C-j> }
nnoremap <silent> <C-k> :<C-u>exe "keepjumps normal! " . v:count1 . "{"<CR>
onoremap <C-k> {
vnoremap <C-k> {

" <C-n>: 水平方向の  E 移動を鉛直方向にしたものに相当
" <C-p>: 水平方向の  B 移動を鉛直方向にしたものに相当
" nnoremap <silent> <C-n> :<C-u>call <SID>movePerVerticalWordNcount(1, 0, -1, v:count1)<CR>
" nnoremap <silent> <C-p> :<C-u>call <SID>movePerVerticalWordNcount(0, 1,  1, v:count1)<CR>

" omap では， inclusive な挙動が求められているとき
" <C-n> でいい感じに inclusive っぽくなるようにする．
" たとえば d<C-n> とするとその vWORD の最後まで消える
" （その下の空行は消えない）．
" onoremap <silent> <C-n> :<C-u>call <SID>movePerVerticalWordNcount(1, 0,  0, v:count1)<CR>
" onoremap <silent> <C-p> :<C-u>call <SID>movePerVerticalWordNcount(0, 1,  1, v:count1)<CR>

" 矩形選択のときなどに有用
" TODO: visual モード中に v:count をとってモーションを繰り返したい
" vnoremap <silent> <C-n> <Esc>:call <SID>movePerVerticalWordNcount(1, 0, -1, 1)<CR>mzgv`z
" vnoremap <silent> <C-p> <Esc>:call <SID>movePerVerticalWordNcount(0, 1,  1, 1)<CR>mzgv`z

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
command! -nargs=1 LineSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m)
command! -nargs=1 VisualLineSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 's') | normal v`'o
command! LineSameSearch call search('^\s*\V'. @m)
command! -nargs=1 LineBackSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 'b')
command! -nargs=1 VisualLineBackSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 'bs') | normal v`'o
command! LineBackSameSearch call search('^\s*\V'. @m, 'b')
nnoremap <Space>f :LineSearch<Space>
nnoremap <Space>F :LineBackSearch<Space>
onoremap <Space>f :LineSearch<Space>
onoremap <Space>F :LineBackSearch<Space>
vnoremap <Space>f :<C-u>VisualLineSearch<Space>
vnoremap <Space>F :<C-u>VisualLineBackSearch<Space>
nnoremap <Space>; :LineSameSearch<CR>
nnoremap <Space>, :LineBackSameSearch<CR>

" }}}

" Command mode mapping {{{
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>
" }}}

" }}}


" その他の特殊キーマップ{{{
""""""""""""""""""""""""""""

" 無効化 {{{
noremap <F1>   <Nop>
noremap <M-F1> <Nop>
noremap <F2>   <Nop>
noremap <F3>   <Nop>
noremap <F4>   <Nop>
noremap <F5>   <Nop>
noremap <F6>   <Nop>
noremap <F7>   <Nop>
noremap <F8>   <Nop>
noremap <F9>   <Nop>
noremap <F10>  <Nop>
noremap <F12>  <Nop>
noremap! <F1>   <Nop>
noremap! <M-F1> <Nop>

" prefix とするため
noremap <Space> <Nop>
noremap <CR> <Nop>
" }}}

" 行の操作/空行追加 {{{

" 改行だけを入力する
" thanks to cohama
nnoremap <expr> <Space>o "mz" . v:count . "o\<Esc>`z"
nnoremap <expr> <Space>O "mz" . v:count . "O\<Esc>`z"

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
" 将来何かに割り当てようっと
nnoremap <S-CR> <Nop>
nnoremap <C-S-CR> <Nop>
nnoremap <C-CR> <Nop>

" 長い文の改行をノーマルモードから楽に行う
" try: f.<Space><CR> or f,<Space><CR>
nnoremap <silent> <Space><CR> a<CR><Esc>

" }}}

" マクロの活用 {{{
nnoremap q qq<Esc>
nnoremap Q q
nnoremap , @q
" JIS キーボードなので <S-;> が + と同じ
nnoremap + ,
" }}}

" Transform with Lambda function {{{

" 選択した数値を任意の関数で変換する．
" たとえば 300pt の 300 を選択して <Space>s とし，
" x -> x * 3/2 と指定すれば 450pt になる．
" 計算式は g:monaqa_lambda_func に格納されるので <Space>r で使い回せる．
" 小数のインクリメントや css での長さ調整等に便利？マクロと組み合わせてもいい．
" 中で eval を用いているので悪用厳禁．基本的に数値にのみ用いるようにする
vnoremap <Space>s :<C-u>call <SID>applyLambdaToSelectedArea()<CR>
vnoremap <Space>r :<C-u>call <SID>repeatLambdaToSelectedArea()<CR>

let g:monaqa_lambda_func = 'x'

function s:applyLambdaToSelectedArea() abort
  let tmp = @@
  silent normal gvy
  let visual_area = @@

  let lambda_body = input('Lambda: x -> ', g:monaqa_lambda_func)
  let g:monaqa_lambda_func = lambda_body
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

  let lambda_body = g:monaqa_lambda_func
  let lambda_expr = '{ x -> ' . lambda_body . ' }'
  let Lambda = eval(lambda_expr)
  let retval = Lambda(eval(visual_area))
  let return_str = string(retval)

  let @@ = return_str
  silent normal gvp
  let @@ = tmp
endfunction

" }}}

" jump with changed list {{{
" 便利なので連打しやすいマップにしてみる
nnoremap <C-h> g;
nnoremap <C-g> g,

" }}}

" rename/delete current file {{{
" thanks to cohama

" 今開いているファイルを削除
function! DeleteMe(force)
  if a:force || !&modified
    let filename = expand('%')
    bdelete!
    call delete(filename)
  else
    echomsg 'File modified'
  endif
endfunction
command! -bang -nargs=0 DeleteMe call DeleteMe(<bang>0)

" 今開いているファイルをリネーム
function! RenameMe(newFileName)
  let currentFileName = expand('%')
  execute 'saveas ' . a:newFileName
  bdelete! #
  call delete(currentFileName)
endfunction
command! -nargs=1 RenameMe call RenameMe(<q-args>)

cnoreabbrev <expr> RenameMe "RenameMe " . expand('%')

" }}}

" 文字コードのインクリメント {{{
nnoremap <Space>a :<C-u>call <SID>increment_char(v:count1)<CR>
nnoremap <Space>x :<C-u>call <SID>increment_char(-v:count1)<CR>

function! s:increment_char(count)
  normal v"my
  let char = @m
  let num = char2nr(char)
  let @m = nr2char(num + a:count)
  normal gv"mp
endfunction
" }}}

" auto-format {{{
" 行末の空白とか最終行の空行を削除
function! RemoveUnwantedSpaces()
  let pos_save = getpos('.')
  try
    keeppatterns %s/\s\+$//e
    while 1
      let lastline = getline('$')
      if lastline =~ '^\s*$' && line('$') != 1
        $delete
      else
        break
      endif
    endwhile
  finally
    call setpos('.', pos_save)
  endtry
endfunction
command! -nargs=0 RemoveUnwantedSpaces call RemoveUnwantedSpaces()
" }}}

cnoreabbrev w] w

" }}}


" 特定の種類のファイルに対する設定{{{

" Vim {{{

" Vimscript {{{
let g:vim_indent_cont = 0
augroup vimrc
  autocmd FileType vim nnoremap <buffer> K K
  autocmd FileType vim setlocal keywordprg=:help
augroup END
" }}}

" netrw {{{
augroup vimrc
  autocmd FileType netrw call NetrwMapping()
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

" }}}

" Programming Language {{{

" Rust {{{
let g:rust_fold = 2
augroup vimrc
  autocmd FileType rust setlocal foldlevel=1
augroup END

" }}}

" Python {{{
augroup vimrc
  autocmd FileType python setlocal nosmartindent
augroup END
" }}}

" Julia {{{

augroup vimrc
  autocmd FileType julia setlocal shiftwidth=4
  autocmd FileType julia setlocal path+=/Applications/Julia-1.1.app/Contents/Resources/julia/share/julia/base
augroup END

" }}}

" }}}

" Markup Language {{{

" TeX/LaTeX {{{
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '@line @pdf @tex'

let g:tex_flavor = 'latex'
" \cs を一単語に
augroup vimrc
  autocmd FileType tex setlocal iskeyword+=92
augroup END
" }}}

" SATySFi {{{

augroup vimrc
  autocmd BufRead,BufNewFile *.satyg setlocal filetype=satysfi
  autocmd BufRead,BufNewFile Satyristes setlocal filetype=lisp
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>o :!open %:r.pdf<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>q :!satysfi %<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>Q :!satysfi --debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space %<CR>
  autocmd FileType satysfi setlocal path+=/usr/local/share/satysfi/dist/packages,$HOME/.satysfi/dist/packages,$HOME/.satysfi/local/packages
  autocmd FileType satysfi setlocal suffixesadd+=.saty,.satyh,.satyg
  " iskeyword で +,\,@ の3文字を単語に含める
  autocmd FileType satysfi setlocal iskeyword+=43,92,@-@
  autocmd FileType satysfi let b:caw_oneline_comment = "%"
  autocmd FileType satysfi let b:match_words = '<%:>%'
  autocmd FileType satysfi setlocal matchpairs-=<:>
  autocmd FileType satysfi setlocal foldmethod=indent
  autocmd FileType satysfi setlocal foldnestmax=4
  autocmd FileType satysfi setlocal foldminlines=5
augroup END

" }}}

" reST {{{

function! s:reSTTitle(punc)
  let line = getline('.')
  sil! exe row 'foldopen!'
  call append('.', repeat(a:punc, strdisplaywidth(line)))
endfunction
augroup vimrc
  autocmd FileType rst setlocal suffixesadd+=.rst
  autocmd FileType rst nnoremap <buffer> <Space>s0 :call <SID>reSTTitle("#")<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s1 :call <SID>reSTTitle("=")<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s2 :call <SID>reSTTitle("-")<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s3 :call <SID>reSTTitle("~")<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s4 :call <SID>reSTTitle('"')<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s5 :call <SID>reSTTitle("'")<CR>jo<Esc>
augroup END

" }}}

" HTML/XML {{{
augroup vimrc
  autocmd FileType xml inoremap <buffer> </ </<C-x><C-o>
  autocmd FileType html inoremap <buffer> </ </<C-x><C-o>
augroup END
" }}}

" }}}

" misc {{{

" fish {{{
augroup vimrc
  autocmd BufRead,BufNewFile *.fish setlocal filetype=fish
augroup END
" }}}

" tmux conf {{{

augroup vimrc
  autocmd FileType tmux  nnoremap <buffer> <CR>s :!tmux source ~/.tmux.conf<CR>
augroup END

" }}}

" ToDo6 {{{

augroup vimrc
  autocmd BufRead,BufNewFile .todo6,*.td6 setlocal filetype=todo6
  autocmd FileType todo6 setlocal noexpandtab
  autocmd FileType todo6 setlocal shiftwidth=4
  autocmd FileType todo6 setlocal tabstop=4
  autocmd FileType todo6 setlocal foldmethod=indent
augroup END

" }}}

" Scrapbox {{{
augroup vimrc
  autocmd FileType scrapbox setlocal tabstop=1
  autocmd FileType scrapbox setlocal shiftwidth=1
augroup END
" }}}

" binary {{{
" もっといい方法がありそう
" augroup vimrc
"   autocmd BufReadPre  *.bin let &bin=1
"   autocmd BufReadPost *.bin if &bin | %!xxd
"   autocmd BufReadPost *.bin set ft=xxd | endif
"   autocmd BufWritePre *.bin if &bin | %!xxd -r
"   autocmd BufWritePre *.bin endif
"   autocmd BufWritePost *.bin if &bin | %!xxd
"   autocmd BufWritePost *.bin set nomod | endif
" augroup END
" }}}
" }}}


" }}}


source ~/.config/nvim/scripts/plugin.vim

" }}}
