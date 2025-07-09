function link
    set -l REMOTE kingfisher
    set -l LINKDIR /tank/www/link/redirects/
    set -l URL https://link.duck-pond.org

    set -l HASH 4 # Number of characters to keep from hash

    argparse --min-args=1 h/help r/rename -- $argv
    or return

    if set -ql _flag_h
        echo 'dump [OPTIONS] URLs'
        echo '  -h  --help        Show this message'
        echo '  -r  --rename      Manually specify the link name'
        return
    end

    set urls

    for url in $argv
        if set -ql _flag_r
            read -p "echo -n 'Rename '; set_color green; echo -n $url; set_color normal; echo -n ' > '" link
        else
            set -l start 1

            set -l hash (echo $url | md5sum | cut -f 1 -d ' ')
            set link (string sub -l $HASH -s $start $hash)
        end

        if test (cat /etc/hostname) = $REMOTE
            # Already on $REMOTE, so just make the file
            echo $url >$LINKDIR/$link
            chmod a+r $LINKDIR/$link
        else
            # Create temporary file to transfer
            set -l temp (mktemp)
            echo $url >$temp

            # Send the file with hpnscp (requires ssh config)
            hpnscp $temp $REMOTE:$LINKDIR/$link
            ssh $REMOTE "chmod a+r $LINKDIR/$link"
        end

        set urls $urls $URL/$link

    end

    if test -n "$urls"
        echo $urls

        # Automatically copy URL
        switch $XDG_SESSION_TYPE
            case wayland
                echo $urls | wl-copy
            case x11
                echo $urls | xclip
        end

    else
        set_color red
        echo 'Error: No links created'
        set_color normal

    end

end
