function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -l git_branch (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/')

	# Status
	if [ $last_status -ne 0 ]
		set_color $fish_color_error
		echo -n 'EXIT '
		echo $last_status
    end

    # User
    set_color $fish_color_user
    echo -n $USER
    set_color normal

    echo -n '@'

    # Host
    set_color --bold $fish_host_color
    echo -n $HOSTNAME
    set_color normal

    echo -n ':'

    # PWD
    set_color --dim $fish_color_cwd
    echo -n $PWD

    # Git
    set_color $fish_color_comment
    echo $git_branch

	switch $fish_bind_mode
		case default
		  set_color --bold $fish_color_operator
		  echo -n 'N'
		case insert
		  set_color --bold $fish_color_user
		  echo -n 'I'
		case replace_one
		  set_color --bold $fish_color_cwd
		  echo -n 'R'
		case visual
		  set_color --bold $fish_color_redirection
		  echo -n 'V'
		case '*'
		  set_color --bold red
		  echo -n '?'
	end
	set_color normal

    echo -n ' > '
end
