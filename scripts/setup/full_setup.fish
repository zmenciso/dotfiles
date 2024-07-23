#!/usr/bin/env fish

set CATEGORIES HYPRLAND RICE TTF UTIL DOC TERM WEB MISC

set HYPRLAND hyprcursor hypridle hyprland hyprlock hyprlang hyprpaper \
    hyprpicker hyprutils xdg-desktop-portal-hyprland
set RICE ironbar anyrun swaync papirus-icon-theme wl-clipboard \
    xcursor-breeze
set TTF noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
    ttf-caladea ttf-carlito ttf-dejavu ttf-liberation ttf-opensans \
    adobe-source-han-sans-jp-fonts adobe-source-han-serif-jp-fonts \
    otf-ipafont ttf-hanazono
set UTIL polkit-gnome xsettingsd lxappearance fcitx5 fcitx5-mozc \
    fcitx5-configtool fcitx5-qt fcitx5-gtk fcitx5-breeze pavucontrol \
    pulseaudio pulseaudio-alsa openssh tree-sitter-cli
set DOC pandoc libreoffice-fresh inkscape
set TERM alacritty xplr neovim btop grim slurp
set WEB firefox
set MISC spotify-tui spotifyd fastfetch

echo "This script must be run from the directory it resides in"
read -P "Proceed wtih full system configuration? (Y/n) " allow

if test (string lower $allow) != 'y'
	and test -n "$allow"
	echo "Aborting..."
	exit 2
end

if test (id -u) -eq 0 
	echo "ERROR: Cannot run script as root"
	exit 1
end

set scriptdir (pwd)
set tempdir (mktemp -d)

# Configure pacman
sudo cp ./pacman.conf /etc

# Install yay
sudo pacman -S base-devel go

cd $tempdir
git clone https://aur.archlinux.org/yay.git
cd yay

makepkg
sudo pacman -U yay*.pkg.tar.zst

# Install GNOME and GNOME software
sudo pacman -S gnome gnome-extra ly
sudo systemctl enable ly

# Install packages
for category in $CATEGORIES
    yay -S $category
end

# Orchis theme
cd $tempdir
git clone https://github.com/vinceliuice/Orchis-theme
cd Orchis-theme
./install.sh --shell 42 --round 8 --tweaks black

# Blex Nerd Font
cd $scriptdir
sudo cp -r ../ttf/Blex /usr/share/fonts
fc-cache
# sudo cp ./environment /etc

# Application setup
./xplr_setup.fish
./nvim_setup.bash

# SSH setup
ssh-keygen

# Export dotfiles
python ../settings.py export all
