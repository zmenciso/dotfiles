function dup --wraps='alacritty --working-directory (pwd) & ; disown' --description 'alias dup alacritty --working-directory (pwd) & ; disown'
  alacritty --working-directory (pwd) & ; disown $argv; 
end
