function power_print -d '[TEXT] [foreground] [background] [font_options]'
	set_color normal
	set_color -b $argv[3]
	set_color $argv[4] $argv[2]
	echo -n $argv[1]
end

function print_cap -d '[CHAR] [foreground] [background]'
	set_color normal

	if [ -n "$argv[3]" ]
		set_color -b $argv[3]
	end

	set_color $argv[2]
	echo -n $argv[1]
end

function fish_prompt -d 'Write out the prompt'
    set -l last_status $status
    set -l git_branch (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')

    set bg 080808
    set blk 303030
    set color
    set tag

    # Host and CWD
    switch $fish_bind_mode
	    case default
	        set color blue
	        set tag N
	    case insert
	        set color brgreen
	        set tag I
	    case replace_one
	        set color blue
	        set tag N
        case replace
            set color brred
            set tag R
	    case visual
	        set color brmagenta
	        set tag V
	    case '*'
	        set color yellow
	        set tag C
    end

    # Hostname
    power_print " $hostname " $bg $color --bold
    print_cap  $color $blk

    # CWD
    power_print ' '(prompt_pwd)' ' white $blk --italics

    set prev $blk

    # Git 
    if [ -n "$git_branch" ]
		print_cap  brblack $prev
		power_print " $git_branch " $color $blk
    end

    # Status
    if [ $last_status -ne 0 ]
		print_cap  $prev red
		power_print "  $last_status " $bg red --bold
		set prev red
    end

	print_cap  $prev

    # VIM Mode
	echo
    power_print " $tag " $bg $color
    print_cap  $color

	echo -n ' '

end
