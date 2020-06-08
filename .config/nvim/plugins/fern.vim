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
  nmap <buffer><expr>
  \ <Plug>(fern-expand-or-enter)
  \ fern#smart#drawer(
  \   "\<Plug>(fern-action-expand)",
  \   "\<Plug>(fern-action-enter)",
  \ )
  nmap <buffer><expr>
  \ <Plug>(fern-open-or-enter)
  \ fern#smart#leaf(
  \   "\<Plug>(fern-action-open)",
  \   "\<Plug>(fern-action-enter)",
  \ )
  nmap <buffer><expr>
  \ <Plug>(fern-open-or-expand)
  \ fern#smart#leaf(
  \   "\<Plug>(fern-action-open)",
  \   "\<Plug>(fern-action-expand)",
  \ )
  nmap <silent><buffer><expr> <Plug>(fern-expand-or-collapse)
  \ fern#smart#leaf(
  \   "\<Plug>(fern-action-collapse)",
  \   "\<Plug>(fern-action-expand)",
  \   "\<Plug>(fern-action-collapse)",
  \ )

  " move cwd, open file
  nmap <buffer> l <Plug>(fern-open-or-expand)
  nmap <buffer> <C-h> <Plug>(fern-action-leave)
  nmap <nowait><buffer> <CR> <Plug>(fern-action-enter)
  nmap <buffer> e <Plug>(fern-action-open)
  nmap <buffer> <BS> <Plug>(fern-action-leave)

  " expand/collapse tree
  nmap <nowait><buffer> t <Plug>(fern-expand-or-collapse)
  nmap <nowait><buffer> T <Plug>(fern-action-collapse)

  " new
  nmap <buffer> o <Plug>(fern-action-new-file)
  nmap <buffer> O <Plug>(fern-action-new-dir)

  " move, remove, copy...
  nmap <buffer> d <Plug>(fern-action-trash)
  nmap <buffer> r <Plug>(fern-action-rename)
  nmap <buffer> c <Plug>(fern-action-copy)
  nmap <buffer> m <Plug>(fern-action-move)

  " other
  nmap <buffer> ! <Plug>(fern-action-hidden-toggle)
  nmap <buffer> <C-l> <Plug>(fern-action-redraw)
endfunction
