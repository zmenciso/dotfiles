function marp-setup
    if not set -q MARP_TEMPLATE
        set MARP_TEMPLATE ~/vault/doc/COAIHWL/Marp/COAIHWL_Marp_1
    end

    if test (count $argv) = 0
        set argv (pwd)
    else if test (count $argv) -gt 1
        echo 'ERROR: Too many arguments'
        return 1
    end

    echo 'Copying Markdown template...'
    if not test -e $argv
        mkdir -p $argv
    end
    if not test -d $argv
        echo "ERROR: $argv is not a valid destination"
        return 2
    end
    cp $MARP_TEMPLATE/*.md $argv
    mv $argv/*.md $argv/(basename $argv).md

    echo 'Copying resources...'
    cp $MARP_TEMPLATE/*.svg $argv

    echo 'Customizing template...'
    set date (basename $argv | grep -E --only-matching "[0-9]+-[0-9]+-[0-9]+")
    if test -z "$date"
        set date (date +%Y-%m-%d)
    end
    sed -i "s/yyyy-mm-dd/$date/g" $argv/*.md
end
