" 高速化に大きな寄与を与える
" https://github.com/neovim/neovim/issues/7237
" let g:clipboard = {
          " \   'name': 'xclip-custom',
          " \   'copy': {
          " \      '+': 'xclip -quiet -i -selection clipboard',
          " \      '*': 'xclip -quiet -i -selection primary',
          " \    },
          " \   'paste': {
          " \      '+': 'xclip -o -selection clipboard',
          " \      '*': 'xclip -o -selection primary',
          " \   },
          " \ }
 
" Mac では以下のようにしないと pbcopy が使えないっぽい
" https://github.com/neovim/neovim/issues/8631

" Plugins {{{1
"""""""""""""""

" Required:
" set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
" dein settings {{{
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

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#load_toml(g:rc_dir . '/nvim_dein_lazy.toml', {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
 call dein#install()
endif

"End dein Scripts-------------------------

let g:clipboard = {'copy': {'+': 'pbcopy', '*': 'pbcopy'}, 'paste': {'+': 'pbpaste', '*': 'pbpaste'}, 'name': 'pbcopy', 'cache_enabled': 0}
set clipboard+=unnamedplus

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

set ambiwidth=double

if has('mac')
  let g:vimtex_view_method='skim'
else
  let g:vimtex_view_method='zathura'
endif

let g:vimtex_compiler_progname = 'nvr'

let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '@line @pdf @tex'

source ~/.config/vim/init.vim

