# vim:fdm=marker:fmr=§§,■■

# §§1 xonsh settings
$HISTCONTROL = {
    "ignoredups",
    "ignoreerr",
}
$XONSH_COLOR_STYLE = "native"

# §§1 colorscheme
from xonsh.tools import register_custom_style

mystyle = {
    "Token.PTK.Aborting": "#aaaaaa",
    "Token.PTK.AutoSuggestion": "#aaaaaa",
    "Token.Comment": "#888888"
}
register_custom_style("mystyle", mystyle, base="monokai")
$XONSH_COLOR_STYLE="mystyle"
# $XONSH_TRACE_SUBPROC = True

# §§1 environment variables
$EDITOR = "nvim"
$VISUAL = "nvim"

$PATH.extend([
    "/opt/homebrew/bin",
    f"{$HOME}/.local/bin",
    f"{$HOME}/.nimble/bin",
    f"{$HOME}/.cargo/bin",
    f"{$HOME}/.poetry/bin",
    f"{$HOME}/.deno/bin",
])

$RUSTC_WRAPPER = f"{$HOME}/.cargo/bin/sccache"

$SATYROGRAPHOS_EXPERIMENTAL = "1"

# fuzzy finder
if pf"/opt/homebrew/bin/sk".exists():
    fuzzy_finder = "sk"
elif pf"/opt/homebrew/bin/fzf".exists():
    fuzzy_finder = "fzf"
else:
    fuzzy_finder = None


# §§1 functions, macros
# def select(choices: str):
#     """
#     choices の中から1つを選択する。改行は取り除く。
#     choices は改行で区切られた候補。
# 
#     何も選択されなかった場合は空文字列を返す。
#     """
#     return $(echo @(choices) | @(fuzzy_finder)).strip()


def cd_ghq():
    # selected = select($(ghq list -p))
    # selected = select($(@(["ghq", "list", "-p"])))
    selected = $(ghq list -p | @(fuzzy_finder)).strip()
    if selected == "":
        return
    cd @(selected)

# @fuzzy_selector(["ghq", "list", "-p"])
# def cd_ghq():
#     if selected == "":
#         return
#     cd @(selected)


def exec_history_commands():
    selected = $(history show all | @(fuzzy_finder)).strip()
    print(selected)


def raf_ls():
    selected = $(raf ls | @(fuzzy_finder)).strip()
    if selected == "":
        return
    cd @(selected)


def gh_pr_checkout():
    selected = $(gh pr list --json number,title --jq '.[] | [.number, .title] | @tsv' | @(fuzzy_finder)).strip()
    if selected == "":
        return
    pr_id = selected.split()[0]
    gh pr checkout @(pr_id)


def gh_pr_view():
    selected = $(gh pr list --json number,title --jq '.[] | [.number, .title] | @tsv' | @(fuzzy_finder)).strip()
    if selected == "":
        return
    pr_id = selected.split()[0]
    gh pr view --web @(pr_id)


def gh_issue_view():
    selected = $(gh issue list --json number,title --jq '.[] | [.number, .title] | @tsv' | @(fuzzy_finder)).strip()
    if selected == "":
        return
    pr_id = selected.split()[0]
    gh issue view --web @(pr_id)


def nvim_downloads():
    selected = $(exa -a -s created -r ~/Downloads/ | @(fuzzy_finder)).strip()
    if selected == "":
        return
    nvim ~/Downloads/@(selected)


def open_downloads():
    selected = $(exa -a -s created -r ~/Downloads/ | @(fuzzy_finder)).strip()
    if selected == "":
        return
    open ~/Downloads/@(selected)


def git_switch_worktree():
    selected = $(git worktree list | @(fuzzy_finder)).strip()
    if selected == "":
        return
    worktree_path = selected.split()[0]
    cd @(worktree_path)


def git_add_tree(args):
    repo_root = $(git rev-parse --git-common-dir).strip() + "/../"
    cd @(repo_root)
    repo_path = $(git rev-parse --show-toplevel).strip()
    repo_name = $(basename @(repo_path)).strip()
    if len(args) < 1:
        raise ValueError("required 1 args: branch")
    branch = args[0]
    git branch @(branch)
    git worktree add .worktree/@(branch)/@(repo_name) @(branch)
    cd .worktree/@(branch)/@(repo_name)


# §§1 abbrevs
xontrib load abbrevs

# vim
abbrevs["v"] = "nvim"
abbrevs["mkvs"] = "mkdir .vimsessions"
abbrevs["rmvs"] = "rm .vimsessions/*"

# cargo
abbrevs["cb"] = "cargo build"
abbrevs["cn"] = "cargo new"
abbrevs["cr"] = "cargo run"
abbrevs["ct"] = "cargo test"

# exa
abbrevs["j"] = "exa -a --icons --group-directories-first --long --time-style=long-iso"

# misc
abbrevs["ta"] = "tig --all"
abbrevs["ipy"] = "ipython -c '%autoindent' -i"

abbrevs["rafnew"] = "cd @($(raf new).strip())"

# git

abbrevs["gb"]   = "git branch"
abbrevs["gm"]   = "git merge"
abbrevs["gmm"]  = "git merge @$(git mom)"
abbrevs["gpl"]  = "git pull"
abbrevs["gps"]  = "git push"
abbrevs["grm"]  = "git remote"
abbrevs["grb"]  = "git rebase"
abbrevs["grbm"] = "git rebase @$(git mom)"
abbrevs["grbc"] = "git rebase --continue"
abbrevs["gs"]   = "git swim"
abbrevs["gst"]  = "git stash"
abbrevs["gsm"]  = "git switch @$(git mom)"
abbrevs["gsc"]  = "git switch -c"

abbrevs["ta"]  = "tig --all"

if fuzzy_finder is not None:
    aliases["g"] = cd_ghq
    aliases["hg"] = exec_history_commands
    aliases["rafls"] = raf_ls

    aliases["ghpc"] = gh_pr_checkout
    aliases["ghpv"] = gh_pr_view
    aliases["ghiv"] = gh_issue_view

    aliases["vdown"] = nvim_downloads
    aliases["odown"] = open_downloads
    aliases["gsw"] = git_switch_worktree
    aliases["gitaddtree"] = git_add_tree


# §§1 key bindings
from prompt_toolkit.keys import Keys
from prompt_toolkit.filters import Condition, EmacsInsertMode, ViInsertMode
from prompt_toolkit.key_binding.bindings.named_commands import get_by_name

@events.on_ptk_create
def custom_keybindings(bindings, **kw):

    @bindings.add(Keys.ControlW)
    def say_hi(event):
        get_by_name("backward-kill-word").call(event)
        # get_by_name("unix-word-rubout").call(event)

# §§1 sources
source-bash $(cat $HOME/.opam/opam-init/init.sh)

# §§1 starship

# 本来は以下のコマンド1行叩けば完結する話
# execx($(starship init xonsh))

# しかし starship の rprompt が遅いことが分かったため、無効化（どうせ使ってない）
import uuid


def starship_prompt():
    last_cmd = __xonsh__.history[-1] if __xonsh__.history else None
    status = last_cmd.rtn if last_cmd else 0
    # I believe this is equivalent to xonsh.jobs.get_next_job_number() for our purposes,
    # but we can't use that function because of https://gitter.im/xonsh/xonsh?at=60e8832d82dd9050f5e0c96a
    jobs = sum(1 for job in __xonsh__.all_jobs.values() if job['obj'] and job['obj'].poll() is None)
    duration = round((last_cmd.ts[1] - last_cmd.ts[0]) * 1000) if last_cmd else 0
    # The `| cat` is a workaround for https://github.com/xonsh/xonsh/issues/3786. See https://github.com/starship/starship/pull/2807#discussion_r667316323.
    return $(/opt/homebrew/bin/starship prompt --status=@(status) --jobs=@(jobs) --cmd-duration=@(duration) | cat)

# def starship_rprompt():
#     last_cmd = __xonsh__.history[-1] if __xonsh__.history else None
#     status = last_cmd.rtn if last_cmd else 0
#     # I believe this is equivalent to xonsh.jobs.get_next_job_number() for our purposes,
#     # but we can't use that function because of https://gitter.im/xonsh/xonsh?at=60e8832d82dd9050f5e0c96a
#     jobs = sum(1 for job in __xonsh__.all_jobs.values() if job['obj'] and job['obj'].poll() is None)
#     duration = round((last_cmd.ts[1] - last_cmd.ts[0]) * 1000) if last_cmd else 0
#     # The `| cat` is a workaround for https://github.com/xonsh/xonsh/issues/3786. See https://github.com/starship/starship/pull/2807#discussion_r667316323.
#     return $(/opt/homebrew/bin/starship prompt --status=@(status) --jobs=@(jobs) --cmd-duration=@(duration) --right | cat)


$PROMPT = starship_prompt
# $RIGHT_PROMPT = starship_rprompt
$STARSHIP_SHELL = "xonsh"
$STARSHIP_SESSION_KEY = uuid.uuid4().hex
