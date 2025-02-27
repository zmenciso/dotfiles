#!/usr/bin/env fish

cd (mktemp -d)

yay -S sassc gtk-engine-murrine

git clone git@github.com:Fausto-Korpsvart/Nightfox-GTK-Theme.git
cd Nightfox-GTK-Theme/themes

./install.sh -l -s compact --tweaks carbon
