function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    # User
    set_color $fish_color_user
    echo -n $USER
    set_color normal

    echo -n '@'

    # Host
    set_color --bold $fish_host_color
    echo -n $hostname
    set_color normal

    echo -n ':'

    # PWD
    set_color --dim $fish_color_cwd
    echo -n (prompt_pwd)

    # Status
    if [ $last_status -ne 0 ]
	    set_color $fish_color_error
	    echo -n ' ['$last_status']'
    end

    set_color normal
    # echo
    echo -n ' > '
end

function fish_right_prompt -d "Write out the right side of the prompt"
    set -l git_branch (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/')

    # Git
    set_color $fish_color_comment
    echo -n $git_branch


    # VIM Mode
    set_color --bold normal
    echo -n ' ['
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
    set_color --bold normal
    echo -n ']'
end
