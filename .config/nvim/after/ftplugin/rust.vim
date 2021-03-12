setlocal foldmethod=syntax
setlocal foldlevel=1
nnoremap <buffer><silent> tk :<C-u>CocCommand rust-analyzer.openDocs<CR>

let g:rustfmt_autosave = 1
