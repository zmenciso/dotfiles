#!/usr/bin/env fish
#
# Zephan M. Enciso

set CPFLAGS
set SCRIPTDIR (status dirname)

source $SCRIPTDIR/target_list.fish

function usage
    echo 'settings.fish [options] IMPORT/EXPORT CATEGORY'
    echo
    echo 'options:
    -q   --quiet      Suppres verbose output
    -i   --interact   Interactive (Approve overwrites)
    -h   --help       Print this message'
    echo
    echo 'Categories (or \"all\")'

    for cat in $CATEGORIES
        string lower $cat
    end

    echo '
    Import/i: Copy files from the system to the dotfiles repo
    Export/e: Copy files from the dotfiles repo to the system
    '

    echo '
This script only works when placed in the `scripts` directory of the dotfiles repo!
    '

    return $argv[1]
end

function copy
    for loc in $targets
        if set -q _flag_e
            # Export (copy from dotfiles repo to system)
            /bin/cp $CPFLAGS $SCRIPTDIR/../$loc (dirname $HOME/$loc)
            and set count (math $count + 1)
        else
            # Import (copy from the system to the dotfiles repo)
            /bin/cp $CPFLAGS $HOME/$loc (dirname $SCRIPTDIR/../$loc)
            and set count (math $count + 1)
        end
    end
end

argparse -N 1 q/quiet i/interact e/export h/help -- $argv
or usage 1

set -q _flag_h
and usage 0

set -q _flag_i
and set CPFLAGS $CPFLAGS -i

set -q _flag_q
or set CPFLAGS $CPFLAGS -v

set cat (string upper $argv)

set -q HOME
or echo 'Cannot get home directory' && return 4

set count 0
contains ALL $cat
and set cat $CATEGORIES
for list in $cat
    set targets $targets $$list
end

copy

set_color green
if set -q _flag_e
    echo "Successfully copied $count file(s) from the dotfiles repo to the system."
else
    echo "Successfully copied $count file(s) from the system to the dotfiles repo."
end
set_color normal

return 0
