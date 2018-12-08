#!/usr/local/bin/fish

set dir (pwd)
ln -fs $dir/.config/fish/config.fish ~/.config/fish/config.fish
ln -fs $dir/.vimrc ~/.vimrc

