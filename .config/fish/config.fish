export EDITOR=nvim

fish_vi_key_bindings

set -g fish_ambiguous_width 1

# alias {{{

alias ll='ls -laFh'

# git

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
  nvim $argv
end
function vtex --wraps nvim
  env NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim $argv
end
function nv --wraps nvim
  nvim $argv
end

# }}}

# environment variables {{{ 
# bin at home directory
# set -x PATH '~/bin' $PATH
set -U fish_user_paths ~/bin $fish_user_paths

# SATySFi
export SATYSFI_LIB_ROOT=/usr/local/lib-satysfi

# opam configuration
source /Users/shinichi/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# gopath
set -x PATH '/Users/shinichi/go/bin' $PATH

# }}}


set -U PIPENV_SKIP_LOCK true

eval (starship init fish)

# vim:fdm=marker
