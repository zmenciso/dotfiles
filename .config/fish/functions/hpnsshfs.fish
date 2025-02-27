function hpnsshfs
	if test -n "$argv[2]"
		set REMOTE_DIR $argv[2]
	else 
		set REMOTE_DIR ~
	end

	if test -n "$argv[3]"
		set MOUNTPOINT $argv[3]
	else
		set MOUNTPOINT ~/tank
	end

	sshfs -o follow_symlinks -o reconnect -o ssh_command='hpnssh' $argv[1]:$REMOTE_DIR $MOUNTPOINT
end
