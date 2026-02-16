#!/usr/bin/env fish

source 00-shared.fish

function progress --description 'progress [AMOUNT] [COLOR]'
    set counter 0
    echo -n '['

    while test $counter -lt 100
        if test $argv[1] -ge $counter
            echo -ne "$argv[2]="
        else
            echo -ne "$white="
        end

        set counter (math $counter + 2)
    end

    echo "]$white"
end

set df (df -h | string collect)

echo 'Disk Usage:'

for disk in $DISKS
    set usage (string split ' ' (echo $df | grep -e "$disk\$" | awk '{ print $2,$5 }'))
    set percent (string trim -c '%' $usage[2])

    set color (valcolor $percent $DISK_THRESHOLD_BAD $DISK_THRESHOLD_WARN -ge)
    set length (string length "$usage[2] used out of $usage[1]")
    set message "$color$usage[2] used$NORMAL$DIM out of $NORMAL$usage[1]"

    dblprint $disk $message $length
    bar $percent $color

end

echo
