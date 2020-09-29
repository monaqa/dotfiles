" vim:fdm=marker:fmr=§§,■■

" §§1 表示設定

" 全体
set visualbell
set noerrorbells

set lazyredraw
set ttyfast

" バッファ内
set ambiwidth=single  "全角文字幅
set wrap
set colorcolumn=80
set list
set listchars=tab:▸▹┊,trail:⌑,extends:❯,precedes:❮

set matchpairs+=（:）,「:」,『:』,【:】

" 下
set showcmd
set laststatus=2  " ステータスラインを常に表示
set statusline^=%{coc#status()}

" 左
set number
set foldcolumn=0
set signcolumn=yes:2

" misc
set splitbelow
set splitright

" §§1 colorscheme
set termguicolors
set background=dark
colorscheme gruvbit

" §§1 editing
set expandtab
set tabstop=4
set shiftwidth=4
set breakindent
set smartindent
set virtualedit=block

set clipboard=

autocmd vimrc FileType * set formatoptions-=o formatoptions+=nB

" §§1 editor functions
" backup
set nobackup
set noswapfile

" safety
set autoread
set confirm

" vim modeline
set modeline
set modelines=3

" misc
set hidden
set spelllang=en,cjk
set backspace=indent,eol,start
set history=10000

set mouse=a
if &shell =~# 'fish$'
  set shell=sh
endif

if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

" §§1 search
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set inccommand=split

" §§1 terminal window
augroup vimrc
  autocmd TermOpen * call s:terminal_init()
  autocmd TermOpen * setlocal wrap
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal signcolumn=no
  autocmd TermOpen * setlocal foldcolumn=0
augroup END

