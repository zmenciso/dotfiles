-------------------------------------------------------------------------------
-- General vim settings
-------------------------------------------------------------------------------
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
vim.opt.colorcolumn = {81}
vim.opt.cursorlineopt = "number"
vim.opt.termguicolors = true
vim.opt.syntax = 'on'
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

-- Colorscheme settings
vim.g.moonflyCursorColor = true
vim.g.moonflyNormalFloat = true
vim.g.moonflyUnderlineMatchParen = false
vim.g.moonflyTransparent = true
vim.g.moonflyVirtualTextColor = true
vim.g.moonflyWinSeparator = 1

vim.cmd [[
	colorscheme moonfly
]]

vim.cmd [[
	hi CursorLineNr guibg=None
	hi ColorColumn ctermbg=None guibg=#303030
	hi TelescopeBorder guifg=#b2b2b2
	hi TelescopeTitle guifg=#b2b2b2
	hi FloatBorder guifg=#b2b2b2
]]
