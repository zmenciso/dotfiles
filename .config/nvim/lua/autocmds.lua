-- Set text width
vim.cmd [[
	augroup Text
		autocmd!
		autocmd FileType text setlocal textwidth=80 spell spelllang=en_us
		autocmd FileType tex setlocal textwidth=80 spell spelllang=en_us
	augroup END
]]

-- Custom vim commands and file settings
vim.cmd [[
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
		autocmd FileType markdown setlocal expandtab textwidth=80 spell spelllang=en_us
	augroup END
]]

-- Vim-terminal
vim.cmd [[
	augroup neovim_terminal
		autocmd!
		" Enter Terminal-mode (insert) automatically
		autocmd TermOpen * startinsert
		" Disables number lines on terminal buffers
		autocmd TermOpen * :set nonumber norelativenumber
		" allows you to use Ctrl-c on terminal window
		autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
	augroup END
]]
