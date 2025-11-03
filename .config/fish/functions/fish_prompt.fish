function fish_prompt --description 'Write out the prompt'
    set -l bg 080808
    set -l blk 303030
    set -l last_status $status

    # Color the prompt differently when remote
    if test -n "$SSH_CLIENT"; or test -n "$SSH_TTY"
        set base_color green
    else
        set base_color blue
    end

    set -l host_color (set_color -b $base_color; set_color --bold $bg)
    set -l normal (set_color normal)
    set -l status_color (set_color --bold $base_color)
    set -l cwd_color (set_color -b $bg; set_color --italic $fish_color_cwd)
    set -l vcs_color (set_color -b $bg; set_color brpurple)
    set -l prompt_status ""
    set -l status_disp ""

    # Since we display the prompt on a new line allow the directory names to be longer.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    set -l suffix '❯'
    if test $last_status -ne 0
        set status_color (set_color --bold $fish_color_error)
        set status_disp "  $last_status "
    end

    set clean 'x'(hostname)'x' 'xx'(prompt_pwd)'xx' (fish_git_prompt "[  %s ]xx")
    set length (math (string length (string join $clean)) + (string length $status_disp))
    set cols (tput cols)

    echo -n -s $host_color ' '(hostname)' ' $normal $cwd_color '  '(prompt_pwd)'  ' $normal $vcs_color (fish_git_prompt "[  %s ]  ") $normal (set_color -b $bg)

    echo -s (string repeat -n (math $cols - $length) ' ') $normal (set_color --bold $bg) (set_color -b $fish_color_error) $status_disp $normal

    echo -n -s $status_color $suffix ' ' $normal

end
