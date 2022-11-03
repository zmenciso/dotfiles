#!/bin/bash

BLANK='#00000000'
CLEAR='#8cc85f22'
DEFAULT='#323437cc'
TEXT='#eeeeeeff'
WRONG='#ff5454bb'
VERIFYING='#80a0ffbb'
EMPTY='#e3c78aff'
CAPS='e3c78acc'

# Options to pass to swaylock
swaylock_options="--indicator-radius 100 \
--inside-ver-color $CLEAR \
--ring-ver-color $VERIFYING \
--ring-caps-lock-color $CAPS \
--ring-color $DEFAULT \
--ring-wrong-color $WRONG \
--ring-clear-color $EMPTY \
\
--line-color $BLANK \
--line-clear-color $BLANK \
--line-ver-color $BLANK \
--line-wrong-color $BLANK \
--line-caps-lock-color $BLANK \
\
--layout-bg-color $BLANK \
--layout-border-color $BLANK \
--layout-text-color $TEXT \
\
--inside-color $BLANK \
--inside-clear-color $BLANK \
--inside-wrong-color $BLANK \
\
--separator-color $DEFAULT \
--text-ver-color $TEXT \
--text-wrong-color $TEXT \
--text-clear-color $TEXT \
--key-hl-color $WRONG \
--caps-lock-key-hl-color $WRONG \
--bs-hl-color $WRONG \
\
--daemonize \
\
-l \
-e \
-i /home/zmenciso/lck.jpg \
--scaling fill \
--font-size 26 \
--font Cantarell"

swaylock $swaylock_options
