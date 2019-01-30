" common settings


" 最初に書いておきたい重要なコマンド群 {{{2
" set fenc=utf-8
syntax on
let mapleader=","
set mouse=a

if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif


" Basic config "{{{1
""""""""""""""""""""

" Links {{{2
" https://qiita.com/morikooooo/items/9fd41bcd8d1ce9170301
" https://qiita.com/morikooooo/items/34bb2466f98ab58f2e77
" https://qiita.com/ikeisuke/items/f84818516e8337cf4c80
" https://qiita.com/iwaseasahi/items/0b2da68269397906c14c
 
let g:tex_flavor = 'latex'

" 全角スペース強調 {{{2
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776
augroup MyVimrc
    autocmd!
augroup END

augroup MyVimrc
    autocmd ColorScheme * highlight link UnicodeSpaces Error
    autocmd VimEnter,WinEnter * match UnicodeSpaces /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/
augroup END

" Color scheme {{{2
" if has('gui_running')
  " colorscheme dracula
" else
  " colorscheme default
  " set term=xterm-256color
" endif
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_vert_split = 'fg0'
colorscheme gruvbox
set background=dark
hi! link SpecialKey GruvboxBg4
hi! link NonText GruvboxPurple
hi! ColorColumn ctermbg=238
hi! CursorColumn ctermbg=236
hi! CursorLine ctermbg=236
hi! link Folded GruvboxPurpleBold

" 一般 {{{2
set nobackup  " backup ファイルを作らない
" set nowritebackup  " たとえ書き込みに失敗しても backup しない
set noswapfile  " swap ファイルを作らない
set autoread  " 編集中ファイルの変更を自動で読む
set hidden  " バッファが編集中でも他のファイルを開けるようにする
set showcmd
set colorcolumn=80
" let &colorcolumn=join(range(81,999),",")
" hi ColorColumn ctermbg=235 guibg=#2c2d27
set clipboard+=unnamed

" visual {{{2
set number
set cursorline
set cursorcolumn
set virtualedit=onemore  " 行末の1文字先までカーソルを移動したい
set visualbell
set noerrorbells
" set showmatch " 対応カッコを表示
hi MatchParen ctermbg=0
set laststatus=2 " ステータスラインを常に表示
set scrolloff=10

set modeline
set modelines=3

set breakindent

set lazyredraw
set ttyfast

" spell check

set spelllang=en,cjk

" タブ文字の設定 {{{2   
set list
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
" nmap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
" command! -nargs=1 MgmYankToSlash let @/ = '\V' . escape(<q-args>, '/\')
" command! -nargs=1 MgmYankToM let @m = escape(<q-args>, '/\')
" vnoremap <CR> "my:set hlsearch<CR>:MgmYankToSlash <C-r>m<CR>
" substitute command
" https://stackoverflow.com/questions/7598133/vim-global-search-replace-starting-from-the-cursor-position
" vnoremap <S-CR> "my:set hlsearch<CR>:MgmYankToM <C-r>m<CR>:,$s/\V<C-r>m/<C-r>m/gc\|1,''-&&<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
set virtualedit=block  " 矩形選択時に文字がなくても選択可
set backspace=indent,eol,start
set ambiwidth=double  "全角文字幅
set history=10000

" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <CR> "my/\V<C-R><C-R>=substitute(
  \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>N

vnoremap <S-CR> "sy:set hlsearch<CR>/\V<C-R><C-R>=substitute(
  \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \:,$s/\V<C-R><C-R>=substitute(
  \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR>
  \/<C-R><C-R>=escape(@s, '/\&~')<CR>
  \/gce<Bar>1,''-&&<CR>

" vimrc や help を即座に開く {{{2

nnoremap <Space>V :<C-u>tabedit $MYVIMRC<CR>
nnoremap <Space>v :<C-u>source $MYVIMRC<CR>
nnoremap <Space><C-V> :<C-u>tabedit ~/.config/vim/init.vim<CR>

" 日本語を扱うために {{{2

set matchpairs+=「:」,（:）,【:】,『:』


" Key Remapping {{{1 
"""""""""""""""""""""

" yank mapping (see :h Y)
:map Y y$


" 画面分割のキーリマップ {{{2
" https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
"
" vim-operator-surround と衝突しないように注意！
nnoremap s <Nop>
" バッファ作成と削除
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sn :<C-u>bn<CR>
nnoremap sp :<C-u>bp<CR>
" nnoremap sq :<C-u>bd<CR>
" https://github.com/scrooloose/nerdtree/issues/400
nnoremap sq :<C-u>bp<CR>:bd #<CR>
nnoremap sQ :<C-u>q<CR>
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
nnoremap sN gt
nnoremap sP gT
" nnoremap sT :<C-u>Unite tab<CR>
" nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
" nnoremap sb :<c-u>unite buffer -buffer-name=file<cr>
" nnoremap sc <C-w>c
" nnoremap sw <C-w>w
" Scroll bind
nnoremap sw :set<Space>scb<CR>:vs<Space>

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
nnoremap gj j
nnoremap gk k

nnoremap <Space><Up> "zdd<Up>"zP
nnoremap <Space><Down> "zdd"zp
vnoremap <Space><Up> "zx<Up>"zP`[V`]
vnoremap <Space><Down> "zx"zp`[V`]

" inoremap <CR> <CR><C-g>u
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

" imap <Nul> <Nop>
" 上でうまくいかないので，苦肉の策で <C-@> を潰す
imap <C-Space> <Space>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" nnoremap <Up> 5k
" nnoremap <Down> 5j
" nnoremap <Left> 15k
" nnoremap <Right> 15j

noremap <Space>h ^
noremap <Space>l $
noremap <Space>m %
" vnoremap <Space>h ^
" vnoremap <Space>l $
" vnoremap <Space>m %

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
noremap <silent> f, :call search('[，、,]', '', line("."))<CR>
noremap <silent> f. :call search('[．。.]', '', line("."))<CR>
noremap <silent> F, :call search('[，、,]', 'b', line("."))<CR>
noremap <silent> F. :call search('[．。.]', 'b', line("."))<CR>
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

" vnoremap <CR> "my/\V<C-R><C-R>=substitute(
  " \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>

command! -nargs=1 MgmLineSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m)
command! MgmLineSameSearch call search('^\s*\V'. @m)
command! -nargs=1 MgmLineBackSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 'b')
command! MgmLineBackSameSearch call search('^\s*\V'. @m, 'b')
noremap <Space>f :MgmLineSearch<Space>
noremap <Space>F :MgmLineBackSearch<Space>
" nnoremap <Space>; :MgmLineSameSearch<CR>
" nnoremap <Space>, :MgmLineBackSameSearch<CR>
" nnoremap d<Space>f d:MgmLineSearch<Space>
" nnoremap d<Space>F d:MgmLineBackSearch<Space>
" nnoremap c<Space>f c:MgmLineSearch<Space>
" nnoremap c<Space>F c:MgmLineBackSearch<Space>
" nnoremap y<Space>f y:MgmLineSearch<Space>
" nnoremap y<Space>F y:MgmLineBackSearch<Space>

call submode#enter_with('vertjmp', 'n', '', '<Space>;', ':MgmLineSameSearch<CR>')
call submode#enter_with('vertjmp', 'n', '', '<Space>,', ':MgmLineBackSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ';', ':MgmLineSameSearch<CR>')
call submode#map('vertjmp', 'n', '', ',', ':MgmLineBackSameSearch<CR>')
call submode#leave_with('vertjmp', 'n', '', '<Space>')


" folding {{{2
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
" "}}}

" LaTeX で \cs を一単語に
autocmd Filetype tex set iskeyword+=92

" Asciidoc のプレビュー
command! MgmViewAdoc :!python make.py;asciidoctor %;open -a Vivaldi %:r.html<CR>
