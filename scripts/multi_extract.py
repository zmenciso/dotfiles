#!/usr/bin/env python3

import sys
import os
import subprocess
from multiprocessing import Process

from tools import query

# Globals
CMD = 'tar -xvf'
VERBOSE = True
INTERACTIVE = False


# Functions
def usage(exitcode=0):
    print(f'''python3 {sys.argv[0]} [options] FILES
        -h --help       Print this message
        -c --cmd        Specify command to use (default: 'tar -xvf')
        -i --interact   Interactive (approve each command to be started)
        -q --quiet      Don't print started/finished commands

        FILES supports globs (e.g. *.tar.gz)''')
    sys.exit(exitcode)


def spool(command):
    if VERBOSE:
        print(f"START {' '.join(command)}")

    exstate = subprocess.run(command)

    if VERBOSE:
        print(f"END {' '.join(command)} EXIT {exstate.returncode}")


# Main Execution
if __name__ == '__main__':
    args = sys.argv[1:]

    while len(args) and args[0].startswith('-'):
        if args[0] == '-c' or args[0] == '--cmd':
            CMD = args.pop(1)
        elif args[0] == '-q' or args[0] == '--quiet':
            VERBOSE = False
        elif args[0] == '-h' or args[0] == '--help':
            usage(0)
        elif args[0] == '-i' or args[0] == '--interact':
            INTERACTIVE = True
        else:
            usage(1)

        args.pop(0)

    if not len(args):
        usage(1)

    files = args

    # Dispatch jobs (each file is its own extraction)
    allow = True
    for file in files:
        command = CMD.split()
        command.append(os.path.realpath(file))

        if INTERACTIVE:
            allow = query(f'RUN {" ".join(command)} ?', 'yes')

        if allow:
            Process(target=spool, args=(command, )).start()
