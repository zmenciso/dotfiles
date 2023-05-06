#!/bin/bash

BLANK='#00000000'
DARK='08080880'
GREEN='#8cc85fff'
BLACK='#323437ff'
FGBR='#eeeeeeff'
FG='#b2b2b2ff'
RED='#ff5454ff'
BLUE='#80a0ffff'
YELLOW='#e3c78aff'
PURPLE='#d183d8ff'

# Options to pass to swaylock
swaylock_options="--indicator-radius 100 \
--indicator-thickness 12 \
--clock \
--timestr %H:%M \
--datestr %Y-%m-%d \
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
-l \
-e \
\
--screenshot \
--effect-blur 12x2 \
--effect-vignette 0.5:0.8 \
--fade-in 0.2 \
--font-size 28 \
--font Cantarell"

swaylock $swaylock_options
