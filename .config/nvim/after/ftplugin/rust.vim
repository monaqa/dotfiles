if exists('b:loaded_ftplugin_rust')
  finish
endif

let b:loaded_ftplugin_rust = 1

setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
" setlocal foldmethod=syntax
" setlocal foldlevel=1
nnoremap <buffer><silent> tk :<C-u>CocCommand rust-analyzer.openDocs<CR>
nnoremap <buffer> ; m`A;<Esc>``

let g:rustfmt_autosave = 1
