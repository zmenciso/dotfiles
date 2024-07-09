#!/usr/bin/env fish

set MEM_THRESH 1000
set LOAD_THRESH 10

set white "\e[0;39m"
set green "\e[1;32m"
set red "\e[1;31m"
set dim "\e[2m"
set undim "\e[0m"

set load (cat /proc/loadavg | awk '{ print $1,$2,$3 }')
set load (string split ' ' $load)

set processes (ps -eo user=|sort|uniq -c | awk '{ print $2 " " $1 }' | string collect)
set p_root (echo $processes | grep root | awk '{ print $2 }')
set p_total (math (string join '+' (echo $processes | cut -d ' ' -f 2)))
set p_user (math $p_total - $p_root)

# set cpu (string trim (lscpu | grep '^Model name' | cut -f 2 -d ':'))
set mem (free -htm | grep "Mem" | awk '{ print $3,$7,$2 }')
set mem (string split ' ' $mem)
set mem_raw (free -tm | grep "Mem" | awk '{ print $2,$3 }')
set mem_raw (string split ' ' $mem_raw)

if test (math $mem_raw[1] - $mem_raw[2]) -le $MEM_THRESH
	set mem[1] $red$mem[1]$white
	set mem[2] $red$mem[2]$white
else
	set mem[1] $green$mem[1]$white
	set mem[2] $green$mem[2]$white
end

for i in (seq 3)
	if test $load[$i] -ge $LOAD_THRESH
		set load[$i] $red$load[$i]$white
	else
		set load[$i] $green$load[$i]$white
	end
end

# System info
echo -e "
System Info:
  Kernel........: $(uname) $(uname -r)

  Uptime........: $(uptime -p)
  Processes.....: $green$p_root$white (root), $green$p_user$white (user), $green$p_total$white (total)
  Load..........: $load[1] (1m), $load[2] (5m), $load[3] (15m)

  CPU...........: $cpu
  Memory........: $mem[1] used, $mem[2] free, $mem[3] total
  "
