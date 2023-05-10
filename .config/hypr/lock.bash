#!/bin/bash

BLANK='#00000000'
DARK='08080880'
GREEN='#8cc85f'
BLACK='#323437'
FGBR='#eeeeee'
FG='#b2b2b2'
RED='#ff5454'
BLUE='#80a0ff'
YELLOW='#e3c78a'
PURPLE='#d183d8'

# Options to pass to swaylock
swaylock_options="--indicator-radius 80 \
--indicator-thickness 10 \
\
--ring-color $BLACK \
--ring-ver-color $PURPLE \
--ring-clear-color $YELLOW \
--ring-wrong-color $RED \
\
--line-color $BLACK \
--line-ver-color $PURPLE \
--line-clear-color $YELLOW \
--line-wrong-color $RED \
\
--layout-bg-color $BLANK \
--layout-border-color $BLANK \
--layout-text-color $FGBR \
\
--inside-color $DARK \
--inside-ver-color $DARK \
--inside-clear-color $DARK \
--inside-wrong-color $DARK \
\
--text-color $FGBR \
--text-ver-color $FGBR \
--text-wrong-color $FGBR \
--text-clear-color $FGBR \
\
--separator-color $BLACK \
--key-hl-color $BLUE \
--caps-lock-key-hl-color $BLUE \
--bs-hl-color $RED \
\
--daemonize \
--indicator-caps-lock \
--ignore-empty-password \
--hide-keyboard-layout \
\
--image /home/zmenciso/lck.png \
--scaling fill \
--font-size 24 \
--font Cantarell"

swaylock $swaylock_options
