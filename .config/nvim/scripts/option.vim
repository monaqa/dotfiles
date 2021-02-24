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
" set statusline^=%{coc#status()}

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

" 全角スペース強調
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776
augroup vimrc
  autocmd ColorScheme * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * match UnicodeSpaces
  \ /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/
augroup END

" §§1 editing
set expandtab
set tabstop=4
set shiftwidth=4
set breakindent
set nosmartindent
set virtualedit=block

set clipboard+=unnamedplus

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
