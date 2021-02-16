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

	if [ $argv[1] != '' ]
		set_color $argv[2]
	end
	echo -n $argv[1]
end

function fish_prompt -d 'Write out the prompt'
    set -l last_status $status
    set -l git_branch (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')

    set bg 080808

    # Host
    set_color -b $fish_color_user
    set_color --bold $bg
    echo -n ' '$hostname' '

	print_cap  $fish_color_user black

    # PWD
    power_print ' '(prompt_pwd)' ' $fish_color_cwd black --italics
    set prev black

    # Git 
    if [ -n "$git_branch" ]
		print_cap  $fish_color_git $prev
		power_print ' '$git_branch' ' $fish_color_git black --bold
    end

    # Status
    if [ $last_status -ne 0 ]
		print_cap  red $prev
		power_print '  '$last_status' ' red black
    end

	print_cap  $prev
	echo -n ' '
end

function fish_right_prompt
	set bg 080808
	set_color normal 

    # VIM Mode
    switch $fish_bind_mode
	    case default
	      set_color blue
		  echo -n ''
		  set_color --bold $bg
	      set_color -b blue
	      echo -n ' N '
	    case insert
		  set_color white
		  echo -n ''
		  set_color --bold $bg
	      set_color -b white
	      echo -n ' I '
	    case replace_one
	      set_color brred
		  echo -n ''
		  set_color --bold $bg
	      set_color -b brred
	      echo -n ' R '
	    case visual
	      set_color brmagenta
		  echo -n ''
		  set_color --bold $bg
	      set_color -b brmagenta
	      echo -n ' V '
	    case '*'
	      set_color red
		  echo -n ''
		  set_color normal
	      set_color -b red
	      echo -n '?'
    end

    set_color normal
end
