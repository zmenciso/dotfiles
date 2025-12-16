#!/usr/bin/env fish
#
# Zephan M. Enciso

set CPFLAGS
set SCRIPTDIR (status dirname)

source $SCRIPTDIR/target_list.fish

function usage
    echo 'settings.fish [options] CATEGORY'
    echo
    echo 'options:
    -e   --export     Copy files from the dotfiles repo to the system
    -q   --quiet      Suppress verbose output
    -i   --interact   Interactive (Approve overwrites)
    -h   --help       Print this message'
    echo
    echo 'Categories (or "all")'

    for cat in $CATEGORIES
        echo '    '(string lower $cat)
    end

    echo '
This script only works when placed in the `scripts` directory of the dotfiles repo!'

end

function copy
    for loc in $targets
        if test -n "$argv[1]"
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
or usage && return 1

set -q _flag_h
and return 0

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

set_color green
if set -q _flag_e
    copy export
    echo "Successfully copied $count file(s) from the dotfiles repo to the system."
else
    copy
    echo "Successfully copied $count file(s) from the system to the dotfiles repo."
end
set_color normal

return 0
