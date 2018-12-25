# eval (pyenv init - fish)
set -gx PATH '/Users/shinichi/.pyenv/shims' $PATH
set -gx PYENV_SHELL fish
source '/usr/local/Cellar/pyenv/1.1.5/libexec/../completions/pyenv.fish'
command pyenv rehash 2>/dev/null
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

alias ll='ls -laF'

# ssh alias
alias sviv1='ssh -L 13389:133.11.210.119:3389 sys1'
alias sviv2='ssh -L 13389:133.11.210.120:3389 sys1'
alias selg4='ssh -L 1928:localhost:1928 elger4.sys1'
alias belg4='open -a Firefox; ssh -D 10000 elger4.sys1' # Blouse

alias secc1='ssh -L 1928:localhost:1928 9452181327@ssh0-01.ecc.u-tokyo.ac.jp'
alias secc2='ssh -L 1928:localhost:1928 9452181327@ssh0-02.ecc.u-tokyo.ac.jp'
alias secc3='ssh -L 1928:localhost:1928 9452181327@ssh0-03.ecc.u-tokyo.ac.jp'
alias sclst='ssh u00157@157.82.22.26'

# sshfs alias
alias melger4='sshfs mogami@elger4.sys1:/home/mogami/ ~/mountpoint'
alias melger4-hdd='sshfs mogami@elger4.sys1:/mnt/hdd/mogami-hdd/ ~/mountpoint'
alias umelger4='diskutil unmount ~/mountpoint'

# git alias
alias gplog="git log --pretty='format:%C(yellow)%h %C(green)%cd %C(reset)%s %C(red)%d %C(cyan)[%an]' --date=format:'%c' --all --graph"
alias gdlog='git log --graph --name-status --pretty=format:"%C(red)%h %C(green)%an %Creset%s %C(yellow)%d%Creset"'
function g --wraps git
  git $argv
end
function tiga --wraps tig
  tig --all $argv
end

# for-get
alias fgt='python ~/Documents/git/for-get/forget.py'

# jupyter
alias jnb='jupyter notebook'
alias jlb='jupyter lab'

# vim
# balias v 'env NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim'
function v --wraps nvim
  env NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim $argv
end

# SATySFi
export SATYSFI_LIB_ROOT=/usr/local/lib-satysfi

# AWS s3 sync
alias s3write-input="aws s3 sync ~/Documents/git/research/aspy-exp/input/info s3://aspy-data/input/info"

function s3load-output
  aws s3 sync s3://aspy-data/output/info ~/Documents/git/research/aspy-exp/output/info
end

# Julia
ln -fs "/Users/shinichi/Documents/git/others/julia/julia" /usr/local/bin/julia

# # OPAM configuration
# . /Users/shinichi/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# bin at home directory
# set -x PATH '~/bin' $PATH
set -U fish_user_paths ~/bin $fish_user_paths

set -x PATH '/usr/local/opt/qt/bin' $PATH

# wrike
alias wps='python /Users/shinichi/Documents/git/hobby/wrike_personal/wrike_personal/wrike_personal.py'
