if exists('b:loaded_ftplugin_tmux')
  finish
endif

let b:loaded_ftplugin_tmux = 1

nnoremap <buffer> <CR>s :!tmux source ~/.tmux.conf<CR>
