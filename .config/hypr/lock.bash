#!/bin/bash

BLANK='#00000000'
CLEAR='#8cc85f22'
DEFAULT='#323437cc'
TEXT='#eeeeeeff'
WRONG='#ff5454bb'
VERIFYING='#80a0ffbb'
CAPS='e3c78acc'

# Options to pass to swaylock
swaylock_options="--indicator-radius 80 \
--inside-ver-color $CLEAR \
--ring-ver-color $VERIFYING \
--ring-caps-lock-color $CAPS \
--ring-color $DEFAULT \
--ring-wrong-color $WRONG \
--line-color $BLANK \
\
--layout-bg-color $BLANK \
--layout-border-color $BLANK \
--inside-wrong-color $BLANK \
\
--separator-color $DEFAULT \
--inside-color $BLANK \
--line-ver-color $BLANK \
--line-wrong-color $BLANK \
--line-caps-lock-color $BLANK \
\
--text-ver-color $TEXT \
--text-wrong-color $TEXT \
--layout-text-color $TEXT \
--key-hl-color $WRONG \
--caps-lock-key-hl-color $WRONG \
--bs-hl-color $WRONG \
\
--daemonize \
\
-l \
-k \
-F \
-i /home/zmenciso/lck.jpg \
--scaling fill \
--font-size 26 \
--font Cantarell"

swaylock $swaylock_options
