export EDITOR=nvim

fish_default_key_bindings

set -g fish_ambiguous_width 1

# environment variables {{{
# bin at home directory
set -x PATH "$HOME/.cargo/bin" $PATH
set -x PATH "$HOME/.local/bin" $PATH

# SATySFi
export SATYSFI_LIB_ROOT=/usr/local/lib-satysfi

# opam configuration
source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# gopath
set -x PATH $HOME/go/bin $PATH

# }}}

eval (starship init fish)

# ls
set -x LSCOLORS gxfxcxdxbxegedabagacad

# abbr {{{
# abbr は universal 変数として格納される．
# リセットしたい場合は以下のコマンドを実行
# for a in (abbr --list); abbr --erase $a; end

abbr -a cdd   "cd ../"
abbr -a cddd  "cd ../../"
abbr -a cd2   "cd ../../"
abbr -a cd3   "cd ../../../"
abbr -a mk    "mkdir"
# abbr -a rr  "rm -r"

# git
abbr -a g    "git"
abbr -a gb   "git branch"
abbr -a gcm  "git checkout master"
abbr -a gcb  "git checkout -b"
abbr -a gm  "git merge"
abbr -a gmm  "git merge master"
abbr -a gpl  "git pull"
abbr -a gps  "git push"
abbr -a grm  "git remote"
abbr -a grb  "git rebase"
abbr -a grbm "git rebase master"
abbr -a grbc "git rebase --continue"
abbr -a gss  "git stash save"
abbr -a gsl  "git stash list"
abbr -a gsp  "git stash pop"
# abbr -a gsd "git stash drop"

# tig
abbr -a ta   "tig --all"

# tmux

abbr -a tn   "tmux new-session -A -s"

# jupyter
abbr -a jnb  "jupyter notebook"
abbr -a jlb  "jupyter lab"

# vim
abbr -a v    "nvim"
abbr -a vtex "env NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim"
abbr -a mkvs "mkdir .vimsessions"
abbr -a rmvs "rm .vimsessions/*"

# ssh
abbr -a s    "ssh"

# cargo
abbr -a cb   "cargo build"
abbr -a cn   "cargo new"
abbr -a cr   "cargo run"
abbr -a ct   "cargo test"

# }}}

# modern commands {{{

if type -q exa
  abbr -a j "exa -a --icons --group-directories-first --long --time-style=long-iso"
else
  abbr -a j "ls -Fhla"
end

if type -q sk
  set FUZZY_FINDER sk
else if type -q fzf
  set FUZZY_FINDER fzf
end
if test -n "$FUZZY_FINDER"
  abbr -a gg "cd (ghq list -p | $FUZZY_FINDER || pwd)"
  abbr -a tg "tmux a -t (tmux list-sessions | $FUZZY_FINDER | cut -d : -f 1)"
  # mercurial とかぶっていることに注意
  abbr -a hg "history | $FUZZY_FINDER"
  abbr -a gc "git branch -a | $FUZZY_FINDER | xargs git checkout"
  abbr -a gct "git tag -l | $FUZZY_FINDER | xargs git checkout"
end
# }}}

# vim:fdm=marker
