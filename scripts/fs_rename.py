#!/usr/bin/env python

import os
import sys
import re

from tools import query
from tools import error

# Yes, I know this is literally the worst programming practice imaginable.
# This script was not worth the time to figure out how to do a reverse depth-
# first FS traversal, which would've removed the need for this awful global
# list.  RIP memory efficiency.

# Globals
targets = []
RECURSIVE = False
INTERACT = False
DIRS = True
FILES = True
HIDDEN = False
VERBOSE = True


# Functions
def usage(exitcode):
    ''' Display usage message'''
    print(f'''{sys.argv[0]} [options] paths...
    -t [from] [to]  Arbitrary transformation (regex, does not support POSIX classes, e.g. [:upper:])
    -d --no_dirs    Do not target directories for renaming
    -f --no_files   Do not target files for renaming
    -r --recursive  Recurse through directories
    -q --quiet      Suppress verbose output
    -i --interact   Interactive (Manually approve each renaming)
    -h --help       Print this message

    Replace the spaces in directories and filenames with underscores, including hidden files and directories.
    Default path is current working directory ({os.getcwd()}).

    Return value: Number of failed renames.
    ''')

    sys.exit(exitcode)


def gen_targets(path, regex):
    ''' Given path, append to global target list if file contains match to regex'''
    for item in os.scandir(path):
        match = re.search(regex, item.name)
        if item.is_dir():
            if match and DIRS:
                targets.append(item.path)
            if RECURSIVE:
                gen_targets(item.path, regex)
        elif item.is_file() and match and FILES:
            targets.append(item.path)


# Main Execution
if __name__ == '__main__':
    count = 0
    path = []
    args = sys.argv[1:]
    FROM = ' '
    TO = '_'
    EXIT_CODE = 0

    # Parse command line arguments

    while len(args) and args[0].startswith('-'):
        if args[0] == '-r' or args[0] == '--recursive':
            RECURSIVE = True
        elif args[0] == '-h' or args[0] == '--help':
            usage(0)
        elif args[0] == '-d' or args[0] == '--no_dirs':
            DIRS = False
        elif args[0] == '-f' or args[0] == '--no_files':
            FILES = False
        elif args[0] == '-q' or args[0] == '--quiet':
            VERBOSE = False
        elif args[0] == '-i' or args[0] == '--interact':
            INTERACT = True
        elif args[0] == '-t':
            FROM = str(args.pop(1))
            TO = str(args.pop(1))
        else:
            usage(1)

        args.pop(0)

    if not len(args):
        path.append(os.getcwd())
    else:
        path = args

    if VERBOSE:
        print('Generating target list...')

    for item in path:
        if os.path.isdir(item):
            gen_targets(item, FROM)
        elif os.path.isfile(item):
            targets.append(os.path.realpath(item))

    if VERBOSE:
        print(f'{len(targets)} targets found')

    for target in reversed(sorted(targets, key=lambda x: x.count('/'))):
        allow = True
        head, tail = os.path.split(target)
        tail = re.sub(FROM, TO, tail)

        if INTERACT:
            allow = query(f'{target} --> {head}/{tail}?', 'yes')
        elif VERBOSE:
            print(f'{target} --> {head}/{tail}')

        if allow:
            try:
                os.rename(target, f'{head}/{tail}')
                count += 1
            except Exception as e:
                error(f'Could not rename {target} ({e})')
                EXIT_CODE += 1

    if VERBOSE:
        print(f'Renamed {count} items ({EXIT_CODE} failures)')

    sys.exit(EXIT_CODE)
