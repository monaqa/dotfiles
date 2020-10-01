" vim:fdm=marker:fmr=§§,■■

" §§1 表示設定

augroup vimrc
  " 現在編集中のバッファは scrolloff あり
  autocmd BufEnter,FocusGained,InsertLeave * if &buftype ==# ''
  autocmd BufEnter,FocusGained,InsertLeave *   setlocal scrolloff=10
  autocmd BufEnter,FocusGained,InsertLeave * endif
  " 編集中でないバッファは scrolloff なし
  autocmd BufLeave,FocusLost,InsertEnter   * setlocal scrolloff=0
augroup END

" 全角スペース強調
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776

augroup vimrc
  autocmd ColorScheme * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * match UnicodeSpaces
  \ /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/
augroup END

" window/buffer
augroup vimrc
  autocmd VimResized * call <SID>resizeFloatingWindow()
  autocmd VimResized * exe "normal \<c-w>="
augroup END

function s:resizeFloatingWindow()
  if exists('*ResizeDefxFloatingWindow')
    call ResizeDefxFloatingWindow()
  endif
  if exists('*ResizeDeniteFloatingWindow')
    call ResizeDeniteFloatingWindow()
  endif
endfunction


" §§1 .vimrc.local
augroup vimrc
  autocmd VimEnter * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction


" §§1 editor の機能

autocmd vimrc InsertLeave * set nopaste

" Automatically create missing directories
" thanks to lambdalisue
autocmd vimrc BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
function! s:auto_mkdir(dir, force) abort
  if empty(a:dir) || a:dir =~# '^\w\+://' || isdirectory(a:dir) || a:dir =~# '^suda:'
      return
  endif
  if !a:force
    echohl Question
    call inputsave()
    try
      let result = input(
            \ printf('"%s" does not exist. Create? [y/N]', a:dir),
            \ '',
            \)
      if empty(result)
        echohl WarningMsg
        echo 'Canceled'
        return
      endif
    finally
      call inputrestore()
      echohl None
    endtry
  endif
  call mkdir(a:dir, 'p')
endfunction

" Command-line window
let &cedit = "\<C-C>"
augroup vimrc
  autocmd CmdwinEnter * setlocal nonumber
  autocmd CmdwinEnter * setlocal norelativenumber
  autocmd CmdwinEnter * setlocal signcolumn=no
  autocmd CmdwinEnter * setlocal foldcolumn=0
  autocmd CmdwinEnter * nnoremap <buffer> <C-f> <C-f>
  autocmd CmdwinEnter * nnoremap <buffer> <C-u> <C-u>
  autocmd CmdwinEnter * nnoremap <buffer> <C-b> <C-b>
  autocmd CmdwinEnter * nnoremap <buffer> <C-d> <C-d>
  autocmd CmdwinEnter * nnoremap <buffer><nowait> <CR> <CR>
  autocmd CmdwinEnter : keeppatterns g/^qa\?!\?$/d _
  autocmd CmdwinEnter : keeppatterns g/^wq\?a\?!\?$/d _
augroup END

" yank 操作のときのみ， + レジスタに内容を移す（delete のときはしない）
augroup vimrc
  if exists('##TextYankPost')
    autocmd TextYankPost * call <SID>copyUnnamedToPlus(v:event.operator)
  endif
augroup END
function! s:copyUnnamedToPlus(opr)
  if a:opr ==# 'y'
    let @+ = @"
  endif
endfunction

" §§1


" §§1
