nnoremap m <Nop>
" m を prefix にする
nmap <silent> md <Plug>(coc-definition)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> mi <Plug>(coc-implementation)
nmap <silent> my <Plug>(coc-type-definition)
nmap <silent> mr <Plug>(coc-references)
nmap <silent> mn <Plug>(coc-rename)
nnoremap <silent> K :call CocAction('doHover')<CR>
nnoremap <silent> <Space>j :call CocAction('diagnosticNext')<CR>
nnoremap <silent> <Space>k :call CocAction('diagnosticPrevious')<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" let g:LanguageClient_serverCommands = {
"\   'julia': ['/Applications/Julia-0.6.app/Contents/Resources/julia/bin/julia']}

augroup rc_coc
  autocmd!
  autocmd Filetype java nnoremap <Space>i :CocCommand java.action.organizeImports<CR>
augroup END

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<C-g><C-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<C-g><C-k>'

" imap <C-q> <Plug>(coc-snippets-expand)

" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xnoremap <silent> ma :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nnoremap <silent> ma :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@l
