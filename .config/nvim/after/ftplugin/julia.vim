augroup vimrc
  autocmd FileType julia setlocal shiftwidth=4
  " hydrogen-like julia file
  autocmd FileType julia if getline(1) ==# "# %% [markdown]"
  autocmd FileType julia   setlocal fdm=expr
  autocmd FileType julia   setlocal foldexpr=HydrogenFoldOnlyCode(v:lnum)
  autocmd FileType julia   setlocal foldtext=HydrogenCustomFoldText()
  autocmd FileType julia   nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
  autocmd FileType julia endif
augroup END
