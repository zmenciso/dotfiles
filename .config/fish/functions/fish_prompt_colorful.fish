function power_print -d '[TEXT] [foreground] [background] [font_options]'
	set_color normal
	set_color -b $argv[3]
	set_color $argv[4] $argv[2]
	echo -n $argv[1]
end

function print_cap -d '[foreground] [background]'
	set_color normal

	if [ -n $argv[2] ]
		set_color -b $argv[2]
	end

	set_color $argv[1]
	echo -n ''
end

function fish_prompt -d 'Write out the prompt'
    set -l last_status $status
    set -l git_branch (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/')

    set bg 080808

    # User
    set_color $fish_color_user
    set_color -b black
    echo -n $USER

	set_color normal
    set_color -b black
    echo -n '@'

    # Host
    set_color --bold $fish_color_host
    echo -n $hostname' '

	print_cap black $fish_color_cwd

    # PWD
    power_print ' '(prompt_pwd)' ' $bg $fish_color_cwd --italics
    set prev $fish_color_cwd

    # Git 
    if [ -n "$git_branch" ]
		print_cap $prev $fish_color_git
		power_print $git_branch' ' $bg $fish_color_git --bold
		set prev $fish_color_git
    end

    # Status
    if [ $last_status -ne 0 ]
		print_cap $prev red
		power_print '  '$last_status' ' $bg red
		set prev red
    end

	print_cap $prev
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
