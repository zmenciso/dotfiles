import sys

MISC = {
        'bg.png',
        'lck.png',
        'face.png'
}

BASH = {
        '.bashrc'
}

VIM = {
        '.vimrc'
}

NVIM = {
        '.config/nvim/init.vim'
}

FCITX = {
        '.config/fcitx/config'
}

FISH = {
        '.config/fish/config.fish',
        '.config/fish/functions/fish_mode_prompt.fish',
        '.config/fish/functions/fish_prompt.fish',
        '.config/fish/fish_variables',
}

SSH = {
        '.ssh/config'
}

PANEL = {
        '.config/plasma-org.kde.plasma.desktop-appletsrc'
}

APPEARANCE = {
    '.config/kdeglobals',
    '.config/kscreenlockerrc',
    '.config/kwinrc',
    '.config/gtkrc',
    '.config/gtkrc-2.0',
    '.config/gtk-4.0/settings.ini',
    '.config/gtk-3.0/settings.ini',
    '.config/gtk-3.0/gtk.css',
    '.config/gtk-3.0/window_decorations.css',
    '.config/gtk-3.0/colors.css',
    '.config/ksplashrc',
    '.config/plasmarc',
    '.config/Trolltech.conf',
    '.config/breezerc',
    '.config/kcmfonts',
    '.config/kcminputrc',
    '.config/kfontinstuirc',
    '.config/ksplashrc'
}

WORKSPACE = {
    '.config/plasmarc',
    '.config/kwinrc',
    '.config/kglobalshortcutsrc',
    '.config/kwinrulesrc',
    '.config/khotkeys',
    '.config/kded5rc',
    '.config/ksmserverrc',
    '.config/krunnerrc',
    '.config/baloofilerc'
}

PERSONALIZATION = {
    '.config/plasmanotifyrc',
    '.config/plasma-localerc',
    '.config/ktimeonedrc',
    '.config/kaccessrc',
    '.config/kdeglobals'
    '.config/PlasmaUserFeedback'
}

HARDWARE = {
    '.config/kcminputrc',
    '.config/kxkbrc',
    '.config/kgammarc',
    '.config/powermanagementprofilesrc',
    '.config/bluedevilglobalrc',
    '.config/kdeconnect',
    '.config/device_automounter_kcmrc',
    '.config/kded5rc',
    '.config/kded_device_automounterrc'
}

def decode_category(text):
    if text == 'panel':
        return PANEL
    elif text == 'appearance':
        return APPEARANCE
    elif text == 'workspace':
        return WORKSPACE
    elif text == 'personalization':
        return PERSONALIZATION
    elif text == 'hardware':
        return HARDWARE
    elif text == 'nvim':
        return NVIM
    elif text == 'vim':
        return VIM
    elif text == 'bash':
        return BASH
    elif text == 'fish':
        return FISH
    elif text == 'ssh':
        return SSH
    elif text == 'fcitx':
        return FCITX
    elif text == 'misc':
        return MISC
    else:
        print(f'ERROR: Category "{text}" not found.', file=sys.stderr)
        sys.exit(5)
