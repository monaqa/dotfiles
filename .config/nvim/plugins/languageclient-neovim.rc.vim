let g:LanguageClient_serverCommands = {}

let g:LanguageClient_diagnosticsDisplay = {
    \    1: {
    \        "name": "Error",
    \        "texthl": "ALEError",
    \        "signText": "✖",
    \        "signTexthl": "ALEErrorSign",
    \        "virtualTexthl": "Error",
    \    },
    \    2: {
    \        "name": "Warning",
    \        "texthl": "ALEWarning",
    \        "signText": "⚠",
    \        "signTexthl": "ALEWarningSign",
    \        "virtualTexthl": "GruvboxYellowSign",
    \    },
    \    3: {
    \        "name": "Information",
    \        "texthl": "ALEInfo",
    \        "signText": "ℹ",
    \        "signTexthl": "ALEInfoSign",
    \        "virtualTexthl": "GruvboxBlueSign",
    \    },
    \    4: {
    \        "name": "Hint",
    \        "texthl": "ALEInfo",
    \        "signText": "➤",
    \        "signTexthl": "ALEInfoSign",
    \        "virtualTexthl": "GruvboxGreenSign",
    \    },
    \ }

" 言語ごとに設定する
if executable('clangd')
    let g:LanguageClient_serverCommands['cpp'] = ['clangd']
endif

augroup LanguageClient_config
    autocmd!
    autocmd User LanguageClientStarted setlocal signcolumn=yes
    autocmd User LanguageClientStopped setlocal signcolumn=auto
augroup END

let g:LanguageClient_autoStart = 1
" nnoremap <Leader>lh :call LanguageClient_textDocument_hover()<CR>
" nnoremap <Leader>ld :call LanguageClient_textDocument_definition()<CR>
" nnoremap <Leader>lr :call LanguageClient_textDocument_rename()<CR>
" nnoremap <Leader>lf :call LanguageClient_textDocument_formatting()<CR>
"
"
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
    let g:LanguageClient_serverCommands['python'] = ['pyls']
endif
