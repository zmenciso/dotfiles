#!/usr/bin/env fish

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

sudo cp ./pacman.conf /etc

sudo pacman -S base-devel go

cd $tempdir
git clone https://aur.archlinux.org/yay.git
cd yay

makepkg
sudo pacman -U yay*.pkg.tar.zst

sudo pacman -S gnome gnome-extra

yay -S ly waybar-hyprland-git rofi-lbonn-wayland-git swaylock swayidle swaync \
hyprpaper-git alacritty xsettingsd papirus-icon-theme polkit-gnome xplr \
zathura spotify-tui spotifyd lxappearance fcitx5 fcitx5-mozc fcitx5-configtool \
fcitx5-qt fcitx5-gtk fcitx5-breeze mandoc neovim firefox xcursor-breeze \
noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-caladea \
ttf-carlito ttf-dejavu ttf-liberation ttf-opensans \
adobe-source-han-sans-jp-fonts adobe-source-han-serif-jp-fonts \
otf-ipafont ttf-hanazono pavucontrol pulseaudio-alsa pulseaudio \
libreoffice-fresh inkscape

sudo systemctl enable ly

cd $tempdir
git clone https://github.com/vinceliuice/Orchis-theme
cd Orchis-theme
./install.sh --shell 42 --round 8 --tweaks black

cd $scriptdir
sudo cp -r ../ttf/Blex /usr/share/fonts
fc-cache
sudo cp ./environment /etc

./xplr_setup.fish
./nvim_setup.bash
