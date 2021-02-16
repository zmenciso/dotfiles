# Greeting
set -U fish_greeting
set -Ux LC_ALL 'en_US.UTF-8'

# Functions
function yldme
  for url in $argv
    echo (curl -s --form file="@$url" "https://yld.me/paste?raw=1")
  end
end

function yldme-link
  for url in $argv
    echo (curl -s -X POST -d "$url" "https://yld.me/url")
  end
end

set -x PATH $PATH ~/.local/bin
set -x EDITOR vim

# Colored GCC warnings and errors
set -x GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Aliases
alias cp='cp -iv'
alias rm='rm -i'
alias df='df -h'
alias mv='mv -iv'

# Vim key bindings
fish_vi_key_bindings
