function xcd
    set target (xplr --print-pwd-as-result)

    if test -d $target
        cd $target
    else
        cd (dirname $target)
    end
end
