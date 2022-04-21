vim.cmd [[
  set encoding=utf-8

  augroup vimrc
    autocmd!
  augroup END

  " 正直このあたりよくわかってません
  " https://wiredool.hatenadiary.org/entry/20120618/1340019962
  filetype off
  filetype plugin indent off
]]

require("rc.plugin_beforeload")
require("rc.minpac")

vim.cmd [[
  " load plugins/their settings
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
]]
