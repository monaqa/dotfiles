"treesitter vim:fdm=marker:fmr=§§,■■
" キーマッピング関連。
" そのキーマップが適切に動くようにするための関数や autocmd もここに載せる。

" §§1 changing display

" Z を signcolumn/foldcolumn の toggle に使う
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap <silent><nowait> Z <Cmd>call <SID>toggle_column()<CR>
function! s:toggle_column() abort
  if &signcolumn ==# 'yes:2' && &foldcolumn == 0
    setlocal foldcolumn=4
    setlocal signcolumn=no
  else
    setlocal foldcolumn=0
    setlocal signcolumn=yes:2
  endif
endfunction

nnoremap <silent> zz zz<Cmd>call <SID>temporal_attention()<CR>
function! s:temporal_attention() abort
  setlocal cursorline
  setlocal cursorcolumn
  augroup temporal_attention
    autocmd!
    autocmd CursorMoved * ++once setlocal nocursorline
    autocmd CursorMoved * ++once setlocal nocursorcolumn
  augroup END
endfunction
function! s:temporal_relnum() abort
  setlocal relativenumber
  augroup temporal_relnum
    autocmd!
    autocmd CursorMoved * ++once setlocal norelativenumber
  augroup END
endfunction

function s:expr_temporal_attention()
  call s:temporal_attention()
  call s:temporal_relnum()
  return ""
endfunction

nnoremap <expr> + <SID>expr_temporal_attention()
onoremap <expr> + <SID>expr_temporal_attention()
vnoremap <expr> + <SID>expr_temporal_attention()

" §§1 fold
" nnoremap <Space>z zMzv
" 自分のいない level が 1 の fold だけたたむ
nnoremap <Space>z zMzA
nnoremap <Space>z zx


" §§1 search
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" 検索 with temporal attention
nnoremap <silent><expr> n 'Nn'[v:searchforward] .. '<Cmd>call <SID>temporal_attention()<CR>'
nnoremap <silent><expr> N 'nN'[v:searchforward] .. '<Cmd>call <SID>temporal_attention()<CR>'

" VISUAL モードから簡単に検索
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap * "my/\V<C-R><C-R>=substitute(
\escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>N
vnoremap R "my:set hlsearch<CR>
\:,$s//<C-R><C-R>=escape(@m, '/\&~')<CR>
\/gce<Bar>1,''-&&<CR>

" modal search
" nnoremap <expr> <leader> <SID>modal_search()
" cnoremap <expr> <C-x> s:modal_search_is_active ? s:modal_search_toggle_mode() : "<C-x>"
" 
" let s:modal_search_is_active = v:false
" let s:modal_search_mode = 'rawstr'
" 
" augroup vimrc
"   autocmd CmdlineLeave * call <SID>free_modal_highlight()
"   autocmd CmdlineChanged @ if s:modal_search_is_active
"   autocmd CmdlineChanged @   call <SID>free_modal_highlight()
"   autocmd CmdlineChanged @   call <SID>modal_highlight()
"   autocmd CmdlineChanged @ endif
" augroup END
" 
" function! s:modal_search()
"   let s:modal_search_is_active = v:true
"   let text = s:modal_search_prompt()
"   if text ==# ''
"     return "/\<CR>"
"   endif
"   let s:modal_search_is_active = v:false
"   if s:modal_search_mode ==# 'regexp'
"     return '/\v' .. escape(text, '/') .. "\<CR>"
"   else
"     return '/\V' .. escape(text, '/\') .. "\<CR>"
"   endif
" endfunction
" 
" function! s:modal_search_prompt()
"   let current_modal_search = s:modal_search_mode
"   let text = input({'prompt': '[' .. s:modal_search_mode .. ']/', 'cancelreturn': ''})
"   " 中で s:modal_search_mode が変わったらもう一度 prompt を出す
"   while s:modal_search_mode !=# current_modal_search
"     let current_modal_search = s:modal_search_mode
"     let text = input({'prompt': '[' .. s:modal_search_mode .. ']/', 'cancelreturn': '', 'default': text})
"   endwhile
"   return text
" endfunction
" 
" function! s:modal_search_toggle_mode()
"   let s:modal_search_mode = s:modal_search_mode ==# 'rawstr' ? 'regexp' : 'rawstr'
"   return "\<CR>"
" endfunction
" 
" function! s:modal_highlight()
"   let cmdline = getcmdline()
"   if cmdline ==# ''
"     echom "None"
"     return
"   endif
"   if s:modal_search_mode ==# 'regexp'
"     let regex = '\v' .. escape(cmdline, '/')
"   else
"     let regex = '\V' .. escape(cmdline, '/\')
"   endif
"   let w:modal_match_id = matchadd('IncSearch', regex)
"   redraw
" endfunction
" 
" function! s:free_modal_highlight()
"   if exists("w:modal_match_id")
"     call matchdelete(w:modal_match_id)
"     unlet w:modal_match_id
"   endif
" endfunction

" §§2 QuickFix search

nnoremap <expr> g/ ":\<C-u>silent grep " .. input('g/') .. ' %'
nnoremap gj <Cmd>cnext<CR>
nnoremap gk <Cmd>cprevious<CR>

" https://qiita.com/lighttiger2505/items/166a4705f852e8d7cd0d
" Toggle QuickFix
function! s:toggle_quickfix()
  let l:nr = winnr('$')
  cwindow
  let l:nr2 = winnr('$')
  if l:nr == l:nr2
    cclose
  endif
endfunction
nnoremap <script><silent> q :call <SID>toggle_quickfix()<CR>

" §§1 terminal

tnoremap <C-]> <C-\><C-n>

augroup vimrc
  autocmd TermOpen * call s:terminal_init()
  autocmd TermOpen * setlocal wrap
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal signcolumn=no
  autocmd TermOpen * setlocal foldcolumn=0
augroup END
function! s:terminal_init()
  " ここに :terminal のバッファ固有の設定を記述する
  nnoremap <buffer> <CR> i<CR><C-\><C-n>
  nnoremap <expr><buffer> u "i" . repeat("<Up>", v:count1) . "<C-\><C-n>"
  nnoremap <expr><buffer> <C-r> "i" . repeat("<Down>", v:count1) . "<C-\><C-n>"
  nnoremap <buffer> sw :<C-u>bd!<CR>
  nnoremap <buffer> t :<C-u>let g:current_terminal_job_id = b:terminal_job_id<CR>
  nnoremap <buffer> dd i<C-u><C-\><C-n>
  nnoremap <buffer> A i<C-e>
  nnoremap <buffer><expr> I "i\<C-a>" . repeat("\<Right>", <SID>calc_cursor_right_num())
  nnoremap <buffer> p pi
  nnoremap <buffer> <C-]> <Nop>
endfunction
function! s:calc_cursor_right_num() abort
  " ad hoc!
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
  " edit term://fish
  terminal fish
  let g:current_terminal_job_id = b:terminal_job_id
endfunction

" §§2 send string to terminal buffer
nnoremap <Space>t <Cmd>set opfunc=<SID>op_send_terminal<CR>g@
nnoremap <nowait> <Space>tt <Cmd>set opfunc=<SID>op_send_terminal<CR>g@_
vnoremap <Space>t <Cmd>set opfunc=<SID>op_send_terminal<CR>g@

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
" normal/visual mode の t を潰したため omap のみ
onoremap tj t<C-k>j
onoremap Tj T<C-k>j

function s:register_digraph(key_pair, char)
  execute('digraphs ' .. a:key_pair .. ' ' .. char2nr(a:char) )
endfunction

" これを設定することで， fjj を本来の fj と同じ効果にできる．
call s:register_digraph('jj', 'j')

" カッコ
call s:register_digraph('j(', '（')
call s:register_digraph('j)', '）')
call s:register_digraph('j[', '「')
call s:register_digraph('j]', '」')
call s:register_digraph('j{', '『')
call s:register_digraph('j}', '』')
call s:register_digraph('j<', '【')
call s:register_digraph('j>', '】')

" 句読点
call s:register_digraph('j,', '、')
call s:register_digraph('j.', '。')
call s:register_digraph('j!', '！')
call s:register_digraph('j?', '？')
call s:register_digraph('j:', '：')

" その他の記号
call s:register_digraph('j~', '〜')
call s:register_digraph('j/', '・')
call s:register_digraph('js',  '␣')

" §§1 window/buffer
" https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
nnoremap s <Nop>
" バッファ作成と削除
nnoremap s_ :<C-u>sp<CR>
nnoremap s<Bar> :<C-u>vs<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap <silent><expr> ss <SID>isWideWindow('.') ? ':<C-u>vs<CR>' : ':<C-u>sp<CR>'
nnoremap sq :<C-u>q<CR>
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
" nnoremap sN gt
" nnoremap sP gT
nnoremap sQ :<C-u>tabc<CR>
" Command-line window
nnoremap s: q:G
nnoremap s? q?G
nnoremap s/ q/G

nnoremap - <C-^>

" Sandwich.vim のデフォルトキーバインドを上書きする
nnoremap <nowait> srb <Nop>

function! s:isWideWindow(nr)
  let wd = winwidth(a:nr)
  let ht = winheight(a:nr)
  return wd > 2.2 * ht
endfunction

" §§1 operator / put
" D や C との一貫性
nnoremap Y y$

" どうせ空行1行なんて put するようなもんじゃないし、空行で上書きされるの嫌よね
nnoremap <expr> dd (v:count1 == 1 && v:register == '"' && getline('.') == "") ? '"_dd' : 'dd'

" よく使うレジスタは挿入モードでも挿入しやすく
inoremap <C-r><C-r> <C-g>u<C-r>"
inoremap <C-r><CR> <C-g>u<C-r>0
inoremap <C-r><Space> <C-g>u<C-r>+
cnoremap <C-r><C-r> <C-r>"
cnoremap <C-r><CR> <C-r>0
cnoremap <C-r><Space> <C-r>+

nnoremap <Space>p <Cmd>put +<CR>
nnoremap <Space>P <Cmd>put! +<CR>
vnoremap <Space>p <Cmd>call <SID>visual_replace('+')<CR>

vnoremap p <Cmd>call <SID>visual_replace(v:register)<CR>

" 選択箇所を指定レジスタの内容で置き換える。ただし、指定レジスタの中身はそのまま。
" デフォルトの p と同じ挙動を望む場合は `P` を用いる。
function! s:visual_replace(register)
  let reg_body = getreg(a:register)
  exe 'normal! "' .. a:register .. 'p'
  call setreg(a:register, reg_body)
endfunction

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
nnoremap <Space>h <Cmd>call <SID>smart_home()<CR>
xnoremap <Space>h <Cmd>call <SID>smart_home()<CR>
onoremap <Space>h ^
function! s:smart_home()
  let str_before_cursor = strpart(getline('.'), 0, col('.') - 1)
  " カーソル前がインデントしかないかどうかでコマンドを変える
  if str_before_cursor =~ '^\s*$'
    let move_cmd = '0'
  else
    let move_cmd = '^'
  endif

  let col_before = col(".")
  " まずは表示行の範囲で行頭移動
  exe 'normal! g' .. move_cmd
  " 移動前後でカーソル位置が変わらなかったら再度やり直す
  let col_after = col(".")
  if col_before == col_after
    exe 'normal! ' .. move_cmd
  endif
endfunction

" かしこい End
nnoremap <Space>l <Cmd>call <SID>smart_end()<CR>
xnoremap <Space>l $h
onoremap <Space>l $
function! s:smart_end()
  let col_before = col(".")
  " まずは表示行の範囲で行末移動
  normal! g$
  let col_after = col(".")
  " 移動前後でカーソル位置が変わらなかったら再度やり直す
  if col_before == col_after
    normal! $
  endif
endfunction

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
let g:par_motion_continuous = v:false
augroup vimrc
  autocmd CursorMoved * let g:par_motion_continuous = v:false
augroup END
function! s:smart_par_motion(direction, count)
  execute ((g:par_motion_continuous ? 'keepjumps ' : '') .. 'normal! ' .. a:count .. (a:direction ? '}' : '{'))
endfunction
noremap <C-j> <Cmd>call <SID>smart_par_motion(v:true, v:count1)<CR><Cmd>let g:par_motion_continuous = v:true<CR>
noremap <C-k> <Cmd>call <SID>smart_par_motion(v:false, v:count1)<CR><Cmd>let g:par_motion_continuous = v:true<CR>

" Command mode mapping
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>

" §§1 macros

" マクロの記録レジスタは "aq のような一般のレジスタを指定するのと同様の
" インターフェースで変更するようにし、デフォルトの記録レジスタを q とする。

" マクロの自己再帰呼出しによるループや、マクロの中でマクロを呼び出すことは簡単にはできないようにしている。
" （もちろんレジスタを直接書き換えれば可能）
" デフォルトのレジスタ @q は Vim の開始ごとに初期化される。

" マクロの記録を開始する。もし既に記録中であれば記録を停止する。
nnoremap <expr> Q     reg_recording() ==# '' ? <SID>keymap_start_macro(v:register) : 'q'
" マクロを再生する。もし何らかの記録の途中であれば、その記録をキャンセル（今まで書いたものを破棄）する。
nnoremap <expr> <C-q> reg_recording() ==# '' ? <SID>keymap_play_macro(v:register) : <SID>keymap_cancel_macro(reg_recording())
" デフォルトの再生用キーマップは無効化（local なコマンドの prefix に使うため）
nnoremap @ <Nop>
nnoremap @: @:

let g:last_played_macro_register = 'q'

" マクロの記録を開始する。
function! s:keymap_start_macro(register)
  " 無名レジスタには格納できないようにする & デフォルトを q にする
  let _register = a:register
  if a:register ==# '"'
    let _register = 'q'
  endif
  return 'q' .. _register
endfunction

function! s:keymap_play_macro(register)
  " 無名レジスタには格納できないようにする
  " & デフォルトを前回再生したマクロにする
  let _register = a:register
  if a:register ==# '"'
    let _register = g:last_played_macro_register
  endif
  let g:last_played_macro_register = _register
  if getreg(_register) ==# ''
    echohl ErrorMsg
    echo 'Register @' .. _register .. ' is empty.'
    echohl None
    return ''
  endif
  echohl WarningMsg
  echo 'Playing macro: @' .. _register
  echohl None
  return '@' .. _register
endfunction

" 記録を中止
function! s:keymap_cancel_macro(register)
  " 現在のレジスタに入っているコマンド列を一旦 reg_content に退避
  let cmd = ":\<C-u>let reg_content = @" .. a:register .. "\<CR>"
  " マクロの記録を停止
  let cmd .= 'q'
  " 対象としていたレジスタの中身を先程退避したものに入れ替える
  let cmd .= ":\<C-u>let @" .. a:register .. " = reg_content\<CR>"
  " キャンセルした旨を表示
  let cmd .= ":echo 'Recording Cancelled: @" .. a:register .. "'\<CR>"
  return cmd
endfunction

" §§2 dot repeat のハック
" dot repeat の実現が難しいコマンドのために、 '.' をハックする。
" let g:dot_repeat_register = ''
" nmap <expr> . g:dot_repeat_register ==# '' ? '.' : g:dot_repeat_register
" augroup vimrc
"   autocmd TextChanged * let g:dot_repeat_register = ""
" augroup END

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

" 終了・保存
nnoremap <Space>w <Cmd>update<CR>

" 改行だけを入力する dot-repeatable なマッピング
nnoremap <expr> <Space>o peridot#repeatable_function("\<SID>append_new_lines", [0])
nnoremap <expr> <Space>O peridot#repeatable_function("\<SID>append_new_lines", [-1])

function! s:append_new_lines(ctx, offset_line)
  let curpos = line(".")
  let pos_line = curpos + a:offset_line
  let n_lines = a:ctx['set_count'] ? a:ctx['count'] : 1
  let lines = repeat([""], n_lines)
  call append(pos_line, lines)
endfunction

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
nnoremap <Space><CR> a<CR><Esc>

nnoremap <Space>a :<C-u>call <SID>increment_char(v:count1)<CR>
nnoremap <Space>x :<C-u>call <SID>increment_char(-v:count1)<CR>

" 文字コードのインクリメント
function! s:increment_char(count)
  normal! v"my
  let char = @m
  let num = char2nr(char)
  let @m = nr2char(num + a:count)
  normal! gv"mp
endfunction

" 選択した数値を任意の関数で変換する．
" たとえば 300pt の 300 を選択して <Space>s とし，
" x -> x * 3/2 と指定すれば 450pt になる．
" 計算式は g:monaqa_lambda_func に格納されるので <Space>r で使い回せる．
" 小数のインクリメントや css での長さ調整等に便利？マクロと組み合わせてもいい．
" 中で eval を用いているので悪用厳禁．基本的に数値にのみ用いるようにする
" vnoremap <Space>s :<C-u>call <SID>applyLambdaToSelectedArea()<CR>
" vnoremap <Space>r :<C-u>call <SID>repeatLambdaToSelectedArea()<CR>

let s:monaqa_lambda_func = 'x'

let g:apply_lambda_num_expr = '\d\+\(\.\d\+\)\?'

nnoremap <expr> <Space>s peridot#repeatable_function("<SID>apply_lambda")

function s:apply_lambda(ctx) abort
  let line = getline(".")
  let match = matchstrpos(line, g:apply_lambda_num_expr)
  if match[1] == -1
    return
  endif
  let text = match[0]
  let start = match[1]
  let end = match[2]

  let lambda_func = s:monaqa_lambda_func
  if !a:ctx['repeated']
    let lambda_func = input({
    \   'prompt': 'Lambda: x (= ' .. text .. ') -> ',
    \   'default': s:monaqa_lambda_func,
    \   'cancelreturn': ''
    \ })
  endif
  if lambda_func ==# ''
    return
  endif
  let s:monaqa_lambda_func = lambda_func
  let lambda_expr = '{ x -> ' . s:monaqa_lambda_func . ' }'
  let Lambda = eval(lambda_expr)
  let retval = string(Lambda(eval(text)))
  call setline(".", line[:start - 1] .. retval .. line[end:])
endfunction

" 便利なので連打しやすいマップにしてみる
nnoremap <C-h> g;
nnoremap <C-g> g,

vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

" 2020-11-12 に思いついた便利なアイデア。
" vnoremap <expr> <Bar> "/\\%" .. virtcol(".") .. "v"

" gF は gf の上位互換？
nnoremap gf gF

" <C-v>x, <C-v>u, <C-v>U を統一して分かりやすくした。
" See |i_CTRL-V_digit|
noremap! <C-v>u <C-r>=nr2char(0x)<Left>

" https://github.com/ompugao/vim-bundle/blob/074e7b22320ad4bfba4da5516e53b498ace35a89/vimrc
vnoremap <expr> I  mode() ==# 'V' ? "\<C-v>0o$I" : "I"
vnoremap <expr> A  mode() ==# 'V' ? "\<C-v>0o$A" : "A"

" アイデアはいいんだけど使う場面もないので保留
" cnoremap <expr> <Esc> getcmdline()[:4] ==# "'<,'>" ? "<C-c>gv" : "<C-c>"
