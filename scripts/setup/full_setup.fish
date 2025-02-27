#!/usr/bin/env fish

set LAPTOP

set CATEGORIES SYS BUILD HYPRLAND RICE TTF UTIL DOC TERM WEB MISC

set SYS tlp fingerprint-gui amd-ucode intel-ucode upower powertop
set BUILD downgrade python rust nodejs python-pynvim python-yaml \
    python-seaborn python-numpy python-pandas pyright clang cmake \
    rust-analyzer marksman texlab
set HYPRLAND hyprcursor hypridle hyprland hyprlock hyprlang hyprpaper \
    hyprpicker hyprutils xdg-desktop-portal-hyprland
set RICE ironbar anyrun-git swaync papirus-icon-theme wl-clipboard \
    xcursor-breeze xsettingsd
set TTF noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
    ttf-caladea ttf-carlito ttf-dejavu ttf-liberation ttf-opensans \
    adobe-source-han-sans-jp-fonts adobe-source-han-serif-jp-fonts otf-ipafont \
    ttf-hanazono
set UTIL polkit-gnome xsettingsd lxappearance fcitx5 fcitx5-mozc \
    fcitx5-configtool fcitx5-qt fcitx5-gtk fcitx5-breeze pavucontrol \
    pulseaudio-alsa openssh tree-sitter-cli ripgrep ripgrep-all tree-sitter \
    openssh-hpn proton-pass-bin yubico-pam ccid opensc rsync sshfs tldr
set DOC pandoc libreoffice-fresh inkscape texlive
set TERM alacritty xplr neovim btop grim slurp zed
set WEB firefox
set MISC psst spotifyd fastfetch

echo "This script must be run from the directory it resides in"
read -P "Proceed with full system configuration? (Y/n) " allow

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
sudo pacman -S base-devel go git

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
    yay -S $$category
end

# Power configuration
if set -q LAPTOP
	sudo systemctl enable tlp
	sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
end

sudo systemctl enable pcscd
sudo echo 'enable_pinpad = false' >> /etc/opensc.conf
sudo echo 'card_drivers = cac' >> /etc/opensc.conf

# GTK theme
cd $scriptdir
./nightfox_setup.fish

# Blex Nerd Font
cd $scriptdir
sudo cp -r ../ttf/BlexMono /usr/share/fonts
sudo cp -r ../ttf/BlexSans /usr/share/fonts
fc-cache
# sudo cp ./environment /etc

# Application setup
./xplr_setup.fish
./nvim_setup.bash

# SSH setup
ssh-keygen

# Export dotfiles
python ../settings.py export all
