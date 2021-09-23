if exists('b:loaded_ftplugin_html')
  finish
endif

let b:loaded_ftplugin_html = 1

inoremap <buffer> </ </<C-x><C-o>
setlocal shiftwidth=2
