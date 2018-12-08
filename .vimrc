" vim:foldmethod=marker:

" Basic config "{{{1
""""""""""""""""""""

" Links {{{2
" https://qiita.com/morikooooo/items/9fd41bcd8d1ce9170301
" https://qiita.com/morikooooo/items/34bb2466f98ab58f2e77
" https://qiita.com/ikeisuke/items/f84818516e8337cf4c80
" https://qiita.com/iwaseasahi/items/0b2da68269397906c14c
" 

" 最初に書いておきたい重要なコマンド群 {{{2
set fenc=utf-8
syntax on
let mapleader=","
set mouse=a

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
nnoremap <C-h> :<C-u>help<Space>

" 日本語を扱うために {{{2

set matchpairs+=「:」,（:）,【:】,『:』

" 補完 {{{2

inoremap <C-q> <C-x><C-o>
" Plugins {{{1
"""""""""""""""

" Required:
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
 call dein#install()
endif

"End dein Scripts-------------------------

function! DeinUpdate()
  call dein#update()
endfunction

" Plugin Settings {{{1
"""""""""""""""""""""""

" vim-airline {{{2
" let g:airline#extensions#tabline#enabled = 1
" " let g:airline_theme = 'gruvbox'
" let g:airline_theme = 'dracula'
" nmap <C-p> <Plug>AirlineSelectPrevTab
" nmap <C-n> <Plug>AirlineSelectNextTab

" comfortable-motion {{{2

" let g:comfortable_motion_scroll_down_key = "j"
" let g:comfortable_motion_scroll_up_key = "k"
" let g:comfortable_motion_friction =  200.0
" let g:comfortable_motion_air_drag = 1.8
" let g:comfortable_motion_no_default_key_mappings = 1
" let g:comfortable_motion_impulse_multiplier = 1  " Feel free to increase/decrease this value.
" nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
" nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
" nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
" nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>


" call submpde#enter_with('mgmsearchline', 'n', '', '<Space>f', '<Space>f')
"
" command! MgmUpSameIndent call search("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')
" command! MgmDownSameIndent call search("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")
" 
" call submode#enter_with('imove', 'n', '', '<Space>k', 'k:MgmUpSameIndent<CR>^')
" call submode#enter_with('imove', 'n', '', '<Space>j', ':MgmDownSameIndent<CR>^')
" call submode#map('imove', 'n', '', 'k', 'k:MgmUpSameIndent<CR>^')
" call submode#map('imove', 'n', '', 'j', ':MgmDownSameIndent<CR>^')

" NERD tree {{{2
" nnoremap <Space>z :NERDTreeToggle<CR>
" let g:NERDTreeDirArrows = 0
" let g:NERDTreeDirArrowExpandable  = '>'
" let g:NERDTreeDirArrowCollapsible = 'V'
"
" NERD tree がデフォルトで表示されるようにする設定
" if !has('gui_running')
  " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  " autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" endif
" 
" 色付け
" function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
  " exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
  " exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
" endfunction
" 
" " markup file は green
" call NERDTreeHighlightFile('tex', 'green', 'none', '#3366FF', '#fbf1c7')
" call NERDTreeHighlightFile('rst', 'green', 'none', '#3366FF', '#fbf1c7')
" call NERDTreeHighlightFile('adoc', 'green', 'none', '#3366FF', '#fbf1c7')
" call NERDTreeHighlightFile('md', 'green', 'none', '#3366FF', '#fbf1c7')
" call NERDTreeHighlightFile('html', 'green', 'none', '#3366FF', '#fbf1c7')
" " data or config file は red
" call NERDTreeHighlightFile('yml', 'red', 'none', 'red', '#fbf1c7')
" call NERDTreeHighlightFile('yaml', 'red', 'none', 'red', '#fbf1c7')
" call NERDTreeHighlightFile('json', 'red', 'none', 'red', '#fbf1c7')
" call NERDTreeHighlightFile('sty', 'red', 'none', 'red', '#fbf1c7')
" call NERDTreeHighlightFile('bib', 'red', 'none', 'red', '#fbf1c7')
" " script file は yellow
" call NERDTreeHighlightFile('py', 'yellow', 'none', 'yellow', '#fbf1c7')
" call NERDTreeHighlightFile('jl', 'yellow', 'none', 'yellow', '#fbf1c7')
" call NERDTreeHighlightFile('m', 'yellow', 'none', 'yellow', '#fbf1c7')
" " vim で編集したくないファイルは blue
" call NERDTreeHighlightFile('pdf', 'blue', 'none', 'blue', '#fbf1c7')
" call NERDTreeHighlightFile('eps', 'blue', 'none', 'blue', '#fbf1c7')
" call NERDTreeHighlightFile('docx', 'blue', 'none', 'blue', '#fbf1c7')
" call NERDTreeHighlightFile('xlsx', 'blue', 'none', 'blue', '#fbf1c7')
" call NERDTreeHighlightFile('pptx', 'blue', 'none', 'blue', '#fbf1c7')
" " 補助ファイルは gray
" call NERDTreeHighlightFile('aux', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('bbl', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('blg', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('dvi', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('fdb_latexmk', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('fls', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('log', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('nav', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('out', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('snm', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('synctex.gz', 'gray', 'none', 'gray', '#fbf1c7')
" call NERDTreeHighlightFile('toc', 'gray', 'none', 'gray', '#fbf1c7')

" NERD Commenter setting {{{2

" let g:NERDSpaceDelims = 1  " コメント時に挿入するスペース
" let g:NERDCommentEmptyLines = 1 " 空行のコメントを許す

" parens (vim-surround, lexima) {{{2

" }}}
" neosnippets {{{2
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
" imap <C-s> <Plug>(neosnippet_expand_or_jump)
" smap <C-s> <Plug>(neosnippet_expand_or_jump)
" xmap <C-s> <Plug>(neosnippet_expand_target)
" 
" " Snippets
" 
" let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/snippets'

" foldCC "{{{2

" set foldtext=FoldCCtext()
" set foldcolumn=3
" set fillchars=vert:\|
" let g:foldCCtext_tail = 'printf("   %s[%4d lines  Lv%-2d]%s",
" \ v:folddashes, v:foldend-v:foldstart+1, v:foldlevel, v:folddashes)'
"
" hi Folded gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Grey30 guifg=Grey80
" hi FoldColumn gui=bold term=standout ctermbg=LightGrey ctermfg=DarkBlue guibg=Grey guifg=DarkBlue

" braceless {{{2
" autocmd FileType python,yaml BracelessEnable +fold


" ale {{{2

" let g:syntastic_python_checkers = ["flake8"]
" let g:ale_linters = {
  " \ 'python': ['flake8'],
  " \ 'tex': [],
  " \ 'plaintex': [],
  " \ }

" Vimtex {{{2

" let g:vimtex_compiler_latexmk = {'callback' : 0}
" " let g:vimtex_imaps_list = []
" let g:tex_flavor = "latex"

" Jedi-vim {{{2
" let g:jedi#popup_on_dot = 0
" let g:jedi#popup_select_first = 0
" autocmd FileType python setlocal completeopt-=preview

" Key Remapping {{{1 
"""""""""""""""""""""

" new submode {{{2
" call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
" call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
" call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
" call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
" call submode#map('bufmove', 'n', '', '>', '<C-w>>')
" call submode#map('bufmove', 'n', '', '<', '<C-w><')
" call submode#map('bufmove', 'n', '', '+', '<C-w>+')
" call submode#map('bufmove', 'n', '', '-', '<C-w>-')

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

