" vim:fdm=marker:fmr=§§,■■

" §§1 表示関連

nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap <silent><nowait> Z :call <SID>toggle_column()<CR>
function! s:toggle_column() abort
  if &signcolumn ==# 'yes:2' && &foldcolumn == 0
    setlocal foldcolumn=4
    setlocal signcolumn=no
  else
    setlocal foldcolumn=0
    setlocal signcolumn=yes:2
  endif
endfunction

nnoremap <silent><nowait> <Space><Space> :call <SID>temporal_attention()<CR>:call <SID>temporal_relnum()<CR>
function! s:temporal_attention() abort
    set cursorline
    set cursorcolumn
    augroup temporal_attention
        autocmd!
        autocmd CursorMoved * ++once set nocursorline
        autocmd CursorMoved * ++once set nocursorcolumn
    augroup END
endfunction
function! s:temporal_relnum() abort
    set relativenumber
    augroup temporal_relnum
        autocmd!
        autocmd CursorMoved * ++once set norelativenumber
    augroup END
endfunction

" 検索系は見失いやすいので
nnoremap <silent> n n:call <SID>temporal_attention()<CR>
nnoremap <silent> N N:call <SID>temporal_attention()<CR>

" §§1 fold
nnoremap <Space>z zMzv


" §§1 search
nnoremap g/ /\v
nnoremap * *N
nnoremap g* g*N
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" VISUAL モードから簡単に検索
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap * "my/\V<C-R><C-R>=substitute(
\escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>N
vnoremap S "my:set hlsearch<CR>
\:,$s//<C-R><C-R>=escape(@m, '/\&~')<CR>
\/gce<Bar>1,''-&&<CR>

" §§1 terminal

tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap <C-r><C-r> <C-\><C-N>""pi
tnoremap <C-r><CR> <C-\><C-N>"0pi
tnoremap <C-r><Space> <C-\><C-N>"+pi
" 苦肉の策
tnoremap <C-r><Esc> <C-r>

augroup vimrc
  autocmd FileType fzf tnoremap <buffer><nowait> <Esc> <C-g>
augroup END

augroup vimrc
  autocmd TermOpen * call s:terminal_init()
  autocmd TermOpen * setlocal wrap
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal signcolumn=no
  autocmd TermOpen * setlocal foldcolumn=0
augroup END
function! s:terminal_init()
  " ここに :terminal のバッファ固有の設定を記述する
  " nnoremap <buffer> a i<Up><CR><C-\><C-n>
  nnoremap <buffer> <CR> i<CR><C-\><C-n>
  nnoremap <expr><buffer> u "i" . repeat("<Up>", v:count1) . "<C-\><C-n>"
  nnoremap <expr><buffer> <C-r> "i" . repeat("<Down>", v:count1) . "<C-\><C-n>"
  nnoremap <buffer> sw :<C-u>bd!<CR>
  nnoremap <buffer> t :<C-u>let g:current_terminal_job_id = b:terminal_job_id<CR>
  nnoremap <buffer> dd i<C-u><C-\><C-n>
  " nnoremap <buffer> I i<C-a>
  nnoremap <buffer> A i<C-e>
  nnoremap <buffer><expr> I "i\<C-a>" . repeat("\<Right>", <SID>calc_cursor_right_num())
endfunction
function! s:calc_cursor_right_num() abort
  " ad hoc!
  " normal "my0
  " let strlen = strchars(@m)
  let cpos = getcurpos()
  return cpos[2] - 5
endfunction

nnoremap <silent> st :<C-u>call <SID>openTermWindow()<CR>

function! s:openTermWindow() abort
  if (bufname('term://') ==# '')
    call s:openTerminal()
  elseif (s:isWideWindow('.'))
    vsplit
    buffer term://
  else
    split
    buffer term://
  endif
endfunction

function! s:openTerminal()
  let ft = &filetype
  if (s:isWideWindow('.'))
    vsplit
  else
    split
  endif
  edit term://fish
  if (ft ==# 'python')
    call chansend(b:terminal_job_id, "ipython -c '%autoindent' -i\n")
  endif
  let g:current_terminal_job_id = b:terminal_job_id
endfunction

" §§2 send string to terminal buffer
nnoremap <CR>t :<C-u>set opfunc=<SID>op_send_terminal<CR>g@
nnoremap <CR>tp :<C-u>set opfunc=<SID>op_send_terminal<CR>g@ap
nnoremap <nowait> <CR>tt :<C-u>call <SID>send_terminal_line(v:count1)<CR>
vnoremap <CR>t <Esc>:<C-u>call <SID>send_terminal_visual_range()<CR>

function! s:op_send_terminal(type)
  let sel_save = &selection
  let &selection = "inclusive"
  let m_reg = @m

  if a:type == 'line'
    let visual_range = "'[V']"
  else
    let visual_range = '`[v`]'
  endif
  exe "normal! " . visual_range . '"my'
  call chansend(g:current_terminal_job_id, s:reformat_cmdstring(@m))

  let &selection = sel_save
  let @m=m_reg
endfunction

function! s:send_terminal_line(n_line)
  let sel_save = &selection
  let &selection = "inclusive"
  let m_reg = @m

  exe "normal! " . '"m' . a:n_line . 'yy'
  call chansend(g:current_terminal_job_id, s:reformat_cmdstring(@m))

  let &selection = sel_save
  let @m=m_reg
endfunction

function! s:send_terminal_visual_range()
  let sel_save = &selection
  let &selection = "inclusive"
  let m_reg = @m

  exe "normal! gv" . '"my'
  call chansend(g:current_terminal_job_id, s:reformat_cmdstring(@m))

  let &selection = sel_save
  let @m=m_reg
endfunction

function! s:reformat_cmdstring(str)
  " 空行の削除
  let s = substitute(a:str, '\n\n', '\n', 'g')
  " （なければ）最後に改行を付ける
  if s !~# '\n$'
    let s = s .. "\n"
  endif
  return s
endfunction

" §§1 input Japanese character
" ちょっと j くんには悪いけど，fj は予約したほうが便利．
" これで「fj.」 と押せば全角ピリオドを検索できる
noremap fj f<C-k>j
noremap Fj F<C-k>j
noremap tj t<C-k>j
noremap Tj T<C-k>j
noremap fk f<C-k>k
noremap Fk F<C-k>k
noremap tk t<C-k>k
noremap Tk T<C-k>k

" これを設定することで， fjj を本来の fj と同じ効果にできる．
digraphs jj 106  " j
digraphs kk 107  " k

" 記号追加時のヒント：追加したい記号の上で ga と押せば...
" カッコ
digraphs j( 65288  " （
digraphs j) 65289  " ）
digraphs j[ 12300  " 「
digraphs j] 12301  " 」
digraphs j{ 12302  " 『
digraphs j} 12303  " 』
digraphs j< 12304  " 【
digraphs j> 12305  " 】

" 句読点
digraphs j, 12289  " 、
digraphs j. 12290  " 。
digraphs k, 65292  " ，
digraphs k. 65294  " ．
digraphs j! 65281  " ！
digraphs j? 65311  " ？
digraphs j: 65306  " ：

" その他の記号
digraphs j~ 12316  " 〜
digraphs j/ 12539  " ・
digraphs js  9251  " ␣

" §§1 window/buffer
" https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
nnoremap s <Nop>
" バッファ作成と削除
nnoremap s_ :<C-u>sp<CR>
nnoremap s<Bar> :<C-u>vs<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap <silent><expr> ss <SID>isWideWindow('.') ? ':<C-u>vs<CR>' : ':<C-u>sp<CR>'
nnoremap sq :<C-u>q<CR>
nnoremap <expr> sw &buftype ==# '' ? ":\<C-u>bp\<CR>:\<C-u>bd #\<CR>" : ":bd\<CR>"
" nnoremap s<Space> :<C-u>execute "buffer" v:count<CR>
" バッファ間移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
" バッファの移動（位置関係変更）
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
" 各ウィンドウの大きさ変更
" submode も参照
nnoremap s= <C-w>=
" タブページ
nnoremap <silent> sT :<C-u>tabnew %<CR>
nnoremap sN gt
nnoremap sP gT
nnoremap sQ :<C-u>tabc<CR>
" Command-line window
nnoremap s: q:G
nnoremap s? q?G
nnoremap s/ q/G

" Sandwich.vim のデフォルトキーバインドを上書きする
nnoremap <nowait> srb <Nop>

function! s:isWideWindow(nr)
  let wd = winwidth(a:nr)
  let ht = winheight(a:nr)
  if (wd > 2.2 * ht)
    return 1
  else
    return 0
  endif
endfunction

" §§1 operator
" D や C との一貫性
nnoremap Y y$

" x の結果はバッファに入れない．dx でも同様に扱う
" いや，別にバッファに入れてもいい気がしてきた．一旦コメントアウトしておこう
" nnoremap x "_x
" nnoremap X "_X
nnoremap dx "_d
nnoremap cx "_c

" よく使うレジスタは挿入モードでも挿入しやすく
inoremap <C-r><C-r> <C-g>u<C-r>"
inoremap <C-r><CR> <C-g>u<C-r>0
inoremap <C-r><Space> <C-g>u<C-r>+
cnoremap <C-r><C-r> <C-r>"
cnoremap <C-r><CR> <C-r>0
cnoremap <C-r><Space> <C-r>+

" set clipboard+=unnamed
" noremap <Space>y "+y
noremap <Space>p "+p
noremap <Space>P "+P
noremap <CR>p :<C-u>put +<CR>
noremap <CR>P :<C-u>put! +<CR>
noremap <Space>y "+y

" VISUAL mode での置換にはデフォルトでヤンクレジスタを使う
" （無名レジスタが汚れても連続して同じ文字列を貼り付けることができる）
" もし無名レジスタを使いたい場合は P を使う
vnoremap p "0p

" §§2 operator-like <C-y> in insert mode
" a<Bs> を最初に入れるのは，直後の <Esc> 時に
" インデントが消えてしまわないようにするため（もっといい方法がありそう）
inoremap <expr> <C-y> "a<Bs>\<Esc>k" . (getcurpos()[2] == 1 ? '' : 'l') . ":set opfunc=<SID>control_y\<CR>g@"
inoremap <expr> <C-e> "a<Bs>\<Esc>j" . (getcurpos()[2] == 1 ? '' : 'l') . ":set opfunc=<SID>control_e\<CR>g@"
inoremap <expr> <C-y><C-y> "a<Bs>\<Esc>k" . (getcurpos()[2] == 1 ? '' : 'l') . ":set opfunc=<SID>control_y\<CR>g@$"
inoremap <expr> <C-e><C-e> "a<Bs>\<Esc>j" . (getcurpos()[2] == 1 ? '' : 'l') . ":set opfunc=<SID>control_e\<CR>g@$"

function! s:control_y(type)
  " 設定，レジスタの保存
  let sel_save = &selection
  let m_reg = @m

  let &selection = "inclusive"
  normal! `[v`]"my

  if getpos(".")[2] > len(getline(line(".") + 1))
    " 今いるところが次の行の末端よりも長いかどうか．
    " 行末だったら p（末尾に append）
    normal! j"mp
    startinsert!
  else
    " それ以外は P（途中から insert）
    normal! j"mPl
    startinsert
  endif

  " 設定，レジスタの復元
  let &selection = sel_save
  let @m=m_reg
endfunction

function! s:control_e(type)
  let sel_save = &selection
  let m_reg = @m

  let &selection = "inclusive"
  normal! `[v`]"my

  if getpos(".")[2] > len(getline(line(".") - 1))
    normal! k"mp
    startinsert!
  else
    normal! k"mPl
    startinsert
  endif

  let &selection = sel_save
  let @m=m_reg
endfunction

" §§1 motion/text object

" smart j/k
" thanks to tyru
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j (v:count == 0 && mode() ==# 'v') ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k (v:count == 0 && mode() ==# 'v') ? 'gk' : 'k'

inoremap <C-b> <C-g>U<Left>
inoremap <C-f> <C-g>U<Right>
" 上記移動を行っていると <C-Space> で <C-@> が動作してしまうのが不便．
" imap <Nul> <Nop>
" としてもうまくいかないので，苦肉の策で <C-@> を潰す
inoremap <C-Space> <Space>

" かしこい Home
" thanks to Shougo
noremap <expr> <Space>h <SID>smart_home()
function! s:smart_home()
  let str_before_cursor = strpart(getline('.'), 0, col('.') - 1)
  let wrap_prefix = &wrap ? 'g' : ''
  if str_before_cursor !~ '^\s*$'
    return wrap_prefix . '^ze'
  else
    return wrap_prefix . '0'
  endif
endfunction

" かしこい End
nnoremap <expr> <Space>l &wrap ? 'g$' : '$'
onoremap <expr> <Space>l &wrap ? 'g$' : '$'
xnoremap <expr> <Space>l visualmode() ==# "v" ? '$h' : '$'

inoremap <C-b> <C-g>U<Left>
inoremap <C-f> <C-g>U<Right>
" 上記移動を行っていると <C-Space> で <C-@> が動作してしまうのが不便．
" imap <Nul> <Nop>
" としてもうまくいかないので，苦肉の策で <C-@> を潰す
inoremap <C-Space> <Space>

" word-in-word motion
onoremap u t_
onoremap U :<C-u>call <SID>numSearchLine('[A-Z]', v:count1, '')<CR>

function! s:numSearchLine(ptn, num, opt)
  for i in range(a:num)
    call search(a:ptn, a:opt, line('.'))
  endfor
endfunction

" 整合性のとれた括弧に移動するための motion
noremap m) ])
noremap m} ]}

vnoremap m] i]o``
vnoremap m( i)``
vnoremap m{ i}``
vnoremap m[ i]``

nnoremap dm] vi]o``d
nnoremap dm( vi)``d
nnoremap dm{ vi}``d
nnoremap dm[ vi]``d

nnoremap cm] vi]o``c
nnoremap cm( vi)``c
nnoremap cm{ vi}``c
nnoremap cm[ vi]``c

" クオート系テキストオブジェクトを自分好みに
vnoremap a' 2i'
vnoremap a" 2i"
vnoremap a` 2i`
onoremap a' 2i'
onoremap a" 2i"
onoremap a` 2i`
vnoremap m' a'
vnoremap m" a"
vnoremap m` a`
onoremap m' a'
onoremap m" a"
onoremap m` a`

" Vertical WORD (vWORD) 単位での移動
nnoremap <silent> <C-j> :<C-u>exe "keepjumps normal! " . v:count1 . "}"<CR>
onoremap <C-j> }
vnoremap <C-j> }
nnoremap <silent> <C-k> :<C-u>exe "keepjumps normal! " . v:count1 . "{"<CR>
onoremap <C-k> {
vnoremap <C-k> {

" Vertical f-motion
command! -nargs=1 LineSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m)
command! -nargs=1 VisualLineSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 's') | normal v`'o
command! LineSameSearch call search('^\s*\V'. @m)
command! -nargs=1 LineBackSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 'b')
command! -nargs=1 VisualLineBackSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 'bs') | normal v`'o
command! LineBackSameSearch call search('^\s*\V'. @m, 'b')
nnoremap <Space>f :LineSearch<Space>
nnoremap <Space>F :LineBackSearch<Space>
onoremap <Space>f :LineSearch<Space>
onoremap <Space>F :LineBackSearch<Space>
vnoremap <Space>f :<C-u>VisualLineSearch<Space>
vnoremap <Space>F :<C-u>VisualLineBackSearch<Space>
nnoremap <Space>; :LineSameSearch<CR>
nnoremap <Space>, :LineBackSameSearch<CR>

" Command mode mapping
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>

" §§1 特殊キー
noremap <F1>   <Nop>
noremap <M-F1> <Nop>
noremap <F2>   <Nop>
noremap <F3>   <Nop>
noremap <F4>   <Nop>
noremap <F5>   <Nop>
noremap <F6>   <Nop>
noremap <F7>   <Nop>
noremap <F8>   <Nop>
noremap <F9>   <Nop>
noremap <F10>  <Nop>
noremap <F12>  <Nop>
noremap! <F1>   <Nop>
noremap! <M-F1> <Nop>

" prefix とするため
noremap <Space> <Nop>
noremap <CR> <Nop>


" §§1 その他操作

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

" マクロの活用
nnoremap q qq<Esc>
nnoremap Q q
nnoremap , @q
" JIS キーボードなので <S-;> が + と同じ
nnoremap + ,

nnoremap <Space>a :<C-u>call <SID>increment_char(v:count1)<CR>
nnoremap <Space>x :<C-u>call <SID>increment_char(-v:count1)<CR>

" 文字コードのインクリメント
function! s:increment_char(count)
  normal v"my
  let char = @m
  let num = char2nr(char)
  let @m = nr2char(num + a:count)
  normal gv"mp
endfunction

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

" 便利なので連打しやすいマップにしてみる
nnoremap <C-h> g;
nnoremap <C-g> g,

vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

" 2020-11-12 に思いついた便利なアイデア。
" vnoremap <expr> <Bar> "/\\%" .. virtcol(".") .. "v"
