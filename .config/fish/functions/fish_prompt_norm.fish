function cprint -d '[TEXT] [foreground] [background] [font_options]'
    argparse --min-args=1 'f/foreground=' 'b/background=' 'o/options=' -- $argv
    or return

    set_color -b $_flag_b
    set_color "--$_flag_o" $_flag_f
    echo -n $argv[1]
    set_color normal
end

function fish_prompt -d 'Write out the prompt'
    set -l last_status $status
    set -l git_branch (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')

    set bg 080808
    set blk 303030

    set count 0
    set cols (tput cols)

    if test -n "$SSH_CLIENT"
        or test -n "$SSH_TTY"
        set BASECOLOR green
    else
        set BASECOLOR blue
    end

    # Hostname
    cprint -b $BASECOLOR -f $bg -o bold " $hostname "
    set count (math $count + (string length $hostname) + 2)

    # CWD
    cprint -b $bg -o italics -f white '  '(prompt_pwd)' '
    set count (math $count + (string length (prompt_pwd)) + 3)

    # Git
    if [ -n "$git_branch" ]
        cprint -b $bg -f $BASECOLOR " [ $git_branch ] "
        set count (math $count + (string length $git_branch) + 6)
    end

    if [ $last_status -ne 0 ]
        set count (math $count + (string length $last_status) + 3)
    end

    set_color -b $bg
    set spacer (string repeat -n (math $cols - $count) ' ')
    echo -n $spacer

    # Status
    if [ $last_status -ne 0 ]
        cprint -b $bg -f red -o bold "  $last_status"
    end

    echo
    set_color normal

    cprint -f $BASECOLOR -o bold " "

end
