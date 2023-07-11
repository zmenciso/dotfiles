function marp-setup
    if not set -q MARP_TEMPLATE
        set MARP_TEMPLATE ~/vault/doc/COAIHWL/Marp/COAIHWL_Marp_1
    end

    if test (count $argv) = 0
        set argv (pwd)
    else if test (count $argv) -gt 1
        echo 'ERROR: Too many arguments'
        exit 1
    end

    echo 'Copying Markdown template...'
    cp $MARP_TEMPLATE/*.md $argv
    mv $argv/*.md $argv/(basename $argv).md

    echo 'Copying resources...'
    cp $MARP_TEMPLATE/*.svg $argv
end
