function hpnsshfs
    argparse --min-args=1 h/help 'r/remotedir=?' 'm/mountpoint=?' -- $argv
    or return

    if set -ql _flag_h
        echo 'hpnsshfs [-h | --help] [-r | --remotedir=NAME] [-m | --mountpoint=NAME]'
        return 0
    end

    set REMOTEDIR '~'
    set -ql _flag_r
    and set REMOTEDIR $_flag_r

    set MOUNTPOINT "$HOME/tank"
    set -ql _flag_m
    and set MOUNTPOINT $_flag_m

    sshfs -o follow_symlinks -o reconnect -o ssh_command='hpnssh' $argv[1]:$REMOTEDIR $MOUNTPOINT
end
