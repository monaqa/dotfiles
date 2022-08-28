setlocal path+=/usr/local/share/satysfi/dist/packages,$HOME/.satysfi/dist/packages,$HOME/.satysfi/local/packages
setlocal shiftwidth=2
setlocal suffixesadd+=.saty,.satyh,.satyg
" iskeyword で +,-,\,@ を単語に含める
setlocal iskeyword+=43,45,92,@-@
" setlocal matchpairs-=<:>
setlocal foldmethod=indent
setlocal foldnestmax=4
setlocal foldminlines=5

" setlocal indentkeys+=0=and,0=constraint,0=else,0=end,0=if,0=in,0=let,0=let-block,0=let-inline,0=let-math,0=let-mutable,0=let-rec,0=then,0=type,0=val,0=with,0=\|>,0\|,0},0],0=]>,0),0=\|),0<>>,0*,0=**,0=***,0=****,0=*****,0=******,0=*******

setlocal indentkeys+=0*,0=**,0=***,0=****,0=*****,0=******,0=*******,0=in,0=let,0=then,0=else

let b:caw_oneline_comment = "%"
let b:match_words = '<%:>%'
