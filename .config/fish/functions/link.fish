function link
    set -l LINKDIR /tank/www/link/redirects/
    set -l URL https://link.duck-pond.org

    set -l HASH 4 # Number of characters to keep from hash

    argparse --min-args=1 h/help -- $argv
    or return

    if set -ql _flag_h
        echo 'dump [OPTIONS] URLs'
        echo '  -h  --help        Show this message'
        return
    end

    set urls

    for url in $argv
        set -l start 1

        set -l hash (echo $url | md5sum | cut -f 1 -d ' ')
        set -l link (string sub -l $HASH -s $start $hash)

        # Get new link name
        while test -f $LINKDIR/$link
            set start (math $start + 1)
            set link (string sub -l $HASH -s $start $hash)
        end

        # Create file
        echo $url >$LINKDIR/$link

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
