" General vim settings
set backspace=indent,eol,start
set ignorecase
set smartcase
set copyindent
set ruler
set showcmd
set number
set smarttab
set hlsearch
set autoindent
set relativenumber
set autoread
set cursorline
set t_Co=256

syntax on
" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Map Ctrl-Backspace to delete the previous word in insert mode.
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" Tab settings
set tabstop=8
set shiftwidth=4
set softtabstop=4
set noexpandtab

" Set text width
augroup Text
    autocmd!
    autocmd FileType text setlocal textwidth=80
augroup END

" Toggle spell check
:map <F5> :setlocal spell! spelllang=en_us<cr>
imap <F5> <C-o>:setlocal spell! spelllang=en_us<cr>

set nocompatible
set laststatus=2

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

filetype plugin indent on

" Custom commands
augroup WhiteSpace
    autocmd!
    command! TrimTrailingWhitespace :%s/\s\+$//
augroup END

" Python code should always expand tab
augroup Python
    autocmd!
    autocmd FileType python setlocal expandtab
augroup END

" Markdown
augroup Markdown
    autocmd!
    autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
    autocmd FileType markdown setlocal expandtab
augroup END

" Colorscheme
colorscheme onehalfdark
hi Normal guibg=NONE ctermbg=NONE

set noshowmode

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')


Plug 'neovim/nvim-lspconfig'

Plug 'vim-airline/vim-airline'
Plug 'sonph/onehalf', { 'rtp': 'vim' }

Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

Plug 'https://github.com/ervandew/supertab.git'

call plug#end()

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='onehalfdark'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Powerline fonts
let g:airline_powerline_fonts = 1
