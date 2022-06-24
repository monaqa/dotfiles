-- vim:fdm=marker:fmr=§§,■■

-- §§1 Plugin settings for neoclide/coc.nvim
vim.cmd[[
set tagfunc=CocTagFunc

let g:coc_global_extensions = [
\ 'coc-snippets',
\ 'coc-marketplace',
\ 'coc-actions',
\ 'coc-rust-analyzer',
\ 'coc-pyright',
\ 'coc-json',
\ 'coc-deno',
\]

nnoremap t <Nop>
" t を prefix にする
nmap <silent> td <Cmd>Telescope coc definitions<CR>
" nmap <silent> gd <Cmd>Telescope coc definitions<CR>
nmap <silent> gd <C-]>
nmap <silent> ti <Cmd>Telescope coc implementations<CR>
nmap <silent> ty <Cmd>Telescope coc type_definitions<CR>
nmap <silent> tr <Cmd>Telescope coc references<CR>
" nmap <silent> td <Plug>(coc-definition)
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> ti <Plug>(coc-implementation)
" nmap <silent> ty <Plug>(coc-type-definition)
" nmap <silent> tr <Plug>(coc-references)
nmap <silent> tn <Plug>(coc-rename)
nnoremap <silent> K :call CocAction('doHover')<CR>
nnoremap <silent> <C-n> :call CocAction('diagnosticNext')<CR>
nnoremap <silent> <C-p> :call CocAction('diagnosticPrevious')<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CocCheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CocCheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
" let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<C-g><C-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<C-g><C-k>'

" Remap for do codeAction of selected region
" function! s:cocActionsOpenFromSelected(type) abort
"   execute 'CocCommand actions.open ' . a:type
" endfunction
" xnoremap <silent> ma :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
" nnoremap <silent> ma :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@l
xmap <silent> ta <Plug>(coc-codeaction-selected)
nmap <silent> ta <Plug>(coc-codeaction-selected)l

function! CocServiceNames(ArgLead, CmdLine, CursorPos)
  let actions = map(CocAction('services'), {idx, d -> d['id']})
  return actions
endfunction

command! -nargs=1 -complete=customlist,CocServiceNames CocToggleService call CocAction('toggleService', <q-args>)
]]
