#!/usr/local/bin/fish

# set script_dir (cd (dirname $0); pwd)

set dir (cd (dirname (status -f)); pwd)

function mksymblink
  if test -e $argv[2]
    echo File/folder $argv[2] already exists. Skipping...
  else
    if test -e (dirname $argv[2])
    else
      mkdir -p (dirname $argv[2])
    end
    ln -s $argv[1] $argv[2]
    echo created link $argv[2]
  end
end

mksymblink $dir/.config/fish/config.fish ~/.config/fish/config.fish
mksymblink $dir/.config/git/ignore ~/.config/git/ignore
mksymblink $dir/.config/nvim ~/.config/nvim
mksymblink $dir/.config/vim/init.vim ~/.config/vim/init.vim

mksymblink $dir/.vimrc ~/.vimrc
mksymblink $dir/.gvimrc ~/.gvimrc
mksymblink $dir/.tigrc ~/.tigrc
mksymblink $dir/.latexmkrc ~/.latexmkrc
mksymblink $dir/.commit_template ~/.commit_template
mksymblink $dir/.gitconfig ~/.gitconfig

mksymblink $dir/.vim/rc ~/.vim/rc
mksymblink $dir/.vim/colors ~/.vim/colors

# set dir (pwd)
# mkdir -p ~/.config/fish
# mkdir ~/.config/nvim
# mkdir ~/.config/vim
# mkdir ~/.config/git
# ln -fs $dir/.config/fish/config.fish ~/.config/fish/config.fish
# ln -fs $dir/.config/nvim/init.vim ~/.config/nvim/init.vim
# ln -fs $dir/.config/vim/init.vim ~/.config/vim/init.vim
# ln -fs $dir/.config/git/ignore ~/.config/git/ignore
#
# ln -fs $dir/.vimrc ~/.vimrc
# ln -fs $dir/.gvimrc ~/.gvimrc
# ln -fs $dir/.tigrc ~/.tigrc
#
# mkdir -p ~/.vim/rc/
# ln -fs $dir/.vim/rc/dein.toml ~/.vim/rc/dein.toml 
# ln -fs $dir/.vim/rc/dein_lazy.toml ~/.vim/rc/dein_lazy.toml 
# ln -fs $dir/.vim/rc/nvim_dein_lazy.toml ~/.vim/rc/nvim_dein_lazy.toml 
