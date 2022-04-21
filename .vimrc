" vim:foldmethod=marker:
call jetpack#begin()
call jetpack#add('yasukotelin/shirotelin')
" call jetpack#add('vim-airline/vim-airline')
" call jetpack#add('vim-airline/vim-airline-themes')
call jetpack#add('lambdalisue/fern.vim')
call jetpack#add('tpope/vim-obsession')
call jetpack#end()

set laststatus=2
set hidden

colorscheme shirotelin
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#formatter = 'default'
" let g:airline_theme='papercolor'
