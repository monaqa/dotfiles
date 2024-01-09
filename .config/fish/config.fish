# vim:fdm=marker

# xonsh を試してみるよ！
# if test -e /opt/homebrew/bin/xonsh
#   /opt/homebrew/bin/xonsh
# end

# xonsh が終了したら以下を fallback

# functions {{{
function gitaddtree -a branch
  cd (git rev-parse --git-common-dir)/../
  set reponame (basename (git rev-parse --show-toplevel))
  git branch $branch 2> /dev/null
  git worktree add .worktree/$branch/$reponame $branch
  cd .worktree/$branch/$reponame
end

# thanks: https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e
function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
  status --is-command-substitution; and return

  # Check if we are inside a git directory
  if git rev-parse --show-toplevel &>/dev/null
    set gitdir (realpath (git rev-parse --show-toplevel))
    set cwd (pwd)
    # While we are still inside the git directory, find the closest
    # virtualenv starting from the current directory.
    while string match "$gitdir*" "$cwd" &>/dev/null
      if test -e "$cwd/.venv/bin/activate.fish"
        source "$cwd/.venv/bin/activate.fish" &>/dev/null 
        return
      else
        set cwd (path dirname "$cwd")
      end
    end
  end
  # If virtualenv activated but we are not in a git directory, deactivate.
  if test -n "$VIRTUAL_ENV"
    deactivate
  end
end

# https://blog.kentarom.com/posts/b9e446f0-8297-44e8-8c76-a0a6fe2fb54e
function show_filtered_pr_list
  set query '
  query($q: String!, $limit: Int = 10) {
    search(first: $limit, type: ISSUE, query: $q) {
      nodes {
        ... on PullRequest {
          number
          title
          url
          updatedAt
          repository {
            name
          }
        }
      }
    }
  }
  '
  gh api graphql -F q="$argv" -F limit=10 -f query=$query
end
# show_filtered_pr_list is:open is:pr review-requested:@me
# show_filtered_pr_list is:open is:pr author:@me

# }}}

fish_default_key_bindings

# environment variables {{{

# basic
set -g fish_ambiguous_width 1
set -x EDITOR nvim
set -x LSCOLORS gxfxcxdxbxegedabagacad

# bin at home directory
set -x PATH "/opt/homebrew/bin" $PATH
set -x PATH "$HOME/.cargo/bin" $PATH
set -x PATH "$HOME/.local/bin" $PATH
set -x PNPM_HOME "$HOME/Library/pnpm"
set -x PATH "$PNPM_HOME:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/monaqa/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# SATySFi
export SATYSFI_LIB_ROOT=/usr/local/lib-satysfi

export GPG_TTY=(tty)

# opam configuration
source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# gopath
set -x PATH $HOME/go/bin $PATH

# fzf-preview
set -x FZF_PREVIEW_PREVIEW_BAT_THEME 'gruvbox'

# Haxe
set -x HAXE_STD_PATH "/usr/local/lib/haxe/std"

# yarn
set -x PATH $HOME/.yarn/bin $PATH

# deno
set -x PATH $HOME/.deno/bin $PATH

# 普通に困るくね？
set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK 1

# Rust sccache
# set -x RUSTC_WRAPPER (which sccache)

# Satyrographos
set -x SATYROGRAPHOS_EXPERIMENTAL 1

# pdm
if test -n "$PYTHONPATH"
    set -x PYTHONPATH '/Users/monaqa/.local/pipx/venvs/pdm/lib/python3.11/site-packages/pdm/pep582' $PYTHONPATH
else
    set -x PYTHONPATH '/Users/monaqa/.local/pipx/venvs/pdm/lib/python3.11/site-packages/pdm/pep582'
end

set -x MANPAGER 'nvim +Man!'
# }}}

# abbr {{{
# abbr は universal 変数として格納される．
# リセットしたい場合は以下のコマンドを実行
# for a in (abbr --list); abbr --erase $a; end

abbr -a cp    "cp -i"
abbr -a mv    "mv -i"

abbr -a cdd   "cd ../"
abbr -a cddd  "cd ../../"
abbr -a cd2   "cd ../../"
abbr -a cd3   "cd ../../../"
abbr -a mk    "mkdir"
# abbr -a rr  "rm -r"

# git
abbr -a gb   "git branch"
abbr -a gm   "git merge"
abbr -a gmm  "git merge (git mom)"
abbr -a gpl  "git pull"
abbr -a gps  "git push"
abbr -a grm  "git remote"
abbr -a grb  "git rebase"
abbr -a grbm "git rebase (git mom)"
abbr -a grbc "git rebase --continue"
abbr -a gs   "git swim"
abbr -a gst  "git stash"
abbr -a gsm  "git switch (git mom)"
abbr -a gsc  "git switch -c"
# abbr -a gsd "git stash drop"

# tig
abbr -a ta   "nvim -c 'Gina log --all --graph'"

# tmux

abbr -a tn   "tmux new-session -A -s"

# poetry & ipython & jupyter
abbr -a ipy  "ipython -c '%autoindent' -i"
abbr -a pyr  "poetry run"
abbr -a pyri "poetry run ipython -c '%autoindent' -i"
abbr -a pya  "poetry add"
abbr -a jnb  "jupyter notebook"
abbr -a jlb  "jupyter lab"

# vim
abbr -a v    "nvim"
abbr -a vtex "env NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim"
abbr -a mkvs "mkdir .vimsessions"
abbr -a rmvs "rm .vimsessions/*"
abbr -a vlsp "env NVIM_APPNAME='nvim-nvim_lsp' nvim"
abbr -a vtech "env NVIM_APPNAME='nvim-edit_tech' nvim"

# cargo
abbr -a cb   "cargo build"
abbr -a cn   "cargo new"
abbr -a cr   "cargo run"
abbr -a ct   "cargo test"

# ranger
abbr -a r    "ranger-cd"

# raf
abbr -a rafnew "cd (raf new)"

# }}}

# modern commands {{{

if type -q lsd
  abbr -a j "lsd -l"
  abbr -a jj 'lsd -l --tree --ignore-glob .git --depth 3'
else if type -q exa
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
  abbr -a g "cd (ghq list -p | $FUZZY_FINDER || pwd)"
  abbr -a tg "tmux a -t (tmux list-sessions | $FUZZY_FINDER | cut -d : -f 1)"
  # mercurial とかぶっていることに注意
  abbr -a hg "history | $FUZZY_FINDER"
  # abbr -a gs "git branches | $FUZZY_FINDER | xargs git switch"
  abbr -a gst "git tag -l | $FUZZY_FINDER | xargs git switch"

  # 便利な z
  abbr -a ff  "cd (z -l | awk '{print \$2;}' | $FUZZY_FINDER || echo .)"

  # raf
  abbr -a rafls  "cd (raf ls | $FUZZY_FINDER || pwd)"

  # gh
  abbr -a ghpc   "gh pr list --json number,title --jq '.[] | [.number, .title] | @tsv' | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh pr checkout {}"
  abbr -a ghpv   "gh pr list --json number,title --jq '.[] | [.number, .title] | @tsv' | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh pr view --web {}"
  abbr -a ghiv   "gh issue list --json number,title --jq '.[] | [.number, .title] | @tsv' | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh issue view --web {}"
  abbr -a ghgv   "gh gist list | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh gist view --web {}"

  # downloads
  abbr -a vdown  "exa -a -s created -r ~/Downloads/ | $FUZZY_FINDER | xargs -I{} nvim ~/Downloads/{}"
  abbr -a odown  "exa -a -s created -r ~/Downloads/ | $FUZZY_FINDER | xargs -I{} open ~/Downloads/{}"

  # git swim worktree
  abbr -a gsw "cd (echo (git worktree list | $FUZZY_FINDER || pwd) | awk '{print \$1;}')"
end
# }}}

# local configs {{{

if test -e ~/.config/fish/local.fish
  source ~/.config/fish/local.fish
end

# }}}

eval (starship init fish)
