function hpnsshfs
    set RDIR /home/zmenciso
    set MOUNTPOINT /home/zmenciso/tank

    argparse --min-args=1 h/help r/remotedir=? m/mountpoint=? -- $argv

    if set -ql _flag_h
        echo 'hpnsshfs [-h | --help] [-r | --remotedir=NAME] [-m | --mountpoint=NAME]'
        return 0
    end

    set -q _flag_r
    and set RDIR $_flag_r

    set -q _flag_m
    and set MOUNTPOINT $_flag_m

    sshfs -o follow_symlinks -o reconnect -o ssh_command='hpnssh' $argv[1]:$RDIR $MOUNTPOINT
end
