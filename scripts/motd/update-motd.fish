#!/usr/bin/env fish

set motd_dir '/usr/local/etc/update-motd.d'

/bin/rm /etc/motd
cd $motd_dir

for script in $motd_dir/*.fish
	fish $script >> /etc/motd
end
