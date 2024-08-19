-------------------------------------------------------------------------------
-- Plugin Manager
-------------------------------------------------------------------------------
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

-- LSP shit
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'https://github.com/onsails/lspkind-nvim'

-- Status line
Plug 'nvim-lualine/lualine.nvim'

-- Colorschemes and display
-- Plug 'bluz71/vim-moonfly-colors'
Plug 'EdenEast/nightfox.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-colors.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

-- CMP
-- Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-emoji'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'lukas-reineke/cmp-under-comparator'
Plug 'jc-doyle/cmp-pandoc-references'

-- Snippets
-- Plug 'L3MON4D3/LuaSnip'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

-- Common Functions
Plug 'folke/lua-dev.nvim'
Plug 'nvim-lua/plenary.nvim'

-- Utilities
Plug 'tpope/vim-commentary'
Plug 'is0n/fm-nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'rcarriga/nvim-notify'

-- whichkey
Plug 'folke/which-key.nvim'

vim.call('plug#end')
