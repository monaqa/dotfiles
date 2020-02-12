nnoremap <Space>g :G<CR>

let g:nremap = {'s': '<Nop>'}

augroup rc_fugitive
  autocmd!
  autocmd FileType fugitive call s:fugitive_my_settings()
augroup END

function! s:fugitive_my_settings() abort
  nmap <buffer> u -
endfunction
