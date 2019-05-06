########
dotfiles
########

dotfiles に fish や vim の設定を置いているものの，
ごちゃごちゃしてきて自分でも何を設定したか忘れそうになっている現状を踏まえ，
可能な限りここに設定内容をまとめることとする．

フォルダ構成
============

以下のようなフォルダ構成になっている．

- .config

  - fish/config.fish

  - nvim/init.nvim

  - vim/init.vim

- .vim/

- .gvimrc

- .vimrc

- hydrogen.vim

- install-fish.sh

- install.sh



vim の設定
==========

vim の設定を記載しているファイルは複数存在しており複雑であるが，
基本的には以下の原則に則って記載する場所を決めている．

- vim と nvim に共通する設定：init.vim

- 常に最初に読み込まれる plugin に付随する設定：dein.toml

- 条件付きで読み込まれる plugin に付随する設定：dein_lazy.toml

- neovim のみで用いる plugin に付随する設定：nvim_dein_lazy.toml

- vim で plugin を読み込むために書く設定：.vimrc

- nvim で plugin を読み込むために書く設定：init.nvim

このリストは編集する頻度が高い順に並んでいる．
基本的に，プラグインに関係しない設定を書きたければ init.vim に書けば良いだろう．


init.vim での設定
-----------------

.. highlight:: vim

設定ファイルを書くにあたり，いくつか参考にした記事がある．

- https://qiita.com/morikooooo/items/9fd41bcd8d1ce9170301
- https://qiita.com/iwaseasahi/items/0b2da68269397906c14c
- https://qiita.com/itmammoth/items/312246b4b7688875d023

エディタ全般の設定
~~~~~~~~~~~~~~~~~~


Syntax, mouse などの有効化
""""""""""""""""""""""""""

まずは最も基本的といえるエディタの設定から．
syntax highlight をオンにし，マウスによる操作を有効にする::

  syntax on
  set mouse=a

（`persistent_todo` が有効の場合）
ファイルを閉じても undo を遡って行えるようにする::

  if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
  endif


タブ文字/不可視文字/インデントの設定
""""""""""""""""""""""""""""""""""""

タブ文字と行末のスペースが見えるようにする::

  set list
  set listchars=tab:\▸\-,trail:･

`<Tab>` を押したときにスペースに変換されるようにする::

  set expandtab
  set tabstop=2
  set shiftwidth=2

長い行を折り返して表示する際にインデントを考慮する::

  set breakindent


Theme/colorscheme/表示設定
~~~~~~~~~~~~~~~~~~~~~~~~~~


表示設定
""""""""

行数表示は基本だろう::

  set number

カーソル位置のハイライトをデンマークの国旗のような感じにする::

  set cursorline
  set cursorcolumn

80文字目に印をつけておく::

  set colorcolumn=80

行末の1文字先までカーソルを移動したい::

  set virtualedit=onemore

エラー時のベルは鳴らさない．ここの設定はあまり理解してない::

  set visualbell
  set noerrorbells

ステータスラインを常に表示する．vim-airline を入れているから関係ないかも？::

  set laststatus=2

だいたい常に10行分の余裕をもたせて画面スクロールを行う::

  set scrolloff=10

全角文字幅は2文字分として表示する::

  set ambiwidth=double

現在入力中のコマンドが見えるようにする::

  set showcmd

各ファイルに書かれている（vim に対する）マジックコメントを3行ぶん読み込む::

  set modeline
  set modelines=3

とりあえずこれを指定しておけば早くなるとかならないとか::

  set lazyredraw
  set ttyfast


全角スペース強調
""""""""""""""""

`こちらの記事 <https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776>`_ に
書かれていることをほぼそのまま用いている．
ただし，ぼくは vim で全角空白を能動的に使ったことが片手で数えられるほどしかないので
全角空白は基本意図せぬものと考え，Error 扱いしている::

  augroup MyVimrc
      autocmd!
  augroup END

  augroup MyVimrc
      autocmd ColorScheme * highlight link UnicodeSpaces Error
      autocmd VimEnter,WinEnter * match UnicodeSpaces /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/
  augroup END


Theme
"""""

colorscheme は，個人的に最も気に入っている
`gruvbox <https://github.com/morhetz/gruvbox>`_ を用いる
（iTerm2 の colorscheme にも採用）．
ただし，自分のターミナル環境が少々特殊である故に生じた
一部の見づらさを解消するため，多少テーマに手を入れている．

まずは gruvbox を colorscheme に指定し，
contrast を高めに，background を dark に設定する::

  colorscheme gruvbox
  let g:gruvbox_contrast_dark = 'hard'
  set background=dark

続いて，いくつかの文字を見やすくする::

  let g:gruvbox_vert_split = 'fg0'
  hi! link SpecialKey GruvboxBg4
  hi! link NonText GruvboxPurple
  hi! MatchParen ctermbg=0
  hi! ColorColumn ctermbg=238
  hi! CursorColumn ctermbg=236
  hi! CursorLine ctermbg=236
  hi! link Folded GruvboxPurpleBold


エディタの機能に関する設定
~~~~~~~~~~~~~~~~~~~~~~~~~~

backup ファイルや swapfile は作らない::

  set nobackup
  set noswapfile

編集中のファイルの変更を自動で読めるようにし，
バッファが編集中でも他のファイルを開けるようにする::

  set autoread
  set hidden

スペルチェック時の言語を指定する::

  set spelllang=en,cjk

矩形選択時に文字がなくても選択可能にする::

  set virtualedit=block

backspace がいろいろ消せるようにする::

  set backspace=indent,eol,start

変更履歴を10000件保存する::

  set history=10000


検索機能
""""""""

多分調べれば色々出てくるので詳しい説明は割愛::

  set ignorecase
  set smartcase
  set incsearch
  set wrapscan
  set hlsearch

`<C-l>` による再描画時に同時に nohlsearch を行う::

  nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>


VISUAL モードから簡単に検索や置換を行えるようにする便利コマンド．
SublimeText などで標準のマルチカーソル機能に
類似した機能を標準で提供するために定義した．
`このページ <http://vim.wikia.com/wiki/Search_for_visually_selected_text>`_
にあるコマンドをほぼ踏襲しているが，一部変更している．::

  vnoremap <CR> "my/\V<C-R><C-R>=substitute(
    \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>N
  vnoremap <S-CR> "sy:set hlsearch<CR>/\V<C-R><C-R>=substitute(
    \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \:,$s/\V<C-R><C-R>=substitute(
    \escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR>
    \/<C-R><C-R>=escape(@s, '/\&~')<CR>
    \/gce<Bar>1,''-&&<CR>

使い方は以下の通り．

- VISUAL モードで <CR> を押すと，選択部分を検索する．
  このときの検索条件に正規表現で用いられる記号が入っていても，
  原則そのままの記号として扱われる．
  ただし，空白と改行だけは同一視される．

- VISUAL モードでとある範囲（Aとする）を選択して <CR> を押し，
  検索をかけた後に別の範囲（Bとする）を選択して <S-CR> を押すと，
  範囲 A に該当する箇所を範囲 B に置き換える．
  一箇所ごとに置換するかどうかを決定できる
  （c オプション付きの :s コマンドを用いているだけ）．

さらに，`f<CR>` としたときに「任意のアルファベットの大文字」に飛べるようにした::

   noremap <silent> f<CR> :<C-u>call MgmNumSearchLine('[A-Z]', v:count1, '')<CR>
   noremap <silent> F✠ :<C-u>call MgmNumSearchLine('[A-Z]', v:count1, 'b')<CR>

   function! MgmNumSearchLine(ptn, num, opt)
     for i in range(a:num)
       call search(a:ptn, a:opt, line("."))
     endfor
   endfunction

- `f<CR>` とすると，現在行において，現在のカーソル位置の次のアルファベット大文字に飛ぶ．

- 頭文字に数字を付けても有効．
  たとえば `3f<CR>` とすると，現在のカーソル位置から数えて3番目のアルファベット大文字に飛ぶ．

- `F<S-CR>` とすると，現在行において，現在のカーソル位置の前のアルファベット大文字に飛ぶ．
  Shift キーを押しながら `f` と `<CR>` を押せば良い．

- このコマンドは camelCase なポリシーに則った変数名において，その一部を書き換えるときに役立つ．


日本語に関する設定
~~~~~~~~~~~~~~~~~~

Vim の数少ない欠点として，日本語の扱いづらさがある．
そもそも normal モードという概念が日本語キー入力に相容れないだけでなく，
多くのモーションが日本語文書で意味をなさなくなるのが非常に辛い．
プラグインで解決する問題もそれなりにあるが，それは別ファイルに記載し，
ここでは標準で提供される機能を用いて解決されるものに触れる．

まずは日本語のカッコを対応可能にする::

  set matchpairs+=「:」,（:）,【:】,『:』

続いて，全角カンマ・読点と全角ピリオド・句点を f 移動の対象にする．
ただし以下の実装は ad hoc なところがあり，
カンマやピリオドで f 移動する際に`;`や`,`が使えなくなることに注意．

::

  noremap <silent> f, :<C-u>call MgmNumSearchLine('[，、,]', v:count1, '' )<CR>
  noremap <silent> f. :<C-u>call MgmNumSearchLine('[．。.]', v:count1, '' )<CR>
  noremap <silent> F, :<C-u>call MgmNumSearchLine('[，、,]', v:count1, 'b')<CR>
  noremap <silent> F. :<C-u>call MgmNumSearchLine('[．。.]', v:count1, 'b')<CR>

後述する「長い文章の改行」キーマップと組み合わせれば，
カンマやピリオドの直後に改行を挟むことが簡単にできるようになるので，
改行が無視される類のマークアップ言語（LaTeX など）では非常に重宝される．
また，こちらも頭に数字をつけることができ，おそらく想像通りの効果となる．

Window/buffer の設定
~~~~~~~~~~~~~~~~~~~~

`このページ <https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca>`_
にある記事を大いに参考にした．
標準のキーマップ `s` を潰しているので注意::

  nnoremap s <Nop>
  " バッファ作成と削除
  nnoremap ss :<C-u>sp<CR>
  nnoremap sv :<C-u>vs<CR>
  nnoremap sn :<C-u>bn<CR>
  nnoremap sp :<C-u>bp<CR>
  nnoremap sq :<C-u>bp<CR>:bd #<CR>
  nnoremap sw :<C-u>q<CR>
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
  nnoremap so <C-w>_<C-w>|
  nnoremap sO <C-w>=
  " タブページ
  nnoremap st :<C-u>tabnew<CR>
  nnoremap sN gt
  nnoremap sP gT

submode プラグインを用いて window サイズを楽に変える．
本来は submode プラグインの hook として記述すべきであるものの，
カスタムキーマップの意味合いが強いのでこちらに書いている．

::

  call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
  call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
  call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
  call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
  call submode#map('bufmove', 'n', '', '>', '<C-w>>')
  call submode#map('bufmove', 'n', '', '<', '<C-w><')
  call submode#map('bufmove', 'n', '', '+', '<C-w>+')
  call submode#map('bufmove', 'n', '', '-', '<C-w>-')

新規の window を開く際に，カーソルの居場所が右 or 下にあるようにする::

  set splitbelow
  set splitright

cdy コマンドに関する設定
~~~~~~~~~~~~~~~~~~~~~~~~

change&delete&yank 系のコマンドに関する設定．

まずは D や C との一貫性を保つための処置として
標準の Y の定義を置き換える．詳細は ``:help Y`` 参照．

::

  map Y y$

x による一文字削除の結果を用いることが殆ど無いのでバッファに入れないようにする::

  nnoremap x "_x

システムの clipboard を`+`レジスタや`*`レジスタに用いる．
しかし，クリップボードレジスタと無名レジスタは区別する
（`unnamed` オプションは付けない）．
vim 外のコンテンツからコピーしてから vim 内に yank するまでに
一度でも vim 内で change/delete の操作を挟むと，
コピーしたコンテンツが消えてしまうのが不便に感じたため．
そのかわり，システムのクリップボードを用いる場合は
`<Space>y` で yank，
`<Space>p` で paste を行うことにする::

  set clipboard=
  noremap <Space>y "+y
  noremap <Space>p "+p

NORMAL モードにおける `R` は，通常なら REPLACE モードに入るキーマップである．
しかし REPLACE モードはめったに使わないので，
「後に指定する text object の範囲を削除し，指定したレジスタのものに置き換える」
という動作を行う::

   nmap <silent> R :<C-u>let w:replace_buffer = v:register <Bar> set opfunc=MgmReplace<CR>g@
   nmap <silent> RR :<C-u>let w:replace_buffer = v:register <Bar> call MgmReplaceALine(v:count1)<CR>

   function MgmReplace(type)
     let sel_save = &selection
     let &selection = "inclusive"
     " let m_reg = @m
     exe "let @m = @" . w:replace_buffer

     if a:type == 'line'
       exe "normal! '[V']d"
     else
       exe "normal! `[v`]d"
     endif

     exe "normal! " . '"' . "mP"

     let &selection = sel_save
     " let @m=m_reg
   endfunction

   function MgmReplaceALine(nline)
     let sel_save = &selection
     let &selection = "inclusive"
     " let m_reg = @m
     exe "let @m = @" . w:replace_buffer

     exe "normal! " . a:nline . "dd"
     exe "normal! " . '"' . "mP"

     let &selection = sel_save
     " let @m=m_reg
   endfunction

具体例を出してより正確に述べると， ``"aRiw`` という文字列は

#. 1単語 (inner word) を削除
#. `a` レジスタの中身をペースト
#. 最初に削除された中身は無名レジスタ (`"`) から参照可能

という一連の操作を一度にやってくれる．
単に ``Riw`` とすると，そのコマンド実行前に無名レジスタに格納されていた値がペーストされ，
無名レジスタの中身は削除された1単語に置き換えられる（実装を見るのが早いかもしれない）．

また， ``"aRR`` という文字列は

#. 一行削除
#. `a` レジスタの中身をペースト
#. 最初に削除された中身は ``"`` レジスタから参照可能

という一連の操作を行う． ``3RR`` のように前に数字を指定すれば，
複数行を消して特定の文字列に置き換えることも可能．

その他の特殊キーマップ
~~~~~~~~~~~~~~~~~~~~~~


vimrc 関連
""""""""""

`<Space>v` で vimrc の設定内容を即座に反映できるようにする．
ただし，一度閉じて開き直したほうが確実ではある．

::

  nnoremap <Space>v :<C-u>source $MYVIMRC<CR>

移動系キーマップ
""""""""""""""""

j と gj などの動作を入れ替える::

  nnoremap j gj
  nnoremap k gk
  nnoremap gj j
  nnoremap gk k

INSERT モード時も hjkl で移動できるようにする::

  inoremap <C-h> <Left>
  inoremap <C-j> <Down>
  inoremap <C-k> <Up>
  inoremap <C-l> <Right>

ただし，上記のやり方で移動を行っているとたまに`<C-Space>` を押してしまう．
どうも Mac の環境では？これを押すと `<C-@>` を押したことになってしまうらしい．
変なモノが入力されてしまって困るので苦肉の策で `<C-@>` を潰す::

  imap <C-Space> <Space>

押しにくい上段のキーマップを再定義する::

  noremap <Space>h ^
  noremap <Space>l $
  noremap <Space>m %


縦方向 f 移動
"""""""""""""

行頭文字を検索してそこに移動する．
f移動の手軽さを志して定義されたオリジナルコマンド．
`ここ <https://qiita.com/mogashira/items/9764e957523ad0b56aec>`_
に拙いながら解説がある．

::

  command! -nargs=1 MgmLineSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m)
  command! -nargs=1 MgmVisualLineSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 's') | normal v`'o
  command! MgmLineSameSearch call search('^\s*\V'. @m)
  command! -nargs=1 MgmLineBackSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 'b')
  command! -nargs=1 MgmVisualLineBackSearch let @m=escape(<q-args>, '/\') | call search('^\s*\V'. @m, 'bs') | normal v`'o
  command! MgmLineBackSameSearch call search('^\s*\V'. @m, 'b')
  nnoremap <Space>f :MgmLineSearch<Space>
  nnoremap <Space>F :MgmLineBackSearch<Space>
  onoremap <Space>f :MgmLineSearch<Space>
  onoremap <Space>F :MgmLineBackSearch<Space>
  vnoremap <Space>f :<C-u>MgmVisualLineSearch<Space>
  vnoremap <Space>F :<C-u>MgmVisualLineBackSearch<Space>

  call submode#enter_with('vertjmp', 'n', '', '<Space>;', ':MgmLineSameSearch<CR>')
  call submode#enter_with('vertjmp', 'n', '', '<Space>,', ':MgmLineBackSameSearch<CR>')
  call submode#map('vertjmp', 'n', '', ';', ':MgmLineSameSearch<CR>')
  call submode#map('vertjmp', 'n', '', ',', ':MgmLineBackSameSearch<CR>')
  call submode#leave_with('vertjmp', 'n', '', '<Space>')

行の操作/空行追加
"""""""""""""""""

Space と矢印キーで特定行を上下に移動できるようにする．
そこまで使用頻度は高くない上に，何行も移動させる場合は yank&paste すればよいので
このようなキーマッピングとしている::

  nnoremap <Space><Up> "zdd<Up>"zP
  nnoremap <Space><Down> "zdd"zp
  vnoremap <Space><Up> "zx<Up>"zP`[V`]
  vnoremap <Space><Down> "zx"zp`[V`]

上または下の行に空行を追加する．
いちいち INSERT モードに入らなくても空行の追加ができるので便利．

::

  inoremap <S-CR> <End><CR>
  inoremap <C-S-CR> <Up><End><CR>
  nnoremap <S-CR> mzo<ESC>`z
  nnoremap <C-S-CR> mzO<ESC>`z
  if !has('gui_running')
    " CUIで入力された<S-CR>,<C-S-CR>が拾えないので
    " iTerm2のキー設定を利用して特定の文字入力をmapする
    " Map ✠ (U+2720) to <Esc> as <S-CR> is mapped to ✠ in iTerm2.
    map ✠ <S-CR>
    imap ✠ <S-CR>
    map ✢ <C-S-CR>
    imap ✢ <C-S-CR>
  endif

長い文を改行するときに NORMAL モードから楽に行う．
改行位置は，カーソルキーのある位置の直後であることに注意::

  nnoremap <silent> <Space><CR> a<CR><Esc>

特定の種類のファイルに対する設定
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

LaTeX
"""""

`plaintex` などの形式で開かない::

  let g:tex_flavor = 'latex'

``\\alpha`` などの制御綴を一単語として扱う．
ただし，``\\alpha\\beta`` なども一つとして扱われることに注意．

::

  autocmd Filetype tex set iskeyword+=92

AsciiDoc
""""""""

AsciiDoc で作成された文書をプレビューする．
ブラウザには Vivaldi を指定している．このあたりはお好みで::

  command! MgmViewAdoc :!python make.py;asciidoctor %;open -a Vivaldi %:r.html<CR>

vim Plugin に関する設定
-----------------------

上で述べたとおり，
dein.toml, dein_lazy.toml, nvim_dein_lazy.toml の3箇所に
TOML 形式で記述している．

dein.toml での設定
~~~~~~~~~~~~~~~~~~

vim-airline
"""""""""""

UI をリッチにするプラグイン．
リポジトリへのリンクは `こちら <https://github.com/vim-airline/vim-airline>`_::

  [[plugins]]
  repo = 'vim-airline/vim-airline'
  depends = ['vim-airline-themes']
  hook_add = """
  let g:airline_theme = 'sol'
  let g:airline#extensions#tabline#enabled = 1
  """

  [[plugins]]
  repo = 'vim-airline/vim-airline-themes'

テーマは `sol` を用いている．
gruvbox のテーマもあるが，個人的な好みから外れたので違うものを利用した．
また，常に tab が表示されるようにしている．

comfortable-motion
""""""""""""""""""

小気味良い画面スクロールを実現する．
リポジトリへのリンクは `こちら <https://github.com/yuttie/comfortable-motion.vim>`_::

  [[plugins]]
  repo = 'yuttie/comfortable-motion.vim'
  hook_add = """
  let g:comfortable_motion_scroll_down_key = "j"
  let g:comfortable_motion_scroll_up_key = "k"
  let g:comfortable_motion_friction =  200.0
  let g:comfortable_motion_air_drag = 1.8
  let g:comfortable_motion_no_default_key_mappings = 1
  let g:comfortable_motion_impulse_multiplier = 1  " Feel free to increase/decrease this value.
  nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
  nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
  nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
  nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>
  """

gruvbox
"""""""

上でも述べたとおり．お気に入りの colorsheme．
リポジトリへのリンクは `こちら <https://github.com/morhetz/gruvbox>`_::

  [[plugins]]
  repo = 'morhetz/gruvbox'

submode
"""""""

特定のキーマップで遷移できるサブモードをユーザー定義できるプラグイン．便利．
リポジトリへのリンクは `こちら <https://github.com/kana/vim-submode>`_::

  [[plugins]]
  repo = 'kana/vim-submode'

defx
""""

カレントディレクトリのフォルダ構造を表示するためのプラグイン．
リポジトリへのリンクは `こちら <https://github.com/Shougo/defx.nvim>`_::

  [[plugins]]
  repo = 'Shougo/defx.nvim'
  depends = ['kristijanhusak/defx-git']
  hook_add = """
  nnoremap <silent> <Space>z :Defx
    \ -columns=git:mark:filename
    \ -toggle -split=vertical -winwidth=30 -direction=topleft<CR>
  nnoremap <silent> <Space><S-z> :Defx
    \ -columns=git:mark:filename:size:time
    \ -toggle -split=horizontal -winheight=20 -direction=botright<CR>
  autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort
    " Define mappings
    " nnoremap <silent><buffer><expr> <CR> defx#do_action('open')
    nnoremap <silent><buffer><expr> <CR> defx#do_action('drop')
    nnoremap <silent><buffer><expr> c
    \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
    \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
    \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
    \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> t
    \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> E
    \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
    \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> K
    \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
    \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
    \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C
    \ defx#do_action('toggle_columns',
    \                'mark:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
    \ defx#do_action('toggle_sort', 'time')
    " nnoremap <silent><buffer><expr> d
    " \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
    \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
    \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
    \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
    \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
    \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
    \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
    \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
    \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
    \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
    \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
    \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
    \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
    \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
    \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
    \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
    \ defx#do_action('change_vim_cwd')
  endfunction
  call defx#custom#column('mark', {
        \ 'readonly_icon': '✗',
        \ 'selected_icon': '✓',
        \ })
  call defx#custom#column('filename',{
        \ 'indent': '| ',
        \ })
  """

  [[plugins]]
  repo = 'kristijanhusak/defx-git'

  [[plugins]]
  repo = 'kristijanhusak/defx-icons'

hook_add がとても長い．ほとんどキーマップを定義している．
逆に言えば，キーマップは自分のお気に召すままにほぼ自由自在に設定可能．
最近 (2019/03) 待望のツリー構造が実装されたので早速追加している．
とりあえず，自分は

- <Space>z で簡易なツリーを左側に表示
- <Space>Z で詳細のツリーを下側に表示

としている．
また，git の状態が一緒に把握できるプラグインと，
ファイルタイプに応じたアイコンを表示できるプラグインを同時に追加している．

caw.vim
"""""""

text object を指定してコメントアウトができるようになるプラグイン．
リポジトリへのリンクは `こちら <https://github.com/tyru/caw.vim>`_::

  [[plugins]]
  repo = 'tyru/caw.vim'
  hook_add = """
  let g:caw_operator_keymappings = 1
  map <Space>c gcc
  nmap <Space>cc gcc$
  """

operator と text object の概念に惚れて vim を選んだ身としては，
コメントアウトは是非とも text object 単位でできるようにしたい．
caw.vim は ``g:caw_operator_keymappings`` を1にするだけでそれを実現してくれる，
とても有り難いプラグインである．
前は NERDCommenter を用いていたが，
text-object 単位でのコメントアウト方法がわからなかったためこちらに移行．
コメントアウトは多用するのでより簡単なキーにマップ．
また，上のカスタム例では ``10<Space>cc`` と打てば
現在のカーソルから数えて 10 行ぶんコメントアウトしてくれる．
特定の数行だけコメントアウトしたいときは，
わざわざテキストオブジェクトを探すより行数指定したいこともある．
そういう場合に便利である．

surround
""""""""

「囲み文字追加・変更・削除」系 operator を追加するプラグイン．
リポジトリへのリンクは
`こちら <https://github.com/tpope/vim-surround>`_ と
`こちら <https://github.com/rhysd/vim-operator-surround>`_::

  [[plugins]]
  repo = 'tpope/vim-surround'
  # char2nr 関数を使えば文字に対応する数字を知ることができる
  hook_add = """
  nmap sa ys
  vmap sa S
  let g:surround_{char2nr("P")} = "（\r）"
  let g:surround_{char2nr("B")} = "「\r」"
  let g:surround_{char2nr("D")} = "『\r』"
  let g:surround_{char2nr("m")} = "{{{\r}}}"
  " 例えば saiwB とすることで \{word\} などとできる
  autocmd FileType tex let b:surround_{char2nr("B")} = "\\\\{\r\\\\}"
  """

  [[plugins]]
  repo = 'rhysd/vim-operator-surround'
  depends = ['kana/vim-operator-user']
  hook_add = """
  nmap dsP <Plug>(operator-surround-delete)aP
  nmap dsB <Plug>(operator-surround-delete)aB
  nmap dsD <Plug>(operator-surround-delete)aD
  nmap csP <Plug>(operator-surround-replace)aP
  nmap csB <Plug>(operator-surround-replace)aB
  nmap csD <Plug>(operator-surround-replace)aD
  let g:operator#surround#blocks = {}
  let g:operator#surround#blocks['-'] = [
      \   { 'block' : ['（', '）'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['P'] },
      \   { 'block' : ['「', '」'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['B'] },
      \   { 'block' : ['『', '』'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['D'] },
      \ ]
  """

  [[plugins]]
  repo = 'kana/vim-operator-user'

surround operator を追加するプラグインとして最も有名なのは vim-surround だと思う．
一方で，vim-operator-surround という
（vim-surround と互換性のない）プラグインも存在する．
現在はその両方を用いているため，キーマップがきわめてややこしくなっている．
基本的には operator + text object の使い方をする．

- 特定の text object にカッコを追加する： ``sa`` (surround add と読む)
- 特定のカッコを変更する： ``cs`` （change the surround of ... と読む）
- 特定のカッコを削除する： ``ds`` （delete the surround of ... と読む）

要は，基本 vim-surround のキーマップを用いるが，
yank と紛らわしい ys だけは sa に変えたという感じ．

vim-operator-surround は，日本語の括弧の変更・削除を行うためだけに入れている．
vim-surround でも日本語の括弧の「追加」を行うことはできるものの，
変更と削除となると難しいらしい．

vim-textobj-user
""""""""""""""""

ユーザー指定で text object を作成できる超強力プラグイン．
リポジトリへのリンクは `こちら <https://github.com/kana/vim-textobj-user>`_::

  [[plugins]]
  repo = 'kana/vim-textobj-user'
  hook_add = """
  call textobj#user#plugin('line', {
  \   '-': {
  \     'select-a-function': 'CurrentLineA',
  \     'select-a': 'al',
  \     'select-i-function': 'CurrentLineI',
  \     'select-i': 'il',
  \   },
  \ })

  function! CurrentLineA()
    normal! 0
    let head_pos = getpos('.')
    normal! $
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
  endfunction

  function! CurrentLineI()
    normal! ^
    let head_pos = getpos('.')
    normal! g_
    let tail_pos = getpos('.')
    let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
    return
    \ non_blank_char_exists_p
    \ ? ['v', head_pos, tail_pos]
    \ : 0
  endfunction

  call textobj#user#plugin('jbraces', {
      \   'parens': {
      \       'pattern': ['（', '）'],
      \       'select-a': 'aP', 'select-i': 'iP'
      \  },
      \   'braces': {
      \       'pattern': ['「', '」'],
      \       'select-a': 'aB', 'select-i': 'iB'
      \  },
      \  'double-braces': {
      \       'pattern': ['『', '』'],
      \       'select-a': 'aD', 'select-i': 'iD'
      \  },
      \})
  """

vim-textobj-python の依存プラグインにもなっているからどのみち入れる必要があるが，
ここでは追加で特定行を表す text object と
日本語のカッコで囲まれた箇所を表す text object を追加している．

signature
"""""""""

マークを付けたときに横につけたマークが表示されるようになる．
リポジトリへのリンクは `こちら <https://github.com/kshenoy/vim-signature>`_::

  [[plugins]]
  repo = 'kshenoy/vim-signature'
  hook_add = """
  let g:SignatureIncludeMarks = 'abcdefghijklmnopqrstuvwxyABCDEFGHIJKLMNOPQRSTUVWXYZ'
  """

小文字の z はカスタムで別の操作をするときに用いるので使わないようにしている．

FastFold
""""""""

fold 関連の操作が速くなるらしい．詳しくは知らない．
リポジトリへのリンクは `こちら <https://github.com/Konfekt/FastFold>`_::

  [[plugins]]
  repo = 'Konfekt/FastFold'

denite
""""""

特定のファイル/バッファを開く，grepするなどの操作を便利に行うプラグイン．
リポジトリへのリンクは `こちら <https://github.com/Shougo/denite.nvim>`_::

  [[plugins]]
  repo = 'Shougo/denite.nvim'
  hook_add = """

様々なことを設定しているので，
ここからは一つ一つの設定を詳しく見ていく．
``<Space>b`` (buffer) でバッファリストをノーマルモードで開く::

  nnoremap <Space>b :Denite buffer -mode="normal" -sorters=sorter/word<CR>

``<Space>r`` (register) でレジスタのリストを開く（これあまり使ってない）::

  nnoremap <Space>r :Denite register<CR>

``<Space>g`` (grep) で現在のカレントディレクトリで grep して検索結果を開く::

  nnoremap <Space>g :Denite grep -buffer-name=search-buffer-denite<CR>

``<Space>t`` (todo) で TODO と書かれている部分を拾う（使ってない）::

  nnoremap <Space>t :Denite grep -input=TODO: -mode="normal"<CR>

``<Space>G`` (Grep) で前回 grep 検索した結果を再度開く（検索結果は更新されない）::

  nnoremap <Space>G :Denite -resume -buffer-name=search-buffer-denite<CR>

``<Space>]`` で次の検索結果に移動::

  nnoremap <Space>] :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=+1 -immediately<CR>

``<Space>[`` で前の検索結果に移動::

  nnoremap <Space>[ :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=-1 -immediately<CR>

``<Space>o`` (open) でファイルを開く::

  nnoremap <Space>o :Denite file_rec<CR>

``<Space><Space>`` で任意の Denite 操作を待機（使ってない）::

  nnoremap <Space><Space> :Denite<Space>

特定の拡張子やファイルを無視するようにする::

  call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
        \ [ '.git/', '.ropeproject/', '__pycache__/',
        \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/',
        \   '*.aux', '*.bbl', '*.blg', '*.dvi', '*.fdb_latexmk', '*.fls', '*.synctex.gz', '*.toc',
        \   '*.out', '*.snm', '*.nav',
        \   '*.pdf', '*.eps', '*.svg',
        \   '*.png',
        \   'searchindex.js',
        \   '*.ipynb',
        \   ])

grep や file 検索時にファイル名を使って検索できるようにする::

  call denite#custom#source('grep',
    \ 'matchers', ['converter/abbr_word', 'matcher_fuzzy', 'matcher/ignore_globs'],
    \ )
  call denite#custom#source('file_rec',
    \ 'matchers', ['matcher_fuzzy', 'matcher/ignore_globs'])
  """

現在は特に ``<Space>b`` と ``<Space>o`` をよく使っている．
バッファが多いときや，defx でのファイル探しが面倒なときに重宝する．

session
"""""""


vim を閉じるときに画面を保存し，再度開く時復元してくれるプラグイン．
リポジトリへのリンクは `こちら <https://github.com/xolox/vim-session>`_::

  [[plugins]]
  repo = 'xolox/vim-session'
  depends = ['xolox/vim-misc']
  hook_add = """
  let s:local_session_directory = xolox#misc#path#merge(getcwd(), '.vimsessions')
  " 存在すれば
  if isdirectory(s:local_session_directory)
    " session保存ディレクトリをそのディレクトリの設定
    let g:session_directory = s:local_session_directory
    " vimを辞める時に自動保存
    let g:session_autosave = 'yes'
    " 引数なしでvimを起動した時にsession保存ディレクトリのdefault.vimを開く
    let g:session_autoload = 'yes'
    " 1分間に1回自動保存
    " let g:session_autosave_periodic = 1
  else
    let g:session_autosave = 'no'
    let g:session_autoload = 'no'
  endif
  unlet s:local_session_directory
  """

  [[plugins]]
  repo = 'xolox/vim-misc'

設定は `こちらのサイト <https://www.g104robo.com/entry/vim-session>`_
に基づいて書かれているようだ（忘れた）．
とにかく便利で，セッションを保存する方法は
「.vimsessions というディレクトリを作成する」だけ．
.vimsessions が作成されていると，そのディレクトリがある場所で vim を起動したとき
自動的に .vimsessions の中身を読み込んでロードしてくれる．
また，vim を quit するとき自動的に現在のセッションを保存してくれる．
さらに，特定のファイルを開く時（``vim hogehoge.tex`` のような）は
セッションがロードもセーブもされないので，一時的な操作にはそれを用いればよい．

satysfi
"""""""

`SATySFi <https://github.com/gfngfn/SATySFi>`_
の syntax highlight を実現するプラグイン．
リポジトリへのリンクは `こちら <https://github.com/qnighy/satysfi.vim>`_::

  [[plugins]]
  repo = 'qnighy/satysfi.vim'

本当は遅延読み込みを行うべきだが，
それは自分がもう少し SATySFi を理解してから行う．


dein_lazy.toml での設定
~~~~~~~~~~~~~~~~~~~~~~~

dein-ui
"""""""

dein.vim で管理しているプラグインのアップデートが簡単になる．
リポジトリへのリンクは `こちら <https://github.com/wsdjeg/dein-ui.vim>`_::

  [[plugins]]
  repo = 'wsdjeg/dein-ui.vim'
  on_cmd = ["DeinUpdate"]

vimtex
""""""

vim で TeX をやるときの必須級プラグイン．
リポジトリへのリンクは `こちら <https://github.com/lervag/vimtex>`_::

  [[plugins]]
  repo = 'lervag/vimtex'

特に何もオプションを付けていないものの，機能は強力である．
``ie`` や ``a$`` といった text object は明らかに LaTeX において多用されうるし，




リポジトリへのリンクは `こちら <https://github.com/>`_::

以下，工事中

