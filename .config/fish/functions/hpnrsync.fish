function hpnrsync --wraps=rsync\ -e\ \'hpnssh\ -p\ 2222\'\ -rauL\ --info=progress2 --description alias\ hpnrsync\ rsync\ -e\ \'hpnssh\ -p\ 2222\'\ -rauL\ --info=progress2
  rsync -e 'hpnssh -p 2222' -rauhL --info=progress2 $argv
        
end
