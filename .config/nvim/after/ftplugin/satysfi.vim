augroup vimrc
  autocmd FileType satysfi setlocal path+=/usr/local/share/satysfi/dist/packages,$HOME/.satysfi/dist/packages,$HOME/.satysfi/local/packages
  autocmd FileType satysfi setlocal shiftwidth=2
  autocmd FileType satysfi setlocal suffixesadd+=.saty,.satyh,.satyg
  autocmd FileType satysfi " iskeyword で +,\,@ の3文字を単語に含める
  autocmd FileType satysfi setlocal iskeyword+=43,92,@-@
  autocmd FileType satysfi let b:caw_oneline_comment = "%"
  autocmd FileType satysfi let b:match_words = '<%:>%'
  autocmd FileType satysfi setlocal matchpairs-=<:>
  autocmd FileType satysfi setlocal foldmethod=indent
  autocmd FileType satysfi setlocal foldnestmax=4
  autocmd FileType satysfi setlocal foldminlines=5
augroup END
