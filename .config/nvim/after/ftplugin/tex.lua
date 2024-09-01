vim.cmd([[
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '@line @pdf @tex'

let g:tex_flavor = 'latex'
setlocal shiftwidth=2
setlocal iskeyword+=92,@-@
nmap <buffer> <CR>q <Plug>(vimtex-compile)
nmap <buffer> <CR>o <Plug>(vimtex-view)
nmap <buffer> <CR>l <Plug>(vimtex-compile-output)
]])
