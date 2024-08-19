#!/usr/bin/env fish

cd (mktemp -d)

git clone git@github.com:vinceliuice/Orchis-theme.git
cd Orchis-theme

./install.sh -l -s compact --tweaks carbon outline
