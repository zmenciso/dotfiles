function pacclean --wraps='sudo pacman -Qdtq | sudo pacman -Rns -' --description 'alias pacclean sudo pacman -Qdtq | sudo pacman -Rns -'
  sudo pacman -Qdtq | sudo pacman -Rns - $argv
        
end
