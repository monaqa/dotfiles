# vim:fdm=marker:

# 基本設定 {{{
autoload -Uz compinit && compinit
setopt auto_cd
setopt share_history

export LANG=ja_JP.UTF-8
HISTFILE=$HOME/.zsh-history
HISTSIZE=1000000
SAVEHIST=1000000

# より良い CTRL-W の体験を
export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>' 

# emacs key binding
# https://k-koh.hatenablog.com/entry/2020/10/24/160323
bindkey -e
# }}}

# zplug {{{
# https://sanoto-nittc.hatenablog.com/entry/2017/12/16/213735
# zplugが無ければgitからclone

if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

# zplugを使う
source ~/.zplug/init.zsh

# ここに使いたいプラグインを書いておく
# zplug "ユーザー名/リポジトリ名", タグ

# 自分自身をプラグインとして管理
zplug "zplug/zplug", hook-build:'zplug --self-manage'

# 補完を更に強化する
# pacman や yaourt のパッケージリストも補完するようになる
# zplug "zsh-users/zsh-completions"

# git の補完を効かせる
# 補完＆エイリアスが追加される
# zplug "plugins/git",   from:oh-my-zsh
# zplug "peterhurford/git-aliases.zsh"

# 入力途中に候補をうっすら表示
# 不具合あり: https://github.com/zsh-users/zsh-syntax-highlighting/issues/857
zplug "zsh-users/zsh-autosuggestions"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666,bg=#222222,underline"

# コマンドを種類ごとに色付け
# zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-syntax-highlighting"


# ヒストリの補完を強化する
# zplug "zsh-users/zsh-history-substring-search", defer:3

zplug "momo-lab/zsh-abbrev-alias"

zplug "dracula/zsh", as:theme

# インストールしてないプラグインはインストール
# 遅いらしいのでコメントアウト

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
# zplug load --verbose
zplug load
# }}}

# alias {{{
# https://qiita.com/momo-lab/items/b1b1afee313e42ba687b

abbrev-alias -c cb="cargo build"
abbrev-alias -c cn="cargo new"
abbrev-alias -c cr="cargo run"
abbrev-alias -c ct="cargo test"
abbrev-alias -c gb="git branch"
abbrev-alias -c gm="git merge"
abbrev-alias -c gmm="git merge master"
abbrev-alias -c gpl="git pull"
abbrev-alias -c gps="git push"
abbrev-alias -c grb="git rebase"
abbrev-alias -c grbc="git rebase --continue"
abbrev-alias -c grbm="git rebase master"
abbrev-alias -c grm="git remote"
abbrev-alias -c gs="git swim"
abbrev-alias -c gsc="git switch -c"
abbrev-alias -c gsm="git switch master"
abbrev-alias -c gst="git stash"
abbrev-alias -c mkvs="mkdir .vimsessions"
abbrev-alias -c rmvs="rm .vimsessions/*"
abbrev-alias -c ta="tig --all"
abbrev-alias -c tn="tmux new-session -A -s"
# abbrev-alias -c v="nvim"
abbrev-alias -c v="env NVIM_APPNAME='nvim-edit_tech' nvim"
abbrev-alias -c rafnew="cd \$(raf new)"

if type "exa" > /dev/null 2>&1; then
    abbrev-alias -c j="exa -a --icons --group-directories-first --long --time-style=long-iso"
else
    abbrev-alias -c j="ls -Fhla"
fi

if type "sk" > /dev/null 2>&1; then
    FUZZY_FINDER="sk"
elif type "fzf" > /dev/null 2>&1; then
    FUZZY_FINDER="fzf"
fi

if test -n "$FUZZY_FINDER"; then
    abbrev-alias -c g="cd \$(ghq list -p | $FUZZY_FINDER || pwd)"
    abbrev-alias -c tg="tmux a -t \$(tmux list-sessions | $FUZZY_FINDER | cut -d : -f 1)"
    abbrev-alias -c hg="history | $FUZZY_FINDER"
    # abbrev-alias -a gs "git branches | $FUZZY_FINDER | xargs git switch"
    abbrev-alias -c gst="git tag -l | $FUZZY_FINDER | xargs git switch"

    # 便利な z
    abbrev-alias -c ff="cd \$(z -l | awk '{print \$2;}' | $FUZZY_FINDER || echo .)"

    # raf
    abbrev-alias -c rafls="cd \$(raf ls | $FUZZY_FINDER || pwd)"

    # gh
    abbrev-alias -c ghpc="gh pr list --json number,title --jq '.[] | [.number, .title] | @tsv' | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh pr checkout {}"
    abbrev-alias -c ghpv="gh pr list --json number,title --jq '.[] | [.number, .title] | @tsv' | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh pr view --web {}"
    abbrev-alias -c ghiv="gh issue list --json number,title --jq '.[] | [.number, .title] | @tsv' | $FUZZY_FINDER | awk '{print \$1}' | xargs -I{} gh issue view --web {}"

    # git swim worktree
    abbrev-alias -c gsw="cd \$(echo \$(git worktree list | $FUZZY_FINDER || pwd) | awk '{print \$1;}')"
fi



# }}}


# starship {{{
eval "$(starship init zsh)"
# }}}

export PATH="$HOME/.poetry/bin:$PATH"
