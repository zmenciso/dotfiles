#!/usr/bin/env python

# Zephan M. Enciso

import os
import shutil
import sys
import argparse

from tools import query, error, cprint
import target_list as tl

# Global Variables

VERBOSE = True
INTERACT = False
DIRECTION = 'import'
CATEGORY = 'ALL'
HOME = None
SCRIPTS = None

CATEGORIES = set(tl.CATEGORIES.keys())

def create_custom_help():
    # Create the categories list
    categories_help = '\n'.join(' ' * 8 + cat.lower() for cat in CATEGORIES)

    # Create the complete help message
    return f'''%(prog)s [options] [import/export] CATEGORY

options:
    -q --quiet      Suppress verbose output
    -i --interact   Interactive (Manually approve each copy)
    -h --help       Print this message

Categories (or "all"):
{categories_help}

    Import/i: Copy files from the system to the dotfiles repo
    Export/e: Copy files from the dotfiles repo to the system

    This script only works when placed in the `scripts` directory in the dotfiles repo!'''


def copy(src, dst):
    allow = True
    copied = False

    if INTERACT:
        allow = query(f'{src} --> {dst}?', 'no')

    if allow:
        dirname = os.path.dirname(dst)

        try:
            if not os.path.isdir(dirname):
                os.mkdir(dirname)

        except Exception as e:
            if VERBOSE:
                error(f'Could not create {dirname} ({e})')
                return False

        try:
            shutil.copy2(src, dst)
            copied = True
            if VERBOSE and not INTERACT:
                print(f'{src} --> {dst}')

        except Exception as e:
            if VERBOSE:
                error(f'Could not copy {src} to {dst} ({e})')
                return False

    return copied


def copy_settings(category, homedir, scriptdir, direction):
    if category not in CATEGORIES:
        error(f"Invalid category '{category}'", 0)

    source = None
    destination = None
    count = 0

    for file in tl.decode_category(category):
        if 'i' in direction.lower():
            source = os.path.join(homedir, file)
            destination = os.path.join(scriptdir, '..', file)
        elif 'e' in direction.lower():
            destination = os.path.join(homedir, file)
            source = os.path.join(scriptdir, '..', file)
        else:
            error(f"Invalid direction '{direction}'", 0)

        if copy(source, destination):
            count += 1

    return count


# Main Execution
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Copy dotfiles to or from dotfiles repo',
        usage=create_custom_help(),
        add_help=False
    )

    # Add arguments
    parser.add_argument('direction',
                       help=argparse.SUPPRESS,
                       choices=['import', 'export', 'i', 'e'])
    parser.add_argument('category',
                       help=argparse.SUPPRESS,
                       nargs='+')
    parser.add_argument('-q', '--quiet',
                       action='store_true',
                       help=argparse.SUPPRESS)
    parser.add_argument('-i', '--interact',
                       action='store_true',
                       help=argparse.SUPPRESS)
    parser.add_argument('-h', '--help',
                       action='help',
                       help=argparse.SUPPRESS)

    # Parse arguments
    args = parser.parse_args()

    # Set variables based on parsed arguments
    VERBOSE = not args.quiet
    INTERACT = args.interact
    DIRECTION = args.direction.strip().lower()
    CATEGORY = [arg.strip().upper() for arg in args.category]
    EXIT_CODE = 0

    try:
        HOME = os.path.realpath(os.getenv('HOME'))
    except Exception as e:
        error(f'Could not get home directory ({e})', 4)

    try:
        SCRIPTS = os.path.dirname(os.path.realpath(sys.argv[0]))
    except Exception as e:
        error(f'Could not translate scripts directory ({e})', 7)

    count = 0
    if 'ALL' in CATEGORY:
        for item in CATEGORIES:
            count += copy_settings(item, HOME, SCRIPTS, DIRECTION)
    else:
        for item in CATEGORY:
            count += copy_settings(item, HOME, SCRIPTS, DIRECTION)

    cprint('OKGREEN', f'Successfully {DIRECTION}ed {count} file(s).')

    sys.exit(0)
