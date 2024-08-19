-------------------------------------------------------------------------------
-- General vim settings
-------------------------------------------------------------------------------
-- vim.opt.autochdir = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.copyindent = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.number = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.autoread = true
vim.opt.cursorline = true
-- vim.opt.colorcolumn = {81}
-- vim.opt.cursorlineopt = "number"
vim.opt.termguicolors = true
vim.opt.syntax = 'on'
vim.opt.hlsearch = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.wrapscan = false
vim.opt.updatetime = 250
vim.opt.history = 999
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.o.compatible = false
vim.o.laststatus = 3
vim.opt.mouse = ''
vim.opt.spelloptions = "camel"
vim.opt.fillchars = {
	horiz = "━", horizup = "┻", horizdown = "┳", vert = "┃", vertleft = "┫",
	vertright = "┣", verthoriz = "╋",
	foldclose = "▷", foldopen = "▼", foldsep = "┃",
	diff = "",
}
vim.opt.listchars = {
	tab = "  ", trail = "‧",
	extends = "»", precedes = "«",
}

-- Tab settings
vim.o.tabstop = 4
vim.o.shiftwidth = vim.o.tabstop
vim.o.softtabstop = vim.o.tabstop
vim.o.expandtab = false

vim.o.showmode = false

-- Colorscheme
require('nightfox').setup({
  options = {
    transparent = false,
    dim_inactive = true,
    module_default = true,
    styles = {               -- Style to be applied to different syntax groups
      comments = "NONE",     -- Value is any valid attr-list value `:help attr-list`
      conditionals = "NONE",
      constants = "NONE",
      functions = "NONE",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = {
      match_paren = true,
      visual = false,
      search = false,
    },
  },
})

vim.cmd("colorscheme carbonfox")

vim.cmd [[
	" hi CursorLineNr guibg=None
	" hi ColorColumn ctermbg=None guibg=#303030
	hi TelescopeBorder guifg=#b2b2b2
	hi TelescopeTitle guifg=#b2b2b2
	hi FloatBorder guifg=#b2b2b2
]]
