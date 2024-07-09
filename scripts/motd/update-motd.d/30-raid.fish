#!/usr/bin/env fish

set white "\e[0;39m"
set green "\e[1;32m"
set red "\e[1;31m"
set dim "\e[2m"
set undim "\e[0m"

set raid (cat /proc/mdstat | grep blocks | grep -o '\[.*\]')

echo -e "RAID Status: $raid
"
