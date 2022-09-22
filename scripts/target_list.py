import sys

CATEGORIES = {
    'MISC': {'bg.jpg', 'lck.jpg', 'face.png', '.config/user-dirs.dirs'},
    'BASH': {'.bashrc'},
    'VIM': {'.vimrc'},
    'NVIM': {'.config/nvim/init.lua'},
    'XPLR': {'.config/xplr/init.lua'},
    'TMUX': {
        '.tmux.conf',
        '.config/tmux-powerline/themes/default.sh'
    },
    # 'FCITX': {'.config/fcitx/config', '.pam_environment'},
    'MOZC': {'.config/mozc/ibus_config.textproto'},
    'HYPRLAND': {
        '.config/hypr/hyprland.conf',
        '.config/hypr/hyprpaper.conf',
        '.config/hypr/lock.bash',
        '.xsettingsd',
        '.config/mimeapps.list',
        '.wrappedhl'
    },
    'WAYBAR': {
        '.config/waybar/config.jsonc',
        '.config/waybar/style.css'
    },
    'FISH': {
        '.config/fish/config.fish',
        '.config/fish/functions/mdpdf.fish',
        '.config/fish/functions/fish_mode_prompt.fish',
        '.config/fish/functions/fish_prompt.fish',
        '.config/fish/functions/fish_prompt_simple.fish',
        '.config/fish/functions/fish_prompt_colorful.fish',
        '.config/fish/functions/cp.fish',
        '.config/fish/functions/df.fish',
        '.config/fish/functions/diff.fish',
        '.config/fish/functions/dir.fish',
        '.config/fish/functions/egrep.fish',
        '.config/fish/functions/fgrep.fish',
        '.config/fish/functions/grep.fish',
        '.config/fish/functions/ls.fish',
        '.config/fish/functions/mv.fish',
        '.config/fish/functions/rm.fish',
        '.config/fish/functions/vdir.fish',
        '.config/fish/functions/xcd.fish',
        '.config/fish/functions/xplr.fish',
        '.config/fish/functions/yldme.fish',
        '.config/fish/functions/yldme-link.fish',
        '.config/fish/fish_variables',
    },
    # 'SSH': {'.ssh/config'},
    # 'PANEL': {'.config/plasma-org.kde.plasma.desktop-appletsrc'},
    # 'APPEARANCE': {
    #     '.config/kdeglobals', '.config/kscreenlockerrc', '.config/kwinrc',
    #     '.config/gtkrc', '.config/gtkrc-2.0', '.config/gtk-4.0/settings.ini',
    #     '.config/gtk-3.0/settings.ini', '.config/gtk-3.0/gtk.css',
    #     '.config/gtk-3.0/window_decorations.css', '.config/gtk-3.0/colors.css',
    #     '.config/ksplashrc', '.config/plasmarc', '.config/Trolltech.conf',
    #     '.config/breezerc', '.config/kcmfonts', '.config/kcminputrc',
    #     '.config/kfontinstuirc', '.config/ksplashrc'
    # },
    # 'WORKSPACE': {
    #     '.config/plasmarc', '.config/kwinrc', '.config/kglobalshortcutsrc',
    #     '.config/kwinrulesrc', '.config/khotkeys', '.config/kded5rc',
    #     '.config/ksmserverrc', '.config/krunnerrc', '.config/baloofilerc'
    # },
    # 'PERSONALIZATION': {
    #     '.config/plasmanotifyrc', '.config/plasma-localerc',
    #     '.config/ktimeonedrc', '.config/kaccessrc', '.config/kdeglobals'
    #     '.config/PlasmaUserFeedback'
    # },
    # 'HARDWARE': {
    #     '.config/kcminputrc', '.config/kxkbrc', '.config/kgammarc',
    #     '.config/powermanagementprofilesrc', '.config/bluedevilglobalrc',
    #     '.config/kdeconnect', '.config/device_automounter_kcmrc',
    #     '.config/kded5rc', '.config/kded_device_automounterrc'
    # },
    'I3': {
        '.config/i3/config',
        '.config/i3/lock.bash',
        '.config/picom/picom.conf',
        '.config/mimeapps.list',
        '.config/i3/xinput.fish',
        '.Xresources',
        '.xsettingsd'
    },
    'ROFI': {
        '.config/rofi/theme.rasi',
        '.config/rofi/config.rasi'
    },
    'ALACRITTY': {
        '.config/alacritty/alacritty.yml'
    },
    'DUNST': {
        '.config/dunst/dunstrc'
    },
    'SPOTIFY': {
        '.config/spotifyd/spotifyd.conf'
    },
    'I3STATUS': {
        '.config/i3status/config',
        '.config/i3status/config-small'
    },
    'BUMBLEBEE': {
        '.config/bumblebee-status/themes/moonfly-powerline.json',
        '.config/bumblebee-status/themes/moonfly-powerline-small.json',
        '.config/bumblebee-status/themes/icons/powerline.json'
    }
}


def decode_category(text):
    if text.upper() in CATEGORIES:
        return CATEGORIES[text.upper()]
    else:
        print(f'ERROR: Category "{text}" not found.', file=sys.stderr)
        sys.exit(5)
