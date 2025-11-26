#!/usr/bin/env fish

rm -rf ~/.config/nvim/

git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

python ../settings.py export lazy
