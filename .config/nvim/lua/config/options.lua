-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.smoothscroll = true
vim.g.snacks_animate = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = vim.o.tabstop
vim.o.softtabstop = vim.o.tabstop

vim.opt.hlsearch = false
vim.opt.copyindent = true

vim.opt.backspace = "indent,eol,start"

vim.opt.mouse = ""

vim.opt.conceallevel = 0

-- vim.opt.colorcolumn = { 81 }
-- vim.opt.textwidth = 80
-- vim.opt_local.wrap = true
-- vim.opt_local.spell = true
-- vim.opt.breakindent = true
-- vim.opt.wrapscan = false
-- vim.opt.linebreak = true
