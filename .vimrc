" vim:foldmethod=marker:
call jetpack#begin()

call jetpack#add('sainnhe/edge')
call jetpack#add('lambdalisue/fern.vim', {"branch": "main"})

call jetpack#end()

set laststatus=2
set hidden
set background=light

colorscheme edge

set belloff=all
set mouse=a

filetype plugin indent on
