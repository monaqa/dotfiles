if exists('b:loaded_ftplugin_python')
  finish
endif

let b:loaded_ftplugin_python = 1

inoreabbrev <buffer> imprt import
inoreabbrev <buffer> improt import

setlocal nosmartindent
setlocal foldmethod=indent

if getline(1) ==# "# %% [markdown]"
  setlocal fdm=expr
  setlocal foldexpr=HydrogenFoldOnlyCode(v:lnum)
  setlocal foldtext=HydrogenCustomFoldText()
  nnoremap <buffer> <CR>q :QuickRun jupytext -args %{expand("%")}<CR>
endif

let quickrun_config['jupytext'] = {
      \ 'command': 'jupytext',
      \ 'exec': '%c %o %a',
      \ 'cmdopt': '--update --to notebook',
      \ 'outputter/error/success': 'null',
      \ 'outputter/error/error': 'null',
      \ }
