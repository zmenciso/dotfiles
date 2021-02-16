# Greeting
set -U fish_greeting
set -Ux LC_ALL 'en_US.UTF-8'
set -Ux EDITOR 'nvim'

# Cursor options
set fish_vi_force_cursor

set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block

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

# Colored GCC warnings and errors
set -x GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Basic aliases
alias cp 'cp -iv'
alias rm 'rm -i'
alias df 'df -h'
alias mv 'mv -iv'
alias ls 'ls --color'
alias dir 'dir --color'
alias vdir 'vdir --color'
alias grep 'grep --color'
alias fgrep 'fgrep --color'
alias egrep 'egrep --color'
alias diff 'diff --color'

# xplr aliases
alias xcd 'cd (xplr --print-pwd-as-result)'
alias xplr 'xplr (pwd)'

# Vim key bindings
fish_vi_key_bindings

# Import colorscheme from `wal`
# cat ~/.cache/wal/sequences
