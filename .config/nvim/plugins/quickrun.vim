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
      \ 'exec': '%c %a',
      \ 'outputter/error/success': 'null',
      \ 'outputter/error/error': 'buffer',
      \ }

let quickrun_config['satysfi-debug'] = {
      \ 'command': 'satysfi',
      \ 'exec': '%c %a %o',
      \ 'cmdopt': '--debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space',
      \ 'outputter/error/success': 'null',
      \ 'outputter/error/error': 'buffer',
      \ }

" example; :QuickRun rsync -args /Users/mogami/work/path-of-project remote:work/sync-mac
let g:quickrun_config['rsync'] = {
    \ 'command': 'rsync',
    \ 'cmdopt': '-C --filter=":- .gitignore" --exclude ".git" -acvz --delete -e ssh',
    \ 'exec': '%c %o %a',
    \ 'outputter/error/success': 'null',
\ }


autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>q :QuickRun satysfi -args %{expand("%")}<CR>
autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>Q :QuickRun satysfi-debug -args %{expand("%")}<CR>
