function dump
    set -l REMOTE kingfisher
    set -l DUMPDIR /tank/www/dump

    for file in $argv
        if test (hostname) = $REMOTE
            cp $file $DUMPDIR
        else
            hpnscp $file $REMOTE:$DUMPDIR
        end
    end
end
