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
Plug 'nvim-lua/lsp-status.nvim'
Plug 'ray-x/lsp_signature.nvim'

Plug 'nvim-lualine/lualine.nvim'
"Plug 'vim-airline/vim-airline'
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
Plug 'folke/lua-dev.nvim'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'lukas-reineke/cmp-under-comparator'

Plug 'norcalli/nvim-colorizer.lua'
Plug 'rcarriga/nvim-notify'
Plug 'nvim-lua/plenary.nvim'

Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

Plug 'https://github.com/onsails/lspkind-nvim'

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
    vim.o.updatetime = 250

    require('lualine').setup{
	options = {
	icons_enabled = true,
	theme = 'auto',
	component_separators = { left = '', right = ''},
	section_separators = { left = '', right = ''},
	disabled_filetypes = {},
	always_divide_middle = true,
      },
      sections = {
	lualine_a = {'mode'},
	lualine_b = {'branch', 'diff',
		      {'diagnostics', sources={'nvim_lsp', 'coc'}}},
	lualine_c = {'filename'},
	lualine_x = {'encoding', 'fileformat', 'filetype'},
	lualine_y = {'progress'},
	lualine_z = {'location'}
      },
      inactive_sections = {
	lualine_a = {},
	lualine_b = {},
	lualine_c = {'filename'},
	lualine_x = {'location'},
	lualine_y = {},
	lualine_z = {}
      },
      tabline = {},
      extensions = {}
    }

    -- Don't forget to add language servers to the autocompletion config!
    require('lspconfig').pyright.setup{}
    require('lspconfig').clangd.setup{}
    require('lspconfig').cmake.setup{}

    local lspconfig = require('lspconfig')

    -- lsp_signature
    -- https://github.com/ray-x/lsp_signature.nvim#full-configuration-with-default-values
    local on_attach_lsp_signature = function(client, bufnr)
      require('lsp_signature').on_attach({
	  bind = true, -- This is mandatory, otherwise border config won't get registered.
	  floating_window = true,
	  handler_opts = {
	    border = "none"
	  },
	  zindex = 99,     -- <100 so that it does not hide completion popup.
	  fix_pos = false, -- Let signature window change its position when needed, see GH-53
	  toggle_key = '<M-x>',  -- Press <Alt-x> to toggle signature on and off.
	})
    end

    -- Customize LSP behavior
    -- [[ A callback executed when LSP engine attaches to a buffer. ]]
    local on_attach = function(client, bufnr)
      -- Always use signcolumn for the current buffer
      vim.wo.signcolumn = 'yes:1'

      -- Activate LSP signature on attach.
      on_attach_lsp_signature(client, bufnr)

      -- Activate LSP status on attach (see a configuration below).
      require('lsp-status').on_attach(client)

      -- Keybindings
      -- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
      local opts = { noremap=true, silent=true }
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      if vim.fn.exists(':Telescope') then
	buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
      else
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      end
      buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
      --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
      --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      --buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      --buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      --buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      --buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
      --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
      --buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

    -- Add global keymappings for LSP actions
    -- F3, F12: goto definition
    vim.cmd [[
      map  <F12>  gd
      imap <F12>  <ESC>gd
      map  <F3>   <F12>
      imap <F3>   <F12>
    ]]
    -- Shift+F12: show usages/references
    vim.cmd [[
      map  <F24>  gr
      imap <F24>  <ESC>gr
    ]]

    -------------------------
    -- LSP Handlers (general)
    -------------------------
    -- :help lsp-method
    -- :help lsp-handler

    local lsp_handlers_hover = vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'none'
    })
    vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
      local bufnr, winnr = lsp_handlers_hover(err, result, ctx, config)
      if winnr ~= nil then
	vim.api.nvim_win_set_option(winnr, "winblend", 20)  -- opacity for hover
      end
      return bufnr, winnr
    end

    ------------------
    -- LSP diagnostics
    ------------------
    -- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization

    -- Customize how to show diagnostics:
    -- No virtual text (distracting!), show popup window on hover.
    -- @see https://github.com/neovim/neovim/pull/16057 for new APIs
    vim.diagnostic.config({
      virtual_text = false,
      float = {
        source = 'always',
        focusable = false,   -- See neovim#16425
        border = 'none'
      },
      update_in_insert = false
    })
    _G.LspDiagnosticsShowPopup = function()
    return vim.diagnostic.open_float(0, {scope="cursor"})
    end

    -- Show diagnostics in a pop-up window on hover
    _G.LspDiagnosticsPopupHandler = function()
      local current_cursor = vim.api.nvim_win_get_cursor(0)
      local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or {nil, nil}

      -- Show the popup diagnostics window,
      -- but only once for the current cursor location (unless moved afterwards).
      if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
	vim.w.lsp_diagnostics_last_cursor = current_cursor
	local _, winnr = _G.LspDiagnosticsShowPopup()
	-- if winnr ~= nil then
	  -- vim.api.nvim_win_set_option(winnr, "winblend", 20)  -- opacity for diagnostics
	-- end
      end
    end
    vim.cmd [[
    augroup LSPDiagnosticsOnHover
      autocmd!
      autocmd CursorHold *   lua _G.LspDiagnosticsPopupHandler()
    augroup END
    ]]

    -- Redfine diagnostic colors
    vim.cmd [[
    hi DiagnosticError		guifg=#e6645f ctermfg=167
    hi DiagnosticWarn		guifg=#e5c07b ctermfg=180
    hi DiagnosticHint		guifg=#98c379 ctermfg=114
    hi DiagnosticInfo		guifg=#61afef ctermfg=75
    ]]

    -- Redefine signs (:help diagnostic-signs)
    -- neovim >= 0.6.0
    vim.fn.sign_define("DiagnosticSignError",  {text = " ", texthl = "DiagnosticSignError"})
    vim.fn.sign_define("DiagnosticSignWarn",   {text = " ", texthl = "DiagnosticSignWarn"})
    vim.fn.sign_define("DiagnosticSignInfo",   {text = " ", texthl = "DiagnosticSignInfo"})
    vim.fn.sign_define("DiagnosticSignHint",   {text = " ", texthl = "DiagnosticSignHint"})

    ---------------------------------
    -- nvim-cmp: completion support
    ---------------------------------
    -- https://github.com/hrsh7th/nvim-cmp#recommended-configuration
    -- ~/.vim/plugged/nvim-cmp/lua/cmp/config/default.lua

    vim.o.completeopt = "menu,menuone,noselect"

    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
	return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line-1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    local cmp = require('cmp')
    cmp.setup {
      snippet = {
	expand = function(args)
	  vim.fn["UltiSnips#Anon"](args.body)
	end,
      },
      documentation = {
	border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}  -- in a clockwise order
      },
      mapping = {
	['<C-b>'] = cmp.mapping.scroll_docs(-4),
	['<C-f>'] = cmp.mapping.scroll_docs(4),
	['<C-Space>'] = cmp.mapping.complete(),
	['<C-e>'] = cmp.mapping.close(),
	['<CR>'] = cmp.mapping.confirm({ select = false }),
	['<Tab>'] = function(fallback)  -- see GH-231, GH-286
	  if cmp.visible() then cmp.select_next_item()
	  elseif has_words_before() then cmp.complete()
	  else fallback() end
	end,
	['<S-Tab>'] = function(fallback)
	  if cmp.visible() then cmp.select_prev_item()
	  else fallback() end
	end,
      },
      formatting = {
	format = function(entry, vim_item)
	  -- fancy icons and a name of kind
	  vim_item.kind = " " .. require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
	  -- set a name for each source (see the sources section below)
	  vim_item.menu = ({
	    buffer        = "[Buffer]",
	    nvim_lsp      = "[LSP]",
	    luasnip       = "[LuaSnip]",
	    ultisnips     = "[UltiSnips]",
	    nvim_lua      = "[Lua]",
	    latex_symbols = "[Latex]",
	  })[entry.source.name]
	  return vim_item
	end,
      },
      sources = {
	-- Note: make sure you have proper plugins specified in plugins.vim
	-- https://github.com/topics/nvim-cmp
	{ name = 'nvim_lsp', priority = 100 },
	{ name = 'ultisnips', keyword_length = 2, priority = 50 },  -- workaround '.' trigger
	{ name = 'path', priority = 30, },
	{ name = 'buffer', priority = 10 },
      },
      sorting = {
	comparators = {
	  cmp.config.compare.offset,
	  cmp.config.compare.exact,
	  cmp.config.compare.score,
	  cmp.config.compare.kind,
	  cmp.config.compare.sort_text,
	  cmp.config.compare.length,
	  cmp.config.compare.order,
	},
      },
    }

    -- Highlights for nvim-cmp's custom popup menu (GH-224)
    vim.cmd [[
      " To be compatible with Pmenu (#fff3bf)
      hi CmpItemAbbr           guifg=#111111
      hi CmpItemAbbrMatch      guifg=#f03e3e gui=bold
      hi CmpItemAbbrMatchFuzzy guifg=#fd7e14 gui=bold
      hi CmpItemAbbrDeprecated guifg=#adb5bd
      hi CmpItemKindDefault    guifg=#cc5de8
      hi! def link CmpItemKind CmpItemKindDefault
      hi CmpItemMenu           guifg=#cfa050
    ]]

    ------------
    -- LSPstatus
    ------------
    local lsp_status = require('lsp-status')
    lsp_status.config({
	-- Avoid using use emoji-like or full-width characters
	-- because it can often break rendering within tmux and some terminals
	-- See ~/.vim/plugged/lsp-status.nvim/lua/lsp-status.lua
	indicator_hint = '!',
	status_symbol = ' ',

	-- Automatically sets b:lsp_current_function
	current_function = true,
    })
    lsp_status.register_progress()

    -- LspStatus(): status string for airline
    _G.LspStatus = function()
      if #vim.lsp.buf_get_clients() > 0 then
	return lsp_status.status()
      end
      return ''
    end

    -- :LspStatus (command): display lsp status
    vim.cmd [[
    command! -nargs=0 LspStatus   echom v:lua.LspStatus()
    ]]

    -- Other LSP commands
    vim.cmd [[
    command! -nargs=0 LspDebug  :tab drop $HOME/.cache/nvim/lsp.log
    ]]
EOF

" Additional color customization

