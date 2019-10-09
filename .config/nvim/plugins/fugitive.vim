nnoremap <Space>gb :Gblame<CR>
nnoremap <Space><Space> :G<CR>

let g:nremap = {'s': '<Nop>'}

autocmd FileType fugitive call s:fugitive_my_settings()
function! s:fugitive_my_settings() abort
  nmap <buffer> u -
endfunction
