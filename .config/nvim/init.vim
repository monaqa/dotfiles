set encoding=utf-8
scriptencoding utf-8

augroup vimrc
  autocmd!
augroup END

" load plugins/their settings
source ~/.config/nvim/scripts/plugin_beforeload.vim
source ~/.config/nvim/scripts/minpac.vim
source ~/.config/nvim/scripts/plugin.vim

" load other settings
source ~/.config/nvim/scripts/option.vim
source ~/.config/nvim/scripts/keymap.vim
source ~/.config/nvim/scripts/abbr.vim
source ~/.config/nvim/scripts/autocmd.vim
source ~/.config/nvim/scripts/command.vim
source ~/.config/nvim/scripts/filetype.vim

filetype plugin indent on
syntax enable
