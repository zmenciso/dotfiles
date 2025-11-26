# Greeting
set -U fish_greeting
set -Ux LC_ALL 'en_US.UTF-8'
set -Ux EDITOR helix

# Cursor options
# set fish_vi_force_cursor

# set fish_cursor_default block
# set fish_cursor_insert line
# set fish_cursor_replace_one underscore
# set fish_cursor_visual block

set -gx PATH $PATH ~/.local/bin ~/.cargo/bin /usr/local/bin
set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH /usr/local/lib /usr/local/lib64

# Colored GCC warnings and errors
set -x GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# If not Vim, then set cursor to line for insert
__fish_cursor_xterm line

# Vim key bindings
# fish_vi_key_bindings
# fish_helix_key_bindings

# Import colorscheme from `wal`
# cat ~/.cache/wal/sequences
