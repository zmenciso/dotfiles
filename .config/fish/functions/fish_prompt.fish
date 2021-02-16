function power_print -d '[TEXT] [foreground] [background] [font_options]'
	set_color normal
	set_color -b $argv[3]
	set_color $argv[4] $argv[2]
	echo -n $argv[1]
end

function print_cap -d '[CHAR] [foreground] [background]'
	set_color normal

	if [ -n $argv[3] ]
		set_color -b $argv[3]
	end

	set_color $argv[2]
	echo -n $argv[1]
end

function fish_prompt -d 'Write out the prompt'
    set -l git_branch (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')

    set bg 080808
    set blk 2c2d30

    # Host
    set_color -b $fish_color_user
    set_color --bold $bg
    echo -n ' '$hostname' '

	print_cap  $fish_color_user $blk

    # PWD
    power_print ' '(prompt_pwd)' ' $fish_color_cwd $blk --italics
    set prev $blk

    # Git 
    if [ -n "$git_branch" ]
		print_cap  brblack $prev
		power_print ' '$git_branch' ' $fish_color_git $blk --bold
    end

	print_cap  $prev
	echo -n ' '
end

function fish_right_prompt
	set bg 080808
    set -l last_status $status
    set prev ''

    # Status
    if [ $last_status -ne 0 ]
		print_cap  red
		power_print ' '$last_status' ' $bg red --bold
		set prev red
    end

    # VIM Mode
    switch $fish_bind_mode
	    case default
		  print_cap  blue $prev
		  power_print ' N ' $bg blue --bold
	    case insert
		  print_cap  white $prev
		  power_print ' I ' $bg white --bold
	    case replace_one
		  print_cap  brred $prev
		  power_print ' R ' $bg brred --bold
	    case visual
		  print_cap  brmagenta $prev
		  power_print ' V ' $bg brmagenta --bold
	    case '*'
		  print_cap  red $prev
		  power_print ' ? ' $bg red --bold
    end

    set_color normal
end
