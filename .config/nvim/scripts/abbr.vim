" vim:fdm=marker:fmr=§§,■■

" 範囲保存したいときは write を使おう
cnoreabbrev <expr> w ((getcmdtype() ==# ":" && getcmdline() ==# "'<,'>w") ? ("\<C-u>w") : ("w"))

" typo の達人
function! s:modify_write_typo(typo)
  exec 'cnoreabbrev <expr> ' .. a:typo .. ' ((getcmdtype() ==# ":" && getcmdline() ==# "' .. a:typo .. '")? "w" : "' .. a:typo .. '")'
endfunction

call s:modify_write_typo("w2")
call s:modify_write_typo("w]")
