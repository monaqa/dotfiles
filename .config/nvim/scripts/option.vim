" vim:fdm=marker:fmr=§§,■■

" §§1 表示設定

" 全体
set belloff=all

set lazyredraw
set ttyfast

" バッファ内
set ambiwidth=single
set wrap
set colorcolumn=80
set list
set listchars=tab:▸▹┊,trail:⌑,extends:❯,precedes:❮
set scrolloff=0
set foldlevelstart=99

set matchpairs+=（:）,「:」,『:』,【:】

" 下
set showcmd
set laststatus=2

" 左
set number
set foldcolumn=0
set signcolumn=yes:2

" misc
set splitbelow
set splitright
set diffopt+=vertical,algorithm:histogram

" §§1 colorscheme
set termguicolors
set background=dark
colorscheme gruvbit

" §§1 editing
set expandtab
set tabstop=4
set shiftwidth=4
set breakindent
set nosmartindent
set virtualedit=block
" shellscript 対策
set isfname-==

" set clipboard+=unnamedplus

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
  set undofile
endif

" §§1 search
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set inccommand=split

" §§1 session
set sessionoptions=buffers,folds,tabpages,winsize

" §§1 grep
if executable('rg')
  let &grepprg = 'rg --vimgrep --hidden --glob ' .. "'!tags*'"
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

