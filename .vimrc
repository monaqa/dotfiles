" vim:foldmethod=marker:
call jetpack#begin()

call jetpack#add('yasukotelin/shirotelin')
call jetpack#add('vim-airline/vim-airline')
call jetpack#add('vim-airline/vim-airline-themes')
call jetpack#add('lambdalisue/fern.vim', {"branch": "main"})
call jetpack#add('tpope/vim-obsession')

call jetpack#add('lifepillar/vim-colortemplate')

call jetpack#end()

set laststatus=2
set hidden

colorscheme shirotelin
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_theme='papercolor'

set belloff=all
set mouse=a
