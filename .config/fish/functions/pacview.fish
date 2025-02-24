function pacview --wraps=pacman\ -Slq\ \|\ fzf\ --preview\ \'pacman\ -Si\ \{\}\'\ --layout=reverse --description alias\ pacview\ pacman\ -Slq\ \|\ fzf\ --preview\ \'pacman\ -Si\ \{\}\'\ --layout=reverse
  pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse $argv
        
end
