#!/usr/local/bin/fish

# set script_dir (cd (dirname $0); pwd)

set dir (cd (dirname (status -f)); pwd)

function mksymblink
  if test -e $argv[2]
    echo [WARN] File/folder $argv[2] already exists. Skipping...
  else
    if test -e (dirname $argv[2])
    else
      mkdir -p (dirname $argv[2])
    end
    ln -s $argv[1] $argv[2]
    echo [INFO] created link $argv[2]
  end
end

mksymblink $dir/.config/coc/ultisnips ~/.config/coc/ultisnips
mksymblink $dir/.config/fish/config.fish ~/.config/fish/config.fish
mksymblink $dir/.config/git/ignore ~/.config/git/ignore
mksymblink $dir/.config/nvim/init.vim ~/.config/nvim/init.vim
mksymblink $dir/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
mksymblink $dir/.config/nvim/scripts ~/.config/nvim/scripts
mksymblink $dir/.config/nvim/syntax ~/.config/nvim/syntax
mksymblink $dir/.config/nvim/after ~/.config/nvim/after

mksymblink $dir/.vimrc ~/.vimrc
mksymblink $dir/.tigrc ~/.tigrc
mksymblink $dir/.tmux.conf ~/.tmux.conf
mksymblink $dir/.latexmkrc ~/.latexmkrc
mksymblink $dir/.commit_template ~/.commit_template
mksymblink $dir/.gitconfig ~/.gitconfig
mksymblink $dir/.config/starship.toml ~/.config/starship.toml
