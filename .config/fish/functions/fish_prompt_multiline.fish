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

    # Host
    switch $fish_bind_mode
	    case default
		  power_print " $hostname " $bg blue --bold
		  print_cap  blue $blk
	    case insert
		  power_print " $hostname " $bg white --bold
		  print_cap  white $blk
	    case replace_one
		  power_print " $hostname " $bg brred --bold
		  print_cap  brred $blk
	    case visual
		  power_print " $hostname " $bg brmagenta --bold
		  print_cap  brmagenta $blk
	    case '*'
		  power_print " $hostname " $bg red --bold
		  print_cap  red $blk
    end

    # PWD
    power_print ' '(prompt_pwd)' ' $fish_color_cwd $blk --italics
    set prev $blk

    # Git 
    if [ -n "$git_branch" ]
		print_cap  brblack $prev
		power_print " $git_branch " $fish_color_git $blk
    end

    # Status
    if [ $last_status -ne 0 ]
		print_cap  $prev red
		power_print "  $last_status " $bg red --bold
		set prev red
    end

	print_cap  $prev

    # Second line
	echo

    # VIM Mode
    switch $fish_bind_mode
	    case default
		  power_print " N " $bg blue
		  print_cap  blue
	    case insert
		  power_print " I " $bg white
		  print_cap  white
	    case replace_one
		  power_print " R " $bg brred
		  print_cap  brred
	    case visual
		  power_print " V " $bg brmagenta
		  print_cap  brmagenta
	    case '*'
		  power_print " ? " $bg red
		  print_cap  red
    end

	echo -n ' '

end
