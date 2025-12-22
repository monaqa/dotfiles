# vim:fdm=marker

# アイデア
# <C-r> を押すと fzf / sk が起動して履歴を検索できる
# 選択するとそのコマンドラインが挿入される

# functions {{{
function gitaddtree -a branch
    cd (git rev-parse --git-common-dir)/../
    set reponame (basename (git rev-parse --show-toplevel))
    git branch $branch 2>/dev/null
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

# thanks: https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e
function __auto_set_kubecfg --on-variable PWD --description "KUBECONFIG を自動で設定"
    status --is-command-substitution; and return

    set cwd (pwd)
    # Check if we are inside a git directory
    if test -e "$cwd/.local_ignore_kubeconfig.yaml"
        export KUBECONFIG=".local_ignore_kubeconfig.yaml"
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
if not set -q EDITOR
    set -x EDITOR nvim
end
set -x LSCOLORS gxfxcxdxbxegedabagacad

set -x PNPM_HOME "$HOME/Library/pnpm"

# PATH
set -x PATH /opt/homebrew/bin $PATH
set -x PATH "$HOME/.local/bin" $PATH
set -x PATH "$HOME/go/bin" $PATH
set -x PATH $PNPM_HOME $PATH
set -x PATH "$HOME/.yarn/bin" $PATH
set -x PATH "$HOME/.deno/bin" $PATH
set -x PATH "$HOME/.cargo/bin" $PATH
set -x PATH "$HOME/.bun/bin" $PATH
# set -x PATH "$HOME/.moon/bin" $PATH
# set -x PATH "$HOME/.rye/shims" $PATH

set -x XDG_CONFIG_HOME "$HOME/.config"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "$HOME/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# SATySFi
export SATYSFI_LIB_ROOT=/usr/local/lib-satysfi

export GPG_TTY=(tty)

# opam configuration
source $HOME/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true

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
for a in (abbr --list)
    abbr --erase $a
end

abbr -a cp "cp -i"
abbr -a mv "mv -i"

abbr -a cdd "cd ../"
abbr -a cddd "cd ../../"
abbr -a cd2 "cd ../../"
abbr -a cd3 "cd ../../../"
abbr -a mk mkdir
# abbr -a rr  "rm -r"

# git
abbr -a gb "git branch"
abbr -a gm "git merge"
abbr -a gmm "git merge (git mom)"
abbr -a gpl "git pull"
abbr -a gps "git push"
abbr -a grm "git remote"
abbr -a grb "git rebase"
abbr -a grbm "git rebase (git mom)"
abbr -a grbc "git rebase --continue"
abbr -a gs "git swim"
abbr -a gst "git stash"
abbr -a gsm "git switch (git mom)"
abbr -a gsc "git switch -c"
# abbr -a gsd "git stash drop"

# tig
abbr -a ta "nvim -c 'Gina log --all --graph'"

# tmux

abbr -a tn "tmux new-session -A -s"

# poetry & ipython & jupyter
abbr -a ipy "ipython -c '%autoindent' -i"
abbr -a pyr "poetry run"
abbr -a pyri "poetry run ipython -c '%autoindent' -i"
abbr -a pya "poetry add"
abbr -a jnb "jupyter notebook"
abbr -a jlb "jupyter lab"

# vim
alias edit "$EDITOR"
function choose_editor
    if test "$EDITOR" = nvim
        echo nvim
    else
        echo edit
    end
end

abbr -a v --function choose_editor
abbr -a vtex "env NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim"
abbr -a mkvs "mkdir .vimsessions"
abbr -a rmvs "rm .vimsessions/*"
abbr -a vlsp "env NVIM_APPNAME='nvim-nvim_lsp' nvim"
abbr -a vtech "env NVIM_APPNAME='nvim-edit_tech' nvim"

# cargo
abbr -a cb "cargo build"
abbr -a cn "cargo new"
abbr -a cr "cargo run"
abbr -a ct "cargo test"

# ranger
abbr -a r ranger-cd

# raf
abbr -a rafnew "cd (raf new)"

# k8s
function __kubectl_default_namespace_abbr
    if set -q KUBECTL_DEFAULT_NAMESPACE
        printf 'kubectl -n %s' $KUBECTL_DEFAULT_NAMESPACE
    else
        printf kubectl
    end
end
function __stern_default_namespace_abbr
    if set -q KUBECTL_DEFAULT_NAMESPACE
        printf 'stern -n %s' $KUBECTL_DEFAULT_NAMESPACE
    else
        printf stern
    end
end

abbr -a kubectl --position command --function __kubectl_default_namespace_abbr
abbr -a k --position command --function __kubectl_default_namespace_abbr
abbr -a stern --position command --function __stern_default_namespace_abbr

# }}}

# modern commands {{{

if type -q lsd
    abbr -a j "lsd -l"
    abbr -a tree 'lsd --tree --ignore-glob .git --depth 3'
else
    abbr -a j "ls -Fhla"
end

if type -q trash-put
    abbr -a rm trash-put
end

if type -q sk
    set FUZZY_FINDER sk
else if type -q fzf
    set FUZZY_FINDER fzf
end
if test -n "$FUZZY_FINDER"
    function __ghq_list_fuzzy
        if set -l d ( ghq list | $FUZZY_FINDER ) && test -n "$d"
            echo "pushd ~/ghq/$d"
        end
    end
    abbr -a g --function __ghq_list_fuzzy

    abbr -a tg "tmux a -t (tmux list-sessions | $FUZZY_FINDER | cut -d : -f 1)"
    # mercurial とかぶっていることに注意
    abbr -a hg "history | $FUZZY_FINDER"
    # abbr -a gs "git branches | $FUZZY_FINDER | xargs git switch"
    abbr -a gst "git tag -l | $FUZZY_FINDER | xargs git switch"

    # 便利な z
    abbr -a ff "cd (z -l | awk '{print \$2;}' | $FUZZY_FINDER || echo .)"

    # raf
    abbr -a rafls "cd (raf ls | $FUZZY_FINDER || pwd)"

    # scores
    function __score_list_fuzzy
        if set -l d (fd --base-directory ~/ghq/local/monaqa/scores --type d --exact-depth 3 | $FUZZY_FINDER ) && test -n "$d"
            echo "pushd ~/ghq/local/monaqa/scores/$d"
        end
    end
    abbr -a scores --function __score_list_fuzzy

    # gh
    abbr -a ghpc "gh pr list --json number,title --jq '.[] | [.number, .title] | @tsv' | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh pr checkout {}"
    abbr -a ghpv "gh pr list --json number,title --jq '.[] | [.number, .title] | @tsv' | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh pr view --web {}"
    abbr -a ghiv "gh issue list --json number,title --jq '.[] | [.number, .title] | @tsv' | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh issue view --web {}"
    abbr -a ghgv "gh gist list | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh gist view --web {}"

    # downloads
    function __open_download
        if set -l d ( exa -a -s created -r ~/Downloads/ | $FUZZY_FINDER ) && test -n "$d"
            echo "open ~/Downloads/$d"
        end
    end
    abbr -a vdown "nvim oil://~/Downloads/"
    abbr -a odown --function __nvim_open_download

    # abbr -a vdown  "exa -a -s created -r ~/Downloads/ | $FUZZY_FINDER | xargs -I{} nvim ~/Downloads/{}"

    # git swim worktree
    abbr -a gsw "cd (echo (git worktree list | $FUZZY_FINDER || pwd) | awk '{print \$1;}')"
end
# }}}

# preprompt {{{

set -g __fish_prompt_prefix

function by
    set __fish_prompt_prefix $argv ""
end

function __preprompt --on-event fish_prompt
    commandline --replace "$__fish_prompt_prefix"
end

# }}}

# local configs {{{
if test -e ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
# }}}

if type -q mise
    eval (mise activate fish)
end

set -g async_prompt_functions _pure_prompt_git

set pure_show_system_time true
set pure_show_jobs true
set pure_color_prompt_on_success green

function ghq_path
    set dir (string replace -r "^$HOME" "~" -- $PWD)

    set ghq_pat '^~/ghq/[^/]+/([^/]+)/([^/]+)(/.*)?$'
    set raf_pat '^~/raf/([^/]+)/[^/]+/[^/]+/[^/]+/([^/]+)(/.*)?$'

    if string match -rq $ghq_pat -- $dir
        set user (string replace -r $ghq_pat '$1' -- $dir)
        set repo (string replace -r $ghq_pat '$2' -- $dir)
        set rest (string replace -r $ghq_pat '$3' -- $dir)

        set bold_repo (printf "\e[1m%s\e[0m" $repo)

        echo (_pure_set_color "cyan")"$user/$bold_repo"(_pure_set_color "normal")"$rest"
    else if string match -rq $raf_pat -- $dir
        set lang (string replace -r $raf_pat '$1' -- $dir)
        set slug (string replace -r $raf_pat '$2' -- $dir)
        set rest (string replace -r $raf_pat '$3' -- $dir)

        set bold_slug (printf "\e[1m%s\e[0m" $slug)

        echo (_pure_set_color "magenta")"$lang/…/$bold_slug"(_pure_set_color "normal")"$rest"
    else
        echo (_pure_set_color "normal")$dir
    end
end

function fish_prompt
    set --local exit_code $status # save previous exit code

    set --local prompt_git (_pure_prompt_git)
    set --local prompt_command_duration (_pure_prompt_command_duration)
    set --local current_folder (ghq_path)
    set --local jobs (_pure_prompt_jobs)
    set --local virtualenv (_pure_prompt_virtualenv) # Python virtualenv name
    set --local pure_symbol (_pure_prompt_symbol $exit_code)
    set --local root_prefix (_pure_prefix_root_prompt)

    set --local time_color (_pure_set_color $pure_color_system_time)

    set --local prompt_components

    echo "$time_color"(date '+[%Y-%m-%d %H:%M:%S]')

    set prompt_components \
        $system_time \
        $current_folder \
        $prompt_git \
        $virtualenv \
        $prompt_command_duration

    echo (_pure_print_prompt $prompt_components)

    echo -n (\
        _pure_print_prompt \
        $root_prefix \
        $jobs \
        $pure_symbol \
    )

    echo -e -n (_pure_prompt_ending) # reset colors and end prompt

    set _pure_fresh_session false
end

# eval (starship init fish)
