function temp --wraps='cd (mktemp -d)'
  cd (mktemp -d) $argv
        
end
