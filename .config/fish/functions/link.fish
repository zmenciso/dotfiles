function link
    set -l REMOTE kingfisher
    set -l LINKDIR /tank/www/link/redirects/
    set -l URL https://link.duck-pond.org

    set -l USAGE 'link [OPTIONS] URLs
    -h  --help        Show this message
    -r  --rename      Manually specify the link name'

    set -l LEN 4 # Number of characters to use for link

    argparse --min-args=1 h/help r/rename -- $argv
    or echo $USAGE && return

    set -ql _flag_h
    and echo $USAGE && return

    set urls

    for url in $argv
        if set -ql _flag_r
            read -p "echo -n 'Rename '; set_color green; echo -n $url; set_color normal; echo -n ' > '" link
        else
            set link (head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $LEN)
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
