-- §§1 Plugin settings for ddu.vim
vim.cmd[[
call ddu#custom#patch_global({
    \   'ui': 'ff',
    \   'uiParams': {
    \     'ff': {
    \       'split': 'floating',
    \     }
    \   },
    \   'sources': [
    \      {'name': 'file_rec', 'params': {}},
    \   ],
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': ['matcher_substring'],
    \     },
    \     'rg' : {
    \       'args': ['--column', '--no-heading', '--color', 'never'],
    \     },
    \   },
    \   'kindOptions': {
    \     'file': {
    \       'defaultAction': 'open',
    \     },
    \   }
    \ })

call ddu#custom#patch_global({
    \   'sourceParams' : {
    \     'rg' : {
    \       'args': ['--column', '--no-heading', '--color=never', '--hidden'],
    \     },
    \   },
    \ })

call ddu#custom#patch_global('sourceParams', {
      \ 'file_external': {'cmd': ['fd', '.', '-H', '-E', '__pycache__', '-t', 'f']}
      \ })

nnoremap @o <Cmd>call ddu#start({'sources': [{'name': 'file_external', 'params': {}}]})<CR>
nnoremap @m <Cmd>call ddu#start({'sources': [{'name': 'mr', 'params': {'kind': 'mru'}}]})<CR>
nnoremap @g <Cmd>call ddu_rg#find()<CR>

autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>    <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> <Space> <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i       <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q       <Cmd>call ddu#ui#ff#do_action('quit')<CR>
  nnoremap <buffer><silent> <Esc>   <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer><silent> <CR> <Esc><Cmd>close<CR>

  nnoremap <buffer><silent> <CR>  <Cmd>close<CR>
  nnoremap <buffer><silent> q     <Cmd>close<CR>
  nnoremap <buffer><silent> <Esc> <Cmd>close<CR>
endfunction

]]
