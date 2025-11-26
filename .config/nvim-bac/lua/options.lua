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
vim.opt.hlsearch = false
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
vim.o.expandtab = true

vim.o.showmode = false

-- Colorscheme
require('nightfox').setup({
  options = {
    transparent = false,
    dim_inactive = true,
    module_default = true,
    styles = {               -- Style to be applied to different syntax groups ':help attr-list'
      comments = "italic",
      conditionals = "NONE",
      constants = "NONE",
      functions = "bold",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = {
      match_paren = false,
      visual = false,
      search = false,
    },
  },
})

vim.cmd("colorscheme carbonfox")

vim.cmd [[
	hi NormalFloat guifg=#f2f4f8 guibg=#161616
	hi TelescopeNormal guibg=#161616
	hi TelescopeBorder guibg=#161616
]]
