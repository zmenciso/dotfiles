function yt
    set TARGET ~/vid
    set REMOTE kingfisher

    set -l USAGE 'yt [OPTIONS]
    -r  --remote        Use default remote server, or specify one
    -d  --dir           Overwrite default directory option
    -u  --url           Manually specify a url (do not pull from clipboard)'

    argparse r/remote=? d/dir= u/url=+ -- $argv
    or echo $USAGE && return

    if set -q _flag_u
        set URLS $_flag_u
    else
        set URLS (wl-paste)
    end

    set -q _flag_d
    and set TARGET (dirname $_flag_d)

    set orig_dir (pwd)

    if set -q _flag_r
        test -n "$_flag_r"
        and set -l REMOTE $_flag_r

        set tmpfile (ssh $REMOTE 'mktemp')
        ssh -t $REMOTE "xplr --print-pwd-as-result > $tmpfile"
        set target (ssh $REMOTE "cat $tmpfile")
        ssh $REMOTE "/bin/rm $tmpfile"

        ssh $REMOTE "yt -u $URLS -d $target"
    else
        cd $TARGET
        yt-dlp $URLS
        cd $orig_dir
    end

end
