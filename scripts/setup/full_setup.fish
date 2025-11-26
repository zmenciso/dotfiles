#!/usr/bin/env fish

# set LAPTOP
set UCODE amd

set CATEGORIES SYS BUILD HYPRLAND RICE TTF UTIL DOC TERM WEB MISC

set SYS power-profiles-daemon fingerprint-gui $UCODE-ucode
set BUILD downgrade python rust nodejs python-pynvim python-yaml python-seaborn python-numpy python-pandas pylsp clang cmake rust-analyzer marksman texlab bibtex-tidy clangd fish-lsp prettier ltex-ls-bin
# set HYPRLAND hyprcursor hypridle hyprland hyprlock hyprlang hyprpaper \
#     hyprpicker hyprutils xdg-desktop-portal-hyprland
# set RICE ironbar anyrun-git swaync papirus-icon-theme wl-clipboard \
#     xcursor-breeze xsettingsd
set RICE wl-clipboard papirus-icon-theme xsettingsd xcursor-breeze
set TTF noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-caladea ttf-carlito ttf-dejavu ttf-liberation ttf-opensans adobe-source-han-sans-jp-fonts adobe-source-han-serif-jp-fonts otf-ipafont ttf-hanazono
set UTIL polkit-gnome xsettingsd lxappearance fcitx5 fcitx5-mozc fcitx5-configtool fcitx5-qt fcitx5-gtk fcitx5-breeze pavucontrol pulseaudio-alsa openssh tree-sitter-cli ripgrep ripgrep-all tree-sitter openssh-hpn proton-pass-bin yubico-pam ccid opensc rsync sshfs tldr
set DOC pandoc libreoffice-fresh inkscape texlive
set TERM alacritty xplr helix btop grim slurp zed
set WEB zen-browser-bin
set MISC psst spotifyd fastfetch

echo "This script must be run from the directory it resides in"
read -P "Proceed with full system configuration? (Y/n) " allow

if test (string lower $allow) != y
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
sudo pacman -S gnome gnome-extra ly cosmic
sudo systemctl enable ly

# Install packages
for category in $CATEGORIES
    yay -S $$category
end

# Power configuration
if set -q LAPTOP
    sudo systemctl enable power-profiles-daemon
    sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
end

sudo systemctl enable pcscd
sudo echo 'enable_pinpad = false' >>/etc/opensc.conf
sudo echo 'card_drivers = cac' >>/etc/opensc.conf

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

# SSH setup
ssh-keygen

# Export dotfiles
fish ../settings.fish -e all
