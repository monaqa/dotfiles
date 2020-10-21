" vim:fdm=marker:fmr=§§,■■

" §§1 

" §§1 Vim script
let g:vim_indent_cont = 0

augroup vimrc
  autocmd FileType vim call <SID>autocmd_filetype_vim()
augroup END
function! s:autocmd_filetype_vim()
  setlocal shiftwidth=2
  nnoremap <buffer> K K
  setlocal keywordprg=:help
endfunction

" augroup vimrc
"   autocmd FileType netrw call NetrwMapping()
" augroup END
" 
" function! NetrwMapping()
"   noremap <buffer> i h
"   noremap <buffer> s <Nop>
" endfunction
" " https://www.tomcky.net/entry/2018/03/18/005927
" " 上部に表示される情報を非表示
" let g:netrw_banner = 0
" " 表示形式をTreeViewに変更
" let g:netrw_liststyle = 3
" " 左右分割を右側に開く
" let g:netrw_altv = 1
" " 分割で開いたときに85%のサイズで開く
" let g:netrw_winsize = 85

" §§1 Programming Language

" §§2 Rust
let g:rust_fold = 2
augroup vimrc
  autocmd FileType rust setlocal foldlevel=1
augroup END

" §§2 Python
augroup vimrc
  autocmd FileType python setlocal nosmartindent
augroup END

" §§2 Julia
augroup vimrc
  autocmd FileType julia setlocal shiftwidth=4
  " autocmd FileType julia setlocal path+=/Applications/Julia-1.1.app/Contents/Resources/julia/share/julia/base
augroup END

" §§1 Markup Language

" §§2 SATySFi
augroup vimrc
  autocmd BufRead,BufNewFile *.satyg setlocal filetype=satysfi
  autocmd BufRead,BufNewFile Satyristes setlocal filetype=lisp
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>o :!open %:r.pdf<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>q :!satysfi %<CR>
  autocmd BufRead,BufNewFile *.saty nnoremap <buffer> <CR>Q :!satysfi --debug-show-bbox --debug-show-space --debug-show-block-bbox --debug-show-block-space %<CR>
  autocmd FileType satysfi setlocal path+=/usr/local/share/satysfi/dist/packages,$HOME/.satysfi/dist/packages,$HOME/.satysfi/local/packages
  autocmd FileType satysfi setlocal shiftwidth=2
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

" §§2 TeX/LaTeX
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '@line @pdf @tex'

let g:tex_flavor = 'latex'
augroup vimrc
  autocmd FileType tex setlocal shiftwidth=2
augroup END

" §§2 reStructuredText
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
  autocmd FileType rst setlocal shiftwidth=2
augroup END

" §§2 markdown
augroup vimrc
  autocmd FileType markdown setlocal shiftwidth=2
  autocmd FileType markdown setlocal spell
augroup END

" §§2 HTML/XML
augroup vimrc
  autocmd FileType xml,html inoremap <buffer> </ </<C-x><C-o>
  autocmd FileType xml,html setlocal shiftwidth=2
augroup END

" §§1 shell

" §§2 fish
augroup vimrc
  autocmd BufRead,BufNewFile *.fish setlocal filetype=fish
augroup END

" §§1 conf

" §§2 tmux conf
augroup vimrc
  autocmd FileType tmux  nnoremap <buffer> <CR>s :!tmux source ~/.tmux.conf<CR>
augroup END

" §§1 misc

" §§2 todo6
augroup vimrc
  autocmd BufRead,BufNewFile .todo6,*.td6 setlocal filetype=todo6
  autocmd FileType todo6 setlocal noexpandtab
  autocmd FileType todo6 setlocal shiftwidth=4
  autocmd FileType todo6 setlocal tabstop=4
  autocmd FileType todo6 setlocal foldmethod=indent
augroup END


" §§2 scrapbox
augroup vimrc
  autocmd FileType scrapbox setlocal tabstop=1
  autocmd FileType scrapbox setlocal shiftwidth=1
augroup END
