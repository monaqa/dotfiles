" vim:fdm=marker:fmr=§§,■■
" autocmd まわり。

" §§1 表示設定

augroup vimrc
  " temporal attention の設定初期化
  autocmd BufLeave,FocusLost,InsertEnter * setlocal nocursorline
  autocmd BufLeave,FocusLost,InsertEnter * setlocal nocursorcolumn
  autocmd BufLeave,FocusLost,InsertEnter * setlocal norelativenumber
augroup END

" 全角スペース強調
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776
augroup vimrc
  autocmd ColorScheme * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * match UnicodeSpaces /[\u180E\u2000-\u200A\u2028\u2029\u202F\u205F\u3000]/
augroup END

" window/buffer
augroup vimrc
  autocmd VimResized * exe "normal \<c-w>="
augroup END


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

" 無名レジスタへの yank 操作のときのみ， + レジスタに内容を移す（delete のときはしない）
augroup vimrc
  if exists('##TextYankPost')
    autocmd TextYankPost * call <SID>copyUnnamedToPlus(v:event)
  endif
augroup END
function! s:copyUnnamedToPlus(event)
  if a:event.operator ==# 'y' && a:event.regname ==# ''
    let @+ = @"
  endif
endfunction

augroup vimrc
  " マクロ用のレジスタを消去
  autocmd VimEnter * let @q = ''
augroup END

" §§1 Quickfix
augroup vimrc
  autocmd QuickfixCmdPost [^l]* cwin
  autocmd QuickfixCmdPost l* lwin
augroup END

" §§1 Command-line window
" let &cedit = "\<C-f>"
cnoremap <C-c> <C-f>

" 特定の文字を入力したら自動でコマンドラインウィンドウに切り替わるようにする
" → abbrev が効かなくなるので一旦保留
" cnoremap <expr> <Space> getcmdtype() ==# ":" ? "\<Space>\<C-f>" : "\<Space>"
" cnoremap <expr> \ (getcmdtype() ==# "/" <Bar><Bar> getcmdtype() ==# "?") ? "\\<C-f>" : '\'

augroup vimrc
  autocmd CmdwinEnter * setlocal nonumber
  autocmd CmdwinEnter * setlocal norelativenumber
  autocmd CmdwinEnter * setlocal signcolumn=no
  autocmd CmdwinEnter * setlocal foldcolumn=0
  autocmd CmdwinEnter * nnoremap <buffer> <C-f> <C-f>
  autocmd CmdwinEnter * nnoremap <buffer> <C-u> <C-u>
  autocmd CmdwinEnter * nnoremap <buffer> <C-b> <C-b>
  autocmd CmdwinEnter * nnoremap <buffer> <C-d> <C-d>
  autocmd CmdwinEnter * nnoremap <buffer> <Esc> :q<CR>
  autocmd CmdwinEnter * nnoremap <buffer><nowait> <CR> <CR>
  " autocmd CmdwinEnter : keeppatterns g/^qa\?!\?$/d _
  " autocmd CmdwinEnter : keeppatterns g/^wq\?a\?!\?$/d _
  " autocmd CmdwinEnter : keeppatterns g/^e$/d _
  " autocmd CmdwinEnter * $
  " autocmd CmdwinEnter * startinsert!
augroup END

" Instant Visual Highlight
" Thanks to woodyZootopia
" https://github.com/woodyZootopia/nvim/blob/81047bbf893570cd0d832ef3ec076f278087dc6b/autocmd.vim#L44-L71
augroup vimrc
  autocmd WinLeave * call <SID>free_visual_match()
  autocmd CursorMoved,CursorHold * call <SID>visual_match()
augroup END
xnoremap <Esc> <Esc><Cmd>call <SID>free_visual_match()<CR>
" なぜか SELECT モードでは <Cmd> がうまく動かない
snoremap <silent> <Esc> <Esc>:<C-u>call <SID>free_visual_match()<CR>

function! s:visual_match()
  call s:free_visual_match()
  if index(['v', ''], mode()) != -1 && line('v') == line('.')
    let len_of_char_of_v   = strlen(matchstr(getline('v'), '.', col('v')-1))
    let len_of_char_of_dot = strlen(matchstr(getline('.'), '.', col('.')-1))
    let first = min([col('v') - 1, col('.') - 1])
    let last = max([col('v') - 2 + len_of_char_of_v, col('.') - 2 + len_of_char_of_dot])
    let w:visual_match_id = matchadd('VisualBlue', '\C\V' .. escape(getline('.')[first:last], '\'))
  endif
endfunction

function! s:free_visual_match()
  if exists("w:visual_match_id")
    call matchdelete(w:visual_match_id)
    unlet w:visual_match_id
  endif
endfunction
