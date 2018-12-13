" common settings


" 最初に書いておきたい重要なコマンド群 {{{2
set fenc=utf-8
syntax on
let mapleader=","
set mouse=a

" Basic config "{{{1
""""""""""""""""""""

" Links {{{2
" https://qiita.com/morikooooo/items/9fd41bcd8d1ce9170301
" https://qiita.com/morikooooo/items/34bb2466f98ab58f2e77
" https://qiita.com/ikeisuke/items/f84818516e8337cf4c80
" https://qiita.com/iwaseasahi/items/0b2da68269397906c14c
" 


" 全角スペース強調 {{{2
autocmd Colorscheme * highlight FullWidthSpace ctermbg=white
autocmd VimEnter * match FullWidthSpace /　/
" if has('gui_running')
  " colorscheme dracula
" else
  " colorscheme default
  " set term=xterm-256color
" endif

" Color scheme {{{2
let g:gruvbox_contrast_dark = 'soft'
let g:gruvbox_vert_split = 'fg0'
colorscheme gruvbox
set background=dark

" 一般 {{{2
set nobackup  " backup ファイルを作らない
" set nowritebackup  " たとえ書き込みに失敗しても backup しない
set noswapfile  " swap ファイルを作らない
set autoread  " 編集中ファイルの変更を自動で読む
set hidden  " バッファが編集中でも他のファイルを開けるようにする
set showcmd

set clipboard+=unnamed

" visual {{{2
set number
set cursorline
set cursorcolumn
set virtualedit=onemore  " 行末の1文字先までカーソルを移動したい
set visualbell
set noerrorbells
set showmatch " 対応カッコを表示
hi MatchParen ctermbg=0
set laststatus=2 " ステータスラインを常に表示
set scrolloff=10

set modeline
set modelines=3

set breakindent

set lazyredraw
set ttyfast

" タブ文字の設定 {{{2   
set listchars=tab:\▸\-,trail:･
set expandtab
set tabstop=2
set shiftwidth=2

" 検索 {{{2
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

set virtualedit=block  " 矩形選択時に文字がなくても選択可
set backspace=indent,eol,start
set ambiwidth=double  "全角文字幅
set history=10000

" vimrc や help を即座に開く {{{2

nnoremap <Space>V :<C-u>tabedit $MYVIMRC<CR>
nnoremap <Space>v :<C-u>source $MYVIMRC<CR>
nnoremap <Space><C-V> :<C-u>tabedit ~/.vimrc<CR>

" 日本語を扱うために {{{2

set matchpairs+=「:」,（:）,【:】,『:』


" Key Remapping {{{1 
"""""""""""""""""""""

" 画面分割のキーリマップ {{{2
" https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
"
" vim-operator-surround と衝突しないように注意！
nnoremap s <Nop>
" バッファ作成と削除
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
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
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
" タブページ
nnoremap st :<C-u>tabnew<CR>
nnoremap sn gt
nnoremap sp gT
" nnoremap sT :<C-u>Unite tab<CR>
" nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
" nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>
" nnoremap sc <C-w>c
" nnoremap sw <C-w>w

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

" ついでに

set splitbelow
set splitright

" 移動のキーリマップ {{{2
nnoremap j gj
nnoremap k gk

nnoremap <Space><Up> "zdd<Up>"zP
nnoremap <Space><Down> "zdd"zp
vnoremap <Space><Up> "zx<Up>"zP`[V`]
vnoremap <Space><Down> "zx"zp`[V`]

imap <S-CR> <End><CR>
imap <C-S-CR> <Up><End><CR>
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

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" nnoremap <Up> 5k
" nnoremap <Down> 5j
" nnoremap <Left> 15k
" nnoremap <Right> 15j

nnoremap <Space>h ^
nnoremap <Space>l $
nnoremap <Space>m %
vnoremap <Space>h ^
vnoremap <Space>l $
vnoremap <Space>m %

" モード間移動のキーリマップ {{{2
" inoremap jj <Esc>
" inoremap @[<CR> <Esc>
" inoremap ＠「 <Esc>
inoremap xz <Esc>
inoremap zx <Esc>

" inoremap <CR> <Esc>o
" inoremap <S-CR> <CR>
" inoremap <CR> <Esc>a<CR>

" 日本語を扱いやすくするためのキーマップ {{{2

" 句読点の検索（;や,が使えなくなることに注意）
nnoremap <silent> f, :call search('[，、,]', '', line("."))<CR>
nnoremap <silent> f. :call search('[．。.]', '', line("."))<CR>
nnoremap <silent> F, :call search('[，、,]', 'b', line("."))<CR>
nnoremap <silent> F. :call search('[．。.]', 'b', line("."))<CR>
" 長い文の改行をノーマルモードから楽に行う
" try: f.<Space><CR> or f,<Space><CR>
nnoremap <silent> <Space><CR> a<CR><Esc>
" 日本語の単語区切りを表示

function! MgmDispWordToggle()
  if @/ == '\<'
    let @/=''
    echo "Word Highlight OFF."
  else
    let @/='\<'
    echo "Word Highlight ON."
  endif
endfunction

nnoremap <silent> <Space>w :call MgmDispWordToggle()<CR>

" yank & paste のキーリマップ {{{2
" x の結果をいちいちバッファに入れたくない
nnoremap x "_x

" 縦方向 f 移動 {{{2
"

command! -nargs=1 MgmLineSearch let @m=<q-args> | call search('^\s*'. @m)
command! MgmLineSameSearch call search('^\s*'. @m)
command! -nargs=1 MgmLineBackSearch let @m=<q-args> | call search('^\s*'. @m, 'b')
command! MgmLineBackSameSearch call search('^\s*'. @m, 'b')
nnoremap <Space>f :MgmLineSearch<Space>
nnoremap <Space>F :MgmLineBackSearch<Space>
" nnoremap <Space>; :MgmLineSameSearch<CR>
" nnoremap <Space>, :MgmLineBackSameSearch<CR>
nnoremap d<Space>f d:MgmLineSearch<Space>
nnoremap d<Space>F d:MgmLineBackSearch<Space>
nnoremap c<Space>f c:MgmLineSearch<Space>
nnoremap c<Space>F c:MgmLineBackSearch<Space>
nnoremap y<Space>f y:MgmLineSearch<Space>
nnoremap y<Space>F y:MgmLineBackSearch<Space>

call submode#enter_with('vertjmp', 'n', '', '<Space>;', ':MgmLineSameSearch<CR>')
call submode#enter_with('vertjmp', 'n', '', '<Space>,', ':MgmLineBackSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ';', ':MgmLineSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ',', ':MgmLineBackSameSearch<CR>')
call submode#leave_with('vertjmp', 'n', '', '<Space>')

" 文字数カウント {{{2

nnoremap <Space>c :redi @c<CR>:%s/.//gn<CR>:redi end<CR>:let @/=''<CR>:echo @c<CR>

" folding {{{2
" http://leafcage.hateblo.jp/entry/2013/04/24/053113#f-87298d83
nnoremap <expr>l  foldclosed('.') != -1 ? 'zo' : 'l'
nnoremap <silent><C-_> :<C-u>call <SID>smart_foldcloser()<CR>
function! s:smart_foldcloser() "{{{
  if foldlevel('.') == 0
    norm! zM
    return
  endif

  let foldc_lnum = foldclosed('.')
  norm! zc
  if foldc_lnum == -1
    return
  endif

  if foldclosed('.') != foldc_lnum
    return
  endif
  norm! zM
endfunction
"}}}

nnoremap  z[     :<C-u>call <SID>put_foldmarker(0)<CR>
nnoremap  z]     :<C-u>call <SID>put_foldmarker(1)<CR>
function! s:put_foldmarker(foldclose_p) "{{{
  let crrstr = getline('.')
  let padding = crrstr=='' ? '' : crrstr=~'\s$' ? '' : ' '
  let [cms_start, cms_end] = ['', '']
  let outside_a_comment_p = synIDattr(synID(line('.'), col('$')-1, 1), 'name') !~? 'comment'
  if outside_a_comment_p
    let cms_start = matchstr(&cms,'\V\s\*\zs\.\+\ze%s')
    let cms_end = matchstr(&cms,'\V%s\zs\.\+')
  endif
  let fmr = split(&fmr, ',')[a:foldclose_p]. (v:count ? v:count : '')
  exe 'norm! A'. padding. cms_start. fmr. cms_end
endfunction
"}}}

