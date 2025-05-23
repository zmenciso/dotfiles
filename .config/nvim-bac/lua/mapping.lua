-- vim.api.nvim_set_keymap is too long
function map(mode, shortcut, command, opts)
	vim.api.nvim_set_keymap(mode, shortcut, command, opts)
end

vim.api.nvim_create_user_command('ChDir', 'cd %:p:h', {})

-- Use ctrl-[hjkl] to select the active split!
map('n', '<c-k>', ':wincmd k<CR>', { silent = true })
map('n', '<c-j>', ':wincmd j<CR>', { silent = true })
map('n', '<c-h>', ':wincmd h<CR>', { silent = true })
map('n', '<c-l>', ':wincmd l<CR>', { silent = true })

-- Map Ctrl-Backspace to delete the previous word in insert mode.
map('!', '<C-BS>', '<C-w>', { noremap = true })
map('!', '<C-h>', '<C-w>', { noremap = true })

-- Toggle spell check
map('', '<F5>', ':setlocal spell! spelllang=en_us<cr>', {})
map('i', '<F5>', '<C-o>:setlocal spell! spelllang=en_us<cr>', {})

-- Splits
map('n', '<c-v>', '<cmd>vsplit<cr>', {})
map('n', '<c-x>', '<cmd>split<cr>', {})

-- Terminal
map('n', '<c-t>', '<cmd>term<cr>', { noremap = true })

-------------------------------------------------------------------------------
-- Space mappings
-------------------------------------------------------------------------------

map('n', '<Space>c', '<cmd>cd ..<cr>', { noremap = true })

map('n', '<Space>e', '<cmd>NvimTreeToggle<cr>', { noremap = true })
map('n', '<Space>c', '<cmd>q<cr>', { noremap = true })

-- Open treesitter
map('n', '<Space>t', '<cmd>Telescope treesitter<cr>', { noremap = true })

-- Open xplr
map('n', '<Space>x', '<cmd>Xplr<cr>', { noremap = true })

-- Find files using Telescope
map('n', '<Space>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
map('n', '<Space>/', '<cmd>Telescope live_grep<cr>', { noremap = true })
map('n', '<Space>fm', '<cmd>Telescope man_pages<cr>', { noremap = true })

-- Find vim stuff using Telescope
map('n', '/', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { noremap = true })
map('n', '<Space>o', '<cmd>Telescope buffers<cr>', { noremap = true })
map('n', '<Space>vh', '<cmd>Telescope help_tags<cr>', { noremap = true })
map('n', '<Space>vc', '<cmd>Telescope commands<cr>', { noremap = true })
map('n', '<Space>vo', '<cmd>Telescope vim_options<cr>', { noremap = true })
map('n', '<Space>vs', '<cmd>Telescope spell_suggest<cr>', { noremap = true })

-- Find LSP stuff using Telescope command-line sugar.
map('n', '<Space>d', '<cmd>Telescope diagnostics<cr>', { noremap = true })
map('n', '<Space>li', '<cmd>Telescope lsp_implementations<cr>', { noremap = true })
map('n', '<Space>lr', '<cmd>Telescope lsp_references<cr>', { noremap = true })
map('n', '<Space>ld', '<cmd>Telescope lsp_definitions<cr>', { noremap = true })
