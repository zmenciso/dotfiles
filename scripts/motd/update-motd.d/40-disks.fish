#!/usr/bin/env fish

set DISKS / /home
set THRESHOLD 80

set -g white "\e[0;39m"
set green "\e[1;32m"
set red "\e[1;31m"
set dim "\e[2m"
set undim "\e[0m"

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

echo -e 'Disk Usage:'

for disk in $DISKS
    set usage (string split ' ' (echo $df | grep -e "$disk\$" | awk '{ print $2,$5 }'))

    set percent (string trim -c '%' $usage[2])
    if test $percent -le $THRESHOLD
        set bar (progress $percent $green)
    else
        set bar (progress $percent $red)
    end
   
    set message (string pad -w (math 50 - (string length $disk)) "$usage[2] used out of $usage[1]")
    echo -e "  $disk $message
  $bar"
end

echo
