#!/usr/bin/env fish

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

    echo ']'
end

set df (df -h | string collect)
set data (string split ' ' (echo $df | grep -e '/$' | awk '{ print $2,$5 }'))
set tank (string split ' ' (echo $df | grep -e '/mnt$' | awk '{ print $2,$5 }'))

if test (string trim -c '%' $data[2]) -le $THRESHOLD
	set d_bar (progress (string trim -c '%' $data[2]) $green)
else
	set d_bar (progress (string trim -c '%' $data[2]) $red)
end

if test (string trim -c '%' $tank[2]) -le $THRESHOLD
	set t_bar (progress (string trim -c '%' $tank[2]) $green)
else
	set t_bar (progress (string trim -c '%' $tank[2]) $red)
end

echo -e "Disk Usage:
  data $(string pad -w 46 "$data[2] used out of $data[1]")
  $d_bar
  tank $(string pad -w 46 "$tank[2] used out of $tank[1]")
  $t_bar
  "
