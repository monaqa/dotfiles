" vim:foldmethod=marker:
" common settings


" エディタ全般の設定{{{1
""""""""""""""""""""""""

" Syntax, mouse などの有効化{{{2
syntax on
set mouse=a
" set shell=/bin/bash\ --login
" set shell=/usr/local/bin/fish

if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif
" }}}

" タブ文字/不可視文字/インデントの設定{{{2
set list
set listchars=tab:\▸\-,trail:･
set expandtab
set tabstop=2
set shiftwidth=2
set breakindent
" }}}

" }}}


" Theme/colorscheme/表示設定 {{{1
"""""""""""""""""""""""""""""""""

" 表示設定 {{{2
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

set lazyredraw
set ttyfast

set statusline^=%{coc#status()}
set signcolumn=yes
" }}}

" 全角スペース強調 {{{2
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776
augroup MyVimrc
    autocmd!
augroup END

augroup MyVimrc
    autocmd ColorScheme * highlight link UnicodeSpaces Error
    autocmd VimEnter,WinEnter * match UnicodeSpaces /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/
augroup END
" }}}

" Theme {{{2
" augroup の設定の後に読み込む必要がある
let g:gruvbox_contrast_dark = 'hard'
set background=dark
colorscheme gruvbox

hi! link SpecialKey GruvboxBg4
hi! link NonText GruvboxPurple
hi! MatchParen ctermbg=0
hi! ColorColumn ctermbg=238
hi! CursorColumn ctermbg=236
hi! CursorLine ctermbg=236
hi! link Folded GruvboxPurpleBold
hi! link VertSplit GruvboxFg1
" }}}

" }}}


" エディタの機能に関する設定 {{{1
"""""""""""""""""""""""""""""""""

set backupskip=/tmp/*,/private/tmp/*
set nobackup  " backup ファイルを作らない
" set nowritebackup  " たとえ書き込みに失敗しても backup しない
set noswapfile  " swap ファイルを作らない
set autoread  " 編集中ファイルの変更を自動で読む
set hidden  " バッファが編集中でも他のファイルを開けるようにする

set spelllang=en,cjk

set virtualedit=block  " 矩形選択時に文字がなくても選択可
set backspace=indent,eol,start
set history=10000

" 検索機能{{{2
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set inccommand=split
nnoremap / /\v

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
" }}}

" Terminal 機能 {{{2
tnoremap <Esc> <C-\><C-n>

function! s:bufnew()
   " 幸いにも 'buftype' は設定されているのでそれを基準とする
    if &buftype == "terminal" && &filetype == ""
        set filetype=terminal
    endif
endfunction

function! s:terminal_init()
   " ここに :terminal のバッファ固有の設定を記述する
   nnoremap <buffer> a i<Up><CR><C-\><C-n>
   nnoremap <buffer> q :bd!<CR>
   nnoremap <buffer> t :let g:active_terminal_id = b:terminal_job_id<Bar>let g:slime_default_config = {"jobid": b:terminal_job_id}<CR>
endfunction

augroup my-terminal
    autocmd!
   " BufNew の時点では 'buftype' が設定されていないので timer イベントでごまかすなど…
    autocmd BufNew,BufEnter * call timer_start(0, { -> s:bufnew() })
    autocmd FileType terminal call s:terminal_init()
augroup END

function! MgmOpenTerminal()
    let ft = &filetype
    vsplit
    edit term://fish
    if (ft == "python")
        call chansend(b:terminal_job_id, "ipython\n%autoindent\n")
    elseif (ft == "julia")
        call chansend(b:terminal_job_id, "julia\nBase.active_repl.options.auto_indent = false\n")
    endif
    let g:slime_default_config = {"jobid": b:terminal_job_id}
    let g:active_terminal_id = b:terminal_job_id
endfunction

nnoremap <Space>t :call MgmOpenTerminal()<CR>
" }}}
" }}}


" 日本語に関する設定{{{1
""""""""""""""""""""""""

set matchpairs+=「:」,（:）,【:】,『:』

" 句読点の検索（;や,が使えなくなることに注意）
" noremap <silent> f, :call search('[，、,]', '', line("."))<CR>
" noremap <silent> f. :call search('[．。.]', '', line("."))<CR>
" noremap <silent> F, :call search('[，、,]', 'b', line("."))<CR>
" noremap <silent> F. :call search('[．。.]', 'b', line("."))<CR>

noremap <silent> f, :<C-u>call MgmNumSearchLine('[，、,]', v:count1, '' )<CR>
noremap <silent> f. :<C-u>call MgmNumSearchLine('[．。.]', v:count1, '' )<CR>
noremap <silent> F, :<C-u>call MgmNumSearchLine('[，、,]', v:count1, 'b')<CR>
noremap <silent> F. :<C-u>call MgmNumSearchLine('[．。.]', v:count1, 'b')<CR>

" }}}


" Window/buffer の設定{{{1
""""""""""""""""""""""""""

" https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
nnoremap s <Nop>
" バッファ作成と削除
nnoremap s_ :<C-u>sp<CR>
nnoremap s<Bar> :<C-u>vs<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sn :<C-u>bn<CR>
nnoremap sp :<C-u>bp<CR>
" nnoremap sq :<C-u>bd<CR>
" https://github.com/scrooloose/nerdtree/issues/400
nnoremap sq :<C-u>bp<CR>:bd #<CR>
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
" nnoremap sr <C-w>r
" 各ウィンドウの大きさ変更
" submode も参照
nnoremap s= <C-w>=
" nnoremap so <C-w>_<C-w>|
" nnoremap sO <C-w>=
" タブページ
nnoremap st :<C-u>tabnew<CR>
nnoremap sN gt
nnoremap sP gT
" nnoremap sc <C-w>c
" nnoremap sw <C-w>w
" Scroll bind
" nnoremap sw :set<Space>scb<CR>:vs<Space>

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


" cdy コマンドに関する設定{{{1
""""""""""""""""""""""""""""""

" D や C との一貫性
map Y y$

" x の結果をいちいちバッファに入れたくない
nnoremap x "_x

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

" nmap <silent> R :set opfunc=MgmReplace<CR>g@
nmap <silent> <Space>r :<C-u>let w:replace_buffer = v:register <Bar> set opfunc=MgmReplace<CR>g@
nmap <silent> <Space>rr :<C-u>let w:replace_buffer = v:register <Bar> call MgmReplaceALine(v:count1)<CR>

function! MgmReplace(type)
  let sel_save = &selection
  let &selection = "inclusive"
  " let m_reg = @m
  exe "let @m = @" . w:replace_buffer

  if a:type == 'line'
    exe "normal! '[V']d"
  else
    exe "normal! `[v`]d"
  endif

  exe "normal! " . '"' . "mP"

  let &selection = sel_save
  " let @m=m_reg
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


" その他の特殊キーマップ{{{1
""""""""""""""""""""""""""""

" let mapleader=","

" vimrc を即座に反映{{{2
nnoremap <Space>V :<C-u>tabedit $MYVIMRC<CR>
nnoremap <Space><C-V> :<C-u>tabedit ~/.config/vim/init.vim<CR>
" }}}

" 移動系キーマップ{{{2
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
" }}}

" 縦方向 f 移動 {{{2
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

function! MgmVertSearch(opt)
  let posnow = getcurpos()
  let lspaces = posnow[2] - 1
  let @m = nr2char(getchar())
  let pos = searchpos('^.\{' . lspaces . '}\zs' . @m, a:opt)
  call cursor(pos)
endfunction

function! MgmVisualVertSearch(opt)
  let posnow = getpos("'>")
  let lspaces = posnow[2] - 1
  let @m = nr2char(getchar())
  let pos = searchpos('^.\{' . lspaces . '}\zs' . @m, a:opt)
  call cursor(pos)
  normal v`'o
endfunction

" 改訂版縦方向 f 移動
" nnoremap <silent> <Space>f :<C-u>call MgmVertSearch('')<CR>
" nnoremap <silent> <Space>F :<C-u>call MgmVertSearch('b')<CR>
" onoremap <silent> <Space>f :<C-u>call MgmVertSearch('')<CR>
" onoremap <silent> <Space>F :<C-u>call MgmVertSearch('b')<CR>
" vnoremap <silent> <Space>f :<C-u>call MgmVisualVertSearch('s')<CR>
" vnoremap <silent> <Space>F :<C-u>call MgmVisualVertSearch('bs')<CR>


" }}}

" モード間移動{{{2
" inoremap jj <Esc>
" inoremap @[<CR> <Esc>
" inoremap ＠「 <Esc>
" inoremap xz <Esc>
" inoremap zx <Esc>
" inoremap <CR> <Esc>o
" inoremap <S-CR> <CR>
" inoremap <CR> <Esc>a<CR>
" }}}

" 行の操作/空行追加{{{2
nnoremap <Space><Up> "zdd<Up>"zP
vnoremap <Space><Up> "zx<Up>"zP`[V`]
nnoremap <Space><Down> "zdd"zp
vnoremap <Space><Down> "zx"zp`[V`]

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
endif

" 長い文の改行をノーマルモードから楽に行う
" try: f.<Space><CR> or f,<Space><CR>
nnoremap <silent> <Space><CR> a<CR><Esc>
" nnoremap <silent> <CR> :exe "i".nr2char(getchar())<CR>
" }}}

" folding (invalid){{{2
" http://leafcage.hateblo.jp/entry/2013/04/24/053113#f-87298d83
" nnoremap <expr>l  foldclosed('.') != -1 ? 'zo' : 'l'
" nnoremap <silent><C-_> :<C-u>call <SID>smart_foldcloser()<CR>
" function! s:smart_foldcloser() "{{{
  " if foldlevel('.') == 0
    " norm! zM
    " return
  " endif
" 
  " let foldc_lnum = foldclosed('.')
  " norm! zc
  " if foldc_lnum == -1
    " return
  " endif
" 
  " if foldclosed('.') != foldc_lnum
    " return
  " endif
  " norm! zM
" endfunction
" "}}}
" 
" nnoremap  z[     :<C-u>call <SID>put_foldmarker(0)<CR>
" nnoremap  z]     :<C-u>call <SID>put_foldmarker(1)<CR>
" function! s:put_foldmarker(foldclose_p) "{{{
  " let crrstr = getline('.')
  " let padding = crrstr=='' ? '' : crrstr=~'\s$' ? '' : ' '
  " let [cms_start, cms_end] = ['', '']
  " let outside_a_comment_p = synIDattr(synID(line('.'), col('$')-1, 1), 'name') !~? 'comment'
  " if outside_a_comment_p
    " let cms_start = matchstr(&cms,'\V\s\*\zs\.\+\ze%s')
    " let cms_end = matchstr(&cms,'\V%s\zs\.\+')
  " endif
  " let fmr = split(&fmr, ',')[a:foldclose_p]. (v:count ? v:count : '')
  " exe 'norm! A'. padding. cms_start. fmr. cms_end
" endfunction
" }}}
" }}}

" }}}


" 特定の種類のファイルに対する設定{{{1

" LaTeX{{{2
let g:tex_flavor = 'latex'
" \cs を一単語に
autocmd Filetype tex set iskeyword+=92
" }}}

" Asciidoc{{{2
command! MgmViewAdoc :!python make.py;asciidoctor %;open -a Vivaldi %:r.html<CR>
" }}}

" netrw {{{2
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

" satysfi{{{2

command! MgmSatyCompile :call chansend(g:active_terminal_id, "satysfi " . expand("%") . "\n")
command! MgmSatyShowPDF silent !open %:r.pdf

nnoremap <Space>m :MgmSatyCompile<CR>
nnoremap <Space>M :MgmSatyShowPDF<CR>

autocmd filetype satysfi set path+=/usr/local/share/satysfi/dist/packages,$HOME/.satysfi/dist/packages
autocmd filetype satysfi set suffixesadd+=.saty,.satyh,.satyg
autocmd BufRead,BufNewFile *.satyg setlocal filetype=satysfi
autocmd filetype satysfi let b:caw_oneline_comment = "%"

" autocmd filetype satysfi set foldmethod=

" }}}

" Julia {{{2

autocmd filetype julia set shiftwidth=4
autocmd filetype julia set path+=/Applications/Julia-1.1.app/Contents/Resources/julia/share/julia/base

" }}}

" }}}
