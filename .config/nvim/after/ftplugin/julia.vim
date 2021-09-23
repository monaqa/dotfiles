if exists('b:loaded_ftplugin_julia')
  finish
endif

let b:loaded_ftplugin_julia = 1

setlocal shiftwidth=4
setlocal formatoptions-=o

if getline(1) ==# "# %% [markdown]"
  setlocal fdm=expr
  setlocal foldexpr=HydrogenFoldOnlyCode(v:lnum)
  setlocal foldtext=HydrogenCustomFoldText()
  nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
endif
