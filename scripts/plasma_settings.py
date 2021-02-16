#!/usr/bin/env python

import os
import shutil
import sys

from query import query

# Globals
VERBOSE = True
INTERACT = False
DIRECTION = 'import'
CATEGORY = 'all'
HOME = None
SCRIPTS = None

DIRECTIONS = {'import', 'export'}
CATEGORIES = {'panel', 'appearance', 'workspace', 'personalization', 'hardware'}

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

# Functions
def usage(exitcode):
    ''' Display usage message'''
    print(f'''{sys.argv[0]} [options] [import/export] CATEGORY
    -q --quiet      Suppress verbose output
    -i --interact   Interactive (Manually approve each copy)
    -h --help       Print this message

    Categories:
        all
        panel
        appearance
        workspace
        personalization
        hardware

    Import: Copy files from the system to the dotfiles repo
    Export: Copy files from the dotfiles repo to the system

    This script only works when placed in the `scripts` directory in the dotfiles repo!''')

    sys.exit(exitcode)

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
    else:
        print(f'ERROR: Category "{text}" not found.', file=sys.stderr)
        sys.exit(5)

def copy_settings(category, homedir, scriptdir, direction):
    count = 0
    for file in decode_category(category):
        allow = True
        if direction == 'import':
            source = os.path.realpath(homedir + '/' + file)
            destination = os.path.realpath(scriptdir + '/../' + file)
        elif direction == 'export':
            destination = os.path.realpath(homedir + '/' + file)
            source = os.path.realpath(scriptdir + '/../' + file)
        else:
            print(f"ERROR: Invalid direction '{direction}'", file=sys.stderr)

        if INTERACT:
            allow = query(f'{source} --> {destination}?', 'yes')
        elif VERBOSE:
            print(f'{source} --> {destination}')

        if allow:
            try:
                shutil.copy2(source, destination)
                count += 1
            except Exception as e:
                if VERBOSE:
                    print(f'ERROR: Could not copy {source} to {destination} ({e})', file=sys.stderr)

    return count

# Main Execution
if __name__ == '__main__':
    args = sys.argv[1:]
    EXIT_CODE = 0

    while len(args) and args[0].startswith('-'):
        if args[0] == '-h' or args[0] == '--help':
            usage(0)
        elif args[0] == '-q' or args[0] == '--quiet':
            VERBOSE = False
        elif args[0] == '-i' or args[0] == '--interact':
            INTERACT = True
        else:
            usage(1)

        args.pop(0)

    if len(args) != 2:
        usage(1)
    else:
        DIRECTION = args[0].strip().lower()
        CATEGORY = args[1].strip().lower()

    if DIRECTION not in DIRECTIONS:
        usage (2)
    if CATEGORY not in CATEGORIES and CATEGORY != 'all':
        usage(3)

    try:
        HOME = os.path.realpath(os.getenv('HOME'))
    except Exception as e:
        print(f'ERROR: Could not get home directory ({e})', file=sys.stderr)
        sys.exit(4)

    try:
        SCRIPTS = os.path.dirname(os.path.realpath(sys.argv[0]))
    except Exception as e:
        print(f'ERROR: Could not translate scripts directory ({e})', file=sys.stderr)
        sys.exit(7)

    count = 0
    if CATEGORY != 'all':
        count += copy_settings(CATEGORY, HOME, SCRIPTS, DIRECTION)
    elif CATEGORY == 'all':
        for item in CATEGORIES:
            count += copy_settings(item, HOME, SCRIPTS, DIRECTION)
    else:
        print(f'ERROR: Could not {DIRECTION} from {CATEGORY}', file=sys.stderr)
        sys.exit(6)

    print(f'Successfully {DIRECTION}ed {count} files.')

    sys.exit(0)
