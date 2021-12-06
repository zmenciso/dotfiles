#!/usr/bin/env python

# Zephan M. Enciso
# Yes, this is a super dumb script with terrible coding practices.  It works,
# and time isn't really a factor here

import os
import shutil
import sys

from query import query
import target_list as tl

# Globals
VERBOSE = True
INTERACT = False
DIRECTION = 'import'
CATEGORY = 'all'
HOME = None
SCRIPTS = None

DIRECTIONS = {'import', 'export'}
CATEGORIES = {'panel', 'appearance', 'workspace', 'personalization', 'hardware', 'nvim', 'vim', 'bash', 'fish', 'ssh', 'fcitx', 'misc'}

# Functions
def usage(exitcode):
    ''' Display usage message'''
    print(f'''{sys.argv[0]} [options] [import/export] CATEGORY
    -q --quiet      Suppress verbose output
    -i --interact   Interactive (Manually approve each copy)
    -h --help       Print this message

    Categories (or 'all'):
        panel
        appearance
        workspace
        personalization
        hardware
        nvim
        vim
        bash
        fish
        ssh
        fcitx
        misc

    Import: Copy files from the system to the dotfiles repo
    Export: Copy files from the dotfiles repo to the system

    This script only works when placed in the `scripts` directory in the dotfiles repo!''')

    sys.exit(exitcode)

def copy_settings(category, homedir, scriptdir, direction):
    source = None
    destination = None
    count = 0
    for file in tl.decode_category(category):
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

    print(f'Successfully {DIRECTION}ed {count} file(s).')

    sys.exit(0)
