#!/usr/bin/env fish

set white "\e[0;39m"
set green "\e[1;32m"
set red "\e[1;31m"
set dim "\e[2m"
set undim "\e[0m"

set desc (cat /proc/mdstat | grep -E 'md[0-9]+' | awk '{ print $1,$3,$4 }')
set stat (cat /proc/mdstat | sed -nr 's/\s+[0-9]+\sblocks.*(\[[U_]+\]$)/\1/p')

echo -e 'RAID Status:'

for i in (seq (count $desc))
    set array (string split ' ' $desc[$i])
    set spacer (string pad -c '.' -w (math 15 - (string length $array[1])) :)
    echo -e -n "  $array[1]$spacer "
   
    if string match -r -q -- 'active' $array[2]
        echo -e -n "$green$array[2]$white"
    else
        echo -e -n "$red$array[2]$white"
    end

    echo -e -n " ($array[3]) "

    if string match -r -q -- '_' $stat[$i]
        echo -e "$red$stat[$i]$white"
    else
        echo -e "$green$stat[$i]$white"
    end
end
