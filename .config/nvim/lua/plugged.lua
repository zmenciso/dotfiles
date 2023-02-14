-------------------------------------------------------------------------------
-- Plugin Manager
-------------------------------------------------------------------------------
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

-- LSP shit
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'L3MON4D3/LuaSnip'
Plug 'https://github.com/onsails/lspkind-nvim'

-- Status line
Plug 'nvim-lualine/lualine.nvim'

-- Colorschemes
Plug 'bluz71/vim-moonfly-colors'
Plug 'norcalli/nvim-colorizer.lua'

-- Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-colors.nvim'

-- CMP
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'lukas-reineke/cmp-under-comparator'

-- Common Functions
Plug 'folke/lua-dev.nvim'
Plug 'nvim-lua/plenary.nvim'

Plug 'is0n/fm-nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'rcarriga/nvim-notify'

-- whichkey
Plug 'folke/which-key.nvim'

-- Fish!
Plug 'https://github.com/khaveesh/vim-fish-syntax'

vim.call('plug#end')
