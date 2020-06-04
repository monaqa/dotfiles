let g:fern#disable_default_mappings = 1
let g:fern#default_hidden = 1
nnoremap sf :<C-u>Fern . -drawer -toggle<CR>

augroup rc_fern
  autocmd!
  autocmd FileType fern set nonumber
  autocmd FileType fern set signcolumn=no
  autocmd FileType fern set foldcolumn=0
  autocmd FileType fern call s:fern_settings()
augroup END

function s:fern_settings()
  " move cwd, open file
  nmap <buffer> l <Plug>(fern-action-enter)
  nmap <buffer> <C-h> <Plug>(fern-action-leave)
  nmap <nowait><buffer> <CR> <Plug>(fern-action-open)
  nmap <buffer> e <Plug>(fern-action-open)
  nmap <buffer> <BS> <Plug>(fern-action-leave)

  " expand/collapse tree
  nmap <nowait><buffer> t <Plug>(fern-action-expand)
  nmap <nowait><buffer> T <Plug>(fern-action-collapse)

  " move, remove, copy...
  nmap <buffer> dd <Plug>(fern-action-trash)
endfunction
