#!/usr/local/bin/fish

set dir (pwd)
mkdir -p ~/.config/fish
mkdir ~/.config/nvim
mkdir ~/.config/vim
mkdir ~/.config/git
ln -fs $dir/.config/fish/config.fish ~/.config/fish/config.fish
ln -fs $dir/.config/nvim/init.vim ~/.config/nvim/init.vim
ln -fs $dir/.config/vim/init.vim ~/.config/vim/init.vim
ln -fs $dir/.config/git/ignore ~/.config/git/ignore

ln -fs $dir/.vimrc ~/.vimrc
ln -fs $dir/.gvimrc ~/.gvimrc
ln -fs $dir/.tigrc ~/.tigrc

mkdir -p ~/.vim/rc/
ln -fs $dir/.vim/rc/dein.toml ~/.vim/rc/dein.toml 
ln -fs $dir/.vim/rc/dein_lazy.toml ~/.vim/rc/dein_lazy.toml 
ln -fs $dir/.vim/rc/nvim_dein_lazy.toml ~/.vim/rc/nvim_dein_lazy.toml 
