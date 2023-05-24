#!/bin/bash

## CONFIGURATION ##############################################################

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

# Options to pass to i3lock
i3lock_options="--insidever-color=$DARK \
--ringver-color=$PURPLE \
\
--insidewrong-color=$DARK \
--ringwrong-color=$RED \
\
--inside-color=$DARK \
--ring-color=$BLACK \
--line-color=$BLACK \
--separator-color=$DARK \
\
--verif-color=$FGBR \
--wrong-color=$FGBR \
--time-color=$FGBR \
--date-color=$FGBR \
--layout-color=$FGBR \
--keyhl-color=$BLUE \
--bshl-color=$RED \
\
--keylayout 0 \
-i /home/zenciso/lck.png \
-C \
-f Cantarell \
--radius 100 \
\
--wrong-text=Incorrect \
--noinput-text=None \
--lock-text=Locking \
--verif-text=Verifying \
--lockfailed-text=Failure"

# Run before starting the locker
pre_lock() {
	dunstctl set-paused true
    return
}

# Run after the locker exits
post_lock() {
	dunstctl set-paused false
    return
}

###############################################################################

pre_lock

# We set a trap to kill the locker if we get killed, then start the locker and
# wait for it to exit. The waiting is not that straightforward when the locker
# forks, so we use this polling only if we have a sleep lock to deal with.
if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
    kill_i3lock() {
        pkill -xu $EUID "$@" i3lock
    }

    trap kill_i3lock TERM INT

    # we have to make sure the locker does not inherit a copy of the lock fd
    i3lock $i3lock_options {XSS_SLEEP_LOCK_FD}<&-

    # now close our fd (only remaining copy) to indicate we're ready to sleep
    exec {XSS_SLEEP_LOCK_FD}<&-

    while kill_i3lock -0; do
        sleep 0.5
    done
else
    trap 'kill %%' TERM INT
    i3lock -n $i3lock_options &
    wait
fi

post_lock
