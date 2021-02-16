#!/bin/bash

## CONFIGURATION ##############################################################

BLANK='#00000000'
CLEAR='#8cc85f22'
DEFAULT='#323437cc'
TEXT='#eeeeeeff'
WRONG='#ff5454bb'
VERIFYING='#80a0ffbb'

# Options to pass to i3lock
i3lock_options="--insidever-color=$CLEAR \
--ringver-color=$VERIFYING \
\
--insidewrong-color=$CLEAR \
--ringwrong-color=$WRONG \
\
--inside-color=$BLANK \
--ring-color=$DEFAULT \
--line-color=$BLANK \
--separator-color=$DEFAULT \
\
--verif-color=$TEXT \
--wrong-color=$TEXT \
--time-color=$TEXT \
--date-color=$TEXT \
--layout-color=$TEXT \
--keyhl-color=$WRONG \
--bshl-color=$WRONG \
\
--clock \
--time-str=%H:%M:%S \
--date-str=%Y-%m-%d \
--keylayout 0 \
-i /home/zmenciso/lck.jpg \
-C \
-f Cantarell \
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
