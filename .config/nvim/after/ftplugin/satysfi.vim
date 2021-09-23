if exists('b:loaded_ftplugin_satysfi')
  finish
endif

let b:loaded_ftplugin_satysfi = 1

setlocal path+=/usr/local/share/satysfi/dist/packages,$HOME/.satysfi/dist/packages,$HOME/.satysfi/local/packages
setlocal shiftwidth=2
setlocal suffixesadd+=.saty,.satyh,.satyg
" iskeyword で +,\,@ の3文字を単語に含める
setlocal iskeyword+=43,92,@-@
setlocal matchpairs-=<:>
setlocal foldmethod=indent
setlocal foldnestmax=4
setlocal foldminlines=5

let b:caw_oneline_comment = "%"
let b:match_words = '<%:>%'
