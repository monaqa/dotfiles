" vim:fdm=marker:

set encoding=utf-8
scriptencoding utf-8

" エディタ全般の設定{{{
""""""""""""""""""""""""

augroup vimrc
  autocmd!
augroup END

source ~/.config/nvim/scripts/plugin_beforeload.vim
source ~/.config/nvim/scripts/minpac.vim
source ~/.config/nvim/scripts/plugin.vim

source ~/.config/nvim/scripts/option.vim
source ~/.config/nvim/scripts/abbr.vim
source ~/.config/nvim/scripts/keymap.vim
source ~/.config/nvim/scripts/autocmd.vim
source ~/.config/nvim/scripts/filetype.vim

filetype plugin indent on
syntax enable

" mouse などの有効化{{{

let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim/bin/python'

" }}}
