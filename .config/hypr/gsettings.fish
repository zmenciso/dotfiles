#!/usr/bin/env fish

set gtk_theme 'Nightfox-Dark-Compact-Carbon'
set icon_theme 'Papirus'
set cursor_theme 'Breeze'
set font_name 'BlexSans Nerd Font, 11'

set gnome_schema org.gnome.desktop.interface

gsettings set $gnome_schema gtk-theme $gtk_theme
gsettings set $gnome_schema icon-theme $icon_theme
gsettings set $gnome_schema cursor-theme $cursor_theme
gsettings set $gnome_schema font-name $font_name
