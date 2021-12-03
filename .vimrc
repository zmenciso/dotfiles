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

" Toggle pell check
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
Plug 'folke/lsp-colors.nvim'
" Plug 'folke/trouble.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

call plug#end()

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='onehalfdark'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1

" Colorscheme
colorscheme onehalfdark
hi Normal guibg=NONE ctermbg=NONE

lua << EOF
    -- Don't forget to add language servers to the autocompletion config!
    require('lspconfig').pyright.setup{}
    require('lspconfig').clangd.setup{}
    require('lspconfig').cmake.setup{}

    -- Add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    local lspconfig = require('lspconfig')

    -- Enable some language servers with the additional completion capabiltiies
    -- [MISSING]

    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menuone,noselect'

    -- luasnip setup
    local luasnip = require 'luasnip'

    -- nvim-cmp setup
    local cmp = require 'cmp'
    cmp.setup {
      snippet = {
	expand = function(args)
	  require('luasnip').lsp_expand(args.body)
	end,
      },
      mapping = {
	['<C-p>'] = cmp.mapping.select_prev_item(),
	['<C-n>'] = cmp.mapping.select_next_item(),
	['<C-d>'] = cmp.mapping.scroll_docs(-4),
	['<C-f>'] = cmp.mapping.scroll_docs(4),
	['<C-Space>'] = cmp.mapping.complete(),
	['<C-e>'] = cmp.mapping.close(),
	['<CR>'] = cmp.mapping.confirm {
	  behavior = cmp.ConfirmBehavior.Replace,
	  select = true,
	},
	['<Tab>'] = function(fallback)
	  if cmp.visible() then
	    cmp.select_next_item()
	  elseif luasnip.expand_or_jumpable() then
	    luasnip.expand_or_jump()
	  else
	    fallback()
	  end
	end,
	['<S-Tab>'] = function(fallback)
	  if cmp.visible() then
	    cmp.select_prev_item()
	  elseif luasnip.jumpable(-1) then
	    luasnip.jump(-1)
	  else
	    fallback()
	  end
	end,
      },
      sources = {
	{ name = 'nvim_lsp' },
	{ name = 'luasnip' },
      },
    }

    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    local function goto_definition(split_cmd)
      local util = vim.lsp.util
      local log = require("vim.lsp.log")
      local api = vim.api

      -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
      local handler = function(_, result, ctx)
	if result == nil or vim.tbl_isempty(result) then
	  local _ = log.info() and log.info(ctx.method, "No location found")
	  return nil
	end

	if split_cmd then
	  vim.cmd(split_cmd)
	end

	if vim.tbl_islist(result) then
	  util.jump_to_location(result[1])

	  if #result > 1 then
	    util.set_qflist(util.locations_to_items(result))
	    api.nvim_command("copen")
	    api.nvim_command("wincmd p")
	  end
	else
	  util.jump_to_location(result)
	end
      end

      return handler
    end

    vim.lsp.handlers["textDocument/definition"] = goto_definition('split')
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {
	prefix = '●'
      }
    })
EOF
