function dump
    set -l REMOTE kingfisher
    set -l DUMPDIR /tank/www/dump
    set -l URL https://dump.duck-pond.org

    argparse --min-args=1 h/help r/rename -- $argv
    or return

    if set -ql _flag_h
        echo "Usage: dump [-h | --help] [-r | --rename] URLS"
        return
    end

    set urls

    for file in $argv
        if not test -f $file
            echo -n 'File not found: '
            set_color red
            echo -n $file
            set_color normal
            echo ' (skipping)'
            continue
        end

        if set -ql _flag_r
            read -p "echo -n 'Rename '; set_color green; echo -n $file; set_color normal; echo -n ' > '" dest
        else
            set dest (basename $file)
        end

        if test (cat /etc/hostname) = $REMOTE
            cp $file $DUMPDIR/$dest
        else
            hpnscp $file $REMOTE:$DUMPDIR/$dest
        end

        set urls $urls $URL/$dest
    end

    if test -n "$urls"
        echo $urls
        echo $urls | wl-copy
    else
        set_color red
        echo 'Error: No files uploaded'
        set_color normal
    end

end
