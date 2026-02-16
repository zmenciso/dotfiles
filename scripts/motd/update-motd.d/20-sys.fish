#!/usr/bin/env fish

source 00-shared.fish

set load (cat /proc/loadavg | awk '{ print $1,$2,$3 }')
set load (string split ' ' $load)

set processes (ps -eo user=|sort|uniq -c | awk '{ print $2 " " $1 }' | string collect)
set p_root (echo $processes | grep root | awk '{ print $2 }')
set p_total (math (string join '+' (echo $processes | cut -d ' ' -f 2)))
set p_user (math $p_total - $p_root)

set gpu (lspci | grep -i vga | tail -n 1 | sed 's/.*\[\([^]]*\)\].*/\1/')
set cpu (string trim (lscpu | grep '^Model name' | cut -f 2 -d ':'))
set mem (free -htm | grep "Mem" | awk '{ print $3,$7,$2 }')
set mem (string split ' ' $mem)
set mem_raw (free -tm | grep "Mem" | awk '{ print $2,$3 }')
set mem_raw (string split ' ' $mem_raw)

set mem[1] (valcolor $mem_raw[1] $MEM_THRESH_BAD $MEM_THRESH_WARN -le)$mem[1]$NORMAL
set mem[2] (valcolor $mem_raw[2] $MEM_THRESH_BAD $MEM_THRESH_WARN -le)$mem[2]$NORMAL

for i in (seq 3)
    set load[$i] (valcolor $load[$i] $LOAD_THRESH_BAD $LOAD_THRESH_WARN -ge)$load[$i]$NORMAL
end

set p_root (valcolor $p_root $PROC_THRESH_BAD $PROC_THRESH_WARN -ge)$p_root$NORMAL
set p_total (valcolor $p_total $PROC_THRESH_BAD $PROC_THRESH_WARN -ge)$p_total$NORMAL
set p_user (valcolor $p_user $PROC_THRESH_BAD $PROC_THRESH_WARN -ge)$p_user$NORMAL

echo 'System Info:'

header Kernel "$(uname) $(uname -r)"
echo
header Uptime (uptime -p)
header Processes "$p_root (root), $p_user (user), $p_total (total)"
header Load "$load[1] (1m), $load[2] (5m), $load[3] (15m)"
echo
header CPU $cpu
header GPU $gpu
header Memory "$mem[1] used, $mem[2] free, $mem[3] total"
echo
