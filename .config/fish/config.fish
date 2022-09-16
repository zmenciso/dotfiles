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

set -x PATH $PATH ~/.local/bin ~/.cargo/bin

# Colored GCC warnings and errors
set -x GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Vim key bindings
fish_vi_key_bindings

# Import colorscheme from `wal`
# cat ~/.cache/wal/sequences
