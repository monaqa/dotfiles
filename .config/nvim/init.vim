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
