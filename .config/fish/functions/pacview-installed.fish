function pacview-installed --wraps=sudo\ pacman\ -Qq\ \|\ fzf\ --preview\ \'pacman\ -Qil\ \{\}\'\ --layout=reverse\ --bind\ \'enter:execute\(pacman\ -Qil\ \{\}\ \|\ less\)\' --description alias\ pacview-installed\ sudo\ pacman\ -Qq\ \|\ fzf\ --preview\ \'pacman\ -Qil\ \{\}\'\ --layout=reverse\ --bind\ \'enter:execute\(pacman\ -Qil\ \{\}\ \|\ less\)\'
  sudo pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)' $argv
        
end
