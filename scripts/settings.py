#!/usr/bin/env python

# Zephan M. Enciso
# Yes, this is a super dumb script with terrible coding practices.  It works,
# and time isn't really a factor here

import os
import shutil
import sys

from tools import query
from tools import error
from tools import cprint
import target_list as tl

# Globals
VERBOSE = True
INTERACT = False
DIRECTION = 'import'
CATEGORY = 'all'
HOME = None
SCRIPTS = None

DIRECTIONS = {'import', 'export'}
CATEGORIES = set(tl.CATEGORIES.keys())


# Functions
def usage(exitcode):
    ''' Display usage message'''
    print(f'''{sys.argv[0]} [options] [import/export] CATEGORY
    -q --quiet      Suppress verbose output
    -i --interact   Interactive (Manually approve each copy)
    -h --help       Print this message

    Categories (or "all"):''')

    for cat in CATEGORIES:
        print(' ' * 8 + cat.lower())

    print('''
    Import: Copy files from the system to the dotfiles repo
    Export: Copy files from the dotfiles repo to the system

    This script only works when placed in the `scripts` directory in the dotfiles repo!'''
          )

    sys.exit(exitcode)


def copy_settings(category, homedir, scriptdir, direction):
    if category not in CATEGORIES:
        error(f"Invalid category '{category}'", 0)

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
            error(f"Invalid direction '{direction}'", 0)

        if INTERACT:
            allow = query(f'{source} --> {destination}?', 'no')

        if allow:
            dirname = os.path.dirname(destination)

            try:
                if not os.path.isdir(dirname):
                    os.mkdir(dirname)

                shutil.copy2(source, destination)
                count += 1
                if VERBOSE and not INTERACT:
                    print(f'{source} --> {destination}')

            except Exception as e:
                if VERBOSE:
                    error(f'Could not copy {source} to {destination} ({e})')

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

    if len(args) < 2:
        usage(1)
    else:
        DIRECTION = args.pop(0).strip().lower()
        CATEGORY = args

    try:
        HOME = os.path.realpath(os.getenv('HOME'))
    except Exception as e:
        error(f'Could not get home directory ({e})', 4)

    try:
        SCRIPTS = os.path.dirname(os.path.realpath(sys.argv[0]))
    except Exception as e:
        error(f'Could not translate scripts directory ({e})', 7)

    count = 0
    if 'all' in CATEGORY:
        for item in CATEGORIES:
            count += copy_settings(item, HOME, SCRIPTS, DIRECTION)
    else:
        for item in CATEGORY:
            count += copy_settings(item.strip().upper(), HOME, SCRIPTS,
                                   DIRECTION)

    cprint('OKGREEN', f'Successfully {DIRECTION}ed {count} file(s).')

    sys.exit(0)
