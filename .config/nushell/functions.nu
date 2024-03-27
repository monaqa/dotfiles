# Nushell で使えそうな便利関数を集めたもの。

export def is-git-dir [path] {
    cd $path;
    (do {git rev-parse --show-toplevel} | complete).exit_code == 0
}

# expand auto-source-venv [path] {
#     let gitdir = git rev-parse --show-toplevel | path expand
#     mut cwd = pwd
#
#     while $cwd | str starts-with $gitdir {
#         if ($"($cwd)/.venv/bin/activate.nu" | path exists) {
#             overlay use $"($cwd)/.venv/bin/activate.nu"
#             return
#         }
#     }
# }
