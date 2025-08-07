function dump
    set -l REMOTE kingfisher
    set -l DUMPDIR /tank/www/dump
    set -l URL https://dump.duck-pond.org

    set -l LEN 5 # Number of characters to use for filename

    argparse --min-args=1 k/keep h/help r/rename -- $argv
    or return

    if set -ql _flag_h
        echo 'dump [OPTIONS] FILES'
        echo '  -h  --help        Show this message'
        echo '  -k  --keep        Keep the original filename'
        echo '  -r  --rename      Manually specify the filename'
        return
    end

    set urls

    for file in $argv
        # Bypass copy if file does not exist
        if not test -f $file
            echo -n 'File not found: '
            set_color red
            echo -n $file
            set_color normal
            echo ' (skipping)'
            continue
        end

        if set -ql _flag_k
            # Keep the original filename
            set dest (basename $file)
        else if set -ql _flag_r
            # Manually rename file
            read -p "echo -n 'Rename '; set_color green; echo -n $file; set_color normal; echo -n ' > '" dest
        else
            # Replace the filename with random characters
            set -l ext (path extension $file)
            set dest (head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c $LEN)$ext
            echo $dest
        end

        if test (cat /etc/hostname) = $REMOTE
            # Already on $REMOTE, so just copy the file
            cp $file $DUMPDIR/$dest
            chmod a+r $DUMPDIR/$dest
        else
            # Send the file with hpnscp (requires ssh config)
            hpnscp $file $REMOTE:$DUMPDIR/$dest
            ssh $REMOTE "chmod a+r $DUMPDIR/$dest"
        end

        # Add new URL to list
        set urls $urls $URL/$dest
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
        echo 'Error: No files uploaded'
        set_color normal

    end

end
