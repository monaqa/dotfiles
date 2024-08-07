#!/bin/bash

dir=$(pwd)
mkdir -p ~/.config/nvim
mkdir -p ~/.config/vim
mkdir -p ~/.vim/rc
ln -fs $dir/.config/nvim/init.vim ~/.config/nvim/init.vim
ln -fs $dir/.config/vim/init.vim ~/.config/vim/init.vim
ln -fs $dir/.vimrc ~/.vimrc
ln -fs $dir/.vim/rc/dein.toml ~/.vim/rc/dein.toml 
ln -fs $dir/.vim/rc/dein_lazy.toml ~/.vim/rc/dein_lazy.toml 
ln -fs $dir/.vim/rc/nvim_dein_lazy.toml ~/.vim/rc/nvim_dein_lazy.toml 

