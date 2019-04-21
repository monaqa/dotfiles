##########
vim の設定
##########

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
=================

.. highlight:: vim

設定ファイルを書くにあたり，いくつか参考にした記事がある．

- https://qiita.com/morikooooo/items/9fd41bcd8d1ce9170301
- https://qiita.com/iwaseasahi/items/0b2da68269397906c14c
- https://qiita.com/itmammoth/items/312246b4b7688875d023


エディタ全般の設定
------------------


Syntax, mouse などの有効化
~~~~~~~~~~~~~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
--------

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
~~~~~~~~~~~~~~~~

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
~~~~~

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
~~~~~~~~

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


日本語に関する設定
------------------

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

  noremap <silent> f, :call search('[，、,]', '', line("."))<CR>
  noremap <silent> f. :call search('[．。.]', '', line("."))<CR>
  noremap <silent> F, :call search('[，、,]', 'b', line("."))<CR>
  noremap <silent> F. :call search('[．。.]', 'b', line("."))<CR>

後述する「長い文章の改行」キーマップと組み合わせれば，
カンマやピリオドの直後に改行を挟むことが簡単にできるようになるので，
改行が無視される類のマークアップ言語（LaTeX など）では非常に重宝される．


Window/buffer の設定
--------------------

`このページ <https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca>`_
にある記事を大いに参考にした．
標準のキーマップ `s` を潰しているので注意::

  nnoremap s <Nop>
  " バッファ作成と削除
  nnoremap ss :<C-u>sp<CR>
  nnoremap sv :<C-u>vs<CR>
  nnoremap sn :<C-u>bn<CR>
  nnoremap sp :<C-u>bp<CR>
  nnoremap sq :<C-u>bd<CR>
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
------------------------

change&delete&yank 系のコマンドに関する設定．

まずは D や C との一貫性を保つための処置として
標準の Y の定義を置き換える．詳細は``:help Y``参照．

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


その他の特殊キーマップ
----------------------


vimrc 関連
~~~~~~~~~~

`<Space>v` で vimrc の設定内容を即座に反映できるようにする．
ただし，一度閉じて開き直したほうが確実ではある．

::

  nnoremap <Space>v :<C-u>source $MYVIMRC<CR>


移動系キーマップ
~~~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~~

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
--------------------------------


LaTeX
~~~~~

`plaintex` などの形式で開かない::

  let g:tex_flavor = 'latex'

``\\alpha`` などの制御綴を一単語として扱う．
ただし，``\\alpha\\beta`` なども一つとして扱われることに注意．

::

  autocmd Filetype tex set iskeyword+=92


AsciiDoc
~~~~~~~~

AsciiDoc で作成された文書をプレビューする．
ブラウザには Vivaldi を指定している．このあたりはお好みで::

  command! MgmViewAdoc :!python make.py;asciidoctor %;open -a Vivaldi %:r.html<CR>


vim Plugin に関する設定
~~~~~~~~~~~~~~~~~~~~~~~

.. highlight:: ini

上で述べたとおり，
dein.toml, dein_lazy.toml, nvim_dein_lazy.toml の3箇所に
TOML 形式で記述している．


dein.toml での設定
------------------


vim-airline
~~~~~~~~~~~

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

以下，工事中
