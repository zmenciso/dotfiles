#!/usr/bin/env python

# Collection of functions I like to use

import sys
import os


def bar(header=None, char='#', length=os.get_terminal_size()[0]):
    output = ''

    if header:
        output += (length*char + os.linesep)
        output += (char + header.center(length-2) + char + os.linesep)

    output += (length*char + 2 * os.linesep)
    return output


def query(prompt=None, default=None):
    '''Wait for user to input a y/n, with support for default'''

    valid = {'yes': True, 'y': True, 'ye': True, 'no': False, 'n': False}

    if default is None:
        sel = ' [y/n] '
    elif default == 'yes':
        sel = ' [Y/n] '
    elif default == 'no':
        sel = ' [y/N] '
    else:
        raise ValueError(f'Invalid default answer: {default}')

    while True:
        response = input('\033[93m' + prompt + sel + '\x1b[0m')
        if (default is not None) and len(response) == 0:
            return valid[default]
        elif response.lower() in valid:
            return valid[response.lower()]


def cprint(color, string, end=os.linesep, file=sys.stdout):
    bcolors = {
        'HEADER': '\033[95m',
        'OKBLUE': '\033[94m',
        'OKCYAN': '\033[96m',
        'OKGREEN': '\033[92m',
        'WARNING': '\033[93m',
        'FAIL': '\033[91m',
        'ENDC': '\033[0m',
        'BOLD': '\033[1m',
        'UNDERLINE': '\033[4m'
    }

    if color.upper() in bcolors:
        head = bcolors[color.upper()]
    else:
        head = f'\x1b[{color}m'

    tail = '\x1b[0m'

    print(head + string + tail, end=end, file=file)


def error(message, exitcode=None):
    cprint('0;31;40', f'ERROR: {message}', file=sys.stderr)

    if exitcode:
        sys.exit(exitcode)


def print_format_table():
    """
    prints table of formatted text format options
    """
    for style in range(8):
        for fg in range(30, 38):
            s1 = ''

            for bg in range(40, 48):
                format = ';'.join([str(style), str(fg), str(bg)])
                s1 += '\x1b[%sm %s \x1b[0m' % (format, format)

            print(s1)

        print(os.linesep)
