function zed
    set REMOTE kingfisher
    set BASEDIR '~'

    set PROTOCOL 'ssh://'

    argparse 'a/alive=?' 'p/path=?' h/help -- $argv
    or return

    if set -ql _flag_h
        echo 'dump [OPTIONS] FILES'
        echo '  -h  --help        Show this message'
        echo '  -a  --alive       Keep the terminal open'
        echo '  -p  --path        Use the specified path (not interactive)'
        return
    end

    if test (count $argv) -gt 0
        set dir (dirname $argv[1])
        set PROTOCOL ''
        set REMOTE ''
    end

    set -ql _flag_p
    and set dir /$BASEDIR/$_flag_p

    if not set -ql dir
        set tmpfile (ssh $REMOTE 'mktemp')
        ssh -t $REMOTE "xplr --print-pwd-as-result > $tmpfile"
        set dir (ssh $REMOTE "cat $tmpfile")
        ssh kingfisher "/bin/rm $tmpfile"
    end

    zeditor $PROTOCOL$REMOTE$dir &

    if not set -ql _flag_a
        disown
        exit
    end
end
