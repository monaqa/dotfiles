" YAML 形式の frontmatter があるときはそのシンタックスハイライトを有効にする
let g:vim_markdown_frontmatter = 1

setlocal shiftwidth=2
setlocal spell
setlocal foldexpr=MarkdownLevel(v:lnum)
setlocal foldmethod=expr

setlocal suffixesadd+=.md

" マークダウンのタイトルのパターンにマッチしたらそのタイトルの深さを返す。
" マッチしなかったら -1 を返す。
function! s:markdown_title_pattern(text)
  let mch = matchlist(a:text, '\v^(#{1,6}) ')
  if mch[0] !=# ''
    return strlen(mch[1])
  endif
  return -1
endfunction

function! MarkdownLevel(lnum)
  let initial_depth = s:markdown_title_pattern(getline(1))
  if initial_depth < 0
    let initial_depth = 0
  endif

  let syntax_name = synIDattr(synIDtrans(synID(a:lnum, 1, 0)), "name")
  if syntax_name =~# 'Comment\|String'
    return "="
  endif

  let lnum_depth = s:markdown_title_pattern(getline(a:lnum))
  if lnum_depth < 0
    " タイトル行でなかったら問答無用で前の行の継続
    return "="
  endif

  " タイトル行なら initial_depth のオフセットを
  " 差し引いたものを見出しレベルとする
  return ">" .. max([0, lnum_depth - initial_depth])
endfunction

" 行頭にて - ] と打つと Checkbox list となる
inoreabbrev <buffer><expr> ] (getline('.') ==# '- ]') ? '[ ]' : ']'

" 選択テキストをハイパーリンク化
vnoremap L "lc[<C-r>=substitute(getreg("l"), '\n', '', 'g')<CR>](<C-r>+)<Esc>
