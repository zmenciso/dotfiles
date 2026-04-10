function timezone --wraps='timedatectl set-timezone (curl https://ipapi.co/timezone)' --description 'alias timezone timedatectl set-timezone (curl https://ipapi.co/timezone)'
  timedatectl set-timezone (curl https://ipapi.co/timezone) $argv
        
end
