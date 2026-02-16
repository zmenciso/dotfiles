set NORMAL (set_color normal)
set GOOD (set_color --bold green)
set WARN (set_color --bold yellow)
set BAD (set_color --bold red)
set DIM (set_color --dim)

set DISKS / /tank

set DISK_THRESHOLD_BAD 85
set DISK_THRESHOLD_WARN 75
set MEM_THRESH_BAD 1000
set MEM_THRESH_WARN 4000
set LOAD_THRESH_BAD 10
set LOAD_THRESH_WARN 5
set PROC_THRESH_BAD 2000
set PROC_THRESH_WARN 1000

set HEADER_OFFSET 2
set HEADER_LEN 16
set WIDTH 65
# set WIDTH (tput cols)
set BAR_LEN (math $WIDTH - $HEADER_OFFSET - 2)
set BAR_CHAR '='

# header NAME VAL
function header
    set header $argv[1]
    set val $argv[2]

    set space (string repeat -n $HEADER_OFFSET ' ')
    set strlen (string length $header)
    set dots (string repeat -n (math $HEADER_LEN - $strlen) '.')
    echo $space$header$DIM$dots':'$NORMAL $val
end

# bar VAL COLOR
function bar
    set val $argv[1]
    set color $argv[2]

    set counter 0 &
    set step (math 100 / $BAR_LEN)
    echo -n (string repeat -n $HEADER_OFFSET ' ')'['

    while test $counter -lt 100
        if test $counter -lt $val
            echo -ne $color$BAR_CHAR
        else
            echo -ne $NORMAL$DIM$BAR_CHAR
        end

        set counter (math $counter + $step)
    end

    echo $NORMAL']'
end

# valprint VAL BAD WARN -gt/-lt
function valcolor
    set val $argv[1]
    set bad $argv[2]
    set warn $argv[3]
    set comp $argv[4]

    if test $val $comp $bad
        echo $BAD
    else if test $val $comp $warn
        echo $WARN
    else
        echo $GOOD
    end
end

# dblprint LEFT RIGHT [len]
function dblprint
    set left $argv[1]
    set right $argv[2]

    if test -z "$argv[3]"
        set len (string length $right)
    else
        set len $argv[3]
    end

    set pad (math $WIDTH - $HEADER_OFFSET - (string length $left) - $len)

    echo -n (string repeat -n $HEADER_OFFSET ' ')
    echo -n $left
    echo -n (string repeat -n $pad ' ')
    echo -n $right

    echo
end
