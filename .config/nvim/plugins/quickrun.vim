let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
    \ 'runner': 'vimproc',
    \ 'runner/vimproc/updatetime': 40,
    \ 'outputter': 'error',
    \ 'outputter/error/success': 'buffer',
    \ 'outputter/error/error': 'quickfix',
    \ 'hook/close_quickfix/enable_exit': 1
\ }

let quickrun_config['satysfi'] = {
      \ 'command': 'satysfi',
      \ 'exec': '%c %s',
      \ 'outputter/error/success': 'null',
      \ 'outputter/error/error': 'buffer',
      \ }

autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>q :QuickRun satysfi<CR>
