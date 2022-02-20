if exists('b:loaded_ftplugin_vim')
  finish
endif

let b:loaded_ftplugin_vim = 1

let g:vim_indent_cont = 0

setlocal shiftwidth=2
nnoremap <buffer> K K
setlocal keywordprg=:help

setlocal formatoptions-=ro
let b:partedit_prefix = ''
let b:partedit_filetype = 'lua'
