" vim:fdm=marker:fmr=§§,■■

" §§1 highlight

" Show highlight group name under a cursor
command! HighlightGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
" Show highlight item name under a cursor
command! HighlightItem echo synIDattr(synID(line("."), col("."), 1), "name")

" §§1 文字コードフォーマット

" フォーマット変えて開き直す系
" thanks to cohama
command! Utf8 edit ++enc=utf-8 %
command! Cp932 edit ++enc=cp932 %
command! Unix edit ++ff=unix %
command! Dos edit ++ff=dos %
command! AsUtf8 set fenc=utf-8|w

" §§1 差分表示

command! -nargs=0 DiffThese call s:diff_these()
function! s:diff_these()
  let win_count = winnr('$')
  if win_count == 2
    diffthis
    wincmd w
    diffthis
    wincmd w
  else
    echomsg "Too many windows."
  endif
endfunction

" §§1 ファイルのリネーム・削除

" thanks to cohama
" 今開いているファイルを削除
command! -bang -nargs=0 DeleteMe call DeleteMe(<bang>0)
function! DeleteMe(force)
  if a:force || !&modified
    let filename = expand('%')
    bdelete!
    call delete(filename)
  else
    echomsg 'File modified'
  endif
endfunction

" 今開いているファイルをリネーム
command! -nargs=1 RenameMe call RenameMe(<q-args>)
function! RenameMe(newFileName)
  let currentFileName = expand('%')
  execute 'saveas ' . a:newFileName
  bdelete! #
  call delete(currentFileName)
endfunction
cnoreabbrev <expr> RenameMe "RenameMe " . expand('%')

" §§1 行末の空白とか最終行の空行を削除
function! RemoveUnwantedSpaces()
  let pos_save = getpos('.')
  try
    keeppatterns %s/\s\+$//e
    while 1
      let lastline = getline('$')
      if lastline =~ '^\s*$' && line('$') != 1
        $delete
      else
        break
      endif
    endwhile
  finally
    call setpos('.', pos_save)
  endtry
endfunction
command! -nargs=0 RemoveUnwantedSpaces call RemoveUnwantedSpaces()

" 現在のファイル名をコピー
command! YankCurrentFileName let @+ = expand("%:p")

" §§1 substitute
command! -bang -nargs=0 SubstituteCommaPeriod call SubstituteCommaPeriod(<bang>0)
function! SubstituteCommaPeriod(invert)
  if a:invert
    %substitute/、/，/g
    %substitute/。/．/g
  else
    %substitute/，/、/g
    %substitute/．/。/g
  endif
endfunction
