setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal foldmethod=indent

nnoremap <buffer><expr> @d "<cmd>normal! I(" .. strftime('%Y-%m-%d', localtime() + 86400 * v:count) .. ") <CR>"

let b:caw_oneline_comment = '-'

let b:partedit_prefix_pattern = '\v\t+#\|'
let b:partedit_filetype = 'markdown'
