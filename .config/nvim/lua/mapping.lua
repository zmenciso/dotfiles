-- vim.api.nvim_set_keymap is too long
function map(mode, shortcut, command, opts)
	vim.api.nvim_set_keymap(mode, shortcut, command, opts)
end

-- Use ctrl-[hjkl] to select the active split!
map('n', '<c-k>', ':wincmd k<CR>', { silent = true })
map('n', '<c-j>', ':wincmd j<CR>', { silent = true })
map('n', '<c-h>', ':wincmd h<CR>', { silent = true })
map('n', '<c-l>', ':wincmd l<CR>', { silent = true })

-- Map Ctrl-Backspace to delete the previous word in insert mode.
map('!', '<C-BS>', '<C-w>', {noremap = true})
map('!', '<C-h>', '<C-w>', {noremap = true})

-- Toggle spell check
map('', '<F5>', ':setlocal spell! spelllang=en_us<cr>', {})
map('i', '<F5>', '<C-o>:setlocal spell! spelllang=en_us<cr>', {})

-------------------------------------------------------------------------------
-- Leader mappings
-------------------------------------------------------------------------------

map('n', '<leader>c', '<cmd>cd ..<cr>', { noremap = true })

-- Open xplr
map('n', '<leader>x', '<cmd>Xplr<cr>', { noremap = true })

-- Find files using Telescope
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
map('n', '<leader>fm', '<cmd>Telescope man_pages<cr>', { noremap = true })

-- Find vim stuff using Telescope
map('n', '<leader>vf', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { noremap = true })
map('n', '<leader>vb', '<cmd>Telescope buffers<cr>', { noremap = true })
map('n', '<leader>vh', '<cmd>Telescope help_tags<cr>', { noremap = true })
map('n', '<leader>vc', '<cmd>Telescope commands<cr>', { noremap = true })
map('n', '<leader>vo', '<cmd>Telescope vim_options<cr>', { noremap = true })
map('n', '<leader>vs', '<cmd>Telescope spell_suggest<cr>', { noremap = true })

-- Find LSP stuff using Telescope command-line sugar.
map('n', '<leader>lx', '<cmd>Telescope diagnostics<cr>', { noremap = true })
map('n', '<leader>li', '<cmd>Telescope lsp_implementations<cr>', { noremap = true })
map('n', '<leader>lr', '<cmd>Telescope lsp_references<cr>', { noremap = true })
map('n', '<leader>ld', '<cmd>Telescope lsp_definitions<cr>', { noremap = true })

