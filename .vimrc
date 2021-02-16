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

" Set the runtime path to include Vundle and initialize 
set rtp+=~/.vim/bundle/Vundle.vim 
call vundle#begin() 

" Alternatively, pass a path where Vundle should install plugins 
" Call vundle#begin('~/some/path/here') 
" Let Vundle manage Vundle, required 
Plugin 'VundleVim/Vundle.vim' 
Plugin 'sheerun/vim-polyglot'
Plugin 'vim-airline/vim-airline'
Plugin 'https://github.com/KeitaNakamura/neodark.vim'
Plugin 'sonph/onehalf', { 'rtp': 'vim' }
Plugin 'tpope/vim-fugitive' 
Plugin 'dense-analysis/ale'
" Plugin 'git://git.wincent.com/command-t.git' 
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'} 
" Plugin 'ascenator/L9', {'name': 'newL9'} 
" Plugin 'https://github.com/vim-syntastic/syntastic.git'
Plugin 'https://github.com/ervandew/supertab.git'

call vundle#end()		" required 

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='onehalfdark'

" Syntastic
" let g:syntastic_auto_loc_list=0
" let g:syntastic_check_on_open=0
" let g:syntastic_enable_signs=1
" let g:syntastic_quiet_messages = { "type": "style" }
" let g:syntastic_cpp_compiler_options = ' -std=c++11'
" let g:syntastic_python_checkers = ['python3']

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

" Tab settings
set tabstop=4
set shiftwidth=4
set softtabstop=0

" Brief help 
" :PluginList       - lists configured plugins 
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate 
" :PluginSearch foo - searches for foo; append `!` to refresh local cache 
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
" 
" see :h vundle for more details or wiki for FAQ 
" Put your non-Plugin stuff after this line 
