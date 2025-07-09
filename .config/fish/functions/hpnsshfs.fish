function hpnsshfs

    argparse --min-args=1 h/help r/remote=? m/mountpoint=? -- $argv

    if set -ql _flag_h
        echo 'hpnsshfs [-h | --help] [-r | --remote=NAME] [-m | --mountpoint=NAME]'
        return 0
    end

    if test -n "$_flag_r"
        set REMOTE $_flag_r
    else
        set REMOTE '~'
    end

    if test -n "$_flag_m"
        set MOUTNPOINT $_flag_m
    else
        set MOUNTPOINT '~/tank'
    end

    sshfs -o follow_symlinks -o reconnect -o ssh_command='hpnssh' $argv[1]:$REMOTE $MOUNTPOINT
end
