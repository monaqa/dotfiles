" vim:fdm=marker:
" Required:
" set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
" https://qiita.com/kawaz/items/ee725f6214f91337b42b
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
" Required:
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')
  " disable plugins
  call dein#disable('vim-airline/vim-airline')
  call dein#disable('vim-airline/vim-airline-themes')
  call dein#disable('monaqa/smooth-scroll')
  call dein#disable('thinca/vim-splash')
  call dein#disable('gruvbox-community/gruvbox')
  call dein#disable('rhysd/rust-doc.vim')
  call dein#disable('thinca/vim-quickrun')
  call dein#disable('Shougo/vimproc.vim')
  call dein#disable('previm/previm')
  call dein#disable('lambdalisue/gina.vim')
  call dein#disable('xolox/vim-session')
  call dein#disable('xolox/vim-misc')
  call dein#disable('tpope/vim-rhubarb')
  call dein#disable('syusui-s/scrapbox-vim')
  call dein#disable('wsdjeg/dein-ui.vim')
  call dein#disable('raghur/vim-ghost')
  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')
  " firenvim
  " call dein#add('glacambre/firenvim',
  "\ {
  "\   'hook_post_update': { _ -> firenvim#install(0) },
  "\   'hook_add': 'source ~/.config/nvim/plugins/firenvim.vim',
  "\   'merged': 0
  "\ })
  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.config/nvim/plugins/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  " Required:
  call dein#end()
  call dein#save_state()
endif
" Required だけど init.vim でやってるから別にいい
" filetype plugin indent on
" syntax enable
" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
