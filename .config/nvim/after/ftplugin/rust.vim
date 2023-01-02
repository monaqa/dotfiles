setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
" setlocal foldmethod=syntax
" setlocal foldlevel=1
nnoremap <buffer><silent> tk :<C-u>CocCommand rust-analyzer.openDocs<CR>
nnoremap <buffer> ; m`A;<Esc>``

setlocal formatoptions-=ro
" let b:partedit_prefix_pattern = '\v\s*//[!/]?\s*'
" let b:partedit_filetype = 'markdown'
