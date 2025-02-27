function hpnrsync 
  rsync -e 'hpnssh' -rauhL --info=progress2 $argv
        
end
