" vim:fdm=marker:

set encoding=utf-8
scriptencoding utf-8

" エディタ全般の設定{{{
""""""""""""""""""""""""

augroup vimrc
  autocmd!
augroup END

let g:tex_flavor = "latex"

source ~/.config/nvim/scripts/minpac.vim
source ~/.config/nvim/scripts/plugin.vim
filetype plugin indent on
syntax enable

source ~/.config/nvim/scripts/option.vim
source ~/.config/nvim/scripts/abbr.vim
source ~/.config/nvim/scripts/keymap.vim

" mouse などの有効化{{{

let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim/bin/python'

" }}}

" タブ文字/不可視文字/インデントの設定{{{
" indent 幅のデフォルト
augroup vimrc
  autocmd FileType vim setlocal shiftwidth=2
  autocmd FileType xml,html setlocal shiftwidth=2
  autocmd FileType tex setlocal shiftwidth=2
  autocmd FileType satysfi setlocal shiftwidth=2
  autocmd FileType markdown,rst setlocal shiftwidth=2
augroup END
" }}}
" }}}


" Theme/colorscheme/表示設定 {{{
"""""""""""""""""""""""""""""""""

" 表示設定 {{{
augroup vimrc
  " 現在編集中のバッファは scrolloff あり
  autocmd BufEnter,FocusGained,InsertLeave * if &buftype ==# ''
  autocmd BufEnter,FocusGained,InsertLeave *   setlocal scrolloff=10
  autocmd BufEnter,FocusGained,InsertLeave * endif
  " 編集中でないバッファは scrolloff なし
  autocmd BufLeave,FocusLost,InsertEnter   * setlocal scrolloff=0
augroup END

" }}}

" 全角スペース強調 {{{
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776

augroup vimrc
  autocmd ColorScheme * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * highlight link UnicodeSpaces Error
  autocmd VimEnter,WinEnter * match UnicodeSpaces
  \ /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/
augroup END

" }}}

" Theme {{{
" VimShowHlGroup: Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
" VimShowHlItem: Show highlight item name under a cursor
command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")
" }}}

" .vimrc.local {{{
augroup vimrc
  autocmd VimEnter * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction
" }}}
" }}}


" エディタの機能に関する設定 {{{
"""""""""""""""""""""""""""""""""

autocmd vimrc InsertLeave * set nopaste

" folding {{{
" }}}

" 文字コード指定 {{{
" フォーマット変えて開き直す系
" thanks to cohama
command! Utf8 edit ++enc=utf-8 %
command! Cp932 edit ++enc=cp932 %
command! Unix edit ++ff=unix %
command! Dos edit ++ff=dos %
command! AsUtf8 set fenc=utf-8|w
" }}}


" Automatically create missing directories {{{
" thanks to lambdalisue
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
autocmd vimrc BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
" }}}

" Command-line window {{{
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
" }}}

" diff {{{
" thanks to cohama
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
" }}}

" }}}


" Window/buffer の設定{{{
""""""""""""""""""""""""""

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

" }}}


" Operator {{{
""""""""""""""

augroup vimrc
  if exists('##TextYankPost')
    autocmd TextYankPost * call <SID>copyUnnamedToPlus(v:event.operator)
  endif
augroup END

function! s:copyUnnamedToPlus(opr)
  " yank 操作のときのみ， + レジスタに内容を移す（delete のときはしない）
  if a:opr ==# 'y'
    let @+ = @"
  endif
endfunction

" }}}



" 行の操作/空行追加 {{{

" 改行だけを入力する
" thanks to cohama
nnoremap <expr> <Space>o "mz" . v:count . "o\<Esc>`z"
nnoremap <expr> <Space>O "mz" . v:count . "O\<Esc>`z"

if !has('gui_running')
  " CUIで入力された<S-CR>,<C-S-CR>が拾えないので
  " iTerm2のキー設定を利用して特定の文字入力をmapする
  " Map ✠ (U+2720) to <Esc> as <S-CR> is mapped to ✠ in iTerm2.
  map ✠ <S-CR>
  imap ✠ <S-CR>
  map ✢ <C-S-CR>
  imap ✢ <C-S-CR>
  map ➿ <C-CR>
  imap ➿ <C-CR>
endif
" 将来何かに割り当てようっと
nnoremap <S-CR> <Nop>
nnoremap <C-S-CR> <Nop>
nnoremap <C-CR> <Nop>

" 長い文の改行をノーマルモードから楽に行う
" try: f.<Space><CR> or f,<Space><CR>
nnoremap <silent> <Space><CR> a<CR><Esc>

" }}}

" マクロの活用 {{{
nnoremap q qq<Esc>
nnoremap Q q
nnoremap , @q
" JIS キーボードなので <S-;> が + と同じ
nnoremap + ,
" }}}

" Transform with Lambda function {{{

" 選択した数値を任意の関数で変換する．
" たとえば 300pt の 300 を選択して <Space>s とし，
" x -> x * 3/2 と指定すれば 450pt になる．
" 計算式は g:monaqa_lambda_func に格納されるので <Space>r で使い回せる．
" 小数のインクリメントや css での長さ調整等に便利？マクロと組み合わせてもいい．
" 中で eval を用いているので悪用厳禁．基本的に数値にのみ用いるようにする
vnoremap <Space>s :<C-u>call <SID>applyLambdaToSelectedArea()<CR>
vnoremap <Space>r :<C-u>call <SID>repeatLambdaToSelectedArea()<CR>

let g:monaqa_lambda_func = 'x'

function s:applyLambdaToSelectedArea() abort
  let tmp = @@
  silent normal gvy
  let visual_area = @@

  let lambda_body = input('Lambda: x -> ', g:monaqa_lambda_func)
  let g:monaqa_lambda_func = lambda_body
  let lambda_expr = '{ x -> ' . lambda_body . ' }'
  let Lambda = eval(lambda_expr)
  let retval = Lambda(eval(visual_area))
  let return_str = string(retval)

  let @@ = return_str
  silent normal gvp
  let @@ = tmp
endfunction

function s:repeatLambdaToSelectedArea() abort
  let tmp = @@
  silent normal gvy
  let visual_area = @@

  let lambda_body = g:monaqa_lambda_func
  let lambda_expr = '{ x -> ' . lambda_body . ' }'
  let Lambda = eval(lambda_expr)
  let retval = Lambda(eval(visual_area))
  let return_str = string(retval)

  let @@ = return_str
  silent normal gvp
  let @@ = tmp
endfunction

" }}}

" jump with changed list {{{
" 便利なので連打しやすいマップにしてみる
nnoremap <C-h> g;
nnoremap <C-g> g,

" }}}

" rename/delete current file {{{
" thanks to cohama

" 今開いているファイルを削除
function! DeleteMe(force)
  if a:force || !&modified
    let filename = expand('%')
    bdelete!
    call delete(filename)
  else
    echomsg 'File modified'
  endif
endfunction
command! -bang -nargs=0 DeleteMe call DeleteMe(<bang>0)

" 今開いているファイルをリネーム
function! RenameMe(newFileName)
  let currentFileName = expand('%')
  execute 'saveas ' . a:newFileName
  bdelete! #
  call delete(currentFileName)
endfunction
command! -nargs=1 RenameMe call RenameMe(<q-args>)

cnoreabbrev <expr> RenameMe "RenameMe " . expand('%')

" }}}

" auto-format {{{
" 行末の空白とか最終行の空行を削除
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
" }}}

" }}}


" 特定の種類のファイルに対する設定{{{

" Vim {{{

" Vimscript {{{
let g:vim_indent_cont = 0
augroup vimrc
  autocmd FileType vim nnoremap <buffer> K K
  autocmd FileType vim setlocal keywordprg=:help
augroup END
" }}}

" netrw {{{
augroup vimrc
  autocmd FileType netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  noremap <buffer> i h
  noremap <buffer> s <Nop>
endfunction

" https://www.tomcky.net/entry/2018/03/18/005927
" 上部に表示される情報を非表示
let g:netrw_banner = 0
" 表示形式をTreeViewに変更
let g:netrw_liststyle = 3
" 左右分割を右側に開く
let g:netrw_altv = 1
" 分割で開いたときに85%のサイズで開く
let g:netrw_winsize = 85
" }}}

" }}}

" Programming Language {{{

" Rust {{{
let g:rust_fold = 2
augroup vimrc
  autocmd FileType rust setlocal foldlevel=1
augroup END

" }}}

" Python {{{
augroup vimrc
  autocmd FileType python setlocal nosmartindent
augroup END
" }}}

" Julia {{{

augroup vimrc
  autocmd FileType julia setlocal shiftwidth=4
  autocmd FileType julia setlocal path+=/Applications/Julia-1.1.app/Contents/Resources/julia/share/julia/base
augroup END

" }}}

" }}}

" Markup Language {{{

" TeX/LaTeX {{{
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '@line @pdf @tex'

let g:tex_flavor = 'latex'
" \cs を一単語に
augroup vimrc
  autocmd FileType tex setlocal iskeyword+=92
augroup END
" }}}

" SATySFi {{{

augroup vimrc
  autocmd BufRead,BufNewFile *.satyg setlocal filetype=satysfi
  autocmd BufRead,BufNewFile Satyristes setlocal filetype=lisp
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>o :!open %:r.pdf<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>q :!satysfi %<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>Q :!satysfi --debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space %<CR>
  autocmd FileType satysfi setlocal path+=/usr/local/share/satysfi/dist/packages,$HOME/.satysfi/dist/packages,$HOME/.satysfi/local/packages
  autocmd FileType satysfi setlocal suffixesadd+=.saty,.satyh,.satyg
  " iskeyword で +,\,@ の3文字を単語に含める
  autocmd FileType satysfi setlocal iskeyword+=43,92,@-@
  autocmd FileType satysfi let b:caw_oneline_comment = "%"
  autocmd FileType satysfi let b:match_words = '<%:>%'
  autocmd FileType satysfi setlocal matchpairs-=<:>
  autocmd FileType satysfi setlocal foldmethod=indent
  autocmd FileType satysfi setlocal foldnestmax=4
  autocmd FileType satysfi setlocal foldminlines=5
augroup END

" }}}

" reST {{{

function! s:reSTTitle(punc)
  let line = getline('.')
  sil! exe row 'foldopen!'
  call append('.', repeat(a:punc, strdisplaywidth(line)))
endfunction
augroup vimrc
  autocmd FileType rst setlocal suffixesadd+=.rst
  autocmd FileType rst nnoremap <buffer> <Space>s0 :call <SID>reSTTitle("#")<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s1 :call <SID>reSTTitle("=")<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s2 :call <SID>reSTTitle("-")<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s3 :call <SID>reSTTitle("~")<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s4 :call <SID>reSTTitle('"')<CR>jo<Esc>
  autocmd FileType rst nnoremap <buffer> <Space>s5 :call <SID>reSTTitle("'")<CR>jo<Esc>
augroup END

" }}}

" HTML/XML {{{
augroup vimrc
  autocmd FileType xml inoremap <buffer> </ </<C-x><C-o>
  autocmd FileType html inoremap <buffer> </ </<C-x><C-o>
augroup END
" }}}

" }}}

" misc {{{

" fish {{{
augroup vimrc
  autocmd BufRead,BufNewFile *.fish setlocal filetype=fish
augroup END
" }}}

" tmux conf {{{

augroup vimrc
  autocmd FileType tmux  nnoremap <buffer> <CR>s :!tmux source ~/.tmux.conf<CR>
augroup END

" }}}

" ToDo6 {{{

augroup vimrc
  autocmd BufRead,BufNewFile .todo6,*.td6 setlocal filetype=todo6
  autocmd FileType todo6 setlocal noexpandtab
  autocmd FileType todo6 setlocal shiftwidth=4
  autocmd FileType todo6 setlocal tabstop=4
  autocmd FileType todo6 setlocal foldmethod=indent
augroup END

" }}}

" Scrapbox {{{
augroup vimrc
  autocmd FileType scrapbox setlocal tabstop=1
  autocmd FileType scrapbox setlocal shiftwidth=1
augroup END
" }}}

" binary {{{
" もっといい方法がありそう
" augroup vimrc
"   autocmd BufReadPre  *.bin let &bin=1
"   autocmd BufReadPost *.bin if &bin | %!xxd
"   autocmd BufReadPost *.bin set ft=xxd | endif
"   autocmd BufWritePre *.bin if &bin | %!xxd -r
"   autocmd BufWritePre *.bin endif
"   autocmd BufWritePost *.bin if &bin | %!xxd
"   autocmd BufWritePost *.bin set nomod | endif
" augroup END
" }}}
" }}}


" }}}



" }}}
