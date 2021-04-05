
inoreabbrev <buffer> imprt import
inoreabbrev <buffer> improt import

augroup vimrc
  autocmd FileType python setlocal nosmartindent
  autocmd FileType python setlocal foldmethod=indent
  " hydrogen-like python file
  autocmd FileType python if getline(1) ==# "# %% [markdown]"
  autocmd FileType python   setlocal fdm=expr
  autocmd FileType python   setlocal foldexpr=HydrogenFoldOnlyCode(v:lnum)
  autocmd FileType python   setlocal foldtext=HydrogenCustomFoldText()
  autocmd FileType python   nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
  autocmd FileType python endif
augroup END

let quickrun_config['jupytext'] = {
      \ 'command': 'jupytext',
      \ 'exec': '%c %o %a',
      \ 'cmdopt': '--update --to notebook',
      \ 'outputter/error/success': 'null',
      \ 'outputter/error/error': 'null',
      \ }
