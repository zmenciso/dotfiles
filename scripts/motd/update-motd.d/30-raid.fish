#!/usr/bin/env fish

source 00-shared.fish

set desc (cat /proc/mdstat | grep -E 'md[0-9]+' | awk '{ print $1,$3,$4 }')
set stat (cat /proc/mdstat | sed -nr 's/\s+[0-9]+\sblocks.*(\[[U_]+\]$)/\1/p')

echo 'RAID Status:'

for i in (seq (count $desc))
    set array (string split ' ' $desc[$i])

    if string match -r -q -- active $array[2]
        set array[2] $GOOD$array[2]$NORMAL
    else
        set array[2] $BAD$array[2]$NORMAL
    end

    if string match -r -q -- _ $stat[$i]
        set stat[1] $BAD$stat[$i]$NORMAL
    else
        set stat[1] $GOOD$stat[$i]$NORMAL
    end

    header $array[1] "$array[2] ($array[3]) $stat[$i]"
end

echo
