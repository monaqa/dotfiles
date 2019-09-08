export EDITOR=nvim

fish_vi_key_bindings

set -g fish_ambiguous_width 1

# Spacefish settings
# set SPACEFISH_PROMPT_ORDER time user dir host git package node docker ruby golang php rust haskell julia aws conda pyenv kubecontext exec_time battery line_sep jobs vi_mode exit_code char
set SPACEFISH_PROMPT_ORDER user dir git julia exec_time battery vi_mode line_sep jobs char
# prompt
set SPACEFISH_PROMPT_ADD_NEWLINE true
set SPACEFISH_PROMPT_SEPARATE_LINE true
# user
set SPACEFISH_USER_SHOW true
# dir
set SPACEFISH_DIR_TRUNC 0
set SPACEFISH_DIR_TRUNC_REPO true
# git
set SPACEFISH_GIT_PREFIX '┅ '
set SPACEFISH_GIT_STATUS_PREFIX ' ┅ status: '
set SPACEFISH_GIT_STATUS_SUFFIX ''
set SPACEFISH_GIT_STATUS_UNTRACKED \uF128
set SPACEFISH_GIT_STATUS_MODIFIED ' '
set SPACEFISH_GIT_STATUS_ADDED ' '
set SPACEFISH_GIT_STATUS_DELETED ' '
set SPACEFISH_GIT_STATUS_STASHED ' '
set SPACEFISH_GIT_STATUS_AHEAD '⤒ '
set SPACEFISH_GIT_STATUS_VEHIND '⤓ '
set SPACEFISH_GIT_STATUS_DIVERGED '⤒⤓ '
# battery
set SPACEFISH_BATTERY_THRESHOLD 80
# vi mode
set SPACEFISH_VI_MODE_SHOW true
set SPACEFISH_VI_MODE_INSERT '           '
set SPACEFISH_VI_MODE_NORMAL '[ NORMAL ]'
set SPACEFISH_VI_MODE_VISUAL '[ VISUAL ]'
set SPACEFISH_VI_MODE_REPLACE_ONE '[ REPLACE]'
# char
set SPACEFISH_CHAR_SYMBOL 'λ→'

set -gx PATH '/Users/shinichi/.pyenv/shims' $PATH
set -gx PYENV_SHELL fish

function pyenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (pyenv "sh-$command" $argv|psub)
  case '*'
    command pyenv "$command" $argv
  end
end

set -gx PYENV_ROOT "$HOME/.pyenv"

alias ll='ls -laF'

# git alias
function g --wraps git
  git $argv
end
function tiga --wraps tig
  tig --all $argv
end

# jupyter
alias jnb='jupyter notebook'
alias jlb='jupyter lab'

# vim
function v --wraps nvim
  $HOME/nvim/nvim-osx64/bin/nvim $argv
end
function vtex --wraps nvim
  env NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim $argv
end
function nv --wraps nvim
  nvim $argv
end

# SATySFi
export SATYSFI_LIB_ROOT=/usr/local/lib-satysfi

# AWS s3 sync
alias s3write-input="aws s3 sync ~/Documents/git/research/aspy-exp/input/info s3://aspy-data/input/info"

function s3load-output
  aws s3 sync s3://aspy-data/output/info ~/Documents/git/research/aspy-exp/output/info
end

# bin at home directory
# set -x PATH '~/bin' $PATH
set -U fish_user_paths ~/bin $fish_user_paths

set -x PATH '/usr/local/opt/qt/bin' $PATH

# opam configuration
source /Users/shinichi/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

set fish_theme default
