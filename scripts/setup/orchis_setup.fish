#!/usr/bin/env fish

cd (mktemp -d)

git clone git@github.com:vinceliuice/Orchis-theme.git
cd Orchis-theme

./install.sh --shell 46 --round 12 -l -i --tweaks black solid compact primary
