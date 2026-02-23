function fetch
    set REMOTE kingfisher
    set HERE (realpath (pwd))
    set BASEDIR '~'
    set ARGS -rauhL --info=progress2
    set PROTOCOL hpnssh

    set -l USAGE 'fetch [OPTIONS]
    -h  --help          Show this message
    -d  --dry-run       Simulate the transfer
    -p  --path          Use the specified path (not interactive)
    -t  --destination   Copy files to this dir instead of the CWD
    -e  --protocol      Specify the protocol (default: hpnssh)'

    argparse h/help d/dry-run 'p/path=?' 'e/protocol=?' 't/destination=?' -- $argv
    or echo $USAGE && return

    set -ql _flag_h
    and echo $USAGE && return

    set -ql _flag_d
    and set ARGS $ARGS --dry-run

    set -ql _flag_e
    and set PROTOCOL $_flag_e

    set -ql _flag_t
    and set HERE (realpath "$_flag_t")

    set -ql _flag_p
    and set target $_flag_p

    # Get target
    if not set -ql target
        set tmpfile (ssh $REMOTE 'mktemp')
        ssh -t $REMOTE "xplr --print-pwd-as-result > $tmpfile"
        set target (ssh $REMOTE "cat $tmpfile")
        ssh $REMOTE "/bin/rm $tmpfile"
    end

    rsync -e $PROTOCOL $ARGS $REMOTE:$target $HERE

end
