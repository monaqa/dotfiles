inoremap <buffer> </ </<C-x><C-o>
setlocal shiftwidth=2
nnoremap <buffer> <CR>f :<C-u>%!tidy --indent-cdata true -xml -utf8 2>/dev/null<CR>
