if exists('b:loaded_ftplugin_rst')
  finish
endif

let b:loaded_ftplugin_rst = 1

function! s:reSTTitle(punc)
  let line = getline('.')
  sil! exe row 'foldopen!'
  call append('.', repeat(a:punc, strdisplaywidth(line)))
endfunction

setlocal suffixesadd+=.rst
nnoremap <buffer> <Space>s0 :call <SID>reSTTitle("#")<CR>jo<Esc>
nnoremap <buffer> <Space>s1 :call <SID>reSTTitle("=")<CR>jo<Esc>
nnoremap <buffer> <Space>s2 :call <SID>reSTTitle("-")<CR>jo<Esc>
nnoremap <buffer> <Space>s3 :call <SID>reSTTitle("~")<CR>jo<Esc>
nnoremap <buffer> <Space>s4 :call <SID>reSTTitle('"')<CR>jo<Esc>
nnoremap <buffer> <Space>s5 :call <SID>reSTTitle("'")<CR>jo<Esc>
setlocal shiftwidth=2
