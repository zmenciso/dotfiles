#!/usr/bin/env python

def bar(header=None, length=60):
    output = ''

    if header:
        output += (length*'#' + '\n')
        output += ('#' + header.center(length-2) + '#\n')

    output += (length*'#' + '\n\n')
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
        response = input(prompt + sel)
        if (default is not None) and len(response) == 0:
            return valid[default]
        elif response.lower() in valid:
            return valid[response.lower()]
